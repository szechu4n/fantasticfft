`timescale 1ns/10ps

// Andrew Sweeney
// CPE 527 Lab 004
// Multiplier Test Bench

// verilator lint_off all
`include "rtl/fixedpoint.sv"

module fantastic_fft8_tb (
    fantasticfft_fft8_if fft8if
);

    initial begin
        logic [7:-8] thing1 = 16'b0000_0000_1011_0101;
        logic [7:-8] thing2 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 3'b0, 8'b1011_0101);
        $display("-----------------------------------------------------------------");
        $display("Testing macros...");
        $display("\tConstant test 1: %b\tConstant test2: %b", thing1, thing2);

        assert (thing1 == thing2) $display("Macro correctly generated fixed point number.");
        else $fatal("\tMacro failed to correctly create fixed point number.");

        $display("-----------------------------------------------------------------");
        $display("Beginning test...");

        
        
        $finish();
    end
endmodule
