// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_riscv_multicycle.h"

void Vtop_riscv_multicycle___ctor_var_reset(Vtop_riscv_multicycle* vlSelf);

Vtop_riscv_multicycle::Vtop_riscv_multicycle(Vtop__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtop_riscv_multicycle___ctor_var_reset(this);
}

void Vtop_riscv_multicycle::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtop_riscv_multicycle::~Vtop_riscv_multicycle() {
}
