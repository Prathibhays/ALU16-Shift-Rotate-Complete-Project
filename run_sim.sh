#!/bin/sh
set -e
iverilog -o alu16_sim alu16_shifter.v tb_alu16_shifter.v
vvp alu16_sim
