`include "RTL/base.sv"
`include "RTL/memory.sv"
`include "RTL/cached_core.sv"

module top #(
    parameter bit ENABLE_BRANCH_PREDICTION = 1'b1
) (
    input clk,
    input reset,
    output logic halt,
    output logic [63:0] cycle_count,
    output logic [63:0] retire_count,
    output logic [63:0] branch_count,
    output logic [63:0] branch_mispredict_count,
    output logic [63:0] btb_hit_count,
    output logic [31:0] debug_pc,
    output logic [31:0] halt_code,
    output logic [63:0] kernel_cycle_count,
    output logic [63:0] kernel_retire_count,
    output logic [63:0] kernel_branch_count,
    output logic [63:0] kernel_mispredict_count,
    output logic [63:0] icache_hit_count,
    output logic [63:0] icache_miss_count,
    output logic [63:0] dcache_hit_count,
    output logic [63:0] dcache_miss_count,
    output logic [63:0] dcache_writeback_count
);


memory_io_req   inst_backing_req;
memory_io_rsp   inst_backing_rsp;
memory_io_req   data_backing_req;
memory_io_rsp   data_backing_rsp;
logic profile_start;
logic profile_stop;

assign profile_start = data_backing_req.valid && data_backing_rsp.ready
    && (data_backing_req.do_write != 4'b0000)
    && (data_backing_req.addr == 32'h0002fff0);
assign profile_stop = data_backing_req.valid && data_backing_rsp.ready
    && (data_backing_req.do_write != 4'b0000)
    && (data_backing_req.addr == 32'h0002fff4);

cached_core #(
    .ENABLE_BRANCH_PREDICTION(ENABLE_BRANCH_PREDICTION)
) the_core (
	.clk(clk)
	,.reset(reset)
    ,.inst_backing_req_o(inst_backing_req)
    ,.inst_backing_rsp_i(inst_backing_rsp)
    ,.data_backing_req_o(data_backing_req)
    ,.data_backing_rsp_i(data_backing_rsp)
    ,.cycle_count_o(cycle_count)
    ,.retire_count_o(retire_count)
    ,.branch_count_o(branch_count)
    ,.branch_mispredict_count_o(branch_mispredict_count)
    ,.btb_hit_count_o(btb_hit_count)
    ,.pc_o(debug_pc)
    ,.profile_start_i(profile_start)
    ,.profile_stop_i(profile_stop)
    ,.kernel_cycle_count_o(kernel_cycle_count)
    ,.kernel_retire_count_o(kernel_retire_count)
    ,.kernel_branch_count_o(kernel_branch_count)
    ,.kernel_mispredict_count_o(kernel_mispredict_count)
    ,.icache_hit_count_o(icache_hit_count)
    ,.icache_miss_count_o(icache_miss_count)
    ,.dcache_hit_count_o(dcache_hit_count)
    ,.dcache_miss_count_o(dcache_miss_count)
    ,.dcache_writeback_count_o(dcache_writeback_count)
    );


`memory #(
    .size(32'h0001_0000)
    ,.initialize_mem(true)
    ,.byte0("code0.hex")
    ,.byte1("code1.hex")
    ,.byte2("code2.hex")
    ,.byte3("code3.hex")
    ,.enable_rsp_addr(true)
    ) code_mem (
    .clk(clk)
    ,.reset(reset)
    ,.req(inst_backing_req)
    ,.rsp(inst_backing_rsp)
    );

`memory #(
    .size(32'h0001_0000)
    ,.initialize_mem(true)
    ,.byte0("data0.hex")
    ,.byte1("data1.hex")
    ,.byte2("data2.hex")
    ,.byte3("data3.hex")
    ,.enable_rsp_addr(true)
    ) data_mem (
    .clk(clk)
    ,.reset(reset)
    ,.req(data_backing_req)
    ,.rsp(data_backing_rsp)
    );



// always @(posedge clk) begin
    
//     if (data_mem_req.valid && data_mem_req.do_write != 0)
//         $display("%x write: %x do_write: %x data: %x", inst_mem_req.addr, data_mem_req.addr, data_mem_req.do_write, data_mem_req.data);
//     if (data_mem_req.valid && data_mem_req.do_read != 0)
//         $display("%x read: %x do_read:", inst_mem_req.addr, data_mem_req.addr, data_mem_req.do_read);

// end


always @(posedge clk) begin
    if (data_backing_req.valid && data_backing_rsp.ready
        && data_backing_req.addr == `word_address_size'h0002_FFF8
        && data_backing_req.do_write != {(`word_address_size/8){1'b0}}) begin
        
        // $display("DEBUG: Full 32-bit data: 0x%08x", data_mem_req.data);
        // $display("DEBUG: Character code: 0x%02x", data_mem_req.data[7:0]);
        // $display("DEBUG: Write mask: 0x%x", data_mem_req.do_write);
        
        // Handle newline specially
        
            $write("%c", data_backing_req.data[7:0]);  // Print character
        
    end
end

// always_ff @(posedge clk) begin
//     $write("");
// end
always @(posedge clk)
	if (data_backing_req.valid && data_backing_rsp.ready
        && data_backing_req.addr == `word_address_size'h0002_FFFD) begin
        // $stop;
		halt <= true;
		halt_code <= data_backing_req.data;
        
    end
	else
		halt <= false;

always @(posedge clk) begin
    if ($test$plusargs("memory_trace")) begin
        if (inst_backing_req.valid && inst_backing_rsp.ready)
            $display("I_FILL addr=%08x", inst_backing_req.addr);
        if (data_backing_req.valid && data_backing_rsp.ready)
            $display("D_BACKING addr=%08x read=%x write=%x data=%08x",
                data_backing_req.addr, data_backing_req.do_read,
                data_backing_req.do_write, data_backing_req.data);
    end
end


endmodule
