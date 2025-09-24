// module regFile (
//     input  logic       clk,         // Clock signal
//    // input  logic       reset,       // Reset signal
//     input  logic [4:0] Read_Addr1,  // Address for Read Port 1
//     output logic [31:0] Read_Data1, // Data output for Read Port 1
//     input  logic [4:0] Read_Addr2,  // Address for Read Port 2
//     output logic [31:0] Read_Data2, // Data output for Read Port 2
//     input  logic [4:0] Write_Addr,  // Address for Write Port
//     input  logic [31:0] Write_Data, // Data input for Write Port
//     output logic RaW_Bypass1,
//     output logic RaW_Bypass2,
//     input  logic       wv,         // Write Enable
//     input logic        rv

// );

//     logic[31:0] reg_Read_Data1, reg_Read_Data2; 
//     // Declare the register array with ascending indices
//     logic [31:0] registers [0:31];

//     always_ff @(posedge clk) begin
//          $display("Register x1 (reg[1]) = %h \n", registers[1]);
//         // $display("Register x6 (reg[6]) = %h \n", registers[6]);
//         // $display("Register x7 (reg[7]) = %h \n", registers[7]); 
//         //$display("Register x13 (reg[13]) = %h \n", registers[13]);
//         //$display("Register x15 (reg[15]) = %h \n", registers[15]);  
//         //$display("Register x8 (reg[8]) = %h \n", registers[8]);             
//         if(rv)begin
//             if(Read_Addr1 == 5'd0)
//                 reg_Read_Data1 <= 32'd0;
//             else
//                 reg_Read_Data1<=registers[Read_Addr1];
//             if(Read_Addr2 == 5'd0)
//                 reg_Read_Data2 <= 32'd0;
//             else 
//                 reg_Read_Data2<=registers[Read_Addr2];
//         end
//         if (wv) begin
//             registers[Write_Addr] <= Write_Data;
//         end
//     end
//     always_comb begin
//         RaW_Bypass1 = 0;
//         RaW_Bypass2 = 0;
//         if (wv && (Write_Addr == Read_Addr1)) begin 
//             Read_Data1 = Write_Data;
//             RaW_Bypass1 = 1;
//         end
//         else begin 
//             Read_Data1 = reg_Read_Data1;
//             RaW_Bypass1 = 0;
//         end
        
//         if (wv && (Write_Addr == Read_Addr2))begin 
//             Read_Data2 = Write_Data;
//             RaW_Bypass2 = 1;
//         end
//         else begin 
//             Read_Data2 = reg_Read_Data2;
//             RaW_Bypass2 = 0;
//         end 
//     end         
    
 
    
// endmodule
`include "RTL/bsg_mem_2r1w_sync.sv"
`define BSG_HIDE_FROM_SYNTHESIS


module regFile(
    input logic clk
    ,input logic reset
    ,input logic [4:0] rs1
    ,output logic [31:0] rd1
    ,input logic [4:0] rs2
    ,output logic [31:0] rd2
    ,input logic [4:0] ws
    ,input logic [31:0] wd
    ,input logic wv
    ,input logic rv
);
    logic[31:0] rd1_reg, rd2_reg;
    bsg_mem_2r1w_sync
    #(
        .width_p(32)
        ,.els_p(32)
    )
    registers
    (
        .clk_i(clk)
        ,.reset_i(reset)
        ,.w_v_i(wv && (ws != 5'd0))
        ,.w_addr_i(ws)
        ,.w_data_i(wd)
        ,.r0_v_i(rv)
        ,.r0_addr_i(rs1)
        ,.r0_data_o(rd1_reg)
        ,.r1_v_i(rv)
        ,.r1_addr_i(rs2)
        ,.r1_data_o(rd2_reg)
    );

    assign rd1 = rd1_reg;
    assign rd2 = rd2_reg;



endmodule
