// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop__Syms.h"
#include "Vtop_clean_core.h"

VL_ATTR_COLD void Vtop_clean_core___stl_sequent__TOP__top__core__0(Vtop_clean_core* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+        Vtop_clean_core___stl_sequent__TOP__top__core__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__PVT__inst_mem_req[0U] = 0U;
    vlSelfRef.__PVT__inst_mem_req[1U] = 0U;
    vlSelfRef.__PVT__inst_mem_req[2U] = 0U;
    vlSelfRef.__PVT__inst_mem_req[1U] = ((0xfffffffU 
                                          & vlSelfRef.__PVT__inst_mem_req[1U]) 
                                         | (vlSymsp->TOP__top__core__core.__PVT__pc 
                                            << 0x1cU));
    vlSelfRef.__PVT__inst_mem_req[2U] = (vlSymsp->TOP__top__core__core.__PVT__pc 
                                         >> 4U);
    vlSelfRef.__PVT__inst_mem_req[0U] = ((0xfff7ffffU 
                                          & vlSelfRef.__PVT__inst_mem_req[0U]) 
                                         | (0xfff80000U 
                                            & ((vlSymsp->TOP__top.__PVT__inst_mem_rsp[0U] 
                                                << 1U) 
                                               & ((0U 
                                                   == vlSymsp->TOP__top__core__core.__PVT__current_stage) 
                                                  << 0x13U))));
    vlSelfRef.__PVT__inst_mem_req[0U] = ((0xf0ffffffU 
                                          & vlSelfRef.__PVT__inst_mem_req[0U]) 
                                         | ((((vlSymsp->TOP__top.__PVT__inst_mem_rsp[0U] 
                                               >> 0x12U) 
                                              & (0U 
                                                 == vlSymsp->TOP__top__core__core.__PVT__current_stage))
                                              ? 0xfU
                                              : 0U) 
                                            << 0x18U));
    vlSelfRef.__PVT__data_mem_req[0U] = 0U;
    vlSelfRef.__PVT__data_mem_req[1U] = 0U;
    vlSelfRef.__PVT__data_mem_req[2U] = 0U;
    vlSelfRef.__PVT__data_mem_req[1U] = ((0xfffffffU 
                                          & vlSelfRef.__PVT__data_mem_req[1U]) 
                                         | (vlSymsp->TOP__top__core__core.__PVT__data_addr 
                                            << 0x1cU));
    vlSelfRef.__PVT__data_mem_req[2U] = (vlSymsp->TOP__top__core__core.__PVT__data_addr 
                                         >> 4U);
    vlSelfRef.__PVT__data_mem_req[0U] = ((0xf007ffffU 
                                          & vlSelfRef.__PVT__data_mem_req[0U]) 
                                         | (0xfff80000U 
                                            & ((((IData)(vlSymsp->TOP__top__core__core.__PVT__data_read_valid)
                                                  ? (IData)(vlSymsp->TOP__top__core__core.__PVT__data_read_byte)
                                                  : 0U) 
                                                << 0x18U) 
                                               | ((((IData)(vlSymsp->TOP__top__core__core.__PVT__data_write_valid)
                                                     ? (IData)(vlSymsp->TOP__top__core__core.__PVT__data_write_byte)
                                                     : 0U) 
                                                   << 0x14U) 
                                                  | (((IData)(vlSymsp->TOP__top__core__core.__PVT__data_read_valid) 
                                                      | (IData)(vlSymsp->TOP__top__core__core.__PVT__data_write_valid)) 
                                                     << 0x13U)))));
    vlSelfRef.__PVT__data_mem_req[0U] = ((0xfffffffU 
                                          & vlSelfRef.__PVT__data_mem_req[0U]) 
                                         | (vlSymsp->TOP__top__core__core.__PVT__data_write 
                                            << 0x1cU));
    vlSelfRef.__PVT__data_mem_req[1U] = ((0xf0000000U 
                                          & vlSelfRef.__PVT__data_mem_req[1U]) 
                                         | (vlSymsp->TOP__top__core__core.__PVT__data_write 
                                            >> 4U));
    vlSelfRef.__PVT__data_mem_req[0U] = ((0xffff0000U 
                                          & vlSelfRef.__PVT__data_mem_req[0U]) 
                                         | (IData)(vlSymsp->TOP__top__core__core.__PVT__data_request_tag));
}
