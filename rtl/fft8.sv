
`include "rtl/fixedpoint.sv"

module fantasticfft_fft8 # (
    // Determines size of integer component of fixed point
    parameter INT_SIZE   = 8,

    // Determines size of fractional component of fixed point
    parameter FRAC_SIZE  = 8
)(
    fantasticfft_fft8_if fft8if
);

// implements a butterfly subadder
task SubAdder(input logic [INT_SIZE - 1 : -FRAC_SIZE] a, b, ref logic [INT_SIZE - 1 : -FRAC_SIZE] c, d);
    begin
        c = a + b;
        d = a - b;
    end
endtask 

task SubSubber(input logic [INT_SIZE - 1 : -FRAC_SIZE] a, b, ref logic [INT_SIZE - 1 : -FRAC_SIZE] c, d);
    begin
        c = a - b;
        d = b - a;
    end
endtask 

// implements a constant multiplier with 1/sqrt(2) as the constant
task ConstMultiplier(input logic [INT_SIZE - 1 : -FRAC_SIZE] a, ref logic [INT_SIZE - 1 : -FRAC_SIZE] b);
    begin
        // Represents 0.707106 (1/sqrt(2))
        logic [INT_SIZE - 1 : -FRAC_SIZE] c0 = `CREATE_CONSTANT_FIXED_POINT(INT_SIZE, FRAC_SIZE, 0, 8'b1011_0101); 
        logic [2 * (INT_SIZE + FRAC_SIZE) - 1:0] d;
        d = (c0 * AbsoluteValue(a)) >> FRAC_SIZE;
        if (a[INT_SIZE - 1]) begin
            d = Negate(d);
        end
        b = d;
    end
endtask

function logic [INT_SIZE - 1 : -FRAC_SIZE] AbsoluteValue(logic [INT_SIZE - 1 : -FRAC_SIZE] a);
    logic [INT_SIZE - 1 : -FRAC_SIZE] b;
    if (a[INT_SIZE - 1]) begin
        b = ~a + 1;
    end else begin
        b = a;
    end
    return b;
endfunction

// implements 2's complement negation
function logic [INT_SIZE - 1 : -FRAC_SIZE] Negate(logic [INT_SIZE - 1 : -FRAC_SIZE] a);
    logic [INT_SIZE - 1 : -FRAC_SIZE] b;
    b = ~a + 1; // this constant does not need to be cast to fixed point because it implements 2's comp binary
    return b;
endfunction

// Each notation (t,c,d) indicates a stage in the pipeline of the FFT. It progresses x -> t -> c -> d -> y
logic [INT_SIZE - 1 : -FRAC_SIZE] t0, t1, t2, t3, t4, t5, t6, t7;
logic [INT_SIZE - 1 : -FRAC_SIZE] c0, c1, c2, c3, c4, c5, c6, c7;
logic [INT_SIZE - 1 : -FRAC_SIZE] d0, d1, d2, d3, d4, d5, d6, d7;
logic isValid_stage1, isValid_stage2, isValid_stage3;

always_ff @( posedge fft8if.clk ) begin : fft8
    // Note: this is implemented in reverse order because the designers of SystemVerilog, in their infinite wisdom, 
    // decided that tasks with outputs passed by reference are not valid targets of non-blocking assignments. Because
    // logically it makes sense to break the operations below down by tasks rather than implement behavioral modules
    // for simple addition and subtraction and constant multiplication, the output layer is provided first.

    // -----------------------------------------------------------------//
    // FFT8 Mathematical definition at Output Layer

    /*
    y0 = d0; 
    y1 = (d4) + -d2; 
    y2 = (d6);
    y3 = (d4) + d2; 
    y4 = d1; 
    y5 = (d4) + d2; 
    y6 = (d6); 
    y7 = (d4) + -d2; 

    y0_i = 0;
    y1_i = (-d5) + -d3;
    y2_i = (d7); 
    y3_i = (d5) + -d3; 
    y4_i = 0;
    y5_i = (-d5) + d3; 
    y6_i = (-d7);
    y7_i = (d5) + d3;
    */

    fft8if.y0 = d0; 
    fft8if.y1 = d4 + -d2; 
    fft8if.y2 = d6;
    fft8if.y3 = d4 + d2; 
    fft8if.y4 = d1; 
    fft8if.y5 = d4 + d2; 
    fft8if.y6 = d6; 
    fft8if.y7 = d4 + -d2; 

    fft8if.y0_i =  0;
    fft8if.y1_i = -d5 + -d3;
    fft8if.y2_i =  d7; 
    fft8if.y3_i =  d5 + -d3; 
    fft8if.y4_i =  0;
    fft8if.y5_i = -d5 + d3; 
    fft8if.y6_i = -d7;
    fft8if.y7_i =  d5 + d3;

    fft8if.resultValid = isValid_stage3;

    // -----------------------------------------------------------------//
    // FFT8 Mathematical definition at Output Layer

    /*
    y0 = (c0) + (c2); 
    y1 = (c6) + 0.707 * (-c5); 
    y2 = (c1);
    y3 = (c6) + 0.707 * (c5); 
    y4 = (c0) - (c2); 
    y5 = (c6) + 0.707 * (c5); 
    y6 = (c1); 
    y7 = (c6) + 0.707 * (-c5); 

    y0_i = 0;
    y1_i = (-c7) + 0.707 * (-c4);
    y2_i = (c3); 
    y3_i = (c7) + 0.707 * (-c4); 
    y4_i = 0;
    y5_i = (-c7) + 0.707 * (c4); 
    y6_i = (-c3);
    y7_i = (c7) + 0.707 * (c4);
    */

    SubAdder(c0, c2, d0, d1);
    ConstMultiplier(c5, d2);
    ConstMultiplier(c4, d3);
    d4 = c6;
    d5 = c7;
    d6 = c1;
    d7 = c3;

    isValid_stage3 = isValid_stage2;


    // -----------------------------------------------------------------//
    // FFT8 Mathematical definition at Layer 2

    /*
    y0 = (t0) + (t2) + (t6) + (t4); 
    y1 = (t1) + 0.707 * ((t7) + (-t5)); 
    y2 = (t0) - (t2);
    y3 = (t1) + 0.707 * ((-t7) + (t5)); 
    y4 = (t0) + (t2) - (t6) - (t4); 
    y5 = (t1) + 0.707 * ((-t7) + (t5)); 
    y6 = (t0) - (t2); 
    y7 = (t1) + 0.707 * ((t7) + (-t5)); 

    y0_i = 0;
    y1_i = (-t3) + 0.707 * ((-t5) + (-t7));
    y2_i = (t4) - (t6); 
    y3_i = (t3) + 0.707 * ((-t5) + (-t7)); 
    y4_i = 0;
    y5_i = (-t3) + 0.707 * ((t7) + (t5)); 
    y6_i = (t6) - (t4);
    y7_i = (t3) + 0.707 * ((t7) + (t5));
    */

    SubAdder(t0, t2, c0, c1);
    SubAdder(t4, t6, c2, c3); // t4 + t6, t4 - t6 -> -(-t4 -t6), -(t6 - t4)
    SubAdder(t5, t7, c4, c5);
    c6 = t1;
    c7 = t3;

    isValid_stage2 = isValid_stage1;



    // -----------------------------------------------------------------//
    // FFT8 Mathematical definition

    /*
    y0 = (x0 + x4) + (x2 + x6) + (x1 + x5) + (x3 + x7); 
    y1 = (x0 - x4) + 0.707 * ((x1 - x5) + (x7 - x3)); 
    y2 = (x0 + x4) - (x2 + x6);
    y3 = (x0 - x4) + 0.707 * ((x5 - x1) + (x3 - x7)); 
    y4 = (x0 + x4) + (x2 + x6) - (x1 + x5) - (x3 + x7); 
    y5 = (x0 - x4) + 0.707 * ((x5 - x1) + (x3 - x7)); 
    y6 = (x0 + x4) - (x2 + x6); 
    y7 = (x0 - x4) + 0.707 * ((x1 - x5) + (x7 - x3)); 

    y0_i = 0;
    y1_i = (x6 - x2) + 0.707 * ((x7 - x3) + (x5 - x1));
    y2_i = (x3 + x7) - (x1 + x5); 
    y3_i = (x2 - x6) + 0.707 * ((x7 - x3) + (x5 - x1)); 
    y4_i = 0;
    y5_i = (x6 - x2) + 0.707 * ((x1 - x5) + (x3 - x7)); 
    y6_i = (x1 + x5) - (x3 + x7);
    y7_i = (x2 - x6) + 0.707 * ((x1 - x5) + (x3 - x7));
    */

    // Layer 1 - From x to t
    SubAdder(fft8if.x0, fft8if.x4, t0, t1);
    SubAdder(fft8if.x2, fft8if.x6, t2, t3);
    SubAdder(fft8if.x3, fft8if.x7, t4, t5);
    SubAdder(fft8if.x1, fft8if.x5, t6, t7);
    
    isValid_stage1 = fft8if.isValid;

    // -----------------------------------------------------------------//
    

end

endmodule