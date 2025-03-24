// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop_top.h"

VL_ATTR_COLD void Vtop_top___eval_initial__TOP__top(Vtop_top* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top___eval_initial__TOP__top\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __PVT__code_mem__DOT__unnamedblk1__DOT__i;
    __PVT__code_mem__DOT__unnamedblk1__DOT__i = 0;
    IData/*31:0*/ __PVT__data_mem__DOT__unnamedblk1__DOT__i;
    __PVT__data_mem__DOT__unnamedblk1__DOT__i = 0;
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_3;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_5;
    VlWide<3>/*95:0*/ __Vtemp_7;
    VlWide<3>/*95:0*/ __Vtemp_8;
    VlWide<3>/*95:0*/ __Vtemp_9;
    VlWide<3>/*95:0*/ __Vtemp_10;
    // Body
    __PVT__code_mem__DOT__unnamedblk1__DOT__i = 0U;
    while ((0x4000U > __PVT__code_mem__DOT__unnamedblk1__DOT__i)) {
        vlSelfRef.__PVT__code_mem__DOT__data0[(0x3fffU 
                                               & __PVT__code_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__code_mem__DOT__data1[(0x3fffU 
                                               & __PVT__code_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__code_mem__DOT__data2[(0x3fffU 
                                               & __PVT__code_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__code_mem__DOT__data3[(0x3fffU 
                                               & __PVT__code_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        __PVT__code_mem__DOT__unnamedblk1__DOT__i = 
            ((IData)(1U) + __PVT__code_mem__DOT__unnamedblk1__DOT__i);
    }
    __Vtemp_2[0U] = 0x2e686578U;
    __Vtemp_2[1U] = 0x6f646530U;
    __Vtemp_2[2U] = 0x63U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_2)
                 ,  &(vlSelfRef.__PVT__code_mem__DOT__data0)
                 , 0U, ~0ULL);
    __Vtemp_3[0U] = 0x2e686578U;
    __Vtemp_3[1U] = 0x6f646531U;
    __Vtemp_3[2U] = 0x63U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_3)
                 ,  &(vlSelfRef.__PVT__code_mem__DOT__data1)
                 , 0U, ~0ULL);
    __Vtemp_4[0U] = 0x2e686578U;
    __Vtemp_4[1U] = 0x6f646532U;
    __Vtemp_4[2U] = 0x63U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_4)
                 ,  &(vlSelfRef.__PVT__code_mem__DOT__data2)
                 , 0U, ~0ULL);
    __Vtemp_5[0U] = 0x2e686578U;
    __Vtemp_5[1U] = 0x6f646533U;
    __Vtemp_5[2U] = 0x63U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_5)
                 ,  &(vlSelfRef.__PVT__code_mem__DOT__data3)
                 , 0U, ~0ULL);
    __PVT__data_mem__DOT__unnamedblk1__DOT__i = 0U;
    while ((0x4000U > __PVT__data_mem__DOT__unnamedblk1__DOT__i)) {
        vlSelfRef.__PVT__data_mem__DOT__data0[(0x3fffU 
                                               & __PVT__data_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__data_mem__DOT__data1[(0x3fffU 
                                               & __PVT__data_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__data_mem__DOT__data2[(0x3fffU 
                                               & __PVT__data_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        vlSelfRef.__PVT__data_mem__DOT__data3[(0x3fffU 
                                               & __PVT__data_mem__DOT__unnamedblk1__DOT__i)] = 0U;
        __PVT__data_mem__DOT__unnamedblk1__DOT__i = 
            ((IData)(1U) + __PVT__data_mem__DOT__unnamedblk1__DOT__i);
    }
    __Vtemp_7[0U] = 0x2e686578U;
    __Vtemp_7[1U] = 0x61746130U;
    __Vtemp_7[2U] = 0x64U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_7)
                 ,  &(vlSelfRef.__PVT__data_mem__DOT__data0)
                 , 0U, ~0ULL);
    __Vtemp_8[0U] = 0x2e686578U;
    __Vtemp_8[1U] = 0x61746131U;
    __Vtemp_8[2U] = 0x64U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_8)
                 ,  &(vlSelfRef.__PVT__data_mem__DOT__data1)
                 , 0U, ~0ULL);
    __Vtemp_9[0U] = 0x2e686578U;
    __Vtemp_9[1U] = 0x61746132U;
    __Vtemp_9[2U] = 0x64U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_9)
                 ,  &(vlSelfRef.__PVT__data_mem__DOT__data2)
                 , 0U, ~0ULL);
    __Vtemp_10[0U] = 0x2e686578U;
    __Vtemp_10[1U] = 0x61746133U;
    __Vtemp_10[2U] = 0x64U;
    VL_READMEM_N(true, 8, 16384, 0, VL_CVT_PACK_STR_NW(3, __Vtemp_10)
                 ,  &(vlSelfRef.__PVT__data_mem__DOT__data3)
                 , 0U, ~0ULL);
}

VL_ATTR_COLD void Vtop_top___ctor_var_reset(Vtop_top* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->halt = VL_RAND_RESET_I(1);
    VL_RAND_RESET_W(84, vlSelf->__PVT__inst_mem_rsp);
    VL_RAND_RESET_W(84, vlSelf->__PVT__data_mem_rsp);
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__code_mem__DOT__data0[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__code_mem__DOT__data1[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__code_mem__DOT__data2[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__code_mem__DOT__data3[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__data_mem__DOT__data0[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__data_mem__DOT__data1[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__data_mem__DOT__data2[__Vi0] = VL_RAND_RESET_I(8);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->__PVT__data_mem__DOT__data3[__Vi0] = VL_RAND_RESET_I(8);
    }
    vlSelf->__VdlySet__code_mem__DOT__data0__v0 = 0;
    vlSelf->__VdlySet__code_mem__DOT__data1__v0 = 0;
    vlSelf->__VdlySet__code_mem__DOT__data2__v0 = 0;
    vlSelf->__VdlySet__code_mem__DOT__data3__v0 = 0;
    vlSelf->__VdlySet__data_mem__DOT__data0__v0 = 0;
    vlSelf->__VdlySet__data_mem__DOT__data1__v0 = 0;
    vlSelf->__VdlySet__data_mem__DOT__data2__v0 = 0;
    vlSelf->__VdlySet__data_mem__DOT__data3__v0 = 0;
}
