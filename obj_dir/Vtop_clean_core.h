// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP_CLEAN_CORE_H_
#define VERILATED_VTOP_CLEAN_CORE_H_  // guard

#include "verilated.h"
class Vtop_riscv_multicycle;


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop_clean_core final : public VerilatedModule {
  public:
    // CELLS
    Vtop_riscv_multicycle* core;

    // DESIGN SPECIFIC STATE
    VL_IN8(__PVT__clk,0,0);
    VL_IN8(__PVT__reset,0,0);
    VL_IN(__PVT__reset_pc,31,0);
    VL_OUTW(__PVT__inst_mem_req,91,0,3);
    VL_INW(__PVT__inst_mem_rsp,83,0,3);
    VL_OUTW(__PVT__data_mem_req,91,0,3);
    VL_INW(__PVT__data_mem_rsp,83,0,3);

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop_clean_core(Vtop__Syms* symsp, const char* v__name);
    ~Vtop_clean_core();
    VL_UNCOPYABLE(Vtop_clean_core);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
