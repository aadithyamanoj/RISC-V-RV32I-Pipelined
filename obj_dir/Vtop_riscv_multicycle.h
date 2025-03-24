// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP_RISCV_MULTICYCLE_H_
#define VERILATED_VTOP_RISCV_MULTICYCLE_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop_riscv_multicycle final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_IN8(__PVT__clk,0,0);
        VL_IN8(__PVT__reset,0,0);
        VL_OUT8(__PVT__instruction_valid,0,0);
        VL_IN8(__PVT__instruction_ready,0,0);
        VL_IN8(__PVT__instruction_response_valid,0,0);
        VL_OUT8(__PVT__data_read_valid,0,0);
        VL_OUT8(__PVT__data_write_valid,0,0);
        VL_OUT8(__PVT__data_read_byte,3,0);
        VL_OUT8(__PVT__data_write_byte,3,0);
        VL_IN8(__PVT__data_ready,0,0);
        VL_IN8(__PVT__data_response_valid,0,0);
        CData/*4:0*/ __PVT__rs1;
        CData/*4:0*/ __PVT__rs2;
        CData/*4:0*/ __PVT__wbs;
        CData/*0:0*/ __PVT__read_reg_valid;
        CData/*0:0*/ __PVT__write_reg_valid;
        CData/*0:0*/ __PVT__memory_stage_complete;
        CData/*0:0*/ __Vfunc_decode_writeback__2__Vfuncout;
        CData/*6:0*/ __Vfunc_decode_funct7__3__Vfuncout;
        CData/*2:0*/ __Vfunc_execute__4__unnamedblk4__DOT__selected_f3;
        CData/*6:0*/ __Vfunc_execute__4__unnamedblk4__DOT__selected_f7;
        CData/*2:0*/ __Vfunc_alu__8__f3;
        CData/*6:0*/ __Vfunc_alu__8__f7;
        CData/*0:0*/ __Vfunc_alu__8__unnamedblk3__DOT__f3_mod;
        CData/*0:0*/ __Vfunc_cast_to_f3_mod__9__Vfuncout;
        CData/*6:0*/ __Vfunc_cast_to_f3_mod__9__in;
        CData/*2:0*/ __Vfunc_cast_to_ext_m__10__Vfuncout;
        CData/*2:0*/ __Vfunc_cast_to_ext_m__10__in;
        CData/*2:0*/ __Vfunc_cast_to_ext_m__11__Vfuncout;
        CData/*2:0*/ __Vfunc_cast_to_ext_m__11__in;
        CData/*0:0*/ __Vfunc_take_branch__14__Vfuncout;
        CData/*2:0*/ __Vfunc_take_branch__14__f3;
        CData/*0:0*/ __Vfunc_take_branch__14__unnamedblk1__DOT__is_zero;
        CData/*3:0*/ __Vfunc_shuffle_store_mask__15__Vfuncout;
        CData/*3:0*/ __Vfunc_shuffle_store_mask__15__mask;
        CData/*3:0*/ __Vfunc_memory_mask__16__Vfuncout;
        CData/*2:0*/ __Vfunc_memory_mask__16__op;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__17__Vfuncout;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__17__in;
        CData/*7:0*/ __Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0;
        CData/*7:0*/ __Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1;
        CData/*7:0*/ __Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2;
        CData/*7:0*/ __Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3;
        CData/*3:0*/ __Vfunc_shuffle_store_mask__19__Vfuncout;
        CData/*3:0*/ __Vfunc_shuffle_store_mask__19__mask;
        CData/*3:0*/ __Vfunc_memory_mask__20__Vfuncout;
        CData/*2:0*/ __Vfunc_memory_mask__20__op;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__21__Vfuncout;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__21__in;
        CData/*2:0*/ __Vfunc_subset_load_data__22__op;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__23__Vfuncout;
        CData/*2:0*/ __Vfunc_cast_to_memory_op__23__in;
        CData/*7:0*/ __Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0;
        CData/*7:0*/ __Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1;
        CData/*7:0*/ __Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2;
        CData/*7:0*/ __Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3;
        CData/*4:0*/ __Vfunc_decode_opcode_q__29__Vfuncout;
        VL_OUT16(__PVT__data_request_tag,15,0);
        VL_IN16(__PVT__data_response_tag,15,0);
        VL_IN(__PVT__reset_pc,31,0);
        VL_OUT(__PVT__instruction_addr,31,0);
        VL_IN(__PVT__instruction_read,31,0);
        VL_OUT(__PVT__data_addr,31,0);
        VL_IN(__PVT__data_read,31,0);
    };
    struct {
        VL_OUT(__PVT__data_write,31,0);
        IData/*31:0*/ __PVT__current_stage;
        IData/*31:0*/ __PVT__pc;
        IData/*31:0*/ __PVT__latched_instruction_read;
        IData/*31:0*/ __PVT__wbd;
        IData/*31:0*/ __PVT__reg_file_rd1;
        IData/*31:0*/ __PVT__reg_file_rd2;
        IData/*31:0*/ __PVT__next_pc_comb;
        IData/*31:0*/ __PVT__exec_result;
        IData/*31:0*/ __PVT__next_pc;
        IData/*31:0*/ __PVT__load_result;
        IData/*31:0*/ instruction_count;
        IData/*31:0*/ __Vfunc_decode_format__0__Vfuncout;
        IData/*31:0*/ __Vfunc_decode_imm__1__Vfuncout;
        IData/*31:0*/ __Vfunc_shuffle_store_mask__15__low_addr;
        IData/*31:0*/ __Vfunc_shuffle_store_data__18__Vfuncout;
        IData/*31:0*/ __Vfunc_shuffle_store_data__18__in;
        IData/*31:0*/ __Vfunc_shuffle_store_data__18__low_addr;
        IData/*31:0*/ __Vfunc_shuffle_store_mask__19__low_addr;
        IData/*31:0*/ __Vfunc_subset_load_data__22__Vfuncout;
        IData/*31:0*/ __Vfunc_subset_load_data__22__in;
        IData/*31:0*/ __Vfunc_shuffle_load_data__24__Vfuncout;
        IData/*31:0*/ __Vfunc_shuffle_load_data__24__in;
        IData/*31:0*/ __Vfunc_shuffle_load_data__24__low_addr;
        QData/*32:0*/ __PVT__exec_result_comb;
        QData/*32:0*/ __Vfunc_execute__4__Vfuncout;
        QData/*32:0*/ __Vfunc_execute__4__unnamedblk4__DOT__selected_rd2;
        QData/*32:0*/ __Vfunc_execute__4__unnamedblk4__DOT__selected_rd1;
        QData/*32:0*/ __Vfunc_execute__4__unnamedblk4__DOT__alu_result;
        QData/*32:0*/ __Vfunc_alu__8__Vfuncout;
        QData/*32:0*/ __Vfunc_alu__8__in1;
        QData/*32:0*/ __Vfunc_alu__8__in2;
        QData/*32:0*/ __Vfunc_alu__8__unnamedblk3__DOT__neg_in2;
        QData/*32:0*/ __Vfunc_alu__8__unnamedblk3__DOT__add_op;
        QData/*32:0*/ __Vfunc_alu__8__unnamedblk3__DOT__pos_in1;
        QData/*32:0*/ __Vfunc_alu__8__unnamedblk3__DOT__pos_in2;
        QData/*32:0*/ __Vfunc_take_branch__14__alu_result;
        VlUnpacked<IData/*31:0*/, 32> __PVT__reg_file;
    };

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop_riscv_multicycle(Vtop__Syms* symsp, const char* v__name);
    ~Vtop_riscv_multicycle();
    VL_UNCOPYABLE(Vtop_riscv_multicycle);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
