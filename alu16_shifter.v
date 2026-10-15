// 16-bit ALU shifter: shift-left, shift-right, rotate-left, rotate-right
// Compatible with Verilog-2001 and Icarus Verilog 0.9.7.
// Operation encoding:
//   2'b00 : logical shift left
//   2'b01 : logical shift right
//   2'b10 : rotate left
//   2'b11 : rotate right
// shift_amt is 0..15. The design uses explicit 2:1 multiplexers in
// five barrel-shifter stages (1, 2, 4, and 8 positions; 4 stages total).

`timescale 1ns/1ps

module mux2_16 (
    input  [15:0] a,
    input  [15:0] b,
    input         sel,
    output [15:0] y
);
    assign y = sel ? b : a;
endmodule

module alu16_shifter (
    input  [15:0] data_in,
    input  [3:0]  shift_amt,
    input  [1:0]  operation,
    output [15:0] data_out
);
    wire [15:0] left_s1, left_s2, left_s4, left_s8;
    wire [15:0] right_s1, right_s2, right_s4, right_s8;
    wire [15:0] rotl_s1, rotl_s2, rotl_s4, rotl_s8;
    wire [15:0] rotr_s1, rotr_s2, rotr_s4, rotr_s8;

    // Logical shift left barrel network.
    mux2_16 l1(data_in, {data_in[14:0], 1'b0}, shift_amt[0], left_s1);
    mux2_16 l2(left_s1, {left_s1[13:0], 2'b00}, shift_amt[1], left_s2);
    mux2_16 l3(left_s2, {left_s2[11:0], 4'b0000}, shift_amt[2], left_s4);
    mux2_16 l4(left_s4, {left_s4[7:0], 8'b00000000}, shift_amt[3], left_s8);

    // Logical shift right barrel network.
    mux2_16 r1(data_in, {1'b0, data_in[15:1]}, shift_amt[0], right_s1);
    mux2_16 r2(right_s1, {2'b00, right_s1[15:2]}, shift_amt[1], right_s2);
    mux2_16 r3(right_s2, {4'b0000, right_s2[15:4]}, shift_amt[2], right_s4);
    mux2_16 r4(right_s4, {8'b00000000, right_s4[15:8]}, shift_amt[3], right_s8);

    // Rotate left barrel network.
    mux2_16 rl1(data_in, {data_in[14:0], data_in[15]}, shift_amt[0], rotl_s1);
    mux2_16 rl2(rotl_s1, {rotl_s1[13:0], rotl_s1[15:14]}, shift_amt[1], rotl_s2);
    mux2_16 rl3(rotl_s2, {rotl_s2[11:0], rotl_s2[15:12]}, shift_amt[2], rotl_s4);
    mux2_16 rl4(rotl_s4, {rotl_s4[7:0], rotl_s4[15:8]}, shift_amt[3], rotl_s8);

    // Rotate right barrel network.
    mux2_16 rr1(data_in, {data_in[0], data_in[15:1]}, shift_amt[0], rotr_s1);
    mux2_16 rr2(rotr_s1, {rotr_s1[1:0], rotr_s1[15:2]}, shift_amt[1], rotr_s2);
    mux2_16 rr3(rotr_s2, {rotr_s2[3:0], rotr_s2[15:4]}, shift_amt[2], rotr_s4);
    mux2_16 rr4(rotr_s4, {rotr_s4[7:0], rotr_s4[15:8]}, shift_amt[3], rotr_s8);

    // Final 4-to-1 operation selection, implemented as mux stages.
    wire [15:0] mux_a, mux_b;
    mux2_16 m0(left_s8, right_s8, operation[0], mux_a);
    mux2_16 m1(rotl_s8, rotr_s8, operation[0], mux_b);
    mux2_16 m2(mux_a, mux_b, operation[1], data_out);
endmodule
