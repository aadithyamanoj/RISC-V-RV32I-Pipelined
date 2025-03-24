// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_top.h"

VL_INLINE_OPT void Vtop_top___nba_sequent__TOP__top__0(Vtop_top* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top___nba_sequent__TOP__top__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY((((vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                       >> 0x13U) & (0x2fff8U == ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                  << 4U) 
                                                 | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                    >> 0x1cU)))) 
                     & (0U != (0xfU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                       >> 0x14U)))))) {
        VL_WRITEF_NX("%c",0,8,(0xffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                         << 4U) | (
                                                   vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                                   >> 0x1cU))));
    }
    vlSelfRef.__VdlySet__data_mem__DOT__data0__v0 = 0U;
    vlSelfRef.__VdlySet__data_mem__DOT__data1__v0 = 0U;
    vlSelfRef.__VdlySet__data_mem__DOT__data2__v0 = 0U;
    vlSelfRef.__VdlySet__data_mem__DOT__data3__v0 = 0U;
    vlSelfRef.__VdlySet__code_mem__DOT__data0__v0 = 0U;
    vlSelfRef.__VdlySet__code_mem__DOT__data1__v0 = 0U;
    vlSelfRef.__VdlySet__code_mem__DOT__data2__v0 = 0U;
    vlSelfRef.__VdlySet__code_mem__DOT__data3__v0 = 0U;
    vlSelfRef.halt = (((vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                        >> 0x13U) & (0x2fffcU == ((
                                                   vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                   << 4U) 
                                                  | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                     >> 0x1cU)))) 
                      & (0U != (0xfU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                        >> 0x14U))));
}

VL_INLINE_OPT void Vtop_top___nba_sequent__TOP__top__1(Vtop_top* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top___nba_sequent__TOP__top__1\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __Vfunc_is_any_byte32__0__Vfuncout;
    __Vfunc_is_any_byte32__0__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_is_any_byte32__0__control;
    __Vfunc_is_any_byte32__0__control = 0;
    CData/*0:0*/ __Vfunc_is_any_byte32__1__Vfuncout;
    __Vfunc_is_any_byte32__1__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_is_any_byte32__1__control;
    __Vfunc_is_any_byte32__1__control = 0;
    CData/*0:0*/ __Vfunc_is_any_byte32__2__Vfuncout;
    __Vfunc_is_any_byte32__2__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_is_any_byte32__2__control;
    __Vfunc_is_any_byte32__2__control = 0;
    CData/*0:0*/ __Vfunc_is_any_byte32__3__Vfuncout;
    __Vfunc_is_any_byte32__3__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_is_any_byte32__3__control;
    __Vfunc_is_any_byte32__3__control = 0;
    CData/*7:0*/ __VdlyVal__code_mem__DOT__data0__v0;
    __VdlyVal__code_mem__DOT__data0__v0 = 0;
    SData/*13:0*/ __VdlyDim0__code_mem__DOT__data0__v0;
    __VdlyDim0__code_mem__DOT__data0__v0 = 0;
    CData/*7:0*/ __VdlyVal__code_mem__DOT__data1__v0;
    __VdlyVal__code_mem__DOT__data1__v0 = 0;
    SData/*13:0*/ __VdlyDim0__code_mem__DOT__data1__v0;
    __VdlyDim0__code_mem__DOT__data1__v0 = 0;
    CData/*7:0*/ __VdlyVal__code_mem__DOT__data2__v0;
    __VdlyVal__code_mem__DOT__data2__v0 = 0;
    SData/*13:0*/ __VdlyDim0__code_mem__DOT__data2__v0;
    __VdlyDim0__code_mem__DOT__data2__v0 = 0;
    CData/*7:0*/ __VdlyVal__code_mem__DOT__data3__v0;
    __VdlyVal__code_mem__DOT__data3__v0 = 0;
    SData/*13:0*/ __VdlyDim0__code_mem__DOT__data3__v0;
    __VdlyDim0__code_mem__DOT__data3__v0 = 0;
    CData/*7:0*/ __VdlyVal__data_mem__DOT__data0__v0;
    __VdlyVal__data_mem__DOT__data0__v0 = 0;
    SData/*13:0*/ __VdlyDim0__data_mem__DOT__data0__v0;
    __VdlyDim0__data_mem__DOT__data0__v0 = 0;
    CData/*7:0*/ __VdlyVal__data_mem__DOT__data1__v0;
    __VdlyVal__data_mem__DOT__data1__v0 = 0;
    SData/*13:0*/ __VdlyDim0__data_mem__DOT__data1__v0;
    __VdlyDim0__data_mem__DOT__data1__v0 = 0;
    CData/*7:0*/ __VdlyVal__data_mem__DOT__data2__v0;
    __VdlyVal__data_mem__DOT__data2__v0 = 0;
    SData/*13:0*/ __VdlyDim0__data_mem__DOT__data2__v0;
    __VdlyDim0__data_mem__DOT__data2__v0 = 0;
    CData/*7:0*/ __VdlyVal__data_mem__DOT__data3__v0;
    __VdlyVal__data_mem__DOT__data3__v0 = 0;
    SData/*13:0*/ __VdlyDim0__data_mem__DOT__data3__v0;
    __VdlyDim0__data_mem__DOT__data3__v0 = 0;
    // Body
    vlSelfRef.__PVT__data_mem_rsp[0U] = 0x40000U;
    vlSelfRef.__PVT__data_mem_rsp[1U] = 0U;
    vlSelfRef.__PVT__data_mem_rsp[2U] = 0U;
    if ((0x80000U & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U])) {
        vlSelfRef.__PVT__data_mem_rsp[0U] = ((0xffff0000U 
                                              & vlSelfRef.__PVT__data_mem_rsp[0U]) 
                                             | (0xffffU 
                                                & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U]));
        if (([&]() {
                    __Vfunc_is_any_byte32__2__control 
                        = (0xfU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                   >> 0x18U));
                    __Vfunc_is_any_byte32__2__Vfuncout 
                        = (IData)((0U != (IData)(__Vfunc_is_any_byte32__2__control)));
                }(), (IData)(__Vfunc_is_any_byte32__2__Vfuncout))) {
            vlSelfRef.__PVT__data_mem_rsp[0U] = ((0xfffffU 
                                                  & vlSelfRef.__PVT__data_mem_rsp[0U]) 
                                                 | (0xfff00000U 
                                                    & ((vlSelfRef.__PVT__data_mem__DOT__data1
                                                        [
                                                        (0x3fffU 
                                                         & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                             << 2U) 
                                                            | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                               >> 0x1eU)))] 
                                                        << 0x1cU) 
                                                       | (vlSelfRef.__PVT__data_mem__DOT__data0
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          << 0x14U))));
            vlSelfRef.__PVT__data_mem_rsp[1U] = ((0xfffffff0U 
                                                  & vlSelfRef.__PVT__data_mem_rsp[1U]) 
                                                 | (0xfffffU 
                                                    & ((0xfffffU 
                                                        & (vlSelfRef.__PVT__data_mem__DOT__data1
                                                           [
                                                           (0x3fffU 
                                                            & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                                << 2U) 
                                                               | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                                  >> 0x1eU)))] 
                                                           >> 4U)) 
                                                       | (vlSelfRef.__PVT__data_mem__DOT__data0
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          >> 0xcU))));
            vlSelfRef.__PVT__data_mem_rsp[1U] = ((0xfff0000fU 
                                                  & vlSelfRef.__PVT__data_mem_rsp[1U]) 
                                                 | (0xfffffff0U 
                                                    & ((vlSelfRef.__PVT__data_mem__DOT__data3
                                                        [
                                                        (0x3fffU 
                                                         & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                             << 2U) 
                                                            | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                               >> 0x1eU)))] 
                                                        << 0xcU) 
                                                       | (vlSelfRef.__PVT__data_mem__DOT__data2
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          << 4U))));
            vlSelfRef.__PVT__data_mem_rsp[0U] = (0x80000U 
                                                 | vlSelfRef.__PVT__data_mem_rsp[0U]);
        } else if (([&]() {
                    __Vfunc_is_any_byte32__3__control 
                        = (0xfU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                   >> 0x14U));
                    __Vfunc_is_any_byte32__3__Vfuncout 
                        = (IData)((0U != (IData)(__Vfunc_is_any_byte32__3__control)));
                }(), (IData)(__Vfunc_is_any_byte32__3__Vfuncout))) {
            vlSelfRef.__PVT__data_mem_rsp[0U] = (0x80000U 
                                                 | vlSelfRef.__PVT__data_mem_rsp[0U]);
            if ((0x100000U & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U])) {
                __VdlyVal__data_mem__DOT__data0__v0 
                    = (0xffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                 << 4U) | (vlSymsp->TOP__top__core.__PVT__data_mem_req[0U] 
                                           >> 0x1cU)));
                __VdlyDim0__data_mem__DOT__data0__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__data_mem__DOT__data0__v0 = 1U;
            }
            if ((0x200000U & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U])) {
                __VdlyVal__data_mem__DOT__data1__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                >> 4U));
                __VdlyDim0__data_mem__DOT__data1__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__data_mem__DOT__data1__v0 = 1U;
            }
            if ((0x400000U & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U])) {
                __VdlyVal__data_mem__DOT__data2__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                >> 0xcU));
                __VdlyDim0__data_mem__DOT__data2__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__data_mem__DOT__data2__v0 = 1U;
            }
            if ((0x800000U & vlSymsp->TOP__top__core.__PVT__data_mem_req[0U])) {
                __VdlyVal__data_mem__DOT__data3__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                >> 0x14U));
                __VdlyDim0__data_mem__DOT__data3__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__data_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__data_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__data_mem__DOT__data3__v0 = 1U;
            }
        } else {
            vlSelfRef.__PVT__data_mem_rsp[0U] = (0xfff7ffffU 
                                                 & vlSelfRef.__PVT__data_mem_rsp[0U]);
        }
    }
    vlSelfRef.__PVT__inst_mem_rsp[0U] = 0x40000U;
    vlSelfRef.__PVT__inst_mem_rsp[1U] = 0U;
    vlSelfRef.__PVT__inst_mem_rsp[2U] = 0U;
    if ((0x80000U & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U])) {
        vlSelfRef.__PVT__inst_mem_rsp[0U] = ((0xffff0000U 
                                              & vlSelfRef.__PVT__inst_mem_rsp[0U]) 
                                             | (0xffffU 
                                                & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U]));
        if (([&]() {
                    __Vfunc_is_any_byte32__0__control 
                        = (0xfU & (vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U] 
                                   >> 0x18U));
                    __Vfunc_is_any_byte32__0__Vfuncout 
                        = (IData)((0U != (IData)(__Vfunc_is_any_byte32__0__control)));
                }(), (IData)(__Vfunc_is_any_byte32__0__Vfuncout))) {
            vlSelfRef.__PVT__inst_mem_rsp[0U] = ((0xfffffU 
                                                  & vlSelfRef.__PVT__inst_mem_rsp[0U]) 
                                                 | (0xfff00000U 
                                                    & ((vlSelfRef.__PVT__code_mem__DOT__data1
                                                        [
                                                        (0x3fffU 
                                                         & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                             << 2U) 
                                                            | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                               >> 0x1eU)))] 
                                                        << 0x1cU) 
                                                       | (vlSelfRef.__PVT__code_mem__DOT__data0
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          << 0x14U))));
            vlSelfRef.__PVT__inst_mem_rsp[1U] = ((0xfffffff0U 
                                                  & vlSelfRef.__PVT__inst_mem_rsp[1U]) 
                                                 | (0xfffffU 
                                                    & ((0xfffffU 
                                                        & (vlSelfRef.__PVT__code_mem__DOT__data1
                                                           [
                                                           (0x3fffU 
                                                            & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                                << 2U) 
                                                               | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                                  >> 0x1eU)))] 
                                                           >> 4U)) 
                                                       | (vlSelfRef.__PVT__code_mem__DOT__data0
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          >> 0xcU))));
            vlSelfRef.__PVT__inst_mem_rsp[1U] = ((0xfff0000fU 
                                                  & vlSelfRef.__PVT__inst_mem_rsp[1U]) 
                                                 | (0xfffffff0U 
                                                    & ((vlSelfRef.__PVT__code_mem__DOT__data3
                                                        [
                                                        (0x3fffU 
                                                         & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                             << 2U) 
                                                            | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                               >> 0x1eU)))] 
                                                        << 0xcU) 
                                                       | (vlSelfRef.__PVT__code_mem__DOT__data2
                                                          [
                                                          (0x3fffU 
                                                           & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                                               << 2U) 
                                                              | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                                                 >> 0x1eU)))] 
                                                          << 4U))));
            vlSelfRef.__PVT__inst_mem_rsp[0U] = (0x80000U 
                                                 | vlSelfRef.__PVT__inst_mem_rsp[0U]);
        } else if (([&]() {
                    __Vfunc_is_any_byte32__1__control 
                        = (0xfU & (vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U] 
                                   >> 0x14U));
                    __Vfunc_is_any_byte32__1__Vfuncout 
                        = (IData)((0U != (IData)(__Vfunc_is_any_byte32__1__control)));
                }(), (IData)(__Vfunc_is_any_byte32__1__Vfuncout))) {
            vlSelfRef.__PVT__inst_mem_rsp[0U] = (0x80000U 
                                                 | vlSelfRef.__PVT__inst_mem_rsp[0U]);
            if ((0x100000U & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U])) {
                __VdlyVal__code_mem__DOT__data0__v0 
                    = (0xffU & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                 << 4U) | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U] 
                                           >> 0x1cU)));
                __VdlyDim0__code_mem__DOT__data0__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__code_mem__DOT__data0__v0 = 1U;
            }
            if ((0x200000U & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U])) {
                __VdlyVal__code_mem__DOT__data1__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                >> 4U));
                __VdlyDim0__code_mem__DOT__data1__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__code_mem__DOT__data1__v0 = 1U;
            }
            if ((0x400000U & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U])) {
                __VdlyVal__code_mem__DOT__data2__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                >> 0xcU));
                __VdlyDim0__code_mem__DOT__data2__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__code_mem__DOT__data2__v0 = 1U;
            }
            if ((0x800000U & vlSymsp->TOP__top__core.__PVT__inst_mem_req[0U])) {
                __VdlyVal__code_mem__DOT__data3__v0 
                    = (0xffU & (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                >> 0x14U));
                __VdlyDim0__code_mem__DOT__data3__v0 
                    = (0x3fffU & ((vlSymsp->TOP__top__core.__PVT__inst_mem_req[2U] 
                                   << 2U) | (vlSymsp->TOP__top__core.__PVT__inst_mem_req[1U] 
                                             >> 0x1eU)));
                vlSelfRef.__VdlySet__code_mem__DOT__data3__v0 = 1U;
            }
        } else {
            vlSelfRef.__PVT__inst_mem_rsp[0U] = (0xfff7ffffU 
                                                 & vlSelfRef.__PVT__inst_mem_rsp[0U]);
        }
    }
    if (vlSelfRef.__VdlySet__data_mem__DOT__data0__v0) {
        vlSelfRef.__PVT__data_mem__DOT__data0[__VdlyDim0__data_mem__DOT__data0__v0] 
            = __VdlyVal__data_mem__DOT__data0__v0;
    }
    if (vlSelfRef.__VdlySet__data_mem__DOT__data1__v0) {
        vlSelfRef.__PVT__data_mem__DOT__data1[__VdlyDim0__data_mem__DOT__data1__v0] 
            = __VdlyVal__data_mem__DOT__data1__v0;
    }
    if (vlSelfRef.__VdlySet__data_mem__DOT__data2__v0) {
        vlSelfRef.__PVT__data_mem__DOT__data2[__VdlyDim0__data_mem__DOT__data2__v0] 
            = __VdlyVal__data_mem__DOT__data2__v0;
    }
    if (vlSelfRef.__VdlySet__data_mem__DOT__data3__v0) {
        vlSelfRef.__PVT__data_mem__DOT__data3[__VdlyDim0__data_mem__DOT__data3__v0] 
            = __VdlyVal__data_mem__DOT__data3__v0;
    }
    if (vlSelfRef.__VdlySet__code_mem__DOT__data0__v0) {
        vlSelfRef.__PVT__code_mem__DOT__data0[__VdlyDim0__code_mem__DOT__data0__v0] 
            = __VdlyVal__code_mem__DOT__data0__v0;
    }
    if (vlSelfRef.__VdlySet__code_mem__DOT__data1__v0) {
        vlSelfRef.__PVT__code_mem__DOT__data1[__VdlyDim0__code_mem__DOT__data1__v0] 
            = __VdlyVal__code_mem__DOT__data1__v0;
    }
    if (vlSelfRef.__VdlySet__code_mem__DOT__data2__v0) {
        vlSelfRef.__PVT__code_mem__DOT__data2[__VdlyDim0__code_mem__DOT__data2__v0] 
            = __VdlyVal__code_mem__DOT__data2__v0;
    }
    if (vlSelfRef.__VdlySet__code_mem__DOT__data3__v0) {
        vlSelfRef.__PVT__code_mem__DOT__data3[__VdlyDim0__code_mem__DOT__data3__v0] 
            = __VdlyVal__code_mem__DOT__data3__v0;
    }
}
