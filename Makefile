#

include Sim/site-config.sh
goal: result-verilator
CC=$(RISCV_PREFIX)-gcc
AS=$(RISCV_PREFIX)-as
LD=$(RISCV_PREFIX)-ld

SSFLAGS=-march=rv32i
CCFLAGS=-march=rv32i -Wno-builtin-declaration-mismatch -Ilibmc
LDFLAGS=--script ld.script
LDPOSTFLAGS= -Llibmc -lmc  -Llibmc -lmc -L$(RISCV_LIB) -lgcc
TOOLS=dumphex
LIBS=libmc/libmc.a

TEST_S=tests/start.s
TEST_C=tests/test.c

# Updated rules for files in subdirectories
tests/%.o: tests/%.c
	$(CC) $(CCFLAGS) -c $< -o $@

tests/%.o: tests/%.s  
	$(AS) $(SSFLAGS) -c $< -o $@

libmc/libmc.a:
	cd libmc; make clean; make; cd ..

dumphex: Sim/dumphex.c
	gcc -o dumphex Sim/dumphex.c

test: $(TEST_S:.s=.o) $(TEST_C:.c=.o) $(LIBS) $(TOOLS)
	$(LD) $(LDFLAGS) -o test $(TEST_S:.s=.o) $(TEST_C:.c=.o) $(LDPOSTFLAGS)
	/bin/bash ./Sim/elftohex.sh test .

result-verilator: RTL/top.sv Sim/verilator_top.cpp RTL/core.sv test
	 @unset LDFLAGS; \
	 $(VERILATOR) -O0 --cc --build --Wno-UNOPTFLAT --Wno-WIDTHEXPAND --top-module top RTL/top.sv Sim/verilator_top.cpp --exe
	 cp obj_dir/Vtop ./result-verilator
	 rm -rf obj_dir
	 ./result-verilator

result-iverilog: RTL/itop.sv RTL/top.sv RTL/core.sv test
	 $(IVERILOG) -g2012 -o result-iverilog RTL/itop.sv
	 ./result-iverilog
	 rm result-iverilog

clean:
	rm -rf dumphex test.vcd obj_dir/ *.o tests/*.o result-verilator result-iverilog *.hex test.bin test

