`ifndef _core_v
`define _core_v
`include "system.sv"
`include "base.sv"
`include "memory_io.sv"
`include "memory.sv"
`include "reg_file.sv"
`include "printDebug.sv"
//-------------------------------------------------------------------------
// Pipeline register definitions
//-------------------------------------------------------------------------
// IF/ID register: latch fetched instruction and PC
typedef struct packed{
    word    pc;
    logic [31:0] inst;
} IF_ID_t;
// ID/EX register: latch decoded fields and register file outputs
typedef struct packed{
    word                  inst;
    word                   pc;
    instruction_decode_t   decoded;
    word Bypass_Read_Data1;
    word Bypass_Read_Data2;
    logic raw1;
    logic raw2;
    // word                   Read_Data1;
    // word                   Read_Data2;
    logic                  reg_write_enable;
} ID_EX_t;
// EX/MEM register: latch ALU result and branch outcome (plus data for stores)
typedef struct packed{
    word inst;
    word                   pc;
    instruction_decode_t   decoded;
    word                   ALU_Result;
    word                   next_pc;
    logic                  jump;
    word                   Read_Data1;
    word                   Read_Data2; // For store instructions
    logic                  reg_write_enable;
} EX_MEM_t;
// MEM/WB register: latch write-back data
typedef struct packed{
    word inst;
    word                   pc;
    instruction_decode_t   decoded;
    logic                  reg_write_enable;
    logic                  mem_complete;
    word                   ALU_Result;
    word                   Read_Data2;
    word                   load_result;
} MEM_WB_t;
//-------------------------------------------------------------------------
module core(
    input logic       clk
    ,input logic      reset
    ,input logic      [`word_address_size-1:0] reset_pc
    ,output memory_io_req   inst_mem_req
    ,input  memory_io_rsp   inst_mem_rsp
    ,output memory_io_req   data_mem_req
    ,input  memory_io_rsp   data_mem_rsp
    );


////////////////////////////////////////////////////////////////////////////////////
//pileline registers
////////////////////////////////////////////////////////////////////////////////////
IF_ID_t IF_ID_r, IF_ID_n;

ID_EX_t ID_EX_r, ID_EX_n;

EX_MEM_t EX_MEM_r, EX_MEM_n;

MEM_WB_t MEM_WB_r, MEM_WB_n;



logic wv, rv;
logic [4:0] Read_Addr1, Read_Addr2, Write_Addr;
logic [31:0] Read_Data1, Read_Data2, Write_Data;
logic RaW_Bypass1, RaW_Bypass2;


word    pc;
word   next_pc;


regFile reg_file (
    .clk(clk),
    .Read_Addr1(Read_Addr1),
    .Read_Data1(Read_Data1),
    .Read_Addr2(Read_Addr2),
    .Read_Data2(Read_Data2),
    .Write_Addr(Write_Addr),
    .Write_Data(Write_Data),
    .RaW_Bypass1(RaW_Bypass1),
    .RaW_Bypass2(RaW_Bypass2),
    .wv(wv),
    .rv(rv)
);

typedef enum {
    stage_fetch
    ,stage_decode
    ,stage_execute
    ,stage_mem
    ,stage_writeback
}   stage;

stage   current_stage;

logic stall;
logic flush;
assign flush = EX_MEM_n.jump;
// logic mem_complete;

////////////////////////////////////////////////////////////////////////////////////
// Stage Fetch
////////////////////////////////////////////////////////////////////////////////////

//figure out how to do pc updating 
//mux for next_pc
always_comb begin
   if (reset)
      next_pc = reset_pc;

   else begin
        if (EX_MEM_n.jump) 
            next_pc = EX_MEM_n.next_pc;
        else    
            next_pc = pc+4;
   end
end
//request read from memory before pc is latched
always_comb begin
    inst_mem_req.addr = next_pc;
    inst_mem_req.valid = inst_mem_rsp.ready;
    inst_mem_req.do_read  = 4'b1111;
end

always_ff @(posedge clk) begin 
    if(~stall)
        pc <= next_pc;
    
end

//comb fetch instruction 

always_comb begin
    if (flush) begin
        IF_ID_n.inst = 32'h0;
        IF_ID_n.pc = 0;
        // Read_Addr1 = 0;
        // Read_Addr2 = 0;
    end
    else begin 
        if (inst_mem_rsp.valid) begin
            IF_ID_n.inst = inst_mem_rsp.data;
        end
        IF_ID_n.pc = pc;
        // Read_Addr1 = get_rs1(IF_ID_n.inst);
        // Read_Addr2 = get_rs2(IF_ID_n.inst);
    end
end

// word latched_instr_read;

//saving IF in pipeline register
always_ff @(posedge clk ) begin 
    if(~stall)
        IF_ID_r <= IF_ID_n;
end

///////////////////////////////////////////////////////////////////////////////////
//decode
///////////////////////////////////////////////////////////////////////////////////

always_comb begin
    ID_EX_n.inst = IF_ID_r.inst;
    stall = false;
    ID_EX_n.raw1 = false;
    ID_EX_n.raw1 = false;
    ID_EX_n.decoded = decode_instruction(IF_ID_r.inst);
    Read_Addr1 = ID_EX_n.decoded.rs1;
    Read_Addr2 = ID_EX_n.decoded.rs2;
    if(RaW_Bypass1) begin
        ID_EX_n.Bypass_Read_Data1 = Read_Data1;
        ID_EX_n.raw1 = true;
    end
    if(RaW_Bypass2) begin 
        ID_EX_n.Bypass_Read_Data2 = Read_Data2;
        ID_EX_n.raw2 = true;
    end
    // ID_EX_n.Read_Data1 = Read_Data1;
    // ID_EX_n.Read_Data2 = Read_Data2;
    
    ID_EX_n.pc = IF_ID_r.pc;
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
    
    //Load Use Hazard Detection
    // stall = ((ID_EX_r.decoded.opcode == OPCODE_I_LOAD) &&
    //          ((ID_EX_r.decoded.rd == ID_EX_n.decoded.rs1) ||
    //           (ID_EX_r.decoded.rd == ID_EX_n.decoded.rs2))) &&
    //             !MEM_WB_r.mem_complete;
    if(((ID_EX_r.decoded.opcode == OPCODE_I_LOAD) &&
        ((ID_EX_r.decoded.rd == ID_EX_n.decoded.rs1) ||
         (ID_EX_r.decoded.rd == ID_EX_n.decoded.rs2))))
         stall = true;

    if(stall||flush) begin
        ID_EX_n.decoded = decode_instruction(NOP);
        ID_EX_n.inst = 0;
        Read_Addr1 = 0;
        Read_Addr2 = 0;
        ID_EX_n.Bypass_Read_Data1 = 0;
        ID_EX_n.Bypass_Read_Data2 = 0;
        ID_EX_n.raw1 = false;
        ID_EX_n.raw2 = false;
        ID_EX_n.pc = flush ? 0 : ID_EX_r.pc;
        ID_EX_n.reg_write_enable = false;
    end
end

always_ff @(posedge clk) begin
    ID_EX_r <= ID_EX_n;
end

//////////////////////////////////////////////////////////////////////////////////////
//exec
//////////////////////////////////////////////////////////////////////////////////////
always_comb begin  
// Calculate jump for me based on opcodes:
    EX_MEM_n.pc = ID_EX_r.pc;
    EX_MEM_n.decoded = ID_EX_r.decoded;
    EX_MEM_n.inst = ID_EX_r.inst;

    //forwarding unit
    if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
        (EX_MEM_r.decoded.rd == EX_MEM_n.decoded.rs1)) begin
        EX_MEM_n.Read_Data1 = EX_MEM_r.ALU_Result;
    end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
                 (MEM_WB_r.decoded.rd == EX_MEM_n.decoded.rs1)) begin
        EX_MEM_n.Read_Data1 = Write_Data;
    end
    else if(ID_EX_r.raw1) begin
        EX_MEM_n.Read_Data1 = ID_EX_r.Bypass_Read_Data1;
    end else begin
        EX_MEM_n.Read_Data1 = Read_Data1;
    end

    // Forwarding for RS2:
    if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
        (EX_MEM_r.decoded.rd == EX_MEM_n.decoded.rs2)) begin
        EX_MEM_n.Read_Data2 = EX_MEM_r.ALU_Result;
    end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
                 (MEM_WB_r.decoded.rd == EX_MEM_n.decoded.rs2)) begin
        EX_MEM_n.Read_Data2 = Write_Data;
    end
    else if(ID_EX_r.raw2) begin
        EX_MEM_n.Read_Data2 = ID_EX_r.Bypass_Read_Data2;
    end
     else begin
        EX_MEM_n.Read_Data2 = Read_Data2;
    end




    EX_MEM_n.reg_write_enable = ID_EX_r.reg_write_enable;
    EX_MEM_n.jump = false; // Default to no jump

    //Branch Resolution
    if (EX_MEM_n.decoded.opcode == OPCODE_UJ_JAL) begin
        EX_MEM_n.jump = true;
    end 
    else if (EX_MEM_n.decoded.opcode == OPCODE_I_JALR) begin
        EX_MEM_n.jump = true;
    end 
    else if (EX_MEM_n.decoded.opcode == OPCODE_SB) begin
        case (EX_MEM_n.decoded.funct3)
            FUNCT3_BEQ: EX_MEM_n.jump = ( EX_MEM_n.Read_Data1 == EX_MEM_n.Read_Data2);
            FUNCT3_BNE: EX_MEM_n.jump = ( EX_MEM_n.Read_Data1 != EX_MEM_n.Read_Data2);
            FUNCT3_BLT: EX_MEM_n.jump = ($signed( EX_MEM_n.Read_Data1) < $signed(EX_MEM_n.Read_Data2));
            FUNCT3_BGE: EX_MEM_n.jump = ($signed( EX_MEM_n.Read_Data1) >= $signed(EX_MEM_n.Read_Data2));
            FUNCT3_BLTU: EX_MEM_n.jump = ( EX_MEM_n.Read_Data1 < EX_MEM_n.Read_Data2);
            FUNCT3_BGEU: EX_MEM_n.jump = ( EX_MEM_n.Read_Data1 >= EX_MEM_n.Read_Data2);
            default: EX_MEM_n.jump = false;
        endcase
    end


    EX_MEM_n.ALU_Result = ALU_EXEC(EX_MEM_n.decoded, EX_MEM_n.Read_Data1, EX_MEM_n.Read_Data2, EX_MEM_n.pc);    
    if(EX_MEM_n.jump) begin
        case (EX_MEM_n.decoded.opcode)
            OPCODE_SB, OPCODE_UJ_JAL: EX_MEM_n.next_pc = EX_MEM_n.pc + EX_MEM_n.decoded.imm;
            OPCODE_I_JALR:  EX_MEM_n.next_pc = (EX_MEM_n.Read_Data1+EX_MEM_n.decoded.imm) & ~1;
            default:  EX_MEM_n.next_pc = EX_MEM_n.pc + EX_MEM_n.decoded.imm;
        endcase
    end
    else begin
         EX_MEM_n.next_pc = pc + 4;
    end
end


//latching the values
always_ff @( posedge clk ) begin 
    EX_MEM_r <= EX_MEM_n;
end

//////////////////////////////////////////////////////////////////////////////////////
//memory stage 
//////////////////////////////////////////////////////////////////////////////////////

//Since Mem is synch read and write, do the request right after ALU, while the EX/MEM is being written to. 
//note the use of EX_MEM_n to get the values at the same time as the pipelinne register 

logic[1:0] store_offset;
logic [31:0] store_data;

always_comb begin


    data_mem_req = memory_io_no_req; 
    if(data_mem_rsp.ready && ((EX_MEM_n.decoded.opcode == OPCODE_I_LOAD)||(EX_MEM_n.decoded.opcode == OPCODE_S))) begin
        case (EX_MEM_n.decoded.opcode)
        //Load Instructions
        OPCODE_I_LOAD: begin 
            data_mem_req.valid = true;
            // For a load, drive the address and the do_read signal.
            data_mem_req.addr    = EX_MEM_n.ALU_Result; // Effective address computed in EX stage
            // Set the correct read width based on funct3:
            case(EX_MEM_r.decoded.funct3)
                FUNCT3_LB, FUNCT3_LBU: 
                    data_mem_req.do_read = `byte8;    // Request an 8-bit read
                FUNCT3_LH, FUNCT3_LHU: 
                    data_mem_req.do_read = `half_word16; // Request a 16-bit read
                FUNCT3_LW: 
                    data_mem_req.do_read = `whole_word32;  // Request a 32-bit read
                default: 
                    data_mem_req.do_read = `whole_word32;
            endcase
        end
        //Store Instructions 
        OPCODE_S: begin
            data_mem_req.valid = true;
            data_mem_req.addr   = EX_MEM_n.ALU_Result;
            //data_mem_req.data   <= 32'hdeadbeef;
            store_offset = data_mem_req.addr[1:0];
            if (EX_MEM_n.decoded.funct3 == FUNCT3_SB) begin
                store_data = (store_offset == 2'b00) ? {24'd0,EX_MEM_n.Read_Data2[7:0]} :
                            (store_offset == 2'b01) ? {16'd0, EX_MEM_n.Read_Data2[7:0], 8'd0} :
                            (store_offset == 2'b10) ? {8'd0, EX_MEM_n.Read_Data2[7:0], 16'd0} :
                                                     {EX_MEM_n.Read_Data2[7:0], 24'd0};
            end
            else if (EX_MEM_n.decoded.funct3 == FUNCT3_SH) begin
                store_data = (store_offset == 2'b00) ? {16'd0, EX_MEM_n.Read_Data2[15:0]} : {MEM_WB_n.Read_Data2[15:0], 16'd0};
            end
            else if (EX_MEM_n.decoded.funct3 == FUNCT3_SW) begin
                store_data = EX_MEM_n.Read_Data2;
            end
            else begin
                store_data = EX_MEM_n.Read_Data2;
            end
            data_mem_req.data   = store_data;
            data_mem_req.do_write = write_mask(EX_MEM_n.decoded.funct3, data_mem_req.addr);
        end
        default: begin
            data_mem_req = memory_io_no_req;
        end
    endcase
    end
end




word Latched_mem_rsp;
word MEM_RSP;
word LOAD_RESULT;

always_ff @(posedge clk) begin
    if (data_mem_rsp.valid) begin
        Latched_mem_rsp <= data_mem_rsp.data;
    end
end

assign MEM_RSP = (data_mem_rsp.valid) ? data_mem_rsp.data : Latched_mem_rsp;

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
            LOAD_RESULT = {{24{data_byte[7]}}, data_byte};
        end
        FUNCT3_LH: begin
            data_halfword = (byte_offset == 2'b00) ? MEM_RSP[15:0] : MEM_RSP[31:16];
            LOAD_RESULT = {{16{data_halfword[15]}}, data_halfword};
        end
        // For unsigned loads, zero-extend the loaded data.
        FUNCT3_LBU: begin 
             data_byte = (byte_offset == 2'b00) ? MEM_RSP[7:0] :
                        (byte_offset == 2'b01) ? MEM_RSP[15:8] :
                        (byte_offset == 2'b10) ? MEM_RSP[23:16] :
                                                 MEM_RSP[31:24];
            LOAD_RESULT = {24'd0, data_byte};
        end
        FUNCT3_LHU: begin 
            data_halfword = (byte_offset == 2'b00) ? MEM_RSP[15:0] : MEM_RSP[31:16];
            LOAD_RESULT = {16'd0, data_halfword};
        end
        // For word loads, no extraction is needed.
        FUNCT3_LW:  LOAD_RESULT = MEM_RSP;
        default:    LOAD_RESULT = MEM_RSP;
    endcase
           
    // if (MEM_WB_n.decoded.opcode == OPCODE_U_LUI) begin
    //     LOAD_RESULT = MEM_WB_n.decoded.imm;
    // end  
end

//this is to define values for MEM_WB
always_comb begin 
    MEM_WB_n.inst = EX_MEM_r.inst;
    MEM_WB_n.pc = EX_MEM_r.pc;
    MEM_WB_n.decoded = EX_MEM_r.decoded;
    MEM_WB_n.Read_Data2 = EX_MEM_r.Read_Data2;
    MEM_WB_n.reg_write_enable = EX_MEM_r.reg_write_enable;
    MEM_WB_n.ALU_Result = EX_MEM_r.ALU_Result; 
    MEM_WB_n.load_result = LOAD_RESULT;
    if(EX_MEM_r.decoded.opcode == OPCODE_I_LOAD) begin
        if(data_mem_rsp.valid) 
            MEM_WB_n.mem_complete = true;
        else    
            MEM_WB_n.mem_complete = false;
    end
    else begin
        MEM_WB_n.mem_complete = true;
    end
end
always_ff @( posedge clk ) begin 
        MEM_WB_r <= MEM_WB_n;
end

//////////////////////////////////////////////////////////////////////////////////////
//writeback
//////////////////////////////////////////////////////////////////////////////////////
always_comb begin
    rv = true;
    wv = false;
    if (MEM_WB_r.reg_write_enable) begin
        wv = true;
    end
end

always_comb begin
    Write_Addr = MEM_WB_r.decoded.rd;
    if ((MEM_WB_r.decoded.opcode == OPCODE_I_LOAD)) begin
        Write_Data = MEM_WB_r.load_result;
    end
    else if (MEM_WB_r.decoded.opcode == OPCODE_UJ_JAL||MEM_WB_r.decoded.opcode == OPCODE_I_JALR) begin
        Write_Data = MEM_WB_r.pc+4;
    end
    else 
        Write_Data = MEM_WB_r.ALU_Result;
end



//////////////////////////////////////////////////////////////////////////////////////
//debugging
//////////////////////////////////////////////////////////////////////////////////////

//show me the state of the pipeline at each cc
always_ff @( posedge clk ) begin
    // $display("RS2: %h", Read_Addr2);
    // $display("RS1: %h", Read_Addr1);
    // if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
    //     (EX_MEM_r.decoded.rd == ID_EX_r.decoded.rs1)) begin
    //     $display("Execute stage: Forwarding active: EX/MEM ALU_Result 0x%h forwarded from rd %0d to RS1 (rs1 value: %0d)",
    //              EX_MEM_r.ALU_Result, EX_MEM_r.decoded.rd, ID_EX_r.decoded.rs1);
    // end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
    //              (MEM_WB_r.decoded.rd == ID_EX_r.decoded.rs1)) begin
    //     $display("Execute stage: Forwarding active: MEM/WB Write_Data 0x%h forwarded from rd %0d to RS1 (rs1 value: %0d)",
    //              Write_Data, MEM_WB_r.decoded.rd, ID_EX_r.decoded.rs1);
    // end

    // if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
    //     (EX_MEM_r.decoded.rd == ID_EX_r.decoded.rs2)) begin
    //     $display("Execute stage: Forwarding active: EX/MEM ALU_Result 0x%h forwarded from rd %0d to RS2 (rs2 value: %0d)",
    //              EX_MEM_r.ALU_Result, EX_MEM_r.decoded.rd, ID_EX_r.decoded.rs2);
    // end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
    //              (MEM_WB_r.decoded.rd == ID_EX_r.decoded.rs2)) begin
    //     $display("Execute stage: Forwarding active: MEM/WB Write_Data 0x%h forwarded from rd %0d to RS2 (rs2 value: %0d)",
    //              Write_Data, MEM_WB_r.decoded.rd, ID_EX_r.decoded.rs2);
    // end
    // $display("ALU Result: %h", EX_MEM_r.ALU_Result);
    // $display("stall: %h", stall);
    // print_debug();
    print_instruction(IF_ID_r.pc, IF_ID_r.inst);
    print_instruction(ID_EX_r.pc, ID_EX_r.inst);
    print_instruction(EX_MEM_r.pc, EX_MEM_r.inst);
    print_instruction(MEM_WB_r.pc, MEM_WB_r.inst);

end

//FUNCTIONS FOR DEBUG ONLY------------------------------------------------------------------------------------------------------------------
function automatic void print_debug();
    // Print values at each pipeline register
    $display("-------------------------------------------------------------------------------------------");
    $display("IF/ID: PC: %h | INST: %h", IF_ID_r.pc, IF_ID_r.inst);
    $display();
    $display("ID/EX: PC: %h | INSTRUCTION: %s | reg_write_enable: %b",
             ID_EX_r.pc, instruction_to_string(ID_EX_r.decoded), ID_EX_r.reg_write_enable);
    $display();
    $display("EX/MEM: PC: %h | INSTRUCTION: %s | ALU_Result: %h | next_pc: %h | jump: %b | Read_Data1: %h | Read_Data2: %h | reg_write_enable: %b",
             EX_MEM_r.pc, instruction_to_string(EX_MEM_r.decoded), EX_MEM_r.ALU_Result, EX_MEM_r.next_pc, EX_MEM_r.jump, EX_MEM_r.Read_Data1, EX_MEM_r.Read_Data2, EX_MEM_r.reg_write_enable);
    $display();
    $display("MEM/WB: PC: %h | INSTRUCTION: %s | Write_Data: %h | reg_write_enable: %b | mem_complete: %b | ALU_Result: %h | Read_Data2: %h",
             MEM_WB_r.pc, instruction_to_string(MEM_WB_r.decoded), Write_Data, MEM_WB_r.reg_write_enable, MEM_WB_r.mem_complete, MEM_WB_r.ALU_Result, MEM_WB_r.Read_Data2);
    $display("-------------------------------------------------------------------------------------------");
endfunction

function automatic string instruction_to_string(instruction_decode_t decoded);
    case (decoded.opcode)
        OPCODE_R: return $sformatf("R-type: funct3=%h, funct7=%h, rs1=%h, rs2=%h, rd=%h", decoded.funct3, decoded.funct7, decoded.rs1, decoded.rs2, decoded.rd);
        OPCODE_I_IMM: return $sformatf("I-type: funct3=%h, rs1=%h, rd=%h, imm=%h", decoded.funct3, decoded.rs1, decoded.rd, decoded.imm);
        OPCODE_I_LOAD: return $sformatf("Load: funct3=%h, rs1=%h, rd=%h, imm=%h", decoded.funct3, decoded.rs1, decoded.rd, decoded.imm);
        OPCODE_S: return $sformatf("Store: funct3=%h, rs1=%h, rs2=%h, imm=%h", decoded.funct3, decoded.rs1, decoded.rs2, decoded.imm);
        OPCODE_SB: return $sformatf("Branch: funct3=%h, rs1=%h, rs2=%h, imm=%h", decoded.funct3, decoded.rs1, decoded.rs2, decoded.imm);
        OPCODE_U_LUI: return $sformatf("LUI: rd=%h, imm=%h", decoded.rd, decoded.imm);
        OPCODE_U_AUIPC: return $sformatf("AUIPC: rd=%h, imm=%h", decoded.rd, decoded.imm);
        OPCODE_UJ_JAL: return $sformatf("JAL: rd=%h, imm=%h", decoded.rd, decoded.imm);
        OPCODE_I_JALR: return $sformatf("JALR: funct3=%h, rs1=%h, rd=%h, imm=%h", decoded.funct3, decoded.rs1, decoded.rd, decoded.imm);
        default: return "Unknown instruction";
    endcase
endfunction



//using for debugging
function automatic string stage_to_string(stage s);
    case (s)
        stage_fetch:      return "FETCH";
        stage_decode:     return "DECODE";
        stage_execute:    return "EXECUTE";
        stage_mem:        return "MEMORY";
        stage_writeback:  return "WRITEBACK";
        default:           return "UNKNOWN";
    endcase
endfunction


endmodule




`endif

