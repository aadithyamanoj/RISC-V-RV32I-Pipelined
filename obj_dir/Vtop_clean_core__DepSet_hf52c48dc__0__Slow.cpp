// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop_clean_core.h"

VL_ATTR_COLD void Vtop_clean_core___ctor_var_reset(Vtop_clean_core* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vtop_clean_core___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->__PVT__clk = VL_RAND_RESET_I(1);
    vlSelf->__PVT__reset = VL_RAND_RESET_I(1);
    vlSelf->__PVT__reset_pc = VL_RAND_RESET_I(32);
    VL_RAND_RESET_W(92, vlSelf->__PVT__inst_mem_req);
    VL_RAND_RESET_W(84, vlSelf->__PVT__inst_mem_rsp);
    VL_RAND_RESET_W(92, vlSelf->__PVT__data_mem_req);
    VL_RAND_RESET_W(84, vlSelf->__PVT__data_mem_rsp);
}
