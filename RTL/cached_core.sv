`ifndef _cached_core_sv
`define _cached_core_sv

`include "RTL/core.sv"
`include "RTL/l1_cache.sv"

// Synthesis boundary for the CPU plus its private instruction and data caches.
// The backing-memory word ports remain external so DRAM/interconnect behavior
// can be modeled independently from the on-chip L1 SRAMs.
module cached_core #(
    parameter bit ENABLE_BRANCH_PREDICTION = 1'b1,
    parameter int unsigned FETCH_DEPTH = 4,
    parameter int unsigned STORE_DEPTH = 4,
    parameter int unsigned CACHE_META_DEPTH = 4
) (
    input  logic clk,
    input  logic reset,
    output memory_io_req inst_backing_req_o,
    input  memory_io_rsp inst_backing_rsp_i,
    output memory_io_req data_backing_req_o,
    input  memory_io_rsp data_backing_rsp_i,
    input  logic profile_start_i,
    input  logic profile_stop_i,
    output logic [63:0] cycle_count_o,
    output logic [63:0] retire_count_o,
    output logic [63:0] branch_count_o,
    output logic [63:0] branch_mispredict_count_o,
    output logic [63:0] btb_hit_count_o,
    output logic [31:0] pc_o,
    output logic [63:0] kernel_cycle_count_o,
    output logic [63:0] kernel_retire_count_o,
    output logic [63:0] kernel_branch_count_o,
    output logic [63:0] kernel_mispredict_count_o,
    output logic [63:0] icache_hit_count_o,
    output logic [63:0] icache_miss_count_o,
    output logic [63:0] dcache_hit_count_o,
    output logic [63:0] dcache_miss_count_o,
    output logic [63:0] dcache_writeback_count_o
);

    memory_io_req inst_mem_req;
    memory_io_rsp inst_mem_rsp;
    memory_io_req data_mem_req;
    memory_io_rsp data_mem_rsp;
    logic [63:0] unused_icache_writebacks;

    core #(
        .ENABLE_BRANCH_PREDICTION(ENABLE_BRANCH_PREDICTION),
        .FETCH_DEPTH(FETCH_DEPTH),
        .STORE_DEPTH(STORE_DEPTH)
    ) cpu (
        .clk(clk),
        .reset(reset),
        .reset_pc(32'h0001_0000),
        .inst_mem_req(inst_mem_req),
        .inst_mem_rsp(inst_mem_rsp),
        .data_mem_req(data_mem_req),
        .data_mem_rsp(data_mem_rsp),
        .cycle_count_o(cycle_count_o),
        .retire_count_o(retire_count_o),
        .branch_count_o(branch_count_o),
        .branch_mispredict_count_o(branch_mispredict_count_o),
        .btb_hit_count_o(btb_hit_count_o),
        .pc_o(pc_o),
        .profile_start_i(profile_start_i),
        .profile_stop_i(profile_stop_i),
        .kernel_cycle_count_o(kernel_cycle_count_o),
        .kernel_retire_count_o(kernel_retire_count_o),
        .kernel_branch_count_o(kernel_branch_count_o),
        .kernel_mispredict_count_o(kernel_mispredict_count_o)
    );

    l1_cache #(
        .READ_ONLY(1'b1),
        .META_DEPTH(CACHE_META_DEPTH)
    ) instruction_cache (
        .clk(clk),
        .reset(reset),
        .cpu_req_i(inst_mem_req),
        .cpu_rsp_o(inst_mem_rsp),
        .memory_req_o(inst_backing_req_o),
        .memory_rsp_i(inst_backing_rsp_i),
        .hit_count_o(icache_hit_count_o),
        .miss_count_o(icache_miss_count_o),
        .writeback_count_o(unused_icache_writebacks)
    );

    l1_cache #(
        .READ_ONLY(1'b0),
        .META_DEPTH(CACHE_META_DEPTH)
    ) data_cache (
        .clk(clk),
        .reset(reset),
        .cpu_req_i(data_mem_req),
        .cpu_rsp_o(data_mem_rsp),
        .memory_req_o(data_backing_req_o),
        .memory_rsp_i(data_backing_rsp_i),
        .hit_count_o(dcache_hit_count_o),
        .miss_count_o(dcache_miss_count_o),
        .writeback_count_o(dcache_writeback_count_o)
    );

endmodule

`endif
