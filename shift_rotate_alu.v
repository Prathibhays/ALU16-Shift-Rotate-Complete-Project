`timescale 1ns/1ps

// 16-bit shift/rotate unit built from cascaded 2:1 multiplexers.
// Operation select:
//   2'b00 : Shift Left Logical  (SLL)
//   2'b01 : Shift Right Logical (SRL)
//   2'b10 : Rotate Left         (ROL)
//   2'b11 : Rotate Right        (ROR)
//
// shift_amount is 4 bits, so the supported range is 0 through 15.
// Written in Verilog-2001 style for compatibility with Icarus Verilog.

module shift_rotate_alu (
    input  [15:0] data_in,
    input  [3:0]  shift_amount,
    input  [1:0]  operation,
    output [15:0] result
);

    wire rotate_mode;
    wire [15:0] left_stage1, left_stage2, left_stage3, left_stage4;
    wire [15:0] right_stage1, right_stage2, right_stage3, right_stage4;

    assign rotate_mode = operation[1];

    // LEFT path: four mux stages for shifts by 1, 2, 4 and 8 bits.
    // In rotate mode, the bits shifted out at the MSB side wrap around.
    assign left_stage1 = shift_amount[0] ?
        (rotate_mode ? {data_in[14:0], data_in[15]} :
                       {data_in[14:0], 1'b0}) : data_in;

    assign left_stage2 = shift_amount[1] ?
        (rotate_mode ? {left_stage1[13:0], left_stage1[15:14]} :
                       {left_stage1[13:0], 2'b00}) : left_stage1;

    assign left_stage3 = shift_amount[2] ?
        (rotate_mode ? {left_stage2[11:0], left_stage2[15:12]} :
                       {left_stage2[11:0], 4'b0000}) : left_stage2;

    assign left_stage4 = shift_amount[3] ?
        (rotate_mode ? {left_stage3[7:0], left_stage3[15:8]} :
                       {left_stage3[7:0], 8'b00000000}) : left_stage3;

    // RIGHT path: four mux stages for shifts by 1, 2, 4 and 8 bits.
    // In rotate mode, the bits shifted out at the LSB side wrap around.
    assign right_stage1 = shift_amount[0] ?
        (rotate_mode ? {data_in[0], data_in[15:1]} :
                       {1'b0, data_in[15:1]}) : data_in;

    assign right_stage2 = shift_amount[1] ?
        (rotate_mode ? {right_stage1[1:0], right_stage1[15:2]} :
                       {2'b00, right_stage1[15:2]}) : right_stage1;

    assign right_stage3 = shift_amount[2] ?
        (rotate_mode ? {right_stage2[3:0], right_stage2[15:4]} :
                       {4'b0000, right_stage2[15:4]}) : right_stage2;

    assign right_stage4 = shift_amount[3] ?
        (rotate_mode ? {right_stage3[7:0], right_stage3[15:8]} :
                       {8'b00000000, right_stage3[15:8]}) : right_stage3;

    // Final 2:1 mux selects the left or right datapath.
    assign result = operation[0] ? right_stage4 : left_stage4;

endmodule
