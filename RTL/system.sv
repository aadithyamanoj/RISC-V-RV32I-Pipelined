`ifndef _system_
`define _system_

`define word_size 32
`define word_address_size 32

`define word_size_bytes (`word_size/8)
`define word_address_size_bytes (`word_address_size/8)

`define user_tag_size 16


//------------------------------------------------------------------------------
// Opcode Localparams
//------------------------------------------------------------------------------
localparam logic [6:0] OPCODE_R       = 7'b0110011; // R-type (e.g., ADD, SUB)
localparam logic [6:0] OPCODE_I_LOAD  = 7'b0000011; // I-type loads (e.g., LB, LH, LW, etc.)
localparam logic [6:0] OPCODE_I_IMM   = 7'b0010011; // I-type immediates (e.g., ADDI, SLTI)
localparam logic [6:0] OPCODE_I_JALR  = 7'b1100111; // I-type (JALR)
localparam logic [6:0] OPCODE_S       = 7'b0100011; // S-type stores (e.g., SB, SH, SW)
localparam logic [6:0] OPCODE_SB      = 7'b1100011; // SB-type branches (e.g., BEQ, BNE, etc.)
localparam logic [6:0] OPCODE_U_LUI   = 7'b0110111; // U-type (LUI)
localparam logic [6:0] OPCODE_U_AUIPC = 7'b0010111; // U-type (AUIPC)
localparam logic [6:0] OPCODE_UJ_JAL  = 7'b1101111; // UJ-type (JAL)
localparam logic [31:0] NOP = 32'h00000013;

//------------------------------------------------------------------------------
// Funct3 Localparams
//------------------------------------------------------------------------------
// For R-type arithmetic and I-type immediate arithmetic:
localparam logic [2:0] FUNCT3_ADD_SUB   = 3'b000; // R-type: ADD/SUB ; I-type: ADDI
localparam logic [2:0] FUNCT3_SLL       = 3'b001; // R-type: SLL   ; I-type: SLLI
localparam logic [2:0] FUNCT3_SLT       = 3'b010; // R-type: SLT   ; I-type: SLTI
localparam logic [2:0] FUNCT3_SLTU      = 3'b011; // R-type: SLTU  ; I-type: SLTIU
localparam logic [2:0] FUNCT3_XOR       = 3'b100; // R-type: XOR   ; I-type: XORI
localparam logic [2:0] FUNCT3_SRL_SRA   = 3'b101; // R-type: SRL/SRA ; I-type: SRLI/SRAI
localparam logic [2:0] FUNCT3_OR        = 3'b110; // R-type: OR    ; I-type: ORI
localparam logic [2:0] FUNCT3_AND       = 3'b111; // R-type: AND   ; I-type: ANDI

// For load instructions (I-type loads):
localparam logic [2:0] FUNCT3_LB        = 3'b000; // LB
localparam logic [2:0] FUNCT3_LH        = 3'b001; // LH
localparam logic [2:0] FUNCT3_LW        = 3'b010; // LW
localparam logic [2:0] FUNCT3_LBU       = 3'b100; // LBU
localparam logic [2:0] FUNCT3_LHU       = 3'b101; // LHU

// For store instructions (S-type):
localparam logic [2:0] FUNCT3_SB        = 3'b000; // SB
localparam logic [2:0] FUNCT3_SH        = 3'b001; // SH
localparam logic [2:0] FUNCT3_SW        = 3'b010; // SW

// For branch (SB-type) instructions:
localparam logic [2:0] FUNCT3_BEQ       = 3'b000; // BEQ
localparam logic [2:0] FUNCT3_BNE       = 3'b001; // BNE
localparam logic [2:0] FUNCT3_BLT       = 3'b100; // BLT
localparam logic [2:0] FUNCT3_BGE       = 3'b101; // BGE
localparam logic [2:0] FUNCT3_BLTU      = 3'b110; // BLTU
localparam logic [2:0] FUNCT3_BGEU      = 3'b111; // BGEU


//------------------------------------------------------------------------------
// Funct7 Localparams (used with R-type instructions)
//------------------------------------------------------------------------------
localparam logic [6:0] FUNCT7_ADD  = 7'b0000000; // ADD operation (funct3 000)
localparam logic [6:0] FUNCT7_SUB  = 7'b0100000; // SUB operation (funct3 000)
localparam logic [6:0] FUNCT7_SLL  = 7'b0000000; // SLL operation (funct3 001)
localparam logic [6:0] FUNCT7_SLT  = 7'b0000000; // SLT operation (funct3 010)
localparam logic [6:0] FUNCT7_SLTU = 7'b0000000; // SLTU operation (funct3 011)
localparam logic [6:0] FUNCT7_XOR  = 7'b0000000; // XOR operation (funct3 100)
localparam logic [6:0] FUNCT7_SRL  = 7'b0000000; // SRL operation (funct3 101)
localparam logic [6:0] FUNCT7_SRA  = 7'b0100000; // SRA operation (funct3 101)
localparam logic [6:0] FUNCT7_OR   = 7'b0000000; // OR operation (funct3 110)
localparam logic [6:0] FUNCT7_AND  = 7'b0000000; // AND operation (funct3 111)




typedef logic[`word_size - 1:0] word;


typedef enum logic [4:0] {
    ALU_ADD  = 5'd0,  // Addition
    ALU_SUB  = 5'd1,  // Subtraction
    ALU_SLL  = 5'd2,  // Shift Left Logical
    ALU_SLT  = 5'd3,  // Set Less Than (Signed)
    ALU_SLTU = 5'd4,  // Set Less Than Unsigned
    ALU_XOR  = 5'd5,  // Bitwise XOR
    ALU_SRL  = 5'd6,  // Shift Right Logical
    ALU_SRA  = 5'd7,  // Shift Right Arithmetic
    ALU_OR   = 5'd8,  // Bitwise OR
    ALU_AND  = 5'd9,  // Bitwise AND
    ALU_NOP  = 5'd10 // No Operation (Default/Unused)
} alu_op_t;

typedef struct packed {
    logic[6:0] opcode;
    logic[4:0] rs1;
    logic[4:0] rs2;
    logic[4:0] rd;
    logic[2:0] funct3;
    logic[6:0] funct7;
    word imm;
    alu_op_t alu_op;
} instruction_decode_t;



function automatic logic[31:0] ALU_EXEC(instruction_decode_t decoded_params, logic[31:0] Read_Data1, logic[31:0] Read_Data2, pc);
    logic [4:0] shamt;
    if (decoded_params.opcode==OPCODE_U_LUI) begin
        return decoded_params.imm;
    end 
    if (decoded_params.opcode==OPCODE_R)
        shamt = Read_Data2[4:0]; // R-Type: rs2 as shamt
    else
        shamt = decoded_params.imm[4:0];
    case (decoded_params.alu_op)
        ALU_ADD: begin
            // Signed addition for both R-type and I-type
            if(decoded_params.opcode == OPCODE_U_AUIPC) begin 
                return pc + decoded_params.imm;
            end
            if(decoded_params.opcode == OPCODE_S|| decoded_params.opcode == OPCODE_I_LOAD) begin
                return Read_Data1 + decoded_params.imm;
            end
            return $signed(Read_Data1) + (decoded_params.opcode==OPCODE_R ? $signed(Read_Data2) : $signed(decoded_params.imm));
        end
        ALU_SUB: begin
            // Signed subtraction for R-type
            return $signed(Read_Data1) - $signed(Read_Data2);
        end
        ALU_SLL: begin
            // Shift Left Logical
            return Read_Data1 << shamt;
        end
        ALU_SLT: begin
            // Set Less Than (Signed)
            return ($signed(Read_Data1) < $signed((decoded_params.opcode==OPCODE_R ? Read_Data2 : decoded_params.imm))) ? 32'd1 : 32'd0;
        end
        ALU_SLTU: begin
            // Set Less Than Unsigned
            return (Read_Data1 < (decoded_params.opcode==OPCODE_R ? Read_Data2 : decoded_params.imm)) ? 32'd1 : 32'd0;
        end
        ALU_XOR: begin
            // Bitwise XOR
            return Read_Data1 ^ (decoded_params.opcode==OPCODE_R ? Read_Data2 : decoded_params.imm);
        end
        ALU_SRL: begin
            // Shift Right Logical
            return Read_Data1 >> shamt;
        end
        ALU_SRA: begin
            // Shift Right Arithmetic
            return $signed(Read_Data1) >>> shamt;
        end
        ALU_OR: begin
            // Bitwise OR
            return Read_Data1 | (decoded_params.opcode==OPCODE_R ? Read_Data2 : decoded_params.imm);
        end
        ALU_AND: begin
            // Bitwise AND
            return Read_Data1 & (decoded_params.opcode==OPCODE_R ? Read_Data2 : decoded_params.imm);
        end
        ALU_NOP: begin
            // No Operation
            return 32'd0;
        end
        default: begin
            // Default operation
            return 32'd0;
        end
    endcase
    

endfunction


function automatic logic[4:0] get_rs1(word instruction);
    return instruction[19:15];
endfunction

function automatic logic[4:0] get_rs2(word instruction);
    return instruction[24:20];
endfunction

function automatic instruction_decode_t decode_instruction(word fetched_instruction);


    instruction_decode_t decoded_params;
    // Extract fields from fetched_instruction
    decoded_params.opcode = fetched_instruction[6:0];
    decoded_params.rd = fetched_instruction[11:7];
    decoded_params.rs1 = fetched_instruction[19:15];
    decoded_params.rs2 = fetched_instruction[24:20];
    decoded_params.funct3 = fetched_instruction[14:12];
    decoded_params.funct7 = fetched_instruction[31:25];
    decoded_params.imm = {{20{fetched_instruction[31]}}, fetched_instruction[31:20]};
    decoded_params.alu_op = ALU_NOP;
 

    // Decode  Instructions
    case(decoded_params.opcode)
        OPCODE_R: begin
            case (decoded_params.funct3)
                FUNCT3_ADD_SUB: begin
                    if (decoded_params.funct7 == FUNCT7_ADD)
                        decoded_params.alu_op = ALU_ADD;
                    else if (decoded_params.funct7 == FUNCT7_SUB)
                        decoded_params.alu_op = ALU_SUB;
                    else
                        decoded_params.alu_op = ALU_ADD;
                end
                FUNCT3_SLL:  decoded_params.alu_op = ALU_SLL;
                FUNCT3_SLT:  decoded_params.alu_op = ALU_SLT;
                FUNCT3_SLTU: decoded_params.alu_op = ALU_SLTU;
                FUNCT3_XOR:  decoded_params.alu_op = ALU_XOR;
                FUNCT3_SRL_SRA: begin
                    if (decoded_params.funct7 == FUNCT7_SRL)
                        decoded_params.alu_op = ALU_SRL;
                    else if (decoded_params.funct7 == FUNCT7_SRA)
                        decoded_params.alu_op = ALU_SRA;
                end
                FUNCT3_OR:  decoded_params.alu_op = ALU_OR;
                FUNCT3_AND: decoded_params.alu_op = ALU_AND;
                default:    decoded_params.alu_op = ALU_NOP;
            endcase
        end

        // Decode I-type ALU Instructions
        OPCODE_I_IMM: begin
            case (decoded_params.funct3)
                FUNCT3_ADD_SUB: decoded_params.alu_op = ALU_ADD; // ADDI
                FUNCT3_SLL:     decoded_params.alu_op = ALU_SLL; // SLLI
                FUNCT3_SLT:     decoded_params.alu_op = ALU_SLT; // SLTI
                FUNCT3_SLTU:    decoded_params.alu_op = ALU_SLTU; // SLTIU
                FUNCT3_XOR:     decoded_params.alu_op = ALU_XOR; // XORI
                FUNCT3_SRL_SRA: decoded_params.alu_op = alu_op_t'( (fetched_instruction[30] == 1'b0) ? ALU_SRL : ALU_SRA );
                FUNCT3_OR:      decoded_params.alu_op = ALU_OR; // ORI
                FUNCT3_AND:     decoded_params.alu_op = ALU_AND; // ANDI
                default:        decoded_params.alu_op = ALU_NOP;
            endcase
        end 
     

   
        OPCODE_I_LOAD: begin
            decoded_params.alu_op = ALU_ADD; // Memory address computation: base register + offset
            decoded_params.imm = {{20{fetched_instruction[31]}}, fetched_instruction[31:20]}; // Load immediate (offset)
        end

        // Decode Store Instructions
        OPCODE_S: begin
            decoded_params.alu_op = ALU_ADD; // Compute memory address: base register + offset
            decoded_params.imm = {{20{fetched_instruction[31]}}, fetched_instruction[31:25], fetched_instruction[11:7]}; // Store immediate format
        end


         // ------------------------------
        // SB-type Branches (e.g., BEQ, BNE, BLT, etc.)
        // ------------------------------
        OPCODE_SB: begin
            // Branch immediate is in SB-format:
            // imm[12]    = fetched_instruction[31]
            // imm[11]    = fetched_instruction[7]
            // imm[10:5]  = fetched_instruction[30:25]
            // imm[4:1]   = fetched_instruction[11:8]
            // imm[0]     = 0 (always zero)
            decoded_params.imm = { {19{fetched_instruction[31]}}, // Sign extension (32-13 = 19 bits)
                      fetched_instruction[31],
                      fetched_instruction[7],
                      fetched_instruction[30:25],
                      fetched_instruction[11:8],
                      1'b0 };
            decoded_params.alu_op = ALU_NOP; 
           
        end
        // ------------------------------
        // U-type LUI (Load Upper Immediate)
        // ------------------------------
        OPCODE_U_LUI: begin
            // Immediate is bits[31:12] shifted left by 12 bits.
            decoded_params.imm = {fetched_instruction[31:12], 12'b0};
            decoded_params.alu_op = ALU_NOP; // No ALU operation required for LUI itself
        end

        // ------------------------------
        // U-type AUIPC (Add Upper Immediate to PC)
        // ------------------------------
        OPCODE_U_AUIPC: begin
            // Immediate is bits[31:12] shifted left by 12 bits.
            decoded_params.imm = {fetched_instruction[31:12], 12'b0};
            // AUIPC performs: PC + immediate. ALU will add PC (handled elsewhere) with decoded_params.imm.
            decoded_params.alu_op = ALU_ADD;
        end

        // ------------------------------
        // UJ-type JAL (Jump And Link)
        // ------------------------------
        OPCODE_UJ_JAL: begin
            // JAL immediate is encoded in UJ-format:
            // imm[20]    = fetched_instruction[31]
            // imm[10:1]  = fetched_instruction[30:21]
            // imm[11]    = fetched_instruction[20]
            // imm[19:12] = fetched_instruction[19:12]
            // With a zero as the LSB.
            decoded_params.imm = { {11{fetched_instruction[31]}},  // Sign extension (32-21 = 11 bits)
                      fetched_instruction[31],
                      fetched_instruction[19:12],
                      fetched_instruction[20],
                      fetched_instruction[30:21],
                      1'b0 };
            decoded_params.alu_op = ALU_NOP; // Jump target is computed by adding PC + decoded_params.imm (handled specially)
        end

        OPCODE_I_JALR: begin
            decoded_params.alu_op = ALU_NOP; // Compute target address: base register + offset
        end

        default: begin
            decoded_params.alu_op    = ALU_NOP;
            
        end 
    endcase
    
    return decoded_params;
endfunction

function automatic logic[3:0] write_mask(logic[2:0] f3, word addr); begin
    case(f3)
        FUNCT3_SB: begin
            case(addr[1:0])
                2'b00: return 4'b0001;
                2'b01: return 4'b0010;
                2'b10: return 4'b0100;
                2'b11: return 4'b1000;
                default: return 4'b0001;
            endcase
        end
        FUNCT3_SH: begin
            case(addr[1:0])
                2'b00: return 4'b0011;
                2'b10: return 4'b1100;
                default: return 4'b0011;
            endcase
        end
        FUNCT3_SW: begin
            return 4'b1111;
        end
        default: return 4'b1111;
    endcase
end
endfunction


`endif
