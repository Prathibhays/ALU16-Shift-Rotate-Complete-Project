`timescale 1ns/1ps

module tb_alu16_shifter;
    reg [15:0] data_in;
    reg [3:0] shift_amt;
    reg [1:0] operation;
    wire [15:0] data_out;
    integer errors;

    alu16_shifter dut (
        .data_in(data_in),
        .shift_amt(shift_amt),
        .operation(operation),
        .data_out(data_out)
    );

    task check;
        input [15:0] expected;
        input [255:0] test_name;
        begin
            #10;
            if (data_out !== expected) begin
                $display("FAIL: %0s | in=%h amount=%0d op=%b expected=%h got=%h",
                         test_name, data_in, shift_amt, operation, expected, data_out);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s | output=%h", test_name, data_out);
            end
        end
    endtask

    initial begin
        errors = 0;
        data_in = 16'h8001;
        shift_amt = 1;
        operation = 2'b00; check(16'h0002, "shift left by 1");

        data_in = 16'h8001;
        shift_amt = 1;
        operation = 2'b01; check(16'h4000, "shift right by 1");

        data_in = 16'h8001;
        shift_amt = 1;
        operation = 2'b10; check(16'h0003, "rotate left by 1");

        data_in = 16'h8001;
        shift_amt = 1;
        operation = 2'b11; check(16'hC000, "rotate right by 1");

        data_in = 16'h1234;
        shift_amt = 4;
        operation = 2'b00; check(16'h2340, "shift left by 4");

        data_in = 16'h1234;
        shift_amt = 4;
        operation = 2'b01; check(16'h0123, "shift right by 4");

        data_in = 16'h1234;
        shift_amt = 4;
        operation = 2'b10; check(16'h2341, "rotate left by 4");

        data_in = 16'h1234;
        shift_amt = 4;
        operation = 2'b11; check(16'h4123, "rotate right by 4");

        data_in = 16'hA5C3;
        shift_amt = 0;
        operation = 2'b00; check(16'hA5C3, "shift amount zero");

        data_in = 16'hFFFF;
        shift_amt = 15;
        operation = 2'b00; check(16'h8000, "shift left by 15");

        data_in = 16'h0001;
        shift_amt = 15;
        operation = 2'b10; check(16'h8000, "rotate left by 15");

        if (errors == 0)
            $display("\nALL TESTS PASSED");
        else
            $display("\nTESTS FAILED: %0d error(s)", errors);

        $finish;
    end
endmodule
