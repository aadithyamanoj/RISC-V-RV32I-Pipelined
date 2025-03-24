// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.set(0U, ((IData)(vlSelfRef.clk) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__act(vlSelf);
    }
#endif
}

void Vtop_top___nba_sequent__TOP__top__0(Vtop_top* vlSelf);
void Vtop_riscv_multicycle___nba_sequent__TOP__top__core__core__0(Vtop_riscv_multicycle* vlSelf);
void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf);
void Vtop_top___nba_sequent__TOP__top__1(Vtop_top* vlSelf);
void Vtop_clean_core___nba_sequent__TOP__top__core__0(Vtop_clean_core* vlSelf);
void Vtop_riscv_multicycle___nba_sequent__TOP__top__core__core__1(Vtop_riscv_multicycle* vlSelf);
void Vtop_clean_core___nba_sequent__TOP__top__core__1(Vtop_clean_core* vlSelf);

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtop_top___nba_sequent__TOP__top__0((&vlSymsp->TOP__top));
        Vtop_riscv_multicycle___nba_sequent__TOP__top__core__core__0((&vlSymsp->TOP__top__core__core));
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
        Vtop_top___nba_sequent__TOP__top__1((&vlSymsp->TOP__top));
        Vtop_clean_core___nba_sequent__TOP__top__core__0((&vlSymsp->TOP__top__core));
        Vtop_riscv_multicycle___nba_sequent__TOP__top__core__core__1((&vlSymsp->TOP__top__core__core));
        Vtop_clean_core___nba_sequent__TOP__top__core__1((&vlSymsp->TOP__top__core));
    }
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.halt = vlSymsp->TOP__top.halt;
}
