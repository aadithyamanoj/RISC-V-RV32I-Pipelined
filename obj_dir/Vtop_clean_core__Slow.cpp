// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_clean_core.h"

void Vtop_clean_core___ctor_var_reset(Vtop_clean_core* vlSelf);

Vtop_clean_core::Vtop_clean_core(Vtop__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtop_clean_core___ctor_var_reset(this);
}

void Vtop_clean_core::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtop_clean_core::~Vtop_clean_core() {
}
