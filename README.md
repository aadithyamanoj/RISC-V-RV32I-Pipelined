# Pipelined RV32I RISC-V CPU

## 1. Project Overview
This project implements a five-stage pipelined RV32I RISC-V CPU with full data-hazard bypassing, designed from the ground up to demystify how instructions flow through a modern processor pipeline. Driven by a desire to understand the low level mechanics of program execution (fetch, decode, execute, memory access, and write-back stages interact, and how hazards are detected and resolved), I built each pipeline stage in SystemVerilog, added forwarding paths to eliminate stalls, and verified correctness by writing RV32I Assembly. The result is a hands-on, fully functional RV32I core that illustrates the fundamental principles behind high-performance CPU design.

## 2. Features
- Full RV32I instruction support
- Five pipeline stages
- Data-hazard detection and bypassing 
- Control-hazard handling

## 3. Architecture  
Inspired by the processor that is described in the Hennesy and Patterson textbook, I designed my core with 5 pipeline stages. Unlike the text, however, I opted to use synchronous memories as they represented a more realistic view on memory latency. As a result of this there are a few key differences in the timing of the memory and register file reads in order to read data in time for execution. Additionally I opted to only implement basic arithmetic in the execute stage, removing the need for stalls due to multy-cycle execution(multiply, divide, etc.).
### 3.1. Pipeline Stages  
- **IF (Instruction Fetch)**  
- **ID (Instruction Decode)**  
- **EX (Execute / ALU)**  
- **MEM (Data Memory Access)**  
- **WB (Write-Back to Register File)**  

### 3.4. Hazard Handling  
- **Data hazards**: Hazard detection logic and control signals 
- **Control hazards**: branch resolution in EX and pipeline flush  

## 4. Implementation Details  
In order to simulate this design, I used Verilator for its quick compile and execution time. In order to accurately test full ISA compliance, I compiled Assembly and simple C programs (start.s and test.c respectively) and turned the linked .elf file into hex files which could be read into the memory from the verilog. 

## 5. Learnings and Future opportunites
I came into this project with the idea that the execution would be at the core of what makes it complex. In reality, I have learned that data dependencies and data movoement were one of the biggest bottlenecks in my design. Out of every part, debugging the bypassing took the longest time. Additionally, its clear how moving data to and from memory may have been simple in the project, but adding larger memories with larger latencies or multilevel caches would significantly increase complexity. Finally, there is plenty of opportunity to expore futher perofmance advancements for my design, the first of which is a BTB. A BTB is a minimal solution to branch misprediction that would serve to dramatically improve my misprediction rate (which is 100% right now :( ). I also now have a strong foundation upon which I plan on exploring the mechanics of Out of Order execution in a similar simulated fasion. 
