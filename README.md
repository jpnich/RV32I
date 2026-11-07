# RV32I 5 Stage Pipeline and Single-Cycle Implemented on DE10-Lite FPGA
## Overview
The primary aim of this project is to compare the compilation logs in Quartus of the single-cycle versus the pipeline to quantify the effects of pipelining a microprocessor. From a more personal point of view, I wanted to develop my understanding of RISCV architecture, datapath and controller design, RV32I instruction encoding, pipelining (and dealing with pipeline hazards) and more generally improve my skills in RTL design and verification - all of which I successfully achieved.  

Note: the full RV32I instruction set has yet to be implemented (see below), however, it is my intention to implement all instructions fully in the near future.

## Initial Objectives
-Design a single-cycle RV32I processor that passes all simulations  

-Implement single-cycle onto DE10-Lite  

-Develop 5 stage pipeline on the single-cycle base and account for pipeline hazards  

-Implement pipelined version onto DE10-Lite  

-Compare compilation logs in Quartus to quantify the differences between pipelining versus single-cylce  


## Specifications
SystemVerilog is used for all RTL design throughout, including testbenches; Verilator is the simulator used, complemented by GTKWave for waveform viewing; Quartus was used for synthesis and implementation on the Intel-based FPGA; and finally a trusted paper and pencil were used for mapping out the datapath whenever I got confused why the pipeline hazard logic wasn't working.

The pipeline design implements all I-type, R-type, B-type instructions plus load and store, however, jumps and the rest of the load/store instructions have yet to be implemented - I will be coming back to this. In terms of an architectural POV (see block diagrams below), the single-cycle involves an ALU, ALU controller, program counter, controller, instruction memory, data memory, immediate generator and a few multiplexers and some logic gates. The pipeline builds on this adding 4 pipeline registers (IFID, IDEX, EXMEM, MEMWB), a bypass unit for data forwarding, a stall unit for load-use stalls and pipeline flushing for branch conditions. I need to develop a more standardised approach to testbench coverage but I'm pretty confident it fully works, given I've had it running through dozens of different, randomised instructions (I use a program.hex file to set the instruction memory).

## Block Diagrams:
### Single-Cycle Architecture
<img width="1280" height="720" alt="singlecycle-blockdiagram" src="https://github.com/user-attachments/assets/5bffd98d-6f70-49f9-bc5e-e2b8382a1443" />

### Pipelined Architecture
<img width="1280" height="720" alt="pipeline-blockdiagram" src="https://github.com/user-attachments/assets/6f4fa26b-b635-47e7-aca6-763c906f97cb" />

Note: I made these block diagrams in PowerPoint for some reason so it took a very long time, but I'm quite proud of it. Secondly, most of the actual RTL design was done with hand-drawn sketches of the architecture to figure out what signals were needed for dealing with pipeline hazards and such.

