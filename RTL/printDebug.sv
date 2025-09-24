// verilator lint_off WIDTHEXPAND
`include "RTL/system.sv"
//---------------------------------------------------------------------------------------------------------------------------------


//This is the main function to print the decoded instruction 

function void print_instruction(logic [31:0] pc, logic [31:0] instruction);
    logic[6:0] opcode;
    string decoded;
    

    $write("%x: ", pc);
    $write("%x   ", instruction);
    // More here that you do


    opcode = instruction[6:0];

    decoded = decode_full_instruction(instruction, opcode);

    $write("             ");

    $write(decoded);

    $write("\n");
endfunction

//--------------------------------------------------------------------------------------------------------------------------------

//this block decodes the funct3 for the operations where it is relavent. 

function automatic logic[2:0] decode_funct3(
  input logic [31:0] instr,
  input logic[6:0] opcode
);
  logic[2:0] f3;
  
  case (opcode)
    // For these opcodes, funct3 is encoded in bits [14:12]
    OPCODE_R,
    OPCODE_I_LOAD,
    OPCODE_I_IMM,
    OPCODE_I_JALR,
    OPCODE_S,
    OPCODE_SB: begin
      f3 = instr[14:12];
      decode_funct3 = f3;
    end

    // For U-type and UJ-type instructions, funct3 is not used
    OPCODE_U_LUI,
    OPCODE_U_AUIPC,
    OPCODE_UJ_JAL: begin
      decode_funct3 = 3'bxxx;
    end

    default: begin
      decode_funct3 = 3'bxxx; // Unknown opcode
    end
  endcase
endfunction

//---------------------------------------------------------------------------------------------------------------------------------

//This block decodes funct7 for the operations where it is relavent

function automatic logic[6:0] decode_funct7(
  input logic [31:0] instr,
  input logic[6:0] opcode
);
  case (opcode)
    // For R-type instructions the funct7 field is located at bits [31:25]
    OPCODE_R: begin
      decode_funct7 = instr[31:25];
    end

    // For opcodes where funct7 is not used, return a don't care value.
    OPCODE_I_LOAD,
    OPCODE_I_IMM,
    OPCODE_I_JALR,
    OPCODE_S,
    OPCODE_SB,
    OPCODE_U_LUI,
    OPCODE_U_AUIPC,
    OPCODE_UJ_JAL: begin
      decode_funct7 = 7'bxxx;
    end

    default: begin
      decode_funct7 = 7'bxxx; // Unknown opcode
    end
  endcase
endfunction


//------------------------------------------------------------------------------------------------------------------------------
/*
This next block decodes the whole instruction

*/
function automatic string decode_full_instruction(
  input logic [31:0] instr,
  input logic[6:0] opcode
);
  //This defines all possible argumets for all instruction formats
  int rd, rs1, rs2;
  int imm;
  int branch_imm;
  string asm_str;
  logic[2:0] FUNCT3;
  logic[6:0] FUNCT7;

  // Obtain funct3 and funct7 for opcodes where applicable.
  FUNCT3 = decode_funct3(instr, opcode);
  FUNCT7 = decode_funct7(instr, opcode);

  case (opcode)
    //--------------------------------------------------------------------------
    // R-type Instructions: Format: op rd, rs1, rs2
    // Use funct3 and funct7 to determine the operation.
    OPCODE_R: begin
      rd  = instr[11:7];
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      // Decode based on FUNCT3/FUNCT7:
      case (FUNCT3)
        FUNCT3_ADD_SUB: begin
          if (FUNCT7 == FUNCT7_ADD)
            asm_str = {"add    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
          else if (FUNCT7 == FUNCT7_SUB)
            asm_str = {"sub    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
          else
            asm_str = "r-type ADD/SUB unknown";
        end
        FUNCT3_SLL:   asm_str = {"sll    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        FUNCT3_SLT:   asm_str = {"slt    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        FUNCT3_SLTU:  asm_str = {"sltu   ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        FUNCT3_XOR:   asm_str = {"xor    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        FUNCT3_SRL_SRA: begin
          if (FUNCT7 == FUNCT7_SRL)
            asm_str = {"srl    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
          else if (FUNCT7 == FUNCT7_SRA)
            asm_str = {"sra    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
          else
            asm_str = "r-type SRL/SRA unknown";
        end
        FUNCT3_OR:    asm_str = {"or     ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        FUNCT3_AND:   asm_str = {"and    ", regname(rd), ",", regname(rs1), ",", regname(rs2)};
        default:      asm_str = "r-type unknown";
      endcase
    end

    //--------------------------------------------------------------------------
    // I-type Load Instructions: Format: op rd, imm(rs1)
    // Immediates are in bits [31:20].
    OPCODE_I_LOAD: begin
      rd  = instr[11:7];
      rs1 = instr[19:15];
      imm = $signed(instr[31:20]);
      case (FUNCT3)
        FUNCT3_LB:  asm_str = {"lb     ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_LH:  asm_str = {"lh     ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_LW:  asm_str = {"lw     ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_LBU: asm_str = {"lbu    ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_LHU: asm_str = {"lhu    ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        default:    asm_str = "I-load unknown";
      endcase
    end

    //--------------------------------------------------------------------------
    // I-type Immediate Arithmetic Instructions: Format: op rd, rs1, imm
    // Immediates are in bits [31:20].
    OPCODE_I_IMM: begin
      rd  = instr[11:7];
      rs1 = instr[19:15];
      imm = $signed(instr[31:20]);
      case (FUNCT3)
        FUNCT3_ADD_SUB: asm_str = {"addi   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        FUNCT3_SLL:     asm_str = {"slli   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};  // shift amount is imm[4:0]
        FUNCT3_SLT:     asm_str = {"slti   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        FUNCT3_SLTU:    asm_str = {"sltiu  ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        FUNCT3_XOR:     asm_str = {"xori   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        FUNCT3_SRL_SRA: begin
          if (FUNCT7 == FUNCT7_SRL)
            asm_str = {"srli   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)}; // shift amount
          else if (FUNCT7 == FUNCT7_SRA)
            asm_str = {"srai   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
          else
            asm_str = "I-imm SRL/SRA unknown";
        end
        FUNCT3_OR:      asm_str = {"ori    ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        FUNCT3_AND:     asm_str = {"andi   ", regname(rd), ",", regname(rs1), ",", $sformatf("%0d", imm)};
        default:        asm_str = "I-imm unknown";
      endcase
    end

    //--------------------------------------------------------------------------
    // I-type JALR Instruction: Format: jalr rd, imm(rs1)
    OPCODE_I_JALR: begin
      rd  = instr[11:7];
      rs1 = instr[19:15];
      imm = $signed(instr[31:20]);
      asm_str = {"jalr   ", regname(rd), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
    end

    //--------------------------------------------------------------------------
    // S-type Store Instructions: Format: op rs2, imm(rs1)
    // Immediate is formed from bits [31:25] and [11:7].
    OPCODE_S: begin
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      imm = $signed({instr[31:25], instr[11:7]});
      case (FUNCT3)
        FUNCT3_SB: asm_str = {"sb     ", regname(rs2), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_SH: asm_str = {"sh     ", regname(rs2), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        FUNCT3_SW: asm_str = {"sw     ", regname(rs2), ",", $sformatf("%0d", imm), "(", regname(rs1), ")"};
        default:   asm_str = "S-type unknown";
      endcase
    end

    //--------------------------------------------------------------------------
    // SB-type Branch Instructions: Format: op rs1, rs2, branch_offset
    // Branch immediate is assembled from various bits and then shifted left by 1.
    OPCODE_SB: begin
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      // Assemble the branch immediate:
      //   imm[12] = instr[31], imm[10:5] = instr[30:25],
      //   imm[4:1] = instr[11:8], imm[11] = instr[7]
      branch_imm = $signed({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0});
      case (FUNCT3)
        FUNCT3_BEQ:  asm_str = {"beq    ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        FUNCT3_BNE:  asm_str = {"bne    ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        FUNCT3_BLT:  asm_str = {"blt    ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        FUNCT3_BGE:  asm_str = {"bge    ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        FUNCT3_BLTU: asm_str = {"bltu   ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        FUNCT3_BGEU: asm_str = {"bgeu   ", regname(rs1), ",", regname(rs2), ",", $sformatf("%0d", branch_imm)};
        default:     asm_str = "branch unknown";
      endcase
    end

    //--------------------------------------------------------------------------
    // U-type Instructions:
    // OPCODE_U_LUI: Format: lui rd, imm   -- immediate from bits [31:12] << 12
    // OPCODE_U_AUIPC: Format: auipc rd, imm
    OPCODE_U_LUI,
    OPCODE_U_AUIPC: begin
      rd = instr[11:7];
      imm = $signed({instr[31:12], 12'b0});
      if (opcode == OPCODE_U_LUI)
        asm_str = {"lui    ", regname(rd), ",", $sformatf("%0x", imm)};
      else
        asm_str = {"auipc  ", regname(rd), ",", $sformatf("%0x", imm)};
    end

    //--------------------------------------------------------------------------
    // UJ-type Instruction: JAL, Format: jal rd, jump_offset
    // Immediate is assembled as:
    //   imm[20]    = instr[31], imm[10:1] = instr[30:21],
    //   imm[11]    = instr[20], imm[19:12] = instr[19:12], shifted left by 1.
    OPCODE_UJ_JAL: begin
      rd = instr[11:7];
      imm = $signed({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0});
      asm_str = {"jal    ", regname(rd), ",", $sformatf("%0x", imm)};
    end

    //--------------------------------------------------------------------------
    // Unknown Instruction Format
    default: asm_str = "unknown";
  endcase

  return asm_str;
endfunction


//----------------------------------------------------------------------------------

//This function decodes the registers to their name in a string format


function automatic string regname(input int register);
  case (register)
    0:  regname = "zero";  // Hard-wired zero
    1:  regname = "ra";    // Return address
    2:  regname = "sp";    // Stack pointer
    3:  regname = "gp";    // Global pointer
    4:  regname = "tp";    // Thread pointer
    5:  regname = "t0";    // Temporary registers
    6:  regname = "t1";
    7:  regname = "t2";
    8:  regname = "s0"; // Saved register / frame pointer
    9:  regname = "s1";    // Saved register
    10: regname = "a0";    // Function argument / return value
    11: regname = "a1";    // Function argument / return value
    12: regname = "a2";    // Function arguments
    13: regname = "a3";
    14: regname = "a4";
    15: regname = "a5";
    16: regname = "a6";
    17: regname = "a7";
    18: regname = "s2";    // Saved registers
    19: regname = "s3";
    20: regname = "s4";
    21: regname = "s5";
    22: regname = "s6";
    23: regname = "s7";
    24: regname = "s8";
    25: regname = "s9";
    26: regname = "s10";
    27: regname = "s11";
    28: regname = "t3";    // Temporary registers
    29: regname = "t4";
    30: regname = "t5";
    31: regname = "t6";
    default: regname = {"x", $sformatf("%0d", register)}; // Generic name if out-of-range
  endcase
endfunction


//-----------------------------------------------------------------------------------------------------