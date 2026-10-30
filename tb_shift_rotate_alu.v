`timescale 1ns/1ps

module tb_shift_rotate_alu;

    reg  [15:0] data_in;
    reg  [3:0]  shift_amount;
    reg  [1:0]  operation;
    wire [15:0] result;

    reg  [15:0] expected;
    integer op;
    integer amount;
    integer pattern;
    integer errors;

    shift_rotate_alu dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .operation(operation),
        .result(result)
    );

    // Reference model used only by the testbench.
    function [15:0] reference_result;
        input [15:0] value;
        input [3:0] amount;
        input [1:0] op_code;
        reg [31:0] doubled;
        begin
            doubled = {value, value};
            case (op_code)
                2'b00: reference_result = value << amount; // SLL
                2'b01: reference_result = value >> amount; // SRL
                2'b10: reference_result = doubled[31-amount -: 16]; // ROL
                2'b11: reference_result = doubled[amount +: 16];    // ROR
                default: reference_result = 16'h0000;
            endcase
        end
    endfunction

    initial begin
        $dumpfile("shift_rotate_alu.vcd");
        $dumpvars(0, tb_shift_rotate_alu);

        errors = 0;
        data_in = 16'h0000;
        shift_amount = 4'd0;
        operation = 2'b00;

        // Exercise all four operations, all shift amounts (0..15),
        // and several input patterns.
        for (pattern = 0; pattern < 6; pattern = pattern + 1) begin
            case (pattern)
                0: data_in = 16'h0001;
                1: data_in = 16'h8001;
                2: data_in = 16'hA5C3;
                3: data_in = 16'hFFFF;
                4: data_in = 16'h00FF;
                5: data_in = 16'h1234;
            endcase

            for (op = 0; op < 4; op = op + 1) begin
                for (amount = 0; amount < 16; amount = amount + 1) begin
                    operation = op[1:0];
                    shift_amount = amount[3:0];
                    #10;
                    expected = reference_result(data_in, shift_amount, operation);

                    if (result !== expected) begin
                        errors = errors + 1;
                        $display("FAIL op=%b amount=%0d input=%h expected=%h got=%h",
                                 operation, shift_amount, data_in, expected, result);
                    end else begin
                        $display("PASS op=%b amount=%0d input=%h result=%h",
                                 operation, shift_amount, data_in, result);
                    end
                end
            end
        end

        if (errors == 0)
            $display("\nALL TESTS PASSED.");
        else
            $display("\nTESTS FAILED: %0d mismatches.", errors);

        #10;
        $finish;
    end

endmodule
