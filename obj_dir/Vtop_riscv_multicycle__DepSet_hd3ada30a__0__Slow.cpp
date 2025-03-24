// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop_riscv_multicycle.h"

VL_ATTR_COLD void Vtop_riscv_multicycle___ctor_var_reset(Vtop_riscv_multicycle* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+          Vtop_riscv_multicycle___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->__PVT__clk = VL_RAND_RESET_I(1);
    vlSelf->__PVT__reset = VL_RAND_RESET_I(1);
    vlSelf->__PVT__reset_pc = VL_RAND_RESET_I(32);
    vlSelf->__PVT__instruction_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__instruction_addr = VL_RAND_RESET_I(32);
    vlSelf->__PVT__instruction_read = VL_RAND_RESET_I(32);
    vlSelf->__PVT__instruction_ready = VL_RAND_RESET_I(1);
    vlSelf->__PVT__instruction_response_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__data_read_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__data_write_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__data_addr = VL_RAND_RESET_I(32);
    vlSelf->__PVT__data_read = VL_RAND_RESET_I(32);
    vlSelf->__PVT__data_write = VL_RAND_RESET_I(32);
    vlSelf->__PVT__data_read_byte = VL_RAND_RESET_I(4);
    vlSelf->__PVT__data_write_byte = VL_RAND_RESET_I(4);
    vlSelf->__PVT__data_request_tag = VL_RAND_RESET_I(16);
    vlSelf->__PVT__data_ready = VL_RAND_RESET_I(1);
    vlSelf->__PVT__data_response_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__data_response_tag = VL_RAND_RESET_I(16);
    vlSelf->__PVT__current_stage = 0;
    vlSelf->__PVT__pc = VL_RAND_RESET_I(32);
    vlSelf->__PVT__latched_instruction_read = VL_RAND_RESET_I(32);
    vlSelf->__PVT__rs1 = VL_RAND_RESET_I(5);
    vlSelf->__PVT__rs2 = VL_RAND_RESET_I(5);
    vlSelf->__PVT__wbs = VL_RAND_RESET_I(5);
    vlSelf->__PVT__wbd = VL_RAND_RESET_I(32);
    vlSelf->__PVT__reg_file_rd1 = VL_RAND_RESET_I(32);
    vlSelf->__PVT__reg_file_rd2 = VL_RAND_RESET_I(32);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->__PVT__reg_file[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->__PVT__read_reg_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__write_reg_valid = VL_RAND_RESET_I(1);
    vlSelf->__PVT__memory_stage_complete = VL_RAND_RESET_I(1);
    vlSelf->__PVT__exec_result_comb = VL_RAND_RESET_Q(33);
    vlSelf->__PVT__next_pc_comb = VL_RAND_RESET_I(32);
    vlSelf->__PVT__exec_result = VL_RAND_RESET_I(32);
    vlSelf->__PVT__next_pc = VL_RAND_RESET_I(32);
    vlSelf->__PVT__load_result = VL_RAND_RESET_I(32);
    vlSelf->instruction_count = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_decode_format__0__Vfuncout = 0;
    vlSelf->__Vfunc_decode_imm__1__Vfuncout = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_decode_writeback__2__Vfuncout = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_decode_funct7__3__Vfuncout = VL_RAND_RESET_I(7);
    vlSelf->__Vfunc_execute__4__Vfuncout = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_execute__4__unnamedblk4__DOT__selected_rd2 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_execute__4__unnamedblk4__DOT__selected_rd1 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_execute__4__unnamedblk4__DOT__selected_f3 = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_execute__4__unnamedblk4__DOT__selected_f7 = VL_RAND_RESET_I(7);
    vlSelf->__Vfunc_execute__4__unnamedblk4__DOT__alu_result = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__Vfuncout = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__in1 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__in2 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__f3 = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_alu__8__f7 = VL_RAND_RESET_I(7);
    vlSelf->__Vfunc_alu__8__unnamedblk3__DOT__f3_mod = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_alu__8__unnamedblk3__DOT__neg_in2 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__unnamedblk3__DOT__add_op = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__unnamedblk3__DOT__pos_in1 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_alu__8__unnamedblk3__DOT__pos_in2 = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_cast_to_f3_mod__9__Vfuncout = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_cast_to_f3_mod__9__in = VL_RAND_RESET_I(7);
    vlSelf->__Vfunc_cast_to_ext_m__10__Vfuncout = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_ext_m__10__in = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_ext_m__11__Vfuncout = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_ext_m__11__in = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_take_branch__14__Vfuncout = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_take_branch__14__alu_result = VL_RAND_RESET_Q(33);
    vlSelf->__Vfunc_take_branch__14__f3 = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_take_branch__14__unnamedblk1__DOT__is_zero = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_shuffle_store_mask__15__Vfuncout = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_shuffle_store_mask__15__mask = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_shuffle_store_mask__15__low_addr = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_memory_mask__16__Vfuncout = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_memory_mask__16__op = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__17__Vfuncout = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__17__in = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_shuffle_store_data__18__Vfuncout = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_store_data__18__in = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_store_data__18__low_addr = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_store_mask__19__Vfuncout = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_shuffle_store_mask__19__mask = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_shuffle_store_mask__19__low_addr = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_memory_mask__20__Vfuncout = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_memory_mask__20__op = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__21__Vfuncout = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__21__in = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_subset_load_data__22__Vfuncout = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_subset_load_data__22__in = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_subset_load_data__22__op = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__23__Vfuncout = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_cast_to_memory_op__23__in = VL_RAND_RESET_I(3);
    vlSelf->__Vfunc_shuffle_load_data__24__Vfuncout = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_load_data__24__in = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_load_data__24__low_addr = VL_RAND_RESET_I(32);
    vlSelf->__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3 = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_decode_opcode_q__29__Vfuncout = VL_RAND_RESET_I(5);
}
