module fantasticfft_fft8 #(
    parameter INPUT_SIZE = 8,
    parameter K = 0,
    parameter N = 8
)(
    input  logic clk,

    input logic [INPUT_SIZE - 1 : 0] x0,
    input logic [INPUT_SIZE - 1 : 0] x1,
    input logic [INPUT_SIZE - 1 : 0] x2,
    input logic [INPUT_SIZE - 1 : 0] x3,
    input logic [INPUT_SIZE - 1 : 0] x4,
    input logic [INPUT_SIZE - 1 : 0] x5,
    input logic [INPUT_SIZE - 1 : 0] x6,
    input logic [INPUT_SIZE - 1 : 0] x7,

    output logic [INPUT_SIZE - 1 : 0] y0,
    output logic [INPUT_SIZE - 1 : 0] y1,
    output logic [INPUT_SIZE - 1 : 0] y2,
    output logic [INPUT_SIZE - 1 : 0] y3,
    output logic [INPUT_SIZE - 1 : 0] y4,
    output logic [INPUT_SIZE - 1 : 0] y5,
    output logic [INPUT_SIZE - 1 : 0] y6,
    output logic [INPUT_SIZE - 1 : 0] y7,

    output logic [INPUT_SIZE - 1 : 0] y0_i,
    output logic [INPUT_SIZE - 1 : 0] y1_i,
    output logic [INPUT_SIZE - 1 : 0] y2_i,
    output logic [INPUT_SIZE - 1 : 0] y3_i,
    output logic [INPUT_SIZE - 1 : 0] y4_i,
    output logic [INPUT_SIZE - 1 : 0] y5_i,
    output logic [INPUT_SIZE - 1 : 0] y6_i,
    output logic [INPUT_SIZE - 1 : 0] y7_i
);

always_ff @( posedge clk ) begin : fft8

    // x1 - x5
    // x1 + x5

/*
    y0   = sum(x); //a+b+c+d+e+f+g+h;
    y0_i = 0;
    
    y1   = (x(1) - x(5)) + 0.707 * (x(2) - x(6) + x(8) - x(4)); // (a-e)+p*(b-f+h-d); -- matches line y7
    y1_i = x(7) - x(3) + 0.707 * (x(8) - x(4) - x(2) + x(6));   // (g-c)+p*(h-d-b+f);
    
    y2   = x(1) + x(5) - x(7) - x(3); // a+e-g-c; -- matches line y6
    y2_i = x(4) + x(8) - x(2) - x(6); // d+h-b-f;
    
    y3   = (x(1) - x(5)) + 0.707 * (x(6) - x(2) + x(4) - x(8)); // (a-e)+p*(f-b+d-h); -- matches line y5
    y3_i = (x(3) - x(7)) + 0.707 * (x(8) + x(6) - x(2) - x(4)); // (c-g)+p*(h+f-b-d);
    
    y4   = x(1) + x(5) + x(3) + x(7) - x(2) - x(6) - x(4) - x(8); //a+e+c+g-b-f-d-h;
    y4_i = 0;
    
    y5   = (x(1) - x(5)) + 0.707 * (x(6) - x(2) + x(4) - x(8)); // (a-e)+p*(f-b-h+d);
    y5_i = (x(7) - x(3)) + 0.707 * (x(2) + x(4) - x(8) - x(6)); // (g-c)+p*(b+d-h-f);
    
    y6   = x(1) + x(5) - x(7) - x(3); // a+e-g-c;
    y6_i = x(2) + x(6) - x(4) - x(8); // b+f-d-h;
    
    y7   = (x(1) - x(5)) + 0.707 * (x(2) - x(6) + x(8) - x(4)); // (a-e)+p*(b+h-f-d);
    y7_i = (x(3) - x(7)) + 0.707 * (x(2) + x(4) - x(8) - x(6)); // (c-g)+p*(b+d-h-f);

*/
end
    
endmodule


module sum_diff_adder #(
    parameter INPUT_SIZE = 8
) (
    input logic [INPUT_SIZE - 1 : 0] a,
    input logic [INPUT_SIZE - 1 : 0] b,

    output logic [INPUT_SIZE - 1 : 0] c,
    output logic [INPUT_SIZE - 1 : 0] c_neg
);

logic [INPUT_SIZE - 1 : 0] temp;

always_comb begin : adder
    temp  = a + b;
    c     <= temp;
    c_neg <= ~temp + 1;
end
    
endmodule