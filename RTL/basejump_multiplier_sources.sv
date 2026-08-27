// Keep the BaseJump multiplier and its helper modules in one compilation unit.
// Its Booth helper function has compilation-unit scope and is used by the
// structural leaf modules below.
`include "bsg_mul_pipelined.sv"
`include "bsg_mul/bsg_mul_booth_4_block.sv"
`include "bsg_mul/bsg_mul_booth_4_block_rep.sv"
`include "bsg_mul/bsg_mul_comp42.sv"
`include "bsg_mul/bsg_mul_comp42_rep.sv"
