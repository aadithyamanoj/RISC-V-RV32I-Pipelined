// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_riscv_multicycle.h"

VL_ATTR_COLD void Vtop_riscv_multicycle___stl_sequent__TOP__top__core__core__0(Vtop_riscv_multicycle* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+          Vtop_riscv_multicycle___stl_sequent__TOP__top__core__core__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __PVT__fetched_instruction;
    __PVT__fetched_instruction = 0;
    IData/*31:0*/ __PVT__rd1;
    __PVT__rd1 = 0;
    IData/*31:0*/ __PVT__rd2;
    __PVT__rd2 = 0;
    CData/*0:0*/ __PVT__wbv;
    __PVT__wbv = 0;
    IData/*31:0*/ __PVT__imm;
    __PVT__imm = 0;
    CData/*2:0*/ __PVT__f3;
    __PVT__f3 = 0;
    CData/*6:0*/ __PVT__f7;
    __PVT__f7 = 0;
    CData/*4:0*/ __PVT__op_q;
    __PVT__op_q = 0;
    IData/*31:0*/ __PVT__format;
    __PVT__format = 0;
    CData/*4:0*/ __VdfgExtracted_h88d4a440__0;
    __VdfgExtracted_h88d4a440__0 = 0;
    CData/*4:0*/ __VdfgExtracted_h4d90c180__0;
    __VdfgExtracted_h4d90c180__0 = 0;
    CData/*4:0*/ __VdfgExtracted_h248d6ee0__0;
    __VdfgExtracted_h248d6ee0__0 = 0;
    CData/*2:0*/ __VdfgExtracted_hd2eeb536__0;
    __VdfgExtracted_hd2eeb536__0 = 0;
    CData/*4:0*/ __VdfgExtracted_hde7d18ad__0;
    __VdfgExtracted_hde7d18ad__0 = 0;
    CData/*4:0*/ __Vfunc_decode_format__0__op_q;
    __Vfunc_decode_format__0__op_q = 0;
    IData/*31:0*/ __Vfunc_decode_imm__1__instr;
    __Vfunc_decode_imm__1__instr = 0;
    IData/*31:0*/ __Vfunc_decode_imm__1__format;
    __Vfunc_decode_imm__1__format = 0;
    CData/*4:0*/ __Vfunc_decode_writeback__2__in;
    __Vfunc_decode_writeback__2__in = 0;
    IData/*31:0*/ __Vfunc_decode_funct7__3__instr;
    __Vfunc_decode_funct7__3__instr = 0;
    IData/*31:0*/ __Vfunc_decode_funct7__3__format;
    __Vfunc_decode_funct7__3__format = 0;
    QData/*32:0*/ __Vfunc_execute__4__rd1;
    __Vfunc_execute__4__rd1 = 0;
    QData/*32:0*/ __Vfunc_execute__4__rd2;
    __Vfunc_execute__4__rd2 = 0;
    QData/*32:0*/ __Vfunc_execute__4__imm;
    __Vfunc_execute__4__imm = 0;
    IData/*31:0*/ __Vfunc_execute__4__pc;
    __Vfunc_execute__4__pc = 0;
    CData/*4:0*/ __Vfunc_execute__4__op_q;
    __Vfunc_execute__4__op_q = 0;
    CData/*2:0*/ __Vfunc_execute__4__f3;
    __Vfunc_execute__4__f3 = 0;
    CData/*6:0*/ __Vfunc_execute__4__f7;
    __Vfunc_execute__4__f7 = 0;
    QData/*32:0*/ __Vfunc_cast_to_ext_operand__5__Vfuncout;
    __Vfunc_cast_to_ext_operand__5__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_cast_to_ext_operand__5__in;
    __Vfunc_cast_to_ext_operand__5__in = 0;
    QData/*32:0*/ __Vfunc_cast_to_ext_operand__6__Vfuncout;
    __Vfunc_cast_to_ext_operand__6__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_cast_to_ext_operand__6__in;
    __Vfunc_cast_to_ext_operand__6__in = 0;
    QData/*32:0*/ __Vfunc_cast_to_ext_operand__7__Vfuncout;
    __Vfunc_cast_to_ext_operand__7__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_cast_to_ext_operand__7__in;
    __Vfunc_cast_to_ext_operand__7__in = 0;
    IData/*31:0*/ __Vfunc_compute_next_pc__12__Vfuncout;
    __Vfunc_compute_next_pc__12__Vfuncout = 0;
    QData/*32:0*/ __Vfunc_compute_next_pc__12__rd1;
    __Vfunc_compute_next_pc__12__rd1 = 0;
    QData/*32:0*/ __Vfunc_compute_next_pc__12__alu_result;
    __Vfunc_compute_next_pc__12__alu_result = 0;
    IData/*31:0*/ __Vfunc_compute_next_pc__12__imm;
    __Vfunc_compute_next_pc__12__imm = 0;
    IData/*31:0*/ __Vfunc_compute_next_pc__12__pc;
    __Vfunc_compute_next_pc__12__pc = 0;
    CData/*4:0*/ __Vfunc_compute_next_pc__12__op_q;
    __Vfunc_compute_next_pc__12__op_q = 0;
    CData/*2:0*/ __Vfunc_compute_next_pc__12__f3;
    __Vfunc_compute_next_pc__12__f3 = 0;
    IData/*31:0*/ __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in1;
    __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in1 = 0;
    IData/*31:0*/ __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2;
    __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2 = 0;
    QData/*32:0*/ __Vfunc_cast_to_ext_operand__13__Vfuncout;
    __Vfunc_cast_to_ext_operand__13__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_cast_to_ext_operand__13__in;
    __Vfunc_cast_to_ext_operand__13__in = 0;
    CData/*4:0*/ __Vfunc_decode_rs1__25__Vfuncout;
    __Vfunc_decode_rs1__25__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_decode_rs1__25__instr;
    __Vfunc_decode_rs1__25__instr = 0;
    CData/*4:0*/ __Vfunc_decode_rs2__26__Vfuncout;
    __Vfunc_decode_rs2__26__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_decode_rs2__26__instr;
    __Vfunc_decode_rs2__26__instr = 0;
    CData/*4:0*/ __Vfunc_decode_rd__27__Vfuncout;
    __Vfunc_decode_rd__27__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_decode_rd__27__instr;
    __Vfunc_decode_rd__27__instr = 0;
    CData/*2:0*/ __Vfunc_decode_funct3__28__Vfuncout;
    __Vfunc_decode_funct3__28__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_decode_funct3__28__instr;
    __Vfunc_decode_funct3__28__instr = 0;
    IData/*31:0*/ __Vfunc_decode_opcode_q__29__instr;
    __Vfunc_decode_opcode_q__29__instr = 0;
    // Body
    vlSelfRef.__PVT__read_reg_valid = 0U;
    if ((1U == vlSelfRef.__PVT__current_stage)) {
        vlSelfRef.__PVT__read_reg_valid = 1U;
    }
    __PVT__fetched_instruction = ((0x80000U & vlSymsp->TOP__top.__PVT__inst_mem_rsp[0U])
                                   ? ((vlSymsp->TOP__top.__PVT__inst_mem_rsp[1U] 
                                       << 0xcU) | (
                                                   vlSymsp->TOP__top.__PVT__inst_mem_rsp[0U] 
                                                   >> 0x14U))
                                   : vlSelfRef.__PVT__latched_instruction_read);
    __Vfunc_decode_rs1__25__instr = __PVT__fetched_instruction;
    __Vfunc_decode_rs1__25__Vfuncout = (0x1fU & (__Vfunc_decode_rs1__25__instr 
                                                 >> 0xfU));
    __VdfgExtracted_h88d4a440__0 = __Vfunc_decode_rs1__25__Vfuncout;
    __Vfunc_decode_rs2__26__instr = __PVT__fetched_instruction;
    __Vfunc_decode_rs2__26__Vfuncout = (0x1fU & (__Vfunc_decode_rs2__26__instr 
                                                 >> 0x14U));
    __VdfgExtracted_h4d90c180__0 = __Vfunc_decode_rs2__26__Vfuncout;
    __Vfunc_decode_rd__27__instr = __PVT__fetched_instruction;
    __Vfunc_decode_rd__27__Vfuncout = (0x1fU & (__Vfunc_decode_rd__27__instr 
                                                >> 7U));
    __VdfgExtracted_h248d6ee0__0 = __Vfunc_decode_rd__27__Vfuncout;
    __Vfunc_decode_funct3__28__instr = __PVT__fetched_instruction;
    __Vfunc_decode_funct3__28__Vfuncout = (7U & (__Vfunc_decode_funct3__28__instr 
                                                 >> 0xcU));
    __VdfgExtracted_hd2eeb536__0 = __Vfunc_decode_funct3__28__Vfuncout;
    __Vfunc_decode_opcode_q__29__instr = __PVT__fetched_instruction;
    {
        if ((0x40U & __Vfunc_decode_opcode_q__29__instr)) {
            if ((0x20U & __Vfunc_decode_opcode_q__29__instr)) {
                if ((0x10U & __Vfunc_decode_opcode_q__29__instr)) {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                    goto __Vlabel1;
                } else if ((8U & __Vfunc_decode_opcode_q__29__instr)) {
                    if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
                        vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0x1bU;
                        goto __Vlabel1;
                    } else {
                        vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                        goto __Vlabel1;
                    }
                } else if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0x19U;
                    goto __Vlabel1;
                } else {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0x18U;
                    goto __Vlabel1;
                }
            } else {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                goto __Vlabel1;
            }
        } else if ((0x20U & __Vfunc_decode_opcode_q__29__instr)) {
            if ((0x10U & __Vfunc_decode_opcode_q__29__instr)) {
                if ((8U & __Vfunc_decode_opcode_q__29__instr)) {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                    goto __Vlabel1;
                } else if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0xdU;
                    goto __Vlabel1;
                } else {
                    vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0xcU;
                    goto __Vlabel1;
                }
            } else if ((8U & __Vfunc_decode_opcode_q__29__instr)) {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                goto __Vlabel1;
            } else if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                goto __Vlabel1;
            } else {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 8U;
                goto __Vlabel1;
            }
        } else if ((0x10U & __Vfunc_decode_opcode_q__29__instr)) {
            if ((8U & __Vfunc_decode_opcode_q__29__instr)) {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
                goto __Vlabel1;
            } else if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 5U;
                goto __Vlabel1;
            } else {
                vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 4U;
                goto __Vlabel1;
            }
        } else if ((8U & __Vfunc_decode_opcode_q__29__instr)) {
            vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
            goto __Vlabel1;
        } else if ((4U & __Vfunc_decode_opcode_q__29__instr)) {
            vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 7U;
            goto __Vlabel1;
        } else {
            vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout = 0U;
            goto __Vlabel1;
        }
        __Vlabel1: ;
    }
    __VdfgExtracted_hde7d18ad__0 = vlSelfRef.__Vfunc_decode_opcode_q__29__Vfuncout;
    vlSelfRef.__PVT__rs1 = __VdfgExtracted_h88d4a440__0;
    vlSelfRef.__PVT__rs2 = __VdfgExtracted_h4d90c180__0;
    vlSelfRef.__PVT__wbs = __VdfgExtracted_h248d6ee0__0;
    __PVT__f3 = __VdfgExtracted_hd2eeb536__0;
    __PVT__op_q = __VdfgExtracted_hde7d18ad__0;
    __Vfunc_decode_format__0__op_q = __PVT__op_q;
    {
        if ((0x10U & (IData)(__Vfunc_decode_format__0__op_q))) {
            if ((8U & (IData)(__Vfunc_decode_format__0__op_q))) {
                if ((4U & (IData)(__Vfunc_decode_format__0__op_q))) {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                    goto __Vlabel2;
                } else if ((2U & (IData)(__Vfunc_decode_format__0__op_q))) {
                    if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
                        vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 5U;
                        goto __Vlabel2;
                    } else {
                        vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                        goto __Vlabel2;
                    }
                } else if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 1U;
                    goto __Vlabel2;
                } else {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 4U;
                    goto __Vlabel2;
                }
            } else {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                goto __Vlabel2;
            }
        } else if ((8U & (IData)(__Vfunc_decode_format__0__op_q))) {
            if ((4U & (IData)(__Vfunc_decode_format__0__op_q))) {
                if ((2U & (IData)(__Vfunc_decode_format__0__op_q))) {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                    goto __Vlabel2;
                } else if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 3U;
                    goto __Vlabel2;
                } else {
                    vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                    goto __Vlabel2;
                }
            } else if ((2U & (IData)(__Vfunc_decode_format__0__op_q))) {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                goto __Vlabel2;
            } else if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                goto __Vlabel2;
            } else {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 2U;
                goto __Vlabel2;
            }
        } else if ((4U & (IData)(__Vfunc_decode_format__0__op_q))) {
            if ((2U & (IData)(__Vfunc_decode_format__0__op_q))) {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
                goto __Vlabel2;
            } else if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 3U;
                goto __Vlabel2;
            } else {
                vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 1U;
                goto __Vlabel2;
            }
        } else if ((2U & (IData)(__Vfunc_decode_format__0__op_q))) {
            vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
            goto __Vlabel2;
        } else if ((1U & (IData)(__Vfunc_decode_format__0__op_q))) {
            vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 0U;
            goto __Vlabel2;
        } else {
            vlSelfRef.__Vfunc_decode_format__0__Vfuncout = 1U;
            goto __Vlabel2;
        }
        __Vlabel2: ;
    }
    __PVT__format = vlSelfRef.__Vfunc_decode_format__0__Vfuncout;
    __Vfunc_decode_imm__1__format = __PVT__format;
    __Vfunc_decode_imm__1__instr = __PVT__fetched_instruction;
    {
        if ((1U == __Vfunc_decode_imm__1__format)) {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout 
                = (((- (IData)((__Vfunc_decode_imm__1__instr 
                                >> 0x1fU))) << 0xbU) 
                   | (0x7ffU & (__Vfunc_decode_imm__1__instr 
                                >> 0x14U)));
            goto __Vlabel3;
        } else if ((2U == __Vfunc_decode_imm__1__format)) {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout 
                = (((- (IData)((__Vfunc_decode_imm__1__instr 
                                >> 0x1fU))) << 0xbU) 
                   | ((0x7e0U & (__Vfunc_decode_imm__1__instr 
                                 >> 0x14U)) | (0x1fU 
                                               & (__Vfunc_decode_imm__1__instr 
                                                  >> 7U))));
            goto __Vlabel3;
        } else if ((4U == __Vfunc_decode_imm__1__format)) {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout 
                = (((- (IData)((__Vfunc_decode_imm__1__instr 
                                >> 0x1fU))) << 0xcU) 
                   | ((0x800U & (__Vfunc_decode_imm__1__instr 
                                 << 4U)) | ((0x7e0U 
                                             & (__Vfunc_decode_imm__1__instr 
                                                >> 0x14U)) 
                                            | (0x1eU 
                                               & (__Vfunc_decode_imm__1__instr 
                                                  >> 7U)))));
            goto __Vlabel3;
        } else if ((3U == __Vfunc_decode_imm__1__format)) {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout 
                = (0xfffff000U & __Vfunc_decode_imm__1__instr);
            goto __Vlabel3;
        } else if ((5U == __Vfunc_decode_imm__1__format)) {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout 
                = (((- (IData)((__Vfunc_decode_imm__1__instr 
                                >> 0x1fU))) << 0x14U) 
                   | (((0xff000U & __Vfunc_decode_imm__1__instr) 
                       | (0x800U & (__Vfunc_decode_imm__1__instr 
                                    >> 9U))) | ((0x7e0U 
                                                 & (__Vfunc_decode_imm__1__instr 
                                                    >> 0x14U)) 
                                                | (0x1eU 
                                                   & (__Vfunc_decode_imm__1__instr 
                                                      >> 0x14U)))));
            goto __Vlabel3;
        } else {
            vlSelfRef.__Vfunc_decode_imm__1__Vfuncout = 0U;
            goto __Vlabel3;
        }
        __Vlabel3: ;
    }
    __PVT__imm = vlSelfRef.__Vfunc_decode_imm__1__Vfuncout;
    __Vfunc_decode_writeback__2__in = __PVT__op_q;
    {
        if ((0x10U & (IData)(__Vfunc_decode_writeback__2__in))) {
            if ((8U & (IData)(__Vfunc_decode_writeback__2__in))) {
                if ((4U & (IData)(__Vfunc_decode_writeback__2__in))) {
                    vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                    goto __Vlabel4;
                } else if ((1U & (IData)(__Vfunc_decode_writeback__2__in))) {
                    vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 1U;
                    goto __Vlabel4;
                } else {
                    vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                    goto __Vlabel4;
                }
            } else {
                vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                goto __Vlabel4;
            }
        } else if ((8U & (IData)(__Vfunc_decode_writeback__2__in))) {
            if ((4U & (IData)(__Vfunc_decode_writeback__2__in))) {
                if ((2U & (IData)(__Vfunc_decode_writeback__2__in))) {
                    vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                    goto __Vlabel4;
                } else {
                    vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 1U;
                    goto __Vlabel4;
                }
            } else {
                vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                goto __Vlabel4;
            }
        } else if ((4U & (IData)(__Vfunc_decode_writeback__2__in))) {
            if ((2U & (IData)(__Vfunc_decode_writeback__2__in))) {
                vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
                goto __Vlabel4;
            } else {
                vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 1U;
                goto __Vlabel4;
            }
        } else if ((2U & (IData)(__Vfunc_decode_writeback__2__in))) {
            vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
            goto __Vlabel4;
        } else if ((1U & (IData)(__Vfunc_decode_writeback__2__in))) {
            vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 0U;
            goto __Vlabel4;
        } else {
            vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout = 1U;
            goto __Vlabel4;
        }
        __Vlabel4: ;
    }
    __PVT__wbv = vlSelfRef.__Vfunc_decode_writeback__2__Vfuncout;
    __Vfunc_decode_funct7__3__format = __PVT__format;
    __Vfunc_decode_funct7__3__instr = __PVT__fetched_instruction;
    {
        if ((0U == __Vfunc_decode_funct7__3__format)) {
            vlSelfRef.__Vfunc_decode_funct7__3__Vfuncout 
                = (__Vfunc_decode_funct7__3__instr 
                   >> 0x19U);
            goto __Vlabel5;
        }
        vlSelfRef.__Vfunc_decode_funct7__3__Vfuncout = 0U;
        __Vlabel5: ;
    }
    __PVT__f7 = vlSelfRef.__Vfunc_decode_funct7__3__Vfuncout;
    __PVT__rd1 = ((0U == (IData)(vlSelfRef.__PVT__rs1))
                   ? 0U : vlSelfRef.__PVT__reg_file_rd1);
    __PVT__rd2 = ((0U == (IData)(vlSelfRef.__PVT__rs2))
                   ? 0U : vlSelfRef.__PVT__reg_file_rd2);
    vlSelfRef.__PVT__memory_stage_complete = (1U & 
                                              ((~ (
                                                   (0U 
                                                    == (IData)(__PVT__op_q)) 
                                                   | (8U 
                                                      == (IData)(__PVT__op_q)))) 
                                               | (vlSymsp->TOP__top.__PVT__data_mem_rsp[0U] 
                                                  >> 0x13U)));
    vlSelfRef.__PVT__wbd = ((0U == (IData)(__PVT__op_q))
                             ? ([&]() {
                vlSelfRef.__Vfunc_cast_to_memory_op__23__in 
                    = __PVT__f3;
                {
                    if ((4U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                        if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                            vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 0U;
                            goto __Vlabel6;
                        } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                            vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 5U;
                            goto __Vlabel6;
                        } else {
                            vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 4U;
                            goto __Vlabel6;
                        }
                    } else if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                        if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                            vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 0U;
                            goto __Vlabel6;
                        } else {
                            vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 2U;
                            goto __Vlabel6;
                        }
                    } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__23__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 1U;
                        goto __Vlabel6;
                    } else {
                        vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout = 0U;
                        goto __Vlabel6;
                    }
                    __Vlabel6: ;
                }
                vlSelfRef.__Vfunc_subset_load_data__22__op 
                    = vlSelfRef.__Vfunc_cast_to_memory_op__23__Vfuncout;
                vlSelfRef.__Vfunc_shuffle_load_data__24__low_addr 
                    = vlSelfRef.__PVT__exec_result;
                vlSelfRef.__Vfunc_shuffle_load_data__24__in 
                    = ((0x80000U & vlSymsp->TOP__top.__PVT__data_mem_rsp[0U])
                        ? ((vlSymsp->TOP__top.__PVT__data_mem_rsp[1U] 
                            << 0xcU) | (vlSymsp->TOP__top.__PVT__data_mem_rsp[0U] 
                                        >> 0x14U)) : vlSelfRef.__PVT__load_result);
                {
                    vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0 
                        = (0xffU & vlSelfRef.__Vfunc_shuffle_load_data__24__in);
                    vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1 
                        = (0xffU & (vlSelfRef.__Vfunc_shuffle_load_data__24__in 
                                    >> 8U));
                    vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2 
                        = (0xffU & (vlSelfRef.__Vfunc_shuffle_load_data__24__in 
                                    >> 0x10U));
                    vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3 
                        = (vlSelfRef.__Vfunc_shuffle_load_data__24__in 
                           >> 0x18U);
                    if ((2U & vlSelfRef.__Vfunc_shuffle_load_data__24__low_addr)) {
                        if ((1U & vlSelfRef.__Vfunc_shuffle_load_data__24__low_addr)) {
                            vlSelfRef.__Vfunc_shuffle_load_data__24__Vfuncout 
                                = ((((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2) 
                                     << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1) 
                                                  << 0x10U)) 
                                   | (((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0) 
                                       << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3)));
                            goto __Vlabel7;
                        } else {
                            vlSelfRef.__Vfunc_shuffle_load_data__24__Vfuncout 
                                = ((((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1) 
                                     << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0) 
                                                  << 0x10U)) 
                                   | (((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3) 
                                       << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2)));
                            goto __Vlabel7;
                        }
                    } else if ((1U & vlSelfRef.__Vfunc_shuffle_load_data__24__low_addr)) {
                        vlSelfRef.__Vfunc_shuffle_load_data__24__Vfuncout 
                            = ((((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0) 
                                 << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3) 
                                              << 0x10U)) 
                               | (((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2) 
                                   << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1)));
                        goto __Vlabel7;
                    } else {
                        vlSelfRef.__Vfunc_shuffle_load_data__24__Vfuncout 
                            = ((((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b3) 
                                 << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b2) 
                                              << 0x10U)) 
                               | (((IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b1) 
                                   << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_load_data__24__unnamedblk5__DOT__b0)));
                        goto __Vlabel7;
                    }
                    __Vlabel7: ;
                }
                vlSelfRef.__Vfunc_subset_load_data__22__in 
                    = vlSelfRef.__Vfunc_shuffle_load_data__24__Vfuncout;
                {
                    if ((4U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                        if ((2U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                            vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                                = vlSelfRef.__Vfunc_subset_load_data__22__in;
                            goto __Vlabel8;
                        } else if ((1U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                            vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                                = (0xffffU & vlSelfRef.__Vfunc_subset_load_data__22__in);
                            goto __Vlabel8;
                        } else {
                            vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                                = (0xffU & vlSelfRef.__Vfunc_subset_load_data__22__in);
                            goto __Vlabel8;
                        }
                    } else if ((2U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                        if ((1U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                            vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                                = vlSelfRef.__Vfunc_subset_load_data__22__in;
                            goto __Vlabel8;
                        } else {
                            vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                                = vlSelfRef.__Vfunc_subset_load_data__22__in;
                            goto __Vlabel8;
                        }
                    } else if ((1U & (IData)(vlSelfRef.__Vfunc_subset_load_data__22__op))) {
                        vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                            = (((- (IData)((1U & (vlSelfRef.__Vfunc_subset_load_data__22__in 
                                                  >> 0xfU)))) 
                                << 0x10U) | (0xffffU 
                                             & vlSelfRef.__Vfunc_subset_load_data__22__in));
                        goto __Vlabel8;
                    } else {
                        vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout 
                            = (((- (IData)((1U & (vlSelfRef.__Vfunc_subset_load_data__22__in 
                                                  >> 7U)))) 
                                << 8U) | (0xffU & vlSelfRef.__Vfunc_subset_load_data__22__in));
                        goto __Vlabel8;
                    }
                    __Vlabel8: ;
                }
            }(), vlSelfRef.__Vfunc_subset_load_data__22__Vfuncout)
                             : vlSelfRef.__PVT__exec_result);
    __Vfunc_execute__4__f7 = __PVT__f7;
    __Vfunc_execute__4__f3 = __PVT__f3;
    __Vfunc_execute__4__op_q = __PVT__op_q;
    __Vfunc_execute__4__pc = vlSelfRef.__PVT__pc;
    __Vfunc_cast_to_ext_operand__5__in = __PVT__imm;
    __Vfunc_cast_to_ext_operand__5__Vfuncout = (((QData)((IData)(
                                                                 (__Vfunc_cast_to_ext_operand__5__in 
                                                                  >> 0x1fU))) 
                                                 << 0x20U) 
                                                | (QData)((IData)(__Vfunc_cast_to_ext_operand__5__in)));
    __Vfunc_execute__4__imm = __Vfunc_cast_to_ext_operand__5__Vfuncout;
    __Vfunc_cast_to_ext_operand__6__in = __PVT__rd2;
    __Vfunc_cast_to_ext_operand__6__Vfuncout = (((QData)((IData)(
                                                                 (__Vfunc_cast_to_ext_operand__6__in 
                                                                  >> 0x1fU))) 
                                                 << 0x20U) 
                                                | (QData)((IData)(__Vfunc_cast_to_ext_operand__6__in)));
    __Vfunc_execute__4__rd2 = __Vfunc_cast_to_ext_operand__6__Vfuncout;
    __Vfunc_cast_to_ext_operand__7__in = __PVT__rd1;
    __Vfunc_cast_to_ext_operand__7__Vfuncout = (((QData)((IData)(
                                                                 (__Vfunc_cast_to_ext_operand__7__in 
                                                                  >> 0x1fU))) 
                                                 << 0x20U) 
                                                | (QData)((IData)(__Vfunc_cast_to_ext_operand__7__in)));
    __Vfunc_execute__4__rd1 = __Vfunc_cast_to_ext_operand__7__Vfuncout;
    {
        vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd2 
            = (((0xcU == (IData)(__Vfunc_execute__4__op_q)) 
                | (0x18U == (IData)(__Vfunc_execute__4__op_q)))
                ? __Vfunc_execute__4__rd2 : __Vfunc_execute__4__imm);
        vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd1 
            = ((5U == (IData)(__Vfunc_execute__4__op_q))
                ? (QData)((IData)(__Vfunc_execute__4__pc))
                : __Vfunc_execute__4__rd1);
        vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_f3 
            = (((((5U == (IData)(__Vfunc_execute__4__op_q)) 
                  | (0U == (IData)(__Vfunc_execute__4__op_q))) 
                 | (8U == (IData)(__Vfunc_execute__4__op_q))) 
                | (0x18U == (IData)(__Vfunc_execute__4__op_q)))
                ? 0U : (IData)(__Vfunc_execute__4__f3));
        vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_f7 
            = ((((5U == (IData)(__Vfunc_execute__4__op_q)) 
                 | (0U == (IData)(__Vfunc_execute__4__op_q))) 
                | (8U == (IData)(__Vfunc_execute__4__op_q)))
                ? 0U : ((0x18U == (IData)(__Vfunc_execute__4__op_q))
                         ? 0x20U : (IData)(__Vfunc_execute__4__f7)));
        if ((0x18U == (IData)(__Vfunc_execute__4__op_q))) {
            vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd1 
                = (0xffffffffULL & vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd1);
            vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd2 
                = (0xffffffffULL & vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd2);
        }
        vlSelfRef.__Vfunc_alu__8__f7 = vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_f7;
        vlSelfRef.__Vfunc_alu__8__f3 = vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_f3;
        vlSelfRef.__Vfunc_alu__8__in2 = vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd2;
        vlSelfRef.__Vfunc_alu__8__in1 = vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__selected_rd1;
        {
            vlSelfRef.__Vfunc_cast_to_f3_mod__9__in 
                = vlSelfRef.__Vfunc_alu__8__f7;
            vlSelfRef.__Vfunc_cast_to_f3_mod__9__Vfuncout 
                = (1U & ((IData)(vlSelfRef.__Vfunc_cast_to_f3_mod__9__in) 
                         >> 5U));
            vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__f3_mod 
                = vlSelfRef.__Vfunc_cast_to_f3_mod__9__Vfuncout;
            vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__neg_in2 
                = (0x1ffffffffULL & (1ULL + (~ vlSelfRef.__Vfunc_alu__8__in2)));
            vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__add_op 
                = ((IData)(vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__f3_mod)
                    ? vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__neg_in2
                    : vlSelfRef.__Vfunc_alu__8__in2);
            vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__pos_in1 
                = (QData)((IData)(vlSelfRef.__Vfunc_alu__8__in1));
            vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__pos_in2 
                = (QData)((IData)(vlSelfRef.__Vfunc_alu__8__in2));
            if (((0U == (IData)(vlSelfRef.__Vfunc_alu__8__f7)) 
                 | (0x20U == (IData)(vlSelfRef.__Vfunc_alu__8__f7)))) {
                if ((4U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                    if ((2U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                        if ((1U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                            vlSelfRef.__Vfunc_alu__8__Vfuncout 
                                = (vlSelfRef.__Vfunc_alu__8__in1 
                                   & vlSelfRef.__Vfunc_alu__8__in2);
                            goto __Vlabel10;
                        } else {
                            vlSelfRef.__Vfunc_alu__8__Vfuncout 
                                = (vlSelfRef.__Vfunc_alu__8__in1 
                                   | vlSelfRef.__Vfunc_alu__8__in2);
                            goto __Vlabel10;
                        }
                    } else if ((1U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout 
                            = (0x1ffffffffULL & ((IData)(vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__f3_mod)
                                                  ? 
                                                 VL_SHIFTRS_QQI(33,33,5, vlSelfRef.__Vfunc_alu__8__in1, 
                                                                (0x1fU 
                                                                 & (IData)(vlSelfRef.__Vfunc_alu__8__in2)))
                                                  : 
                                                 (vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__pos_in1 
                                                  >> 
                                                  (0x1fU 
                                                   & (IData)(vlSelfRef.__Vfunc_alu__8__in2)))));
                        goto __Vlabel10;
                    } else {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout 
                            = (vlSelfRef.__Vfunc_alu__8__in1 
                               ^ vlSelfRef.__Vfunc_alu__8__in2);
                        goto __Vlabel10;
                    }
                } else if ((2U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                    if ((1U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout 
                            = (VL_LTS_IQQ(33, vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__pos_in1, vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__pos_in2)
                                ? 1ULL : 0ULL);
                        goto __Vlabel10;
                    } else {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout 
                            = (VL_LTS_IQQ(33, vlSelfRef.__Vfunc_alu__8__in1, vlSelfRef.__Vfunc_alu__8__in2)
                                ? 1ULL : 0ULL);
                        goto __Vlabel10;
                    }
                } else if ((1U & (IData)(vlSelfRef.__Vfunc_alu__8__f3))) {
                    vlSelfRef.__Vfunc_alu__8__Vfuncout 
                        = (0x1ffffffffULL & (vlSelfRef.__Vfunc_alu__8__in1 
                                             << (0x1fU 
                                                 & (IData)(vlSelfRef.__Vfunc_alu__8__in2))));
                    goto __Vlabel10;
                } else {
                    vlSelfRef.__Vfunc_alu__8__Vfuncout 
                        = (0x1ffffffffULL & (vlSelfRef.__Vfunc_alu__8__in1 
                                             + vlSelfRef.__Vfunc_alu__8__unnamedblk3__DOT__add_op));
                    goto __Vlabel10;
                }
            } else if ((1U == (IData)(vlSelfRef.__Vfunc_alu__8__f7))) {
                if ((1U | (0U == ([&]() {
                                    vlSelfRef.__Vfunc_cast_to_ext_m__10__in 
                                        = vlSelfRef.__Vfunc_alu__8__f3;
                                    vlSelfRef.__Vfunc_cast_to_ext_m__10__Vfuncout 
                                        = vlSelfRef.__Vfunc_cast_to_ext_m__10__in;
                                }(), (IData)(vlSelfRef.__Vfunc_cast_to_ext_m__10__Vfuncout))))) {
                    if ((0U == ([&]() {
                                    vlSelfRef.__Vfunc_cast_to_ext_m__11__in 
                                        = vlSelfRef.__Vfunc_alu__8__f3;
                                    vlSelfRef.__Vfunc_cast_to_ext_m__11__Vfuncout 
                                        = vlSelfRef.__Vfunc_cast_to_ext_m__11__in;
                                }(), (IData)(vlSelfRef.__Vfunc_cast_to_ext_m__11__Vfuncout)))) {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout 
                            = (0x1ffffffffULL & VL_MULS_QQQ(33, vlSelfRef.__Vfunc_alu__8__in1, vlSelfRef.__Vfunc_alu__8__in2));
                        goto __Vlabel10;
                    } else {
                        vlSelfRef.__Vfunc_alu__8__Vfuncout = 0ULL;
                        goto __Vlabel10;
                    }
                }
            } else {
                vlSelfRef.__Vfunc_alu__8__Vfuncout = 0ULL;
                goto __Vlabel10;
            }
            __Vlabel10: ;
        }
        vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__alu_result 
            = vlSelfRef.__Vfunc_alu__8__Vfuncout;
        if (((0x19U == (IData)(__Vfunc_execute__4__op_q)) 
             | (0x1bU == (IData)(__Vfunc_execute__4__op_q)))) {
            vlSelfRef.__Vfunc_execute__4__Vfuncout 
                = (QData)((IData)(((IData)(4U) + __Vfunc_execute__4__pc)));
            goto __Vlabel9;
        } else if ((0xdU == (IData)(__Vfunc_execute__4__op_q))) {
            vlSelfRef.__Vfunc_execute__4__Vfuncout 
                = (QData)((IData)(__Vfunc_execute__4__imm));
            goto __Vlabel9;
        } else {
            vlSelfRef.__Vfunc_execute__4__Vfuncout 
                = vlSelfRef.__Vfunc_execute__4__unnamedblk4__DOT__alu_result;
            goto __Vlabel9;
        }
        __Vlabel9: ;
    }
    vlSelfRef.__PVT__exec_result_comb = vlSelfRef.__Vfunc_execute__4__Vfuncout;
    __Vfunc_compute_next_pc__12__f3 = __PVT__f3;
    __Vfunc_compute_next_pc__12__op_q = __PVT__op_q;
    __Vfunc_compute_next_pc__12__pc = vlSelfRef.__PVT__pc;
    __Vfunc_compute_next_pc__12__imm = __PVT__imm;
    __Vfunc_compute_next_pc__12__alu_result = vlSelfRef.__PVT__exec_result_comb;
    __Vfunc_cast_to_ext_operand__13__in = __PVT__rd1;
    __Vfunc_cast_to_ext_operand__13__Vfuncout = (((QData)((IData)(
                                                                  (__Vfunc_cast_to_ext_operand__13__in 
                                                                   >> 0x1fU))) 
                                                  << 0x20U) 
                                                 | (QData)((IData)(__Vfunc_cast_to_ext_operand__13__in)));
    __Vfunc_compute_next_pc__12__rd1 = __Vfunc_cast_to_ext_operand__13__Vfuncout;
    __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in1 
        = __Vfunc_compute_next_pc__12__pc;
    __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2 = 4U;
    if ((0x1bU == (IData)(__Vfunc_compute_next_pc__12__op_q))) {
        __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2 
            = __Vfunc_compute_next_pc__12__imm;
    } else if ((0x19U == (IData)(__Vfunc_compute_next_pc__12__op_q))) {
        __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in1 
            = (IData)(__Vfunc_compute_next_pc__12__rd1);
        __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2 
            = __Vfunc_compute_next_pc__12__imm;
    } else if ((0x18U == (IData)(__Vfunc_compute_next_pc__12__op_q))) {
        if (([&]() {
                    vlSelfRef.__Vfunc_take_branch__14__f3 
                        = __Vfunc_compute_next_pc__12__f3;
                    vlSelfRef.__Vfunc_take_branch__14__alu_result 
                        = __Vfunc_compute_next_pc__12__alu_result;
                    {
                        vlSelfRef.__Vfunc_take_branch__14__unnamedblk1__DOT__is_zero 
                            = (0U == (IData)(vlSelfRef.__Vfunc_take_branch__14__alu_result));
                        if ((4U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                            if ((2U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                                if ((1U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                                    vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                        = (1U & (~ (IData)(
                                                           (vlSelfRef.__Vfunc_take_branch__14__alu_result 
                                                            >> 0x20U))));
                                    goto __Vlabel11;
                                } else {
                                    vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                        = (1U & (IData)(
                                                        (vlSelfRef.__Vfunc_take_branch__14__alu_result 
                                                         >> 0x20U)));
                                    goto __Vlabel11;
                                }
                            } else if ((1U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                                vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                    = (1U & (~ (IData)(
                                                       (vlSelfRef.__Vfunc_take_branch__14__alu_result 
                                                        >> 0x1fU))));
                                goto __Vlabel11;
                            } else {
                                vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                    = (1U & (IData)(
                                                    (vlSelfRef.__Vfunc_take_branch__14__alu_result 
                                                     >> 0x1fU)));
                                goto __Vlabel11;
                            }
                        } else if ((2U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                            vlSelfRef.__Vfunc_take_branch__14__Vfuncout = 0U;
                            goto __Vlabel11;
                        } else if ((1U & (IData)(vlSelfRef.__Vfunc_take_branch__14__f3))) {
                            vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                = (1U & (~ (IData)(vlSelfRef.__Vfunc_take_branch__14__unnamedblk1__DOT__is_zero)));
                            goto __Vlabel11;
                        } else {
                            vlSelfRef.__Vfunc_take_branch__14__Vfuncout 
                                = vlSelfRef.__Vfunc_take_branch__14__unnamedblk1__DOT__is_zero;
                            goto __Vlabel11;
                        }
                        __Vlabel11: ;
                    }
                }(), (IData)(vlSelfRef.__Vfunc_take_branch__14__Vfuncout))) {
            __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2 
                = __Vfunc_compute_next_pc__12__imm;
        }
    }
    __Vfunc_compute_next_pc__12__Vfuncout = (__Vfunc_compute_next_pc__12__unnamedblk2__DOT__in1 
                                             + __Vfunc_compute_next_pc__12__unnamedblk2__DOT__in2);
    vlSelfRef.__PVT__next_pc_comb = __Vfunc_compute_next_pc__12__Vfuncout;
    vlSelfRef.__PVT__data_write_valid = 0U;
    vlSelfRef.__PVT__data_read_valid = 0U;
    vlSelfRef.__PVT__data_read_byte = 0U;
    vlSelfRef.__PVT__data_write_byte = 0U;
    vlSelfRef.__PVT__data_write = 0U;
    if ((((vlSymsp->TOP__top.__PVT__data_mem_rsp[0U] 
           >> 0x12U) & (3U == vlSelfRef.__PVT__current_stage)) 
         & ((8U == (IData)(__PVT__op_q)) | (0U == (IData)(__PVT__op_q))))) {
        vlSelfRef.__PVT__data_addr = vlSelfRef.__PVT__exec_result;
        if ((8U == (IData)(__PVT__op_q))) {
            vlSelfRef.__PVT__data_write_valid = 1U;
            vlSelfRef.__Vfunc_shuffle_store_mask__15__low_addr 
                = vlSelfRef.__PVT__exec_result;
            vlSelfRef.__Vfunc_cast_to_memory_op__17__in 
                = __PVT__f3;
            {
                if ((4U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                    if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 0U;
                        goto __Vlabel12;
                    } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 5U;
                        goto __Vlabel12;
                    } else {
                        vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 4U;
                        goto __Vlabel12;
                    }
                } else if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                    if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 0U;
                        goto __Vlabel12;
                    } else {
                        vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 2U;
                        goto __Vlabel12;
                    }
                } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__17__in))) {
                    vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 1U;
                    goto __Vlabel12;
                } else {
                    vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout = 0U;
                    goto __Vlabel12;
                }
                __Vlabel12: ;
            }
            vlSelfRef.__Vfunc_memory_mask__16__op = vlSelfRef.__Vfunc_cast_to_memory_op__17__Vfuncout;
            {
                if ((2U & (IData)(vlSelfRef.__Vfunc_memory_mask__16__op))) {
                    vlSelfRef.__Vfunc_memory_mask__16__Vfuncout = 0xfU;
                    goto __Vlabel13;
                } else if ((1U & (IData)(vlSelfRef.__Vfunc_memory_mask__16__op))) {
                    vlSelfRef.__Vfunc_memory_mask__16__Vfuncout = 3U;
                    goto __Vlabel13;
                } else {
                    vlSelfRef.__Vfunc_memory_mask__16__Vfuncout = 1U;
                    goto __Vlabel13;
                }
                __Vlabel13: ;
            }
            vlSelfRef.__Vfunc_shuffle_store_mask__15__mask 
                = vlSelfRef.__Vfunc_memory_mask__16__Vfuncout;
            {
                if ((2U & vlSelfRef.__Vfunc_shuffle_store_mask__15__low_addr)) {
                    if ((1U & vlSelfRef.__Vfunc_shuffle_store_mask__15__low_addr)) {
                        vlSelfRef.__Vfunc_shuffle_store_mask__15__Vfuncout 
                            = ((8U & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                      << 3U)) | (7U 
                                                 & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                                    >> 1U)));
                        goto __Vlabel14;
                    } else {
                        vlSelfRef.__Vfunc_shuffle_store_mask__15__Vfuncout 
                            = ((0xcU & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                        << 2U)) | (3U 
                                                   & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                                      >> 2U)));
                        goto __Vlabel14;
                    }
                } else if ((1U & vlSelfRef.__Vfunc_shuffle_store_mask__15__low_addr)) {
                    vlSelfRef.__Vfunc_shuffle_store_mask__15__Vfuncout 
                        = ((0xeU & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                    << 1U)) | (1U & 
                                               ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__15__mask) 
                                                >> 3U)));
                    goto __Vlabel14;
                } else {
                    vlSelfRef.__Vfunc_shuffle_store_mask__15__Vfuncout 
                        = vlSelfRef.__Vfunc_shuffle_store_mask__15__mask;
                    goto __Vlabel14;
                }
                __Vlabel14: ;
            }
            vlSelfRef.__PVT__data_write_byte = vlSelfRef.__Vfunc_shuffle_store_mask__15__Vfuncout;
            vlSelfRef.__Vfunc_shuffle_store_data__18__low_addr 
                = vlSelfRef.__PVT__exec_result;
            vlSelfRef.__Vfunc_shuffle_store_data__18__in 
                = __PVT__rd2;
            {
                vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0 
                    = (0xffU & vlSelfRef.__Vfunc_shuffle_store_data__18__in);
                vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1 
                    = (0xffU & (vlSelfRef.__Vfunc_shuffle_store_data__18__in 
                                >> 8U));
                vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2 
                    = (0xffU & (vlSelfRef.__Vfunc_shuffle_store_data__18__in 
                                >> 0x10U));
                vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3 
                    = (vlSelfRef.__Vfunc_shuffle_store_data__18__in 
                       >> 0x18U);
                if ((2U & vlSelfRef.__Vfunc_shuffle_store_data__18__low_addr)) {
                    if ((1U & vlSelfRef.__Vfunc_shuffle_store_data__18__low_addr)) {
                        vlSelfRef.__Vfunc_shuffle_store_data__18__Vfuncout 
                            = ((((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0) 
                                 << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3) 
                                              << 0x10U)) 
                               | (((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2) 
                                   << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1)));
                        goto __Vlabel15;
                    } else {
                        vlSelfRef.__Vfunc_shuffle_store_data__18__Vfuncout 
                            = ((((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1) 
                                 << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0) 
                                              << 0x10U)) 
                               | (((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3) 
                                   << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2)));
                        goto __Vlabel15;
                    }
                } else if ((1U & vlSelfRef.__Vfunc_shuffle_store_data__18__low_addr)) {
                    vlSelfRef.__Vfunc_shuffle_store_data__18__Vfuncout 
                        = ((((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2) 
                             << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1) 
                                          << 0x10U)) 
                           | (((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0) 
                               << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3)));
                    goto __Vlabel15;
                } else {
                    vlSelfRef.__Vfunc_shuffle_store_data__18__Vfuncout 
                        = ((((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b3) 
                             << 0x18U) | ((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b2) 
                                          << 0x10U)) 
                           | (((IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b1) 
                               << 8U) | (IData)(vlSelfRef.__Vfunc_shuffle_store_data__18__unnamedblk6__DOT__b0)));
                    goto __Vlabel15;
                }
                __Vlabel15: ;
            }
            vlSelfRef.__PVT__data_write = vlSelfRef.__Vfunc_shuffle_store_data__18__Vfuncout;
        } else if ((0U == (IData)(__PVT__op_q))) {
            vlSelfRef.__PVT__data_read_valid = 1U;
            vlSelfRef.__Vfunc_shuffle_store_mask__19__low_addr 
                = vlSelfRef.__PVT__exec_result;
            vlSelfRef.__Vfunc_cast_to_memory_op__21__in 
                = __PVT__f3;
            {
                if ((4U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                    if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 0U;
                        goto __Vlabel16;
                    } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 5U;
                        goto __Vlabel16;
                    } else {
                        vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 4U;
                        goto __Vlabel16;
                    }
                } else if ((2U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                    if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                        vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 0U;
                        goto __Vlabel16;
                    } else {
                        vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 2U;
                        goto __Vlabel16;
                    }
                } else if ((1U & (IData)(vlSelfRef.__Vfunc_cast_to_memory_op__21__in))) {
                    vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 1U;
                    goto __Vlabel16;
                } else {
                    vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout = 0U;
                    goto __Vlabel16;
                }
                __Vlabel16: ;
            }
            vlSelfRef.__Vfunc_memory_mask__20__op = vlSelfRef.__Vfunc_cast_to_memory_op__21__Vfuncout;
            {
                if ((2U & (IData)(vlSelfRef.__Vfunc_memory_mask__20__op))) {
                    vlSelfRef.__Vfunc_memory_mask__20__Vfuncout = 0xfU;
                    goto __Vlabel17;
                } else if ((1U & (IData)(vlSelfRef.__Vfunc_memory_mask__20__op))) {
                    vlSelfRef.__Vfunc_memory_mask__20__Vfuncout = 3U;
                    goto __Vlabel17;
                } else {
                    vlSelfRef.__Vfunc_memory_mask__20__Vfuncout = 1U;
                    goto __Vlabel17;
                }
                __Vlabel17: ;
            }
            vlSelfRef.__Vfunc_shuffle_store_mask__19__mask 
                = vlSelfRef.__Vfunc_memory_mask__20__Vfuncout;
            {
                if ((2U & vlSelfRef.__Vfunc_shuffle_store_mask__19__low_addr)) {
                    if ((1U & vlSelfRef.__Vfunc_shuffle_store_mask__19__low_addr)) {
                        vlSelfRef.__Vfunc_shuffle_store_mask__19__Vfuncout 
                            = ((8U & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                      << 3U)) | (7U 
                                                 & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                                    >> 1U)));
                        goto __Vlabel18;
                    } else {
                        vlSelfRef.__Vfunc_shuffle_store_mask__19__Vfuncout 
                            = ((0xcU & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                        << 2U)) | (3U 
                                                   & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                                      >> 2U)));
                        goto __Vlabel18;
                    }
                } else if ((1U & vlSelfRef.__Vfunc_shuffle_store_mask__19__low_addr)) {
                    vlSelfRef.__Vfunc_shuffle_store_mask__19__Vfuncout 
                        = ((0xeU & ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                    << 1U)) | (1U & 
                                               ((IData)(vlSelfRef.__Vfunc_shuffle_store_mask__19__mask) 
                                                >> 3U)));
                    goto __Vlabel18;
                } else {
                    vlSelfRef.__Vfunc_shuffle_store_mask__19__Vfuncout 
                        = vlSelfRef.__Vfunc_shuffle_store_mask__19__mask;
                    goto __Vlabel18;
                }
                __Vlabel18: ;
            }
            vlSelfRef.__PVT__data_read_byte = vlSelfRef.__Vfunc_shuffle_store_mask__19__Vfuncout;
            vlSelfRef.__PVT__data_write_byte = 0U;
            vlSelfRef.__PVT__data_write = 0U;
        }
    } else {
        vlSelfRef.__PVT__data_read_valid = 0U;
        vlSelfRef.__PVT__data_write_valid = 0U;
        vlSelfRef.__PVT__data_write_byte = 0U;
        vlSelfRef.__PVT__data_addr = 0U;
        vlSelfRef.__PVT__data_write = 0U;
    }
    vlSelfRef.__PVT__write_reg_valid = 0U;
    if ((((IData)(vlSelfRef.__PVT__memory_stage_complete) 
          & (4U == vlSelfRef.__PVT__current_stage)) 
         & (IData)(__PVT__wbv))) {
        vlSelfRef.__PVT__write_reg_valid = 1U;
    }
}
