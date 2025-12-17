
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
        ,.read_write_same_addr_p(1)
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
