@echo off
iverilog -o alu16_sim alu16_shifter.v tb_alu16_shifter.v
if errorlevel 1 (
  echo Compilation failed.
  exit /b 1
)
vvp alu16_sim
