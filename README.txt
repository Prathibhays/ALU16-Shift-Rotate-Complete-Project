16-BIT ALU SHIFTER — ICARUS VERILOG 0.9.7

Project:
Design and implement 16-bit shift-left, shift-right, rotate-left and
rotate-right operations using multiplexers.

Files:
  alu16_shifter.v       RTL design; Verilog-2001 syntax
  tb_alu16_shifter.v    Testbench with example test cases
  run_sim.bat           Windows batch file to compile and run
  run_sim.sh            Linux/macOS shell script to compile and run

Operation codes:
  operation = 2'b00 : Logical shift left
  operation = 2'b01 : Logical shift right
  operation = 2'b10 : Rotate left
  operation = 2'b11 : Rotate right

Inputs:
  data_in   : 16-bit input word
  shift_amt : 4-bit shift/rotate amount (0 to 15)
  operation : 2-bit operation selector

Output:
  data_out  : 16-bit result

Run on Windows:
1. Install Icarus Verilog 0.9.7 and ensure iverilog and vvp are on PATH.
2. Open Command Prompt in this folder.
3. Run:
       run_sim.bat

Or run the commands manually:
       iverilog -o alu16_sim alu16_shifter.v tb_alu16_shifter.v
       vvp alu16_sim

Run on Linux/macOS:
       chmod +x run_sim.sh
       ./run_sim.sh

The RTL uses Verilog-2001 constructs (no SystemVerilog-only syntax) to
support older Icarus Verilog releases. Each barrel-shifter stage is built
from 2:1 mux modules. The final operation selector is also implemented
using muxes.

Expected final line:
       ALL TESTS PASSED
