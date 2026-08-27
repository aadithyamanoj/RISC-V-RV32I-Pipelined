#

include Sim/site-config.sh
goal: result-verilator
CC=$(RISCV_PREFIX)-gcc
AS=$(RISCV_PREFIX)-as
LD=$(RISCV_PREFIX)-ld

SSFLAGS=-march=rv32i_zmmul -mabi=ilp32
CCFLAGS=-march=rv32i_zmmul -mabi=ilp32 -O2 -Wno-builtin-declaration-mismatch -Ilibmc
LDFLAGS=--script ld.script
LDPOSTFLAGS= -Llibmc -lmc  -Llibmc -lmc -L$(RISCV_LIB) -lgcc
TOOLS=dumphex
LIBS=libmc/libmc.a

TEST_S=tests/start.s
TEST_C=tests/test.c
PREDICT?=1
FETCH_DEPTH?=4
STORE_DEPTH?=4
CACHE_META_DEPTH?=4

BASEJUMP_STL_DIR=third_party/basejump_stl
BASEJUMP_MUL_SRCS= \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_transpose.sv \
	RTL/basejump_multiplier_sources.sv
BASEJUMP_CACHE_SRCS= \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_defines.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_mux.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_mux_segmented.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_circular_ptr.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_clkgate_optional.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_dff.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_dff_en.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_dff_en_bypass.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_counter_clear_up.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_decode.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_priority_encode.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_lru_pseudo_tree_encode.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_lru_pseudo_tree_decode.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_lru_pseudo_tree_backup.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_mux_bitwise.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_priority_encode_one_hot_out.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_encode_one_hot.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_scan.sv \
	$(BASEJUMP_STL_DIR)/bsg_misc/bsg_expand_bitmask.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1r1w_synth.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1r1w.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync_synth.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync_mask_write_bit_synth.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync_mask_write_byte_synth.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync_mask_write_bit.sv \
	$(BASEJUMP_STL_DIR)/bsg_mem/bsg_mem_1rw_sync_mask_write_byte.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_two_fifo.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_fifo_1r1w_small.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_fifo_1r1w_small_unhardened.sv \
	$(BASEJUMP_STL_DIR)/bsg_dataflow/bsg_fifo_tracker.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_pkg.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_decode.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_dma.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_miss.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_tbuf.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_sbuf.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache_buffer_queue.sv \
	$(BASEJUMP_STL_DIR)/bsg_cache/bsg_cache.sv

# Updated rules for files in subdirectories
tests/%.o: tests/%.c
	$(CC) $(CCFLAGS) -c $< -o $@

benchmarks/%.o: benchmarks/%.c
	$(CC) $(CCFLAGS) -c $< -o $@

tests/%.o: tests/%.s  
	$(AS) $(SSFLAGS) -c $< -o $@

libmc/libmc.a:
	cd libmc; make clean; make; cd ..

dumphex: Sim/dumphex.c
	gcc -o dumphex Sim/dumphex.c

test: $(TEST_S:.s=.o) $(TEST_C:.c=.o) $(LIBS) $(TOOLS)
	$(LD) $(LDFLAGS) -o test $(TEST_S:.s=.o) $(TEST_C:.c=.o) $(LDPOSTFLAGS)
	/bin/bash ./Sim/elftohex.sh test .

.PHONY: attention cache-test feature-bench predictor-test ppa ppa-synth ppa-sta test

attention:
	@$(MAKE) clean
	@$(MAKE) result-verilator TEST_C=benchmarks/attention.c

predictor-test:
	@$(MAKE) clean
	@$(MAKE) result-verilator TEST_C=tests/predictor_mul.c

cache-test:
	@$(MAKE) clean
	@$(MAKE) result-verilator TEST_C=tests/cache_stress.c

feature-bench:
	@./benchmarks/run_feature_sweep.sh

ppa:
	@$(MAKE) -C asic ppa

ppa-synth:
	@$(MAKE) -C asic ppa-synth

ppa-sta:
	@$(MAKE) -C asic ppa-sta

result-verilator: RTL/top.sv Sim/verilator_top.cpp RTL/core.sv $(BASEJUMP_CACHE_SRCS) $(BASEJUMP_MUL_SRCS) test
	 @unset LDFLAGS; \
	 $(VERILATOR) -O0 --cc --build --Wno-UNOPTFLAT --Wno-WIDTHEXPAND \
	 --Wno-WIDTHTRUNC \
	 -I$(BASEJUMP_STL_DIR)/bsg_misc -I$(BASEJUMP_STL_DIR)/bsg_cache \
	 -GENABLE_BRANCH_PREDICTION=$(PREDICT) \
	 -GFETCH_DEPTH=$(FETCH_DEPTH) -GSTORE_DEPTH=$(STORE_DEPTH) \
	 -GCACHE_META_DEPTH=$(CACHE_META_DEPTH) --top-module top \
	 $(BASEJUMP_CACHE_SRCS) $(BASEJUMP_MUL_SRCS) RTL/top.sv Sim/verilator_top.cpp --exe \
	 -CFLAGS "-std=c++17" \
   -LDFLAGS "-std=c++17"
	 cp obj_dir/Vtop ./result-verilator
	 rm -rf obj_dir
	 ./result-verilator

result-iverilog: RTL/itop.sv RTL/top.sv RTL/core.sv test
	 $(IVERILOG) -g2012 -o result-iverilog RTL/itop.sv
	 ./result-iverilog
	 rm result-iverilog

clean:
	rm -rf dumphex test.vcd obj_dir/ *.o tests/*.o benchmarks/*.o result-verilator result-iverilog *.hex test.bin test
