`ifndef _core_v
`define _core_v
`include "RTL/system.sv"
`include "RTL/base.sv"
`include "RTL/memory_io.sv"
`include "RTL/memory.sv"
`include "RTL/reg_file.sv"
`include "RTL/printDebug.sv"

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
word prev_pc;
always_ff @(posedge clk) begin  
    if(reset) begin
        init_pc <= 1;
        pc <= reset_pc;
    end
    if(~STALL_PC) begin
        pc <= next_pc;
        prev_pc <= pc;
    end
    init_pc <= 0;
end
always_comb begin
    if (EX_MEM_n.jump) 
       next_pc = EX_MEM_n.next_pc;
    else    
        next_pc = pc+4;
end
always_comb begin
    inst_mem_req.addr = pc;
    inst_mem_req.valid = (init_pc) ? 0 : (STALL_PC) ? 0 : 1;
    inst_mem_req.do_read  = 4'b1111;
end

//comb fetch instruction 

always_comb begin
    if (FLUSH_IF_ID) begin
        IF_ID_n.inst = 32'h0;
        IF_ID_n.pc = 0;
    end
    else begin 
        if (inst_mem_rsp.valid) begin
            IF_ID_n.inst = inst_mem_rsp.data;
        end
        IF_ID_n.pc = prev_pc;
    end
end

// word latched_instr_read;

//saving IF in pipeline register
always_ff @(posedge clk ) begin 
    if(~STALL_IF_ID)
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

    if(((ID_EX_r.decoded.opcode == OPCODE_I_LOAD) &&
        ((ID_EX_r.decoded.rd == get_rs1(IF_ID_r.inst)) ||
         (ID_EX_r.decoded.rd == get_rs2(IF_ID_r.inst))))) begin
         FLUSH_ID_EX = true;// send one nop into ex
         STALL_IF_ID = true;// stall the if/id pipeline register to hold use in decode stage
         STALL_PC = true;// stall the pc to not fetch the next instruction
    end

    //TODO: change when adding BTB, for now just static predict not taken.
    if((EX_MEM_r.jump == true) ||
        (EX_MEM_r.decoded.opcode == OPCODE_UJ_JAL) ||
        (EX_MEM_r.decoded.opcode == OPCODE_I_JALR)) begin
        FLUSH_ID_EX = true; //flush the id/ex pipeline register
        FLUSH_IF_ID = true; //stall the if/id pipeline register
        FLUSH_EX_MEM = true;
    end
end


///////////////////////////////////////////////////////////////////////////////////
//decode
///////////////////////////////////////////////////////////////////////////////////

always_comb begin
    ID_EX_n.inst = IF_ID_r.inst;
    ID_EX_n.decoded = decode_instruction(IF_ID_r.inst);
    Read_Addr1 = ID_EX_n.decoded.rs1;
    Read_Addr2 = ID_EX_n.decoded.rs2;

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

    if(FLUSH_ID_EX) begin
        ID_EX_n.decoded = decode_instruction(NOP);
        ID_EX_n.inst = 0;
        Read_Addr1 = 0;
        Read_Addr2 = 0;
        ID_EX_n.pc = 0;
        ID_EX_n.reg_write_enable = false;
    end
end

always_ff @(posedge clk) begin
    if(~STALL_ID_EX) begin
    ID_EX_r <= ID_EX_n;
    end
end

//////////////////////////////////////////////////////////////////////////////////////
//exec
//////////////////////////////////////////////////////////////////////////////////////
always_comb begin  
// Calculate jump for me based on opcodes:
    if(FLUSH_EX_MEM) begin
        EX_MEM_n.decoded = decode_instruction(NOP);
        EX_MEM_n.inst = 0;
        EX_MEM_n.pc = 0;
        EX_MEM_n.reg_write_enable = false;
        EX_MEM_n.jump = false;
        EX_MEM_n.Read_Data1 = 0;
        EX_MEM_n.Read_Data2 = 0;
        EX_MEM_n.ALU_Result = 0;
        EX_MEM_n.next_pc = 0;
    end
    else begin
        EX_MEM_n.pc = ID_EX_r.pc;
        EX_MEM_n.decoded = ID_EX_r.decoded;
        EX_MEM_n.inst = ID_EX_r.inst;

        //forwarding unit
        if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
            (EX_MEM_r.decoded.rd == EX_MEM_n.decoded.rs1)) begin
            EX_MEM_n.Read_Data1 = EX_MEM_r.ALU_Result; //forwarding from EX/MEM to RS1
        end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
                    (MEM_WB_r.decoded.rd == EX_MEM_n.decoded.rs1)) begin
            EX_MEM_n.Read_Data1 = Write_Data; //forwarding from MEM/WB to RS1
        end else begin
            EX_MEM_n.Read_Data1 = Read_Data1;
        end

        // Forwarding for RS2:
        if ((EX_MEM_r.reg_write_enable) && (EX_MEM_r.decoded.rd != 0) &&
            (EX_MEM_r.decoded.rd == EX_MEM_n.decoded.rs2)) begin
            EX_MEM_n.Read_Data2 = EX_MEM_r.ALU_Result; //forwarding from EX/MEM to RS2
        end else if ((MEM_WB_r.reg_write_enable) && (MEM_WB_r.decoded.rd != 0) &&
                    (MEM_WB_r.decoded.rd == EX_MEM_n.decoded.rs2)) begin
            EX_MEM_n.Read_Data2 = Write_Data; //forwarding from MEM/WB to RS2
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
end

always_ff @( posedge clk ) begin 
    if(~STALL_EX_MEM) begin
        EX_MEM_r <= EX_MEM_n;
    end
end

//////////////////////////////////////////////////////////////////////////////////////
//memory stage 
//////////////////////////////////////////////////////////////////////////////////////

// Issue requests in Mem stage and wait for the response in the WB stage.

logic[1:0] store_offset;
logic [31:0] store_data;

always_comb begin


    data_mem_req = memory_io_no_req; 
    if(data_mem_rsp.ready && ((EX_MEM_r.decoded.opcode == OPCODE_I_LOAD)||(EX_MEM_r.decoded.opcode == OPCODE_S))) begin
        case (EX_MEM_r.decoded.opcode)
        //Load Instructions
        OPCODE_I_LOAD: begin 
            data_mem_req.valid = true;
            // For a load, drive the address and the do_read signal.
            data_mem_req.addr    = EX_MEM_r.ALU_Result; // Effective address computed in EX stage
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
            data_mem_req.addr   = EX_MEM_r.ALU_Result;
            //data_mem_req.data   <= 32'hdeadbeef;
            store_offset = data_mem_req.addr[1:0];
            if (EX_MEM_r.decoded.funct3 == FUNCT3_SB) begin
                store_data = (store_offset == 2'b00) ? {24'd0,EX_MEM_r.Read_Data2[7:0]} :
                            (store_offset == 2'b01) ? {16'd0, EX_MEM_r.Read_Data2[7:0], 8'd0} :
                            (store_offset == 2'b10) ? {8'd0, EX_MEM_r.Read_Data2[7:0], 16'd0} :
                                                     {EX_MEM_r.Read_Data2[7:0], 24'd0};
            end
            else if (EX_MEM_r.decoded.funct3 == FUNCT3_SH) begin
                store_data = (store_offset == 2'b00) ? {16'd0, EX_MEM_r.Read_Data2[15:0]} : {EX_MEM_r.Read_Data2[15:0], 16'd0};
            end
            else if (EX_MEM_r.decoded.funct3 == FUNCT3_SW) begin
                store_data = EX_MEM_r.Read_Data2;
            end
            else begin
                store_data = EX_MEM_r.Read_Data2;
            end
            data_mem_req.data   = store_data;
            data_mem_req.do_write = write_mask(EX_MEM_r.decoded.funct3, data_mem_req.addr);
        end
        default: begin
            data_mem_req = memory_io_no_req;
        end
    endcase
    end
end

word LOAD_RESULT;
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
    case(MEM_WB_r.decoded.funct3)
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
end

//this is to define values for MEM_WB
always_comb begin 
    if(FLUSH_MEM_WB) begin
        MEM_WB_n.inst = 0;
        MEM_WB_n.pc = 0;
        MEM_WB_n.decoded = decode_instruction(NOP);
        MEM_WB_n.Read_Data2 = 0;
        MEM_WB_n.reg_write_enable = false;
        MEM_WB_n.ALU_Result = 0;
        MEM_WB_n.mem_complete = false;
    end
    else begin
        MEM_WB_n.inst = EX_MEM_r.inst;
        MEM_WB_n.pc = EX_MEM_r.pc;
        MEM_WB_n.decoded = EX_MEM_r.decoded;
        MEM_WB_n.Read_Data2 = EX_MEM_r.Read_Data2;
        MEM_WB_n.reg_write_enable = EX_MEM_r.reg_write_enable;
        MEM_WB_n.ALU_Result = EX_MEM_r.ALU_Result; 
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
end
always_ff @( posedge clk ) begin 
    if(~STALL_MEM_WB) begin
        MEM_WB_r <= MEM_WB_n;
    end
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

    Write_Addr = MEM_WB_r.decoded.rd;
    if ((MEM_WB_r.decoded.opcode == OPCODE_I_LOAD)) begin
        Write_Data = LOAD_RESULT;
    end
    else if (MEM_WB_r.decoded.opcode == OPCODE_UJ_JAL||MEM_WB_r.decoded.opcode == OPCODE_I_JALR) begin
        Write_Data = MEM_WB_r.pc+4;
    end
    else 
        Write_Data = MEM_WB_r.ALU_Result;
end
endmodule
`endif

