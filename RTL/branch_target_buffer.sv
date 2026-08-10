`ifndef _branch_target_buffer_sv
`define _branch_target_buffer_sv

module branch_target_buffer #(
    parameter int unsigned ENTRIES = 32
) (
    input  logic        clk,
    input  logic        reset,

    input  logic [31:0] lookup_pc_i,
    output logic        lookup_hit_o,
    output logic [31:0] lookup_target_o,
    output logic        lookup_conditional_o,

    input  logic        update_valid_i,
    input  logic [31:0] update_pc_i,
    input  logic [31:0] update_target_i,
    input  logic        update_conditional_i
);

    localparam int unsigned INDEX_BITS = $clog2(ENTRIES);

    logic [ENTRIES-1:0] valid_r;
    logic [31:INDEX_BITS+2] tag_r [0:ENTRIES-1];
    logic [31:0] target_r [0:ENTRIES-1];
    logic conditional_r [0:ENTRIES-1];

    logic [INDEX_BITS-1:0] lookup_index;
    logic [INDEX_BITS-1:0] update_index;

    assign lookup_index = lookup_pc_i[INDEX_BITS+1:2];
    assign update_index = update_pc_i[INDEX_BITS+1:2];

    always_comb begin
        lookup_hit_o = valid_r[lookup_index]
            && (tag_r[lookup_index] == lookup_pc_i[31:INDEX_BITS+2]);
        lookup_target_o = target_r[lookup_index];
        lookup_conditional_o = conditional_r[lookup_index];
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            valid_r <= '0;
        end else if (update_valid_i) begin
            valid_r[update_index] <= 1'b1;
            tag_r[update_index] <= update_pc_i[31:INDEX_BITS+2];
            target_r[update_index] <= update_target_i;
            conditional_r[update_index] <= update_conditional_i;
        end
    end

endmodule

`endif
