// Physical implementation selected in place of BaseJump's inferred leaf RAM.
// The large 8x1024 arrays are the byte banks of each bsg_cache data store;
// smaller tag, status, and queue arrays remain inferred.
module bsg_mem_1rw_sync_synth #(
    parameter int width_p = 1,
    parameter int els_p = 1,
    parameter bit latch_last_read_p = 1'b0,
    parameter int addr_width_lp = $clog2(els_p),
    parameter bit verbose_p = 1'b1
) (
    input  logic clk_i,
    input  logic v_i,
    input  logic reset_i,
    input  logic [width_p-1:0] data_i,
    input  logic [addr_width_lp-1:0] addr_i,
    input  logic w_i,
    output logic [width_p-1:0] data_o
);

    if ((width_p == 8) && (els_p == 1024)) begin : openram_data_bank
        logic [7:0] unused_second_port_data;

        sky130_sram_1kbyte_1rw1r_8x1024_8 macro (
            .clk0(clk_i),
            .csb0(~v_i),
            .web0(~w_i),
            .wmask0(1'b1),
            .addr0(addr_i),
            .din0(data_i),
            .dout0(data_o),
            .clk1(clk_i),
            .csb1(1'b1),
            .addr1('0),
            .dout1(unused_second_port_data)
        );
    end else begin : inferred_small_array
        logic [addr_width_lp-1:0] read_addr_r;
        logic [width_p-1:0] memory [0:els_p-1];

        always_ff @(posedge clk_i) begin
            if (v_i && w_i)
                memory[addr_i] <= data_i;
            if (v_i && !w_i)
                read_addr_r <= addr_i;
        end

        assign data_o = memory[read_addr_r];
    end

    logic unused;
    assign unused = reset_i ^ latch_last_read_p ^ verbose_p;

endmodule
