`timescale 1ns/10ps

// Andrew Sweeney
// CPE 527 Lab 004
// Multiplier Test Bench

`include "rtl/fixedpoint.sv"

module fantastic_fft8_tb (
    fantasticfft_fft8_if fft8if
);

    logic [7:-8] x0, x1, x2, x3, x4, x5, x6, x7, 
        y0, y1, y2, y3, y4, y5, y6, y7,
        y0_i, y1_i, y2_i, y3_i, y4_i, y5_i, y6_i, y7_i;

    int iterator;

    initial begin
        logic [7:-8] thing1 = 16'b0000_0000_1011_0101;
        logic [7:-8] thing2 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 3'b0, 8'b1011_0101);
        $display("-----------------------------------------------------------------");
        $display("Testing macros...");
        $display("\tConstant test 1: %b\tConstant test2: %b", thing1, thing2);

        assert (thing1 == thing2) $display("\tMacro correctly generated fixed point number.");
        else $display("\tMacro failed to correctly create fixed point number.");

        $display("\tConstant converted to decimal notation: %d.%d", `GET_FIXED_POINT_DECIMAL_FORM(8, 8, thing1));

        $display("-----------------------------------------------------------------");
        $display("Beginning test...");
        
        x0 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd1, 8'd0);
        x1 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd2, 8'd0);
        x2 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd3, 8'd0);
        x3 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd4, 8'd0);
        x4 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd5, 8'd0);
        x5 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd6, 8'd0);
        x6 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd7, 8'd0);
        x7 = `CREATE_CONSTANT_FIXED_POINT(8, 8, 8'd8, 8'd0);
        $display("\tCreated constants (values 1-8)...");

        y0 = (x0 + x4) + (x2 + x6) + (x1 + x5) + (x3 + x7); 
        y1 = (x0 - x4) + 0.707 * ((x1 - x5) + (x7 - x3)); 
        y2 = (x0 + x4) - (x2 + x6);
        y3 = (x0 - x4) + 0.707 * ((x5 - x1) + (x3 - x7)); 
        y4 = (x0 + x4) + (x2 + x6) - (x1 + x5) - (x3 + x7); 
        y5 = (x0 - x4) + 0.707 * ((x5 - x1) + (x3 - x7)); 
        y6 = (x0 + x4) - (x2 + x6); 
        y7 = (x0 - x4) + 0.707 * ((x1 - x5) + (x7 - x3)); 

        y0_i = 0;
        y1_i = (x6 - x2) + 0.707 * ((x7 - x3) - (x1 + x5));
        y2_i = (x3 + x7) - (x1 + x5); 
        y3_i = (x2 - x6) + 0.707 * ((x7 - x3) + (x5 - x1)); 
        y4_i = 0;
        y5_i = (x6 - x2) + 0.707 * ((x1 - x5) + (x3 - x7)); 
        y6_i = (x1 + x5) - (x3 + x7);
        y7_i = (x2 - x6) + 0.707 * ((x1 - x5) + (x3 - x7));
        $display("\tConstant expressions for FFT8 evaluated...");

        fft8if.x0 <= x0;
        fft8if.x1 <= x1;
        fft8if.x2 <= x2;
        fft8if.x3 <= x3;
        fft8if.x4 <= x4;
        fft8if.x5 <= x5;
        fft8if.x6 <= x6;
        fft8if.x7 <= x7;
        fft8if.isValid <= 1;
        $display("\tAssigned constant values to FFT8 inputs...");

        @(posedge fft8if.clk);
        #1step;

        $display("\tValues should now be clocked into FFT8, clearing values and awaiting results...");

        fft8if.x0 <= 0;
        fft8if.x1 <= 0;
        fft8if.x2 <= 0;
        fft8if.x3 <= 0;
        fft8if.x4 <= 0;
        fft8if.x5 <= 0;
        fft8if.x6 <= 0;
        fft8if.x7 <= 0;
        fft8if.isValid <= 0;

        repeat(3) begin
            @(posedge fft8if.clk);
            #1step;
        end

        
        $display("\ty0 + y0_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y0), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y0_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y0), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y0_i));
        $display("\ty1 + y1_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y1), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y1_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y1), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y1_i));
        $display("\ty2 + y2_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y2), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y2_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y2), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y2_i));
        $display("\ty3 + y3_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y3), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y3_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y3), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y3_i));
        $display("\ty4 + y4_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y4), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y4_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y4), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y4_i));
        $display("\ty5 + y5_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y5), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y5_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y5), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y5_i));
        $display("\ty6 + y6_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y6), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y6_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y6), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y6_i));
        $display("\ty7 + y7_i\tExpected: %d.%d + j * %d.%d\tCalculated: %d.%d + j * %d.%d", 
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y7), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, y7_i),
            `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y7), `GET_FIXED_POINT_DECIMAL_FORM(8, 8, fft8if.y7_i));

        $finish();
    end
endmodule
