// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__pch.h"
#include "Vtop.h"
#include "Vtop___024root.h"
#include "Vtop_top.h"
#include "Vtop___024unit.h"
#include "Vtop_clean_core.h"
#include "Vtop_riscv_multicycle.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{
}

Vtop__Syms::Vtop__Syms(VerilatedContext* contextp, const char* namep, Vtop* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
    , TOP__top{this, Verilated::catName(namep, "top")}
    , TOP__top__core{this, Verilated::catName(namep, "top.core")}
    , TOP__top__core__core{this, Verilated::catName(namep, "top.core.core")}
{
        // Check resources
        Verilated::stackCheck(966);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    TOP.top = &TOP__top;
    TOP__top.core = &TOP__top__core;
    TOP__top__core.core = &TOP__top__core__core;
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    TOP__top.__Vconfigure(true);
    TOP__top__core.__Vconfigure(true);
    TOP__top__core__core.__Vconfigure(true);
    // Setup scopes
    __Vscope_top__core__core.configure(this, name(), "top.core.core", "core", "<null>", 0, VerilatedScope::SCOPE_OTHER);
    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
        __Vscope_top__core__core.varInsert(__Vfinal,"instruction_count", &(TOP__top__core__core.instruction_count), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
    }
}
