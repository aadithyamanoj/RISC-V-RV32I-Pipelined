# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Make include file with class lists
#
# This file lists generated Verilated files, for including in higher level makefiles.
# See Vtop.mk for the caller.

### Switches...
# C11 constructs required?  0/1 (always on now)
VM_C11 = 1
# Timing enabled?  0/1
VM_TIMING = 0
# Coverage output mode?  0/1 (from --coverage)
VM_COVERAGE = 0
# Parallel builds?  0/1 (from --output-split)
VM_PARALLEL_BUILDS = 0
# Tracing output mode?  0/1 (from --trace/--trace-fst)
VM_TRACE = 0
# Tracing output mode in VCD format?  0/1 (from --trace)
VM_TRACE_VCD = 0
# Tracing output mode in FST format?  0/1 (from --trace-fst)
VM_TRACE_FST = 0

### Object file lists...
# Generated module classes, fast-path, compile with highest optimization
VM_CLASSES_FAST += \
	Vtop \
	Vtop___024root__DepSet_h5bd79f41__0 \
	Vtop___024root__DepSet_h90d7eb88__0 \
	Vtop_top__DepSet_h55d42578__0 \
	Vtop_clean_core__DepSet_hbe033c2d__0 \
	Vtop_riscv_multicycle__DepSet_h98bc56ff__0 \

# Generated module classes, non-fast-path, compile with low/medium optimization
VM_CLASSES_SLOW += \
	Vtop___024root__Slow \
	Vtop___024root__DepSet_h5bd79f41__0__Slow \
	Vtop___024root__DepSet_h90d7eb88__0__Slow \
	Vtop_top__Slow \
	Vtop_top__DepSet_h8ed5518f__0__Slow \
	Vtop___024unit__Slow \
	Vtop___024unit__DepSet_h1d85a5cb__0__Slow \
	Vtop_clean_core__Slow \
	Vtop_clean_core__DepSet_hbe033c2d__0__Slow \
	Vtop_clean_core__DepSet_hf52c48dc__0__Slow \
	Vtop_riscv_multicycle__Slow \
	Vtop_riscv_multicycle__DepSet_h98bc56ff__0__Slow \
	Vtop_riscv_multicycle__DepSet_hd3ada30a__0__Slow \

# Generated support classes, fast-path, compile with highest optimization
VM_SUPPORT_FAST += \
	Vtop__Dpi \

# Generated support classes, non-fast-path, compile with low/medium optimization
VM_SUPPORT_SLOW += \
	Vtop__Syms \

# Global classes, need linked once per executable, fast-path, compile with highest optimization
VM_GLOBAL_FAST += \
	verilated \
	verilated_dpi \
	verilated_threads \

# Global classes, need linked once per executable, non-fast-path, compile with low/medium optimization
VM_GLOBAL_SLOW += \


# Verilated -*- Makefile -*-
