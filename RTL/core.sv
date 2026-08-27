`ifndef _core_v
`define _core_v
`include "RTL/system.sv"
`include "RTL/base.sv"
`include "RTL/memory_io.sv"
`include "RTL/memory.sv"
`include "RTL/reg_file.sv"
`include "RTL/printDebug.sv"
`include "RTL/branch_target_buffer.sv"
`include "RTL/gshare_predictor.sv"

module core #(
    parameter bit ENABLE_BRANCH_PREDICTION = 1'b1,
    parameter int unsigned FETCH_DEPTH = 4,
    parameter int unsigned STORE_DEPTH = 4
) (
    input logic       clk
    ,input logic      reset
    ,input logic      [`word_address_size-1:0] reset_pc
    ,output memory_io_req   inst_mem_req
    ,input  memory_io_rsp   inst_mem_rsp
    ,output memory_io_req   data_mem_req
    ,input  memory_io_rsp   data_mem_rsp
    ,output logic [63:0] cycle_count_o
    ,output logic [63:0] retire_count_o
    ,output logic [63:0] branch_count_o
    ,output logic [63:0] branch_mispredict_count_o
    ,output logic [63:0] btb_hit_count_o
    ,output logic [31:0] pc_o
    ,input logic profile_start_i
    ,input logic profile_stop_i
    ,output logic [63:0] kernel_cycle_count_o
    ,output logic [63:0] kernel_retire_count_o
    ,output logic [63:0] kernel_branch_count_o
    ,output logic [63:0] kernel_mispredict_count_o
);


////////////////////////////////////////////////////////////////////////////////////
//pileline registers
////////////////////////////////////////////////////////////////////////////////////
IF_ID_t IF_ID_r, IF_ID_n;

ID_EX_t ID_EX_r, ID_EX_n;

EX_MEM_t EX_MEM_r, EX_MEM_n;

MEM_WB_t MEM_WB_r, MEM_WB_n;


//hazard unit signals
logic STALL_PC;
logic STALL_IF_ID;
logic FLUSH_IF_ID;
logic STALL_ID_EX;
logic FLUSH_ID_EX;
logic STALL_EX_MEM;
logic FLUSH_EX_MEM;
logic STALL_MEM_WB;
logic FLUSH_MEM_WB;




logic wv, rv;
logic [4:0] Read_Addr1, Read_Addr2, Write_Addr;
logic [31:0] Read_Data1, Read_Data2, Write_Data;


word    pc;
word   next_pc;
assign pc_o = pc;

logic btb_hit_fetch;
word btb_target_fetch;
logic btb_conditional_fetch;
logic fetch_prediction_taken;
logic gshare_taken_decode;
logic [5:0] gshare_index_decode;
logic predictor_update_valid;
logic btb_update_valid;
logic predictor_update_conditional;
logic predictor_update_taken;
word predictor_update_pc;
word predictor_update_target;
logic [5:0] predictor_update_index;

logic execute_multiply;
logic multiply_request;
logic multiply_pending_r;
logic multiply_signed;
logic [63:0] multiply_product;
logic [31:0] multiply_result;
logic multiply_lhs_negative_r;
logic [31:0] multiply_rhs_r;

localparam int unsigned FETCH_PTR_WIDTH = (FETCH_DEPTH > 1)
    ? $clog2(FETCH_DEPTH) : 1;

typedef struct packed {
    logic complete;
    logic [`user_tag_size-1:0] epoch;
    word pc;
    word inst;
    logic predicted_taken;
    logic btb_hit;
    word predicted_target;
} fetch_entry_t;

fetch_entry_t fetch_entries_r [0:FETCH_DEPTH-1];
logic [FETCH_PTR_WIDTH-1:0] fetch_head_r;
logic [FETCH_PTR_WIDTH-1:0] fetch_tail_r;
logic [FETCH_PTR_WIDTH-1:0] fetch_response_r;
logic [FETCH_PTR_WIDTH:0] fetch_count_r;
logic fetch_accept;
logic fetch_dequeue;
logic fetch_head_ready;

logic control_ex;
logic conditional_branch_ex;
logic actual_taken_ex;
word actual_target_ex;
word actual_next_pc_ex;
word predicted_next_pc_ex;
logic redirect_ex;

instruction_decode_t decode_stage_instruction;
logic decode_control;
logic decode_conditional;
logic decode_prediction_taken;
word decode_prediction_target;
word decode_fetched_next_pc;
word decode_predicted_next_pc;
logic redirect_decode;
logic [`user_tag_size-1:0] fetch_epoch_r;
logic instruction_response_current;

logic memory_operation_ex_mem;
logic memory_pending_r;
logic memory_wait;
logic execute_enable;

localparam int unsigned STORE_PTR_WIDTH = (STORE_DEPTH > 1)
    ? $clog2(STORE_DEPTH) : 1;
typedef struct packed {
    word addr;
    word data;
    logic [3:0] mask;
} store_entry_t;

store_entry_t store_entries_r [0:STORE_DEPTH-1];
logic [STORE_PTR_WIDTH-1:0] store_head_r;
logic [STORE_PTR_WIDTH-1:0] store_tail_r;
logic [STORE_PTR_WIDTH-1:0] store_issue_r;
logic [STORE_PTR_WIDTH:0] store_count_r;
logic [STORE_PTR_WIDTH:0] store_outstanding_r;
logic store_enqueue;
logic store_request_accept;
logic store_response;
logic load_request_accept;
logic load_response;
logic ex_mem_load;
logic ex_mem_store;

branch_target_buffer #(
    .ENTRIES(32)
) btb (
    .clk(clk),
    .reset(reset),
    .lookup_pc_i(pc),
    .lookup_hit_o(btb_hit_fetch),
    .lookup_target_o(btb_target_fetch),
    .lookup_conditional_o(btb_conditional_fetch),
    .update_valid_i(btb_update_valid),
    .update_pc_i(predictor_update_pc),
    .update_target_i(predictor_update_target),
    .update_conditional_i(predictor_update_conditional)
);

gshare_predictor #(
    .HISTORY_BITS(6)
) gshare (
    .clk(clk),
    .reset(reset),
    .lookup_pc_i(IF_ID_r.pc),
    .lookup_taken_o(gshare_taken_decode),
    .lookup_index_o(gshare_index_decode),
    .update_valid_i(predictor_update_valid && predictor_update_conditional),
    .update_taken_i(predictor_update_taken),
    .update_index_i(predictor_update_index)
);

// A BTB hit predicts a control transfer at fetch. Conditional direction is
// deliberately resolved one stage later by gshare in decode; decode redirects
// to fall-through when gshare disagrees with the fetch-stage taken prediction.
assign fetch_prediction_taken = ENABLE_BRANCH_PREDICTION && btb_hit_fetch;


regFile reg_file (
    .clk(clk),
    .reset(reset),
    .rs1(Read_Addr1),
    .rd1(Read_Data1),
    .rs2(Read_Addr2),
    .rd2(Read_Data2),
    .ws(Write_Addr),
    .wd(Write_Data),
    .wv(wv),
    .rv(rv)
);

////////////////////////////////////////////////////////////////////////////////////
// Stage Fetch
////////////////////////////////////////////////////////////////////////////////////

//figure out how to do pc updating 
//mux for next_pc
logic init_pc;
always_ff @(posedge clk) begin  
    if(reset) begin
        init_pc <= 1'b1;
        pc <= reset_pc;
        fetch_epoch_r <= '0;
    end else begin
        init_pc <= 1'b0;
        if (redirect_ex) begin
            pc <= actual_next_pc_ex;
            fetch_epoch_r <= fetch_epoch_r + 1'b1;
        end else if (redirect_decode) begin
            pc <= decode_predicted_next_pc;
            fetch_epoch_r <= fetch_epoch_r + 1'b1;
        end else if(fetch_accept) begin
            pc <= next_pc;
        end
    end
end
always_comb begin
    if (init_pc)
        next_pc = pc;
    else if (redirect_ex)
        next_pc = actual_next_pc_ex;
    else if (redirect_decode)
        next_pc = decode_predicted_next_pc;
    else if (fetch_prediction_taken)
        next_pc = btb_target_fetch;
    else
        next_pc = pc + 4;
end
always_comb begin
    inst_mem_req = memory_io_no_req;
    inst_mem_req.addr = pc;
    inst_mem_req.valid = !init_pc && !redirect_ex && !redirect_decode
        && (fetch_count_r < FETCH_DEPTH);
    inst_mem_req.do_read  = 4'b1111;
    inst_mem_req.user_tag = fetch_epoch_r;
end

assign fetch_accept = inst_mem_req.valid && inst_mem_rsp.ready;
assign instruction_response_current = inst_mem_rsp.valid
    && (inst_mem_rsp.user_tag == fetch_epoch_r);
assign fetch_head_ready = (fetch_count_r != 0)
    && fetch_entries_r[fetch_head_r].complete
    && (fetch_entries_r[fetch_head_r].epoch == fetch_epoch_r);
assign fetch_dequeue = fetch_head_ready && !STALL_IF_ID
    && !redirect_ex && !redirect_decode;

// BSG returns requests in order. Entries are allocated on request acceptance,
// completed in response order, and consumed by decode. The total allocated
// population is bounded, so the response path never needs core backpressure.
always_ff @(posedge clk) begin
    if (reset) begin
        fetch_head_r <= '0;
        fetch_tail_r <= '0;
        fetch_response_r <= '0;
        fetch_count_r <= '0;
        for (int entry = 0; entry < FETCH_DEPTH; entry = entry + 1)
            fetch_entries_r[entry] <= '0;
    end else if (redirect_ex || redirect_decode) begin
        fetch_head_r <= '0;
        fetch_tail_r <= '0;
        fetch_response_r <= '0;
        fetch_count_r <= '0;
        for (int entry = 0; entry < FETCH_DEPTH; entry = entry + 1)
            fetch_entries_r[entry].complete <= 1'b0;
    end else begin
        if (fetch_accept) begin
            fetch_entries_r[fetch_tail_r].complete <= 1'b0;
            fetch_entries_r[fetch_tail_r].epoch <= fetch_epoch_r;
            fetch_entries_r[fetch_tail_r].pc <= pc;
            fetch_entries_r[fetch_tail_r].inst <= NOP;
            fetch_entries_r[fetch_tail_r].predicted_taken
                <= fetch_prediction_taken;
            fetch_entries_r[fetch_tail_r].btb_hit <= btb_hit_fetch;
            fetch_entries_r[fetch_tail_r].predicted_target
                <= btb_target_fetch;
            fetch_tail_r <= (FETCH_DEPTH == 1)
                ? '0 : fetch_tail_r + 1'b1;
        end

        if (instruction_response_current) begin
            fetch_entries_r[fetch_response_r].inst <= inst_mem_rsp.data;
            fetch_entries_r[fetch_response_r].complete <= 1'b1;
            fetch_response_r <= (FETCH_DEPTH == 1)
                ? '0 : fetch_response_r + 1'b1;
        end

        if (fetch_dequeue) begin
            fetch_entries_r[fetch_head_r].complete <= 1'b0;
            fetch_head_r <= (FETCH_DEPTH == 1)
                ? '0 : fetch_head_r + 1'b1;
        end

        case ({fetch_accept, fetch_dequeue})
            2'b10: fetch_count_r <= fetch_count_r + 1'b1;
            2'b01: fetch_count_r <= fetch_count_r - 1'b1;
            default: fetch_count_r <= fetch_count_r;
        endcase
    end
end

always_comb begin
    IF_ID_n = '0;
    if (FLUSH_IF_ID) begin
        IF_ID_n.valid = 1'b0;
        IF_ID_n.inst = 32'h0;
        IF_ID_n.pc = 0;
        IF_ID_n.predicted_taken = 1'b0;
        IF_ID_n.btb_hit = 1'b0;
        IF_ID_n.predicted_target = '0;
        IF_ID_n.predictor_index = '0;
    end
    else if (fetch_head_ready) begin
        IF_ID_n.valid = 1'b1;
        IF_ID_n.inst = fetch_entries_r[fetch_head_r].inst;
        IF_ID_n.pc = fetch_entries_r[fetch_head_r].pc;
        IF_ID_n.predicted_taken
            = fetch_entries_r[fetch_head_r].predicted_taken;
        IF_ID_n.btb_hit = fetch_entries_r[fetch_head_r].btb_hit;
        IF_ID_n.predicted_target
            = fetch_entries_r[fetch_head_r].predicted_target;
        IF_ID_n.predictor_index = '0;
    end
end

// word latched_instr_read;

//saving IF in pipeline register
always_ff @(posedge clk ) begin 
    if (reset)
        IF_ID_r <= '0;
    else if(~STALL_IF_ID)
        IF_ID_r <= IF_ID_n;
end

////////////////////////////////////////////////////////////////////////////////////
//hazard unit
////////////////////////////////////////////////////////////////////////////////////


always_comb begin
    STALL_PC = false;
    STALL_IF_ID = false;
    FLUSH_IF_ID = false;
    STALL_ID_EX = false;
    STALL_ID_EX = false;
    FLUSH_ID_EX = false;
    STALL_EX_MEM = false;
    FLUSH_EX_MEM = false;
    STALL_MEM_WB = false;
    FLUSH_MEM_WB = false;


    //load use hazard detection

    if((ID_EX_r.valid && IF_ID_r.valid
        && (ID_EX_r.decoded.opcode == OPCODE_I_LOAD) &&
        ((ID_EX_r.decoded.rd == get_rs1(IF_ID_r.inst)) ||
         (ID_EX_r.decoded.rd == get_rs2(IF_ID_r.inst))))) begin
         FLUSH_ID_EX = true;// send one nop into ex
         STALL_IF_ID = true;// stall the if/id pipeline register to hold use in decode stage
         STALL_PC = true;// stall the pc to not fetch the next instruction
    end

    if (redirect_ex) begin
        FLUSH_ID_EX = true; //flush the id/ex pipeline register
        FLUSH_IF_ID = true; //discard instructions from the incorrect path
    end
    if (redirect_decode)
        FLUSH_IF_ID = true;

    if (memory_wait) begin
        STALL_PC = true;
        STALL_IF_ID = true;
        STALL_ID_EX = true;
        STALL_EX_MEM = true;
        FLUSH_ID_EX = false;
        FLUSH_IF_ID = false;
    end

    // Hold the younger stages for the single registered multiplier cycle.
    // EX/MEM remains free so the preceding instruction can continue.
    if (execute_multiply && !multiply_pending_r) begin
        STALL_PC = true;
        STALL_IF_ID = true;
        STALL_ID_EX = true;
        FLUSH_ID_EX = false;
    end
end


///////////////////////////////////////////////////////////////////////////////////
//decode
///////////////////////////////////////////////////////////////////////////////////

always_comb begin
    decode_stage_instruction = decode_instruction(IF_ID_r.inst);
    decode_control = IF_ID_r.valid
        && ((decode_stage_instruction.opcode == OPCODE_SB)
            || (decode_stage_instruction.opcode == OPCODE_UJ_JAL)
            || (decode_stage_instruction.opcode == OPCODE_I_JALR));
    decode_conditional = IF_ID_r.valid
        && (decode_stage_instruction.opcode == OPCODE_SB);

    decode_prediction_taken = IF_ID_r.predicted_taken;
    decode_prediction_target = IF_ID_r.predicted_target;
    if (ENABLE_BRANCH_PREDICTION && decode_conditional) begin
        decode_prediction_taken = gshare_taken_decode;
        if (!IF_ID_r.btb_hit)
            decode_prediction_target = IF_ID_r.pc
                + decode_stage_instruction.imm;
    end else if (ENABLE_BRANCH_PREDICTION
        && decode_stage_instruction.opcode == OPCODE_UJ_JAL) begin
        decode_prediction_taken = 1'b1;
        if (!IF_ID_r.predicted_taken)
            decode_prediction_target = IF_ID_r.pc
                + decode_stage_instruction.imm;
    end else if (!ENABLE_BRANCH_PREDICTION) begin
        decode_prediction_taken = 1'b0;
        decode_prediction_target = '0;
    end

    decode_fetched_next_pc = IF_ID_r.predicted_taken
        ? IF_ID_r.predicted_target : IF_ID_r.pc + 4;
    decode_predicted_next_pc = decode_prediction_taken
        ? decode_prediction_target : IF_ID_r.pc + 4;
    redirect_decode = ENABLE_BRANCH_PREDICTION && decode_control
        && (decode_fetched_next_pc != decode_predicted_next_pc);
end

always_comb begin
    ID_EX_n = '0;
    ID_EX_n.valid = IF_ID_r.valid;
    ID_EX_n.inst = IF_ID_r.inst;
    ID_EX_n.decoded = decode_instruction(IF_ID_r.inst);
    Read_Addr1 = ID_EX_n.decoded.rs1;
    Read_Addr2 = ID_EX_n.decoded.rs2;

    ID_EX_n.pc = IF_ID_r.pc;
    ID_EX_n.predicted_taken = decode_prediction_taken;
    ID_EX_n.btb_hit = IF_ID_r.btb_hit;
    ID_EX_n.predicted_target = decode_prediction_target;
    ID_EX_n.predictor_index = gshare_index_decode;
    ID_EX_n.reg_write_enable = false;
    case (ID_EX_n.decoded.opcode)
        OPCODE_R
        ,OPCODE_I_IMM
        ,OPCODE_I_LOAD
        ,OPCODE_U_LUI
        ,OPCODE_I_JALR
        ,OPCODE_UJ_JAL
        ,OPCODE_U_AUIPC: ID_EX_n.reg_write_enable = true;
        default: ID_EX_n.reg_write_enable = false;
    endcase

    if(FLUSH_ID_EX) begin
        ID_EX_n.valid = 1'b0;
        ID_EX_n.decoded = decode_instruction(NOP);
        ID_EX_n.inst = 0;
        Read_Addr1 = 0;
        Read_Addr2 = 0;
        ID_EX_n.pc = 0;
        ID_EX_n.reg_write_enable = false;
        ID_EX_n.predicted_taken = 1'b0;
        ID_EX_n.predicted_target = '0;
        ID_EX_n.predictor_index = '0;
    end

    // A variable-latency data access can hold ID/EX for many cycles. Keep the
    // synchronous register-file read addresses on the held instruction so its
    // operands do not drift to the younger instruction in IF/ID.
    if (STALL_ID_EX) begin
        Read_Addr1 = ID_EX_r.decoded.rs1;
        Read_Addr2 = ID_EX_r.decoded.rs2;
    end
end

always_ff @(posedge clk) begin
    if (reset)
        ID_EX_r <= '0;
    else if(~STALL_ID_EX)
        ID_EX_r <= ID_EX_n;
end

//////////////////////////////////////////////////////////////////////////////////////
//exec
//////////////////////////////////////////////////////////////////////////////////////
logic [31:0] forwarded_read_data1;
logic [31:0] forwarded_read_data2;
logic [31:0] ex_mem_forward_data;

assign execute_multiply = ID_EX_r.valid
    && (ID_EX_r.decoded.opcode == OPCODE_R)
    && ((ID_EX_r.decoded.alu_op == ALU_MUL)
        || (ID_EX_r.decoded.alu_op == ALU_MULH)
        || (ID_EX_r.decoded.alu_op == ALU_MULHSU)
        || (ID_EX_r.decoded.alu_op == ALU_MULHU));
assign multiply_request = execute_multiply && !multiply_pending_r
    && !memory_wait;
assign multiply_signed = ID_EX_r.decoded.alu_op == ALU_MULH;

bsg_mul_pipelined #(
    .width_p(32),
    .pipeline_p(1),
    .harden_p(0)
) execute_multiplier (
    .clk_i(clk),
    .en_i(multiply_request),
    .x_i(forwarded_read_data1),
    .y_i(forwarded_read_data2),
    .signed_i(multiply_signed),
    .z_o(multiply_product)
);

always_comb begin
    case (ID_EX_r.decoded.alu_op)
        ALU_MUL: multiply_result = multiply_product[31:0];
        ALU_MULH, ALU_MULHU: multiply_result = multiply_product[63:32];
        ALU_MULHSU: multiply_result = multiply_product[63:32]
            - (multiply_lhs_negative_r ? multiply_rhs_r : 32'd0);
        default: multiply_result = 32'd0;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        multiply_pending_r <= 1'b0;
        multiply_lhs_negative_r <= 1'b0;
        multiply_rhs_r <= '0;
    end else begin
        if (multiply_request) begin
            multiply_pending_r <= 1'b1;
            multiply_lhs_negative_r <= forwarded_read_data1[31];
            multiply_rhs_r <= forwarded_read_data2;
        end else if (multiply_pending_r && !memory_wait) begin
            multiply_pending_r <= 1'b0;
        end
    end
end

always_comb begin
    if ((EX_MEM_r.decoded.opcode == OPCODE_UJ_JAL)
        || (EX_MEM_r.decoded.opcode == OPCODE_I_JALR))
        ex_mem_forward_data = EX_MEM_r.pc + 4;
    else
        ex_mem_forward_data = EX_MEM_r.ALU_Result;

    forwarded_read_data1 = Read_Data1;
    if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0)
        && (EX_MEM_r.decoded.rd == ID_EX_r.decoded.rs1))
        forwarded_read_data1 = ex_mem_forward_data;
    else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0)
        && (MEM_WB_r.decoded.rd == ID_EX_r.decoded.rs1))
        forwarded_read_data1 = Write_Data;

    forwarded_read_data2 = Read_Data2;
    if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0)
        && (EX_MEM_r.decoded.rd == ID_EX_r.decoded.rs2))
        forwarded_read_data2 = ex_mem_forward_data;
    else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0)
        && (MEM_WB_r.decoded.rd == ID_EX_r.decoded.rs2))
        forwarded_read_data2 = Write_Data;
end

always_comb begin  
    execute_enable = !memory_wait;
    control_ex = execute_enable && ID_EX_r.valid
        && ((ID_EX_r.decoded.opcode == OPCODE_SB)
        || (ID_EX_r.decoded.opcode == OPCODE_UJ_JAL)
        || (ID_EX_r.decoded.opcode == OPCODE_I_JALR));
    conditional_branch_ex = ID_EX_r.valid
        && (ID_EX_r.decoded.opcode == OPCODE_SB);
    actual_taken_ex = 1'b0;

    if (ID_EX_r.decoded.opcode == OPCODE_UJ_JAL)
        actual_taken_ex = 1'b1;
    else if (ID_EX_r.decoded.opcode == OPCODE_I_JALR)
        actual_taken_ex = 1'b1;
    else if (ID_EX_r.decoded.opcode == OPCODE_SB) begin
        case (ID_EX_r.decoded.funct3)
            FUNCT3_BEQ: actual_taken_ex = (forwarded_read_data1 == forwarded_read_data2);
            FUNCT3_BNE: actual_taken_ex = (forwarded_read_data1 != forwarded_read_data2);
            FUNCT3_BLT: actual_taken_ex = ($signed(forwarded_read_data1) < $signed(forwarded_read_data2));
            FUNCT3_BGE: actual_taken_ex = ($signed(forwarded_read_data1) >= $signed(forwarded_read_data2));
            FUNCT3_BLTU: actual_taken_ex = (forwarded_read_data1 < forwarded_read_data2);
            FUNCT3_BGEU: actual_taken_ex = (forwarded_read_data1 >= forwarded_read_data2);
            default: actual_taken_ex = 1'b0;
        endcase
    end

    if (ID_EX_r.decoded.opcode == OPCODE_I_JALR)
        actual_target_ex = (forwarded_read_data1 + ID_EX_r.decoded.imm) & ~32'd1;
    else
        actual_target_ex = ID_EX_r.pc + ID_EX_r.decoded.imm;

    actual_next_pc_ex = actual_taken_ex ? actual_target_ex : ID_EX_r.pc + 4;
    predicted_next_pc_ex = ID_EX_r.predicted_taken
        ? ID_EX_r.predicted_target : ID_EX_r.pc + 4;
    redirect_ex = control_ex
        && (actual_next_pc_ex != predicted_next_pc_ex);

    predictor_update_valid = control_ex;
    btb_update_valid = predictor_update_valid
        && (ID_EX_r.decoded.opcode != OPCODE_I_JALR);
    predictor_update_conditional = conditional_branch_ex;
    predictor_update_taken = actual_taken_ex;
    predictor_update_pc = ID_EX_r.pc;
    predictor_update_target = actual_target_ex;
    predictor_update_index = ID_EX_r.predictor_index;

// Calculate jump for me based on opcodes:
    if(FLUSH_EX_MEM) begin
        EX_MEM_n.valid = 1'b0;
        EX_MEM_n.decoded = decode_instruction(NOP);
        EX_MEM_n.inst = 0;
        EX_MEM_n.pc = 0;
        EX_MEM_n.reg_write_enable = false;
        EX_MEM_n.jump = false;
        EX_MEM_n.mispredict = false;
        EX_MEM_n.Read_Data1 = 0;
        EX_MEM_n.Read_Data2 = 0;
        EX_MEM_n.ALU_Result = 0;
        EX_MEM_n.next_pc = 0;
    end
    else begin
        EX_MEM_n.valid = ID_EX_r.valid
            && (!execute_multiply || multiply_pending_r);
        EX_MEM_n.pc = ID_EX_r.pc;
        EX_MEM_n.decoded = ID_EX_r.decoded;
        EX_MEM_n.inst = ID_EX_r.inst;

        EX_MEM_n.Read_Data1 = forwarded_read_data1;
        EX_MEM_n.Read_Data2 = forwarded_read_data2;

        EX_MEM_n.reg_write_enable = ID_EX_r.reg_write_enable;
        EX_MEM_n.jump = false; // Default to no jump

        EX_MEM_n.jump = actual_taken_ex;
        EX_MEM_n.mispredict = redirect_ex;
        EX_MEM_n.ALU_Result = execute_multiply
            ? multiply_result
            : ALU_EXEC(EX_MEM_n.decoded, EX_MEM_n.Read_Data1,
                EX_MEM_n.Read_Data2, EX_MEM_n.pc);
        EX_MEM_n.next_pc = actual_next_pc_ex;
    end
end

always_ff @( posedge clk ) begin 
    if (reset)
        EX_MEM_r <= '0;
    else if(~STALL_EX_MEM) begin
        EX_MEM_r <= EX_MEM_n;
    end
end

//////////////////////////////////////////////////////////////////////////////////////
//memory stage 
//////////////////////////////////////////////////////////////////////////////////////

// Issue requests in Mem stage and wait for the response in the WB stage.

logic[1:0] store_offset;
logic [31:0] store_data;
logic [3:0] store_mask;
logic store_queue_has_unsent;

assign ex_mem_load = EX_MEM_r.valid
    && (EX_MEM_r.decoded.opcode == OPCODE_I_LOAD);
assign ex_mem_store = EX_MEM_r.valid
    && (EX_MEM_r.decoded.opcode == OPCODE_S);
assign memory_operation_ex_mem = ex_mem_load || ex_mem_store;
assign store_queue_has_unsent = store_count_r > store_outstanding_r;
assign load_response = data_mem_rsp.valid && memory_pending_r;
assign store_response = data_mem_rsp.valid && !memory_pending_r
    && (store_outstanding_r != 0);
assign memory_wait = ex_mem_load
    ? !load_response
    : (ex_mem_store && (store_count_r == STORE_DEPTH));
assign store_enqueue = ex_mem_store && (store_count_r < STORE_DEPTH);
assign store_request_accept = data_mem_req.valid
    && (data_mem_req.do_write != 0) && data_mem_rsp.ready;
assign load_request_accept = data_mem_req.valid
    && (data_mem_req.do_read != 0) && data_mem_rsp.ready;

always_comb begin
    store_offset = EX_MEM_r.ALU_Result[1:0];
    store_data = EX_MEM_r.Read_Data2;
    if (EX_MEM_r.decoded.funct3 == FUNCT3_SB) begin
        case (store_offset)
            2'b00: store_data = {24'd0, EX_MEM_r.Read_Data2[7:0]};
            2'b01: store_data = {16'd0, EX_MEM_r.Read_Data2[7:0], 8'd0};
            2'b10: store_data = {8'd0, EX_MEM_r.Read_Data2[7:0], 16'd0};
            default: store_data = {EX_MEM_r.Read_Data2[7:0], 24'd0};
        endcase
    end else if (EX_MEM_r.decoded.funct3 == FUNCT3_SH) begin
        store_data = (store_offset == 2'b00)
            ? {16'd0, EX_MEM_r.Read_Data2[15:0]}
            : {EX_MEM_r.Read_Data2[15:0], 16'd0};
    end
    store_mask = write_mask(EX_MEM_r.decoded.funct3, EX_MEM_r.ALU_Result);
end

always_ff @(posedge clk) begin
    if (reset) begin
        store_head_r <= '0;
        store_tail_r <= '0;
        store_issue_r <= '0;
        store_count_r <= '0;
        store_outstanding_r <= '0;
        for (int entry = 0; entry < STORE_DEPTH; entry = entry + 1)
            store_entries_r[entry] <= '0;
    end else begin
        if (store_enqueue) begin
            store_entries_r[store_tail_r].addr <= EX_MEM_r.ALU_Result;
            store_entries_r[store_tail_r].data <= store_data;
            store_entries_r[store_tail_r].mask <= store_mask;
            store_tail_r <= (STORE_DEPTH == 1)
                ? '0 : store_tail_r + 1'b1;
        end

        if (store_request_accept)
            store_issue_r <= (STORE_DEPTH == 1)
                ? '0 : store_issue_r + 1'b1;

        if (store_response)
            store_head_r <= (STORE_DEPTH == 1)
                ? '0 : store_head_r + 1'b1;

        case ({store_enqueue, store_response})
            2'b10: store_count_r <= store_count_r + 1'b1;
            2'b01: store_count_r <= store_count_r - 1'b1;
            default: store_count_r <= store_count_r;
        endcase

        case ({store_request_accept, store_response})
            2'b10: store_outstanding_r <= store_outstanding_r + 1'b1;
            2'b01: store_outstanding_r <= store_outstanding_r - 1'b1;
            default: store_outstanding_r <= store_outstanding_r;
        endcase
    end
end

always_ff @(posedge clk) begin
    if (reset)
        memory_pending_r <= 1'b0;
    else begin
        if (load_response)
            memory_pending_r <= 1'b0;
        else if (load_request_accept)
            memory_pending_r <= 1'b1;
    end
end

always_comb begin
    data_mem_req = memory_io_no_req;

    if (store_queue_has_unsent) begin
        data_mem_req.valid = 1'b1;
        data_mem_req.addr = store_entries_r[store_issue_r].addr;
        data_mem_req.data = store_entries_r[store_issue_r].data;
        data_mem_req.do_write = store_entries_r[store_issue_r].mask;
    end else if (ex_mem_load && (store_count_r == 0)
        && !memory_pending_r) begin
        data_mem_req.valid = 1'b1;
        data_mem_req.addr = EX_MEM_r.ALU_Result;
        case(EX_MEM_r.decoded.funct3)
            FUNCT3_LB, FUNCT3_LBU: data_mem_req.do_read = `byte8;
            FUNCT3_LH, FUNCT3_LHU: data_mem_req.do_read = `half_word16;
            default: data_mem_req.do_read = `whole_word32;
        endcase
    end
end

wire [`word_size-1:0] MEM_RSP = data_mem_rsp.data;
//extracing data from memory response
logic [1:0] byte_offset;
logic [7:0] data_byte;
logic[15:0] data_halfword;
word data_word;
assign byte_offset = data_mem_rsp.addr[1:0];
always_comb begin        
    data_byte = MEM_RSP[7:0];
    data_halfword = MEM_RSP[15:0];
    case(EX_MEM_r.decoded.funct3)
        // For signed loads, sign-extend the loaded data.
        FUNCT3_LB: begin 
            data_byte = (byte_offset == 2'b00) ? MEM_RSP[7:0] :
                        (byte_offset == 2'b01) ? MEM_RSP[15:8] :
                        (byte_offset == 2'b10) ? MEM_RSP[23:16] :
                                                 MEM_RSP[31:24];
            data_word = {{24{data_byte[7]}}, data_byte};
        end
        FUNCT3_LH: begin
            data_halfword = (byte_offset == 2'b00) ? MEM_RSP[15:0] : MEM_RSP[31:16];
            data_word = {{16{data_halfword[15]}}, data_halfword};
        end
        // For unsigned loads, zero-extend the loaded data.
        FUNCT3_LBU: begin 
             data_byte = (byte_offset == 2'b00) ? MEM_RSP[7:0] :
                        (byte_offset == 2'b01) ? MEM_RSP[15:8] :
                        (byte_offset == 2'b10) ? MEM_RSP[23:16] :
                                                 MEM_RSP[31:24];
            data_word = {24'd0, data_byte};
        end
        FUNCT3_LHU: begin 
            data_halfword = (byte_offset == 2'b00) ? MEM_RSP[15:0] : MEM_RSP[31:16];
            data_word = {16'd0, data_halfword};
        end
        // For word loads, no extraction is needed.
        FUNCT3_LW:  data_word = MEM_RSP;
        default:    data_word = MEM_RSP;
    endcase
end

//this is to define values for MEM_WB
always_comb begin 
    MEM_WB_n = '0;
    if(FLUSH_MEM_WB) begin
        MEM_WB_n.valid = 1'b0;
        MEM_WB_n.inst = 0;
        MEM_WB_n.pc = 0;
        MEM_WB_n.decoded = decode_instruction(NOP);
        MEM_WB_n.Read_Data2 = 0;
        MEM_WB_n.reg_write_enable = false;
        MEM_WB_n.ALU_Result = 0;
        MEM_WB_n.Load_Result = 0;
        MEM_WB_n.mem_complete = false;
    end
    else begin
        MEM_WB_n.valid = EX_MEM_r.valid && !memory_wait;
        MEM_WB_n.inst = EX_MEM_r.inst;
        MEM_WB_n.pc = EX_MEM_r.pc;
        MEM_WB_n.decoded = EX_MEM_r.decoded;
        MEM_WB_n.Read_Data2 = EX_MEM_r.Read_Data2;
        MEM_WB_n.reg_write_enable = EX_MEM_r.reg_write_enable;
        MEM_WB_n.ALU_Result = EX_MEM_r.ALU_Result; 
        MEM_WB_n.Load_Result = data_word;
        MEM_WB_n.mem_complete = !ex_mem_load || load_response;
    end
end
always_ff @( posedge clk ) begin 
    if (reset)
        MEM_WB_r <= '0;
    else if(~STALL_MEM_WB) begin
        MEM_WB_r <= MEM_WB_n;
    end
end

//////////////////////////////////////////////////////////////////////////////////////
//writeback
//////////////////////////////////////////////////////////////////////////////////////
always_comb begin
    rv = true;
    wv = false;
    if (MEM_WB_r.valid && MEM_WB_r.mem_complete
        && MEM_WB_r.reg_write_enable
        && MEM_WB_r.decoded.rd != '0) begin
        wv = true;
    end

    Write_Addr = MEM_WB_r.decoded.rd;
    if ((MEM_WB_r.decoded.opcode == OPCODE_I_LOAD)) begin
        Write_Data = MEM_WB_r.Load_Result;
    end
    else if (MEM_WB_r.decoded.opcode == OPCODE_UJ_JAL||MEM_WB_r.decoded.opcode == OPCODE_I_JALR) begin
        Write_Data = MEM_WB_r.pc+4;
    end
    else 
        Write_Data = MEM_WB_r.ALU_Result;
end

always_ff @(posedge clk) begin
    if (reset) begin
        cycle_count_o <= '0;
        retire_count_o <= '0;
        branch_count_o <= '0;
        branch_mispredict_count_o <= '0;
        btb_hit_count_o <= '0;
    end else begin
        cycle_count_o <= cycle_count_o + 1'b1;
        if (MEM_WB_r.valid && MEM_WB_r.mem_complete)
            retire_count_o <= retire_count_o + 1'b1;
        if (predictor_update_valid)
            branch_count_o <= branch_count_o + 1'b1;
        if (redirect_ex)
            branch_mispredict_count_o <= branch_mispredict_count_o + 1'b1;
        if (inst_mem_req.valid && inst_mem_rsp.ready && btb_hit_fetch)
            btb_hit_count_o <= btb_hit_count_o + 1'b1;
    end
end

logic kernel_profile_active_r;
always_ff @(posedge clk) begin
    if (reset) begin
        kernel_profile_active_r <= 1'b0;
        kernel_cycle_count_o <= '0;
        kernel_retire_count_o <= '0;
        kernel_branch_count_o <= '0;
        kernel_mispredict_count_o <= '0;
    end else if (profile_start_i) begin
        kernel_profile_active_r <= 1'b1;
        kernel_cycle_count_o <= '0;
        kernel_retire_count_o <= '0;
        kernel_branch_count_o <= '0;
        kernel_mispredict_count_o <= '0;
    end else begin
        if (profile_stop_i)
            kernel_profile_active_r <= 1'b0;
        if (kernel_profile_active_r) begin
            kernel_cycle_count_o <= kernel_cycle_count_o + 1'b1;
            if (MEM_WB_r.valid && MEM_WB_r.mem_complete)
                kernel_retire_count_o <= kernel_retire_count_o + 1'b1;
            if (predictor_update_valid)
                kernel_branch_count_o <= kernel_branch_count_o + 1'b1;
            if (redirect_ex)
                kernel_mispredict_count_o <= kernel_mispredict_count_o + 1'b1;
        end
    end
end

endmodule
`endif
