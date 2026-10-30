16-bit Shift-Left, Shift-Right and Rotate ALU using Multiplexers
=================================================================

Files
-----
1. shift_rotate_alu.v       - synthesizable 16-bit design
2. tb_shift_rotate_alu.v    - testbench; creates shift_rotate_alu.vcd

Operations
----------
operation = 00 : Shift Left Logical  (SLL)
operation = 01 : Shift Right Logical (SRL)
operation = 10 : Rotate Left         (ROL)
operation = 11 : Rotate Right        (ROR)

Inputs:
- data_in       : 16-bit input data
- shift_amount  : 4-bit shift amount (0 to 15)
- operation     : 2-bit operation selector

Output:
- result        : 16-bit operation result

The datapath uses cascaded conditional assignments (2:1 muxes) in
four stages: shift by 1, 2, 4 and 8. Separate left and right paths
are followed by a final direction-selection mux. The rotate control
selects wrap-around bits instead of zero fill.

Run using Icarus Verilog
------------------------
Open Command Prompt in the folder containing the two .v files.

Compile:
    iverilog -o shift_rotate_sim shift_rotate_alu.v tb_shift_rotate_alu.v

Run:
    vvp shift_rotate_sim

The testbench writes:
    shift_rotate_alu.vcd

Open the waveform in GTKWave:
    gtkwave shift_rotate_alu.vcd

If Windows says 'gtkwave' is not recognized, open GTKWave from its
Start Menu shortcut and use File > Open to select shift_rotate_alu.vcd.
You may also run it with the full path to gtkwave.exe.

What to inspect in GTKWave
-------------------------
Expand tb_shift_rotate_alu and add:
- data_in
- shift_amount
- operation
- result
- expected
- errors

The testbench checks 6 input patterns x 4 operations x 16 shift amounts
(384 test cases). The simulator prints PASS for each matching case and
ends with ALL TESTS PASSED if no mismatch is detected.

Notes
-----
- This is Verilog-2001 compatible; no SystemVerilog-only constructs are used.
- No external IP or vendor-specific libraries are required.
- The VCD is generated when the testbench is run; it is not a pre-made
  waveform file.
