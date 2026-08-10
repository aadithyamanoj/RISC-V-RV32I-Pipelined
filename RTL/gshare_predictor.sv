`ifndef _gshare_predictor_sv
`define _gshare_predictor_sv

module gshare_predictor #(
    parameter int unsigned HISTORY_BITS = 6
) (
    input  logic        clk,
    input  logic        reset,

    input  logic [31:0] lookup_pc_i,
    output logic        lookup_taken_o,
    output logic [HISTORY_BITS-1:0] lookup_index_o,

    input  logic        update_valid_i,
    input  logic        update_taken_i,
    input  logic [HISTORY_BITS-1:0] update_index_i
);

    localparam int unsigned PHT_ENTRIES = 1 << HISTORY_BITS;

    logic [1:0] counter_r [0:PHT_ENTRIES-1];
    logic [HISTORY_BITS-1:0] history_r;

    assign lookup_index_o = lookup_pc_i[HISTORY_BITS+1:2] ^ history_r;
    assign lookup_taken_o = counter_r[lookup_index_o][1];

    integer i;
    always_ff @(posedge clk) begin
        if (reset) begin
            history_r <= '0;
            for (i = 0; i < PHT_ENTRIES; i = i + 1)
                counter_r[i] <= 2'b01;
        end else if (update_valid_i) begin
            if (update_taken_i && counter_r[update_index_i] != 2'b11)
                counter_r[update_index_i] <= counter_r[update_index_i] + 1'b1;
            else if (!update_taken_i && counter_r[update_index_i] != 2'b00)
                counter_r[update_index_i] <= counter_r[update_index_i] - 1'b1;
            history_r <= {history_r[HISTORY_BITS-2:0], update_taken_i};
        end
    end

endmodule

`endif
