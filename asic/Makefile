SHELL := /bin/bash

OSS_CAD_ROOT ?= $(HOME)/tools/oss-cad-suite
OPENLANE_ROOT ?= $(HOME)/openlane2
PDK_ROOT ?= $(HOME)/.volare
PDK_VERSION ?= 0fe599b2afb6708d281543108caf8310912f54af
CLOCK_PERIOD_NS ?= 50.0
POWER_ACTIVITY ?= 0.10
PPA_TAG ?= tt_20mhz_a10

SKY130_ROOT := $(PDK_ROOT)/volare/sky130/versions/$(PDK_VERSION)/sky130A
STD_CELL_LIB_TT := $(SKY130_ROOT)/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
TECH_LEF := $(SKY130_ROOT)/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
STD_CELL_LEF := $(SKY130_ROOT)/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
SRAM_NAME := sky130_sram_1kbyte_1rw1r_8x1024_8
SRAM_DIR := macros/sky130_sram_macros/$(SRAM_NAME)
SRAM_LIB := $(SRAM_DIR)/$(SRAM_NAME)_TT_1p8V_25C.lib
SRAM_LEF := $(SRAM_DIR)/$(SRAM_NAME).lef

BASEJUMP_STL_DIR := ../third_party/basejump_stl
BASEJUMP_CACHE_SRCS := \
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
	bsg_mem_1rw_sync_synth_openram.sv \
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

.PHONY: openram-macros ppa ppa-synth ppa-sta synth-check

ppa: ppa-synth ppa-sta

synth-check:
	@mkdir -p runs
	@source "$(OSS_CAD_ROOT)/environment" && \
	  yosys -Q -q -m slang -l runs/synth-check.log -p \
	  'read_slang --top cached_core --compat vcs --allow-use-before-declare -DSYNTHESIS -DYOSYS -I.. -I$(BASEJUMP_STL_DIR)/bsg_misc -I$(BASEJUMP_STL_DIR)/bsg_cache $(BASEJUMP_CACHE_SRCS) openram_blackboxes.sv ../RTL/cached_core.sv; hierarchy -check -top cached_core; proc; opt; check; memory -nomap; opt; check; stat'

openram-macros:
	@./fetch-openram-macros.sh

ppa-synth: openram-macros
	@test -f "$(STD_CELL_LIB_TT)"
	@test -f "$(SRAM_LIB)"
	@mkdir -p runs/ppa
	@source "$(OSS_CAD_ROOT)/environment" && \
	  yosys -Q -q -m slang -l runs/ppa/yosys.log -p \
	  'read_liberty -lib $(STD_CELL_LIB_TT); read_liberty -lib $(SRAM_LIB); read_slang --top cached_core --compat vcs --allow-use-before-declare -DSYNTHESIS -DYOSYS -I.. -I$(BASEJUMP_STL_DIR)/bsg_misc -I$(BASEJUMP_STL_DIR)/bsg_cache $(BASEJUMP_CACHE_SRCS) openram_blackboxes.sv ../RTL/cached_core.sv; hierarchy -check -top cached_core; proc; flatten; opt; memory_map; opt; techmap; opt; dfflibmap -liberty $(STD_CELL_LIB_TT); abc -liberty $(STD_CELL_LIB_TT) -D 50000; clean; check; stat -liberty $(STD_CELL_LIB_TT); write_verilog -noattr -noexpr runs/ppa/cached_core.nl.v; write_json runs/ppa/cached_core.json'

ppa-sta:
	@test -f runs/ppa/cached_core.nl.v || \
	  { echo "Run 'make ppa-synth' first" >&2; exit 1; }
	@STD_CELL_LIB_TT="$(STD_CELL_LIB_TT)" \
	 TECH_LEF="$(TECH_LEF)" \
	 STD_CELL_LEF="$(STD_CELL_LEF)" \
	 SRAM_LIB="$(CURDIR)/$(SRAM_LIB)" \
	 SRAM_LEF="$(CURDIR)/$(SRAM_LEF)" \
	 PPA_NETLIST="$(CURDIR)/runs/ppa/cached_core.nl.v" \
	 CLOCK_PERIOD_NS="$(CLOCK_PERIOD_NS)" \
	 POWER_ACTIVITY="$(POWER_ACTIVITY)" \
	 /nix/var/nix/profiles/default/bin/nix-shell "$(OPENLANE_ROOT)" --run \
	 'openroad -no_init -exit -log "$(CURDIR)/runs/ppa/sta_power_$(PPA_TAG).log" "$(CURDIR)/sta_power.tcl"'
