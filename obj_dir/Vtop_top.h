// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP_TOP_H_
#define VERILATED_VTOP_TOP_H_  // guard

#include "verilated.h"
class Vtop_clean_core;


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop_top final : public VerilatedModule {
  public:
    // CELLS
    Vtop_clean_core* core;

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_OUT8(halt,0,0);
    CData/*0:0*/ __VdlySet__code_mem__DOT__data0__v0;
    CData/*0:0*/ __VdlySet__code_mem__DOT__data1__v0;
    CData/*0:0*/ __VdlySet__code_mem__DOT__data2__v0;
    CData/*0:0*/ __VdlySet__code_mem__DOT__data3__v0;
    CData/*0:0*/ __VdlySet__data_mem__DOT__data0__v0;
    CData/*0:0*/ __VdlySet__data_mem__DOT__data1__v0;
    CData/*0:0*/ __VdlySet__data_mem__DOT__data2__v0;
    CData/*0:0*/ __VdlySet__data_mem__DOT__data3__v0;
    VlWide<3>/*83:0*/ __PVT__inst_mem_rsp;
    VlWide<3>/*83:0*/ __PVT__data_mem_rsp;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__code_mem__DOT__data0;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__code_mem__DOT__data1;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__code_mem__DOT__data2;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__code_mem__DOT__data3;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__data_mem__DOT__data0;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__data_mem__DOT__data1;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__data_mem__DOT__data2;
    VlUnpacked<CData/*7:0*/, 16384> __PVT__data_mem__DOT__data3;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop_top(Vtop__Syms* symsp, const char* v__name);
    ~Vtop_top();
    VL_UNCOPYABLE(Vtop_top);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
