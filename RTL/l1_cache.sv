`ifndef _l1_cache_sv
`define _l1_cache_sv

`include "RTL/memory_io.sv"
`include "bsg_cache.svh"

// Blocking adapter between the CPU memory_io interface and BaseJump STL's
// two-way, write-back bsg_cache. The cache moves 32-byte lines while the
// simulation backing memory accepts one 32-bit word at a time.
module l1_cache #(
    parameter bit READ_ONLY = 1'b0,
    parameter int unsigned META_DEPTH = 4
) (
    input  logic         clk,
    input  logic         reset,
    input  memory_io_req cpu_req_i,
    output memory_io_rsp cpu_rsp_o,
    output memory_io_req memory_req_o,
    input  memory_io_rsp memory_rsp_i,
    output logic [63:0]  hit_count_o,
    output logic [63:0]  miss_count_o,
    output logic [63:0]  writeback_count_o
);

    import bsg_cache_pkg::*;

    localparam int unsigned ADDR_WIDTH = 32;
    localparam int unsigned DATA_WIDTH = 32;
    localparam int unsigned LINE_WORDS = 8;
    localparam int unsigned SETS = 128;
    localparam int unsigned WAYS = 2;
    localparam int unsigned META_PTR_WIDTH = (META_DEPTH > 1)
        ? $clog2(META_DEPTH) : 1;
    localparam int unsigned CACHE_PKT_WIDTH =
        `bsg_cache_pkt_width(ADDR_WIDTH, DATA_WIDTH);
    localparam int unsigned DMA_PKT_WIDTH =
        `bsg_cache_dma_pkt_width(ADDR_WIDTH, LINE_WORDS);

    `declare_bsg_cache_pkt_s(ADDR_WIDTH, DATA_WIDTH);
    `declare_bsg_cache_dma_pkt_s(ADDR_WIDTH, LINE_WORDS);

    typedef enum logic [3:0] {
        e_dma_idle,
        e_fill_request,
        e_fill_wait,
        e_fill_send,
        e_evict_receive,
        e_evict_request,
        e_evict_wait,
        e_bypass_request,
        e_bypass_wait
    } dma_state_e;

    bsg_cache_pkt_s cache_pkt;
    bsg_cache_dma_pkt_s dma_pkt;
    logic [CACHE_PKT_WIDTH-1:0] cache_pkt_bits;
    logic [DMA_PKT_WIDTH-1:0] dma_pkt_bits;
    logic cache_v, cache_yumi;
    logic [DATA_WIDTH-1:0] cache_data;
    logic cache_rsp_v;
    logic cache_rsp_yumi;
    logic cache_v_we;
    logic dma_pkt_v, dma_pkt_yumi;
    logic [DATA_WIDTH-1:0] dma_fill_data;
    logic dma_fill_v, dma_fill_ready;
    logic [DATA_WIDTH-1:0] dma_evict_data;
    logic dma_evict_v, dma_evict_yumi;

    dma_state_e dma_state_r;
    logic [31:0] metadata_addr_r [0:META_DEPTH-1];
    logic [`user_tag_size-1:0] metadata_user_tag_r [0:META_DEPTH-1];
    logic metadata_missed_r [0:META_DEPTH-1];
    logic [META_PTR_WIDTH-1:0] metadata_head_r;
    logic [META_PTR_WIDTH-1:0] metadata_tail_r;
    logic [META_PTR_WIDTH:0] metadata_count_r;
    logic [31:0] request_addr_r;
    logic [`user_tag_size-1:0] request_user_tag_r;
    logic [31:0] line_addr_r;
    logic [LINE_WORDS-1:0] line_mask_r;
    logic [2:0] line_word_r;
    logic [31:0] word_buffer_r;

    logic cpu_uncached;
    logic cpu_cached_accept;
    logic cpu_bypass_accept;

    assign cpu_uncached = (cpu_req_i.addr[31:4] == 28'h0002fff);

    always_comb begin
        cache_pkt = '0;
        cache_pkt.opcode = (cpu_req_i.do_write != '0) ? SM : LW;
        cache_pkt.addr = cpu_req_i.addr;
        cache_pkt.data = cpu_req_i.data;
        cache_pkt.mask = cpu_req_i.do_write;
        cache_pkt_bits = cache_pkt;

        cache_v = cpu_req_i.valid && !cpu_uncached
            && (metadata_count_r < META_DEPTH);
        cpu_cached_accept = cache_v && cache_yumi;
        cpu_bypass_accept = cpu_req_i.valid && cpu_uncached
            && (metadata_count_r == 0) && (dma_state_r == e_dma_idle)
            && !dma_pkt_v;

        cpu_rsp_o = memory_io_no_rsp;
        cpu_rsp_o.ready = cpu_uncached ? cpu_bypass_accept : cache_yumi;

        cache_rsp_yumi = cache_rsp_v && (metadata_count_r != 0);
        if (cache_rsp_v && (metadata_count_r != 0)) begin
            cpu_rsp_o.valid = 1'b1;
            cpu_rsp_o.addr = metadata_addr_r[metadata_head_r];
            cpu_rsp_o.data = cache_data;
            cpu_rsp_o.user_tag = metadata_user_tag_r[metadata_head_r];
        end

        if ((dma_state_r == e_bypass_wait) && memory_rsp_i.valid) begin
            cpu_rsp_o.valid = 1'b1;
            cpu_rsp_o.addr = request_addr_r;
            cpu_rsp_o.data = memory_rsp_i.data;
            cpu_rsp_o.user_tag = request_user_tag_r;
        end
    end

    bsg_cache #(
        .addr_width_p(ADDR_WIDTH),
        .data_width_p(DATA_WIDTH),
        .block_size_in_words_p(LINE_WORDS),
        .sets_p(SETS),
        .ways_p(WAYS),
        .word_tracking_p(0),
        .amo_support_p(amo_support_level_none_lp),
        .dma_data_width_p(DATA_WIDTH)
    ) cache (
        .clk_i(clk),
        .reset_i(reset),
        .cache_pkt_i(cache_pkt_bits),
        .v_i(cache_v),
        .yumi_o(cache_yumi),
        .data_o(cache_data),
        .v_o(cache_rsp_v),
        .yumi_i(cache_rsp_yumi),
        .dma_pkt_o(dma_pkt_bits),
        .dma_pkt_v_o(dma_pkt_v),
        .dma_pkt_yumi_i(dma_pkt_yumi),
        .dma_data_i(dma_fill_data),
        .dma_data_v_i(dma_fill_v),
        .dma_data_ready_and_o(dma_fill_ready),
        .dma_data_o(dma_evict_data),
        .dma_data_v_o(dma_evict_v),
        .dma_data_yumi_i(dma_evict_yumi),
        .v_we_o(cache_v_we)
    );

    assign dma_pkt = dma_pkt_bits;

    // Convert each BSG cache-line transaction into eight backing-memory word
    // transactions. The response channel is explicitly buffered so it remains
    // valid until bsg_cache accepts the refill word.
    always_comb begin
        memory_req_o = memory_io_no_req;
        dma_pkt_yumi = 1'b0;
        dma_fill_data = word_buffer_r;
        dma_fill_v = 1'b0;
        dma_evict_yumi = 1'b0;

        case (dma_state_r)
            e_dma_idle: begin
                dma_pkt_yumi = dma_pkt_v && !cpu_bypass_accept;
            end

            e_fill_request: begin
                memory_req_o.valid = 1'b1;
                memory_req_o.addr = {line_addr_r[31:5], line_word_r, 2'b00};
                memory_req_o.do_read = 4'b1111;
            end

            e_fill_send: begin
                dma_fill_v = 1'b1;
            end

            e_evict_receive: begin
                dma_evict_yumi = dma_evict_v;
            end

            e_evict_request: begin
                memory_req_o.valid = 1'b1;
                memory_req_o.addr = {line_addr_r[31:5], line_word_r, 2'b00};
                memory_req_o.data = word_buffer_r;
                memory_req_o.do_write = 4'b1111;
            end

            e_bypass_request: begin
                memory_req_o.valid = 1'b1;
                memory_req_o.addr = request_addr_r;
                memory_req_o.data = word_buffer_r;
                memory_req_o.do_read = line_mask_r[3:0];
                memory_req_o.do_write = line_mask_r[7:4];
                memory_req_o.user_tag = request_user_tag_r;
            end

            default: begin
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            dma_state_r <= e_dma_idle;
            metadata_head_r <= '0;
            metadata_tail_r <= '0;
            metadata_count_r <= '0;
            request_addr_r <= '0;
            request_user_tag_r <= '0;
            line_addr_r <= '0;
            line_mask_r <= '0;
            line_word_r <= '0;
            word_buffer_r <= '0;
            hit_count_o <= '0;
            miss_count_o <= '0;
            writeback_count_o <= '0;
            for (int entry = 0; entry < META_DEPTH; entry = entry + 1) begin
                metadata_addr_r[entry] <= '0;
                metadata_user_tag_r[entry] <= '0;
                metadata_missed_r[entry] <= 1'b0;
            end
        end else begin
            if (cpu_cached_accept) begin
                metadata_addr_r[metadata_tail_r] <= cpu_req_i.addr;
                metadata_user_tag_r[metadata_tail_r] <= cpu_req_i.user_tag;
                metadata_missed_r[metadata_tail_r] <= 1'b0;
                metadata_tail_r <= (META_DEPTH == 1)
                    ? '0 : metadata_tail_r + 1'b1;
            end

            if (cpu_bypass_accept) begin
                request_addr_r <= cpu_req_i.addr;
                request_user_tag_r <= cpu_req_i.user_tag;
                word_buffer_r <= cpu_req_i.data;
                line_mask_r <= {cpu_req_i.do_write, cpu_req_i.do_read};
                dma_state_r <= e_bypass_request;
            end

            if (cache_rsp_v && cache_rsp_yumi) begin
                if (!metadata_missed_r[metadata_head_r])
                    hit_count_o <= hit_count_o + 1'b1;
                metadata_head_r <= (META_DEPTH == 1)
                    ? '0 : metadata_head_r + 1'b1;
            end

            case ({cpu_cached_accept, cache_rsp_v && cache_rsp_yumi})
                2'b10: metadata_count_r <= metadata_count_r + 1'b1;
                2'b01: metadata_count_r <= metadata_count_r - 1'b1;
                default: metadata_count_r <= metadata_count_r;
            endcase

            case (dma_state_r)
                e_dma_idle: begin
                    if (dma_pkt_v && dma_pkt_yumi) begin
                        line_addr_r <= dma_pkt.addr;
                        line_mask_r <= dma_pkt.mask;
                        line_word_r <= '0;
                        if (dma_pkt.write_not_read) begin
                            dma_state_r <= e_evict_receive;
                            writeback_count_o <= writeback_count_o + 1'b1;
                        end else begin
                            dma_state_r <= e_fill_request;
                            metadata_missed_r[metadata_head_r] <= 1'b1;
                            miss_count_o <= miss_count_o + 1'b1;
                        end
                    end
                end

                e_fill_request: begin
                    if (memory_req_o.valid && memory_rsp_i.ready)
                        dma_state_r <= e_fill_wait;
                end

                e_fill_wait: begin
                    if (memory_rsp_i.valid) begin
                        word_buffer_r <= memory_rsp_i.data;
                        dma_state_r <= e_fill_send;
                    end
                end

                e_fill_send: begin
                    if (dma_fill_v && dma_fill_ready) begin
                        if (line_word_r == LINE_WORDS-1) begin
                            line_word_r <= '0;
                            dma_state_r <= e_dma_idle;
                        end else begin
                            line_word_r <= line_word_r + 1'b1;
                            dma_state_r <= e_fill_request;
                        end
                    end
                end

                e_evict_receive: begin
                    if (dma_evict_v && dma_evict_yumi) begin
                        word_buffer_r <= dma_evict_data;
                        if (line_mask_r[line_word_r])
                            dma_state_r <= e_evict_request;
                        else if (line_word_r == LINE_WORDS-1) begin
                            line_word_r <= '0;
                            dma_state_r <= e_dma_idle;
                        end else begin
                            line_word_r <= line_word_r + 1'b1;
                        end
                    end
                end

                e_evict_request: begin
                    if (memory_req_o.valid && memory_rsp_i.ready)
                        dma_state_r <= e_evict_wait;
                end

                e_evict_wait: begin
                    if (memory_rsp_i.valid) begin
                        if (line_word_r == LINE_WORDS-1) begin
                            line_word_r <= '0;
                            dma_state_r <= e_dma_idle;
                        end else begin
                            line_word_r <= line_word_r + 1'b1;
                            dma_state_r <= e_evict_receive;
                        end
                    end
                end

                e_bypass_request: begin
                    if (memory_req_o.valid && memory_rsp_i.ready)
                        dma_state_r <= e_bypass_wait;
                end

                e_bypass_wait: begin
                    if (memory_rsp_i.valid) begin
                        dma_state_r <= e_dma_idle;
                    end
                end

                default: dma_state_r <= e_dma_idle;
            endcase
        end
    end

    logic unused;
    assign unused = READ_ONLY ^ cache_v_we;

endmodule

`endif
