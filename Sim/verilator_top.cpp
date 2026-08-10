#include <verilated.h>          // Defines common routines
#include <iostream>             // Need std::cout
#include "Vtop.h"               // From Verilating "top.v"
#include "Vtop_top.h"
// #include "Vtop_clean_core.h"
// #include "Vtop_riscv_multicycle.h"
Vtop *top;                      // Instantiation of module

vluint64_t main_time = 0;       // Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus.  This is in units of the timeprecision
// used in Verilog (or from --timescale-override)

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;           // converts to double, to match
                               // what SystemC does
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);   // Remember args

    top = new Vtop;             // Create instance

    top->reset = 1;           // Set some inputs

    constexpr vluint64_t max_cycles = 10000000;
    while (!Verilated::gotFinish() && main_time < max_cycles) {
        if (main_time > 10)
            top->reset = 0;   // Deassert reset
        top->clk = 1;
        top->eval();
        top->clk = 0;
        top->eval();
        if (top->halt == 1)
            break;
        main_time++;            // Time passes...
    }

    if (main_time == max_cycles) {
        std::cerr << "ERROR simulation timeout after " << max_cycles
                  << " cycles" << std::endl;
    }

    std::cout << "PROFILE cycles=" << top->cycle_count
              << " retired=" << top->retire_count
              << " branches=" << top->branch_count
              << " mispredicts=" << top->branch_mispredict_count
              << " btb_hits=" << top->btb_hit_count
              << std::endl;
    std::cout << "HALT code=0x" << std::hex << top->halt_code
              << " pc=0x" << top->debug_pc << std::dec << std::endl;
    std::cout << "KERNEL_PROFILE cycles=" << top->kernel_cycle_count
              << " retired=" << top->kernel_retire_count
              << " branches=" << top->kernel_branch_count
              << " mispredicts=" << top->kernel_mispredict_count
              << std::endl;
    std::cout << "CACHE_PROFILE icache_hits=" << top->icache_hit_count
              << " icache_misses=" << top->icache_miss_count
              << " dcache_hits=" << top->dcache_hit_count
              << " dcache_misses=" << top->dcache_miss_count
              << " dcache_writebacks=" << top->dcache_writeback_count
              << std::endl;

    // printf("Instructions completed (approximately): %d\n",
    //     top->top->core->core->instruction_count);
    const bool failed = main_time == max_cycles || top->halt_code != 0xc0de;
    top->final();               // Done simulating
    //    // (Though this example doesn't get here)
    delete top;
    return failed ? 1 : 0;
}
