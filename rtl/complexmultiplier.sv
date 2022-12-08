`timescale 1ns/100ps

`include "rtl/fixedpoint.sv"

module complexmultiplier(
    input  logic clk,
    input  logic isValid,
    input  logic [5 : 0] start,
    input  logic [5 : 0] step,
    input  logic signed [15 : 0] x  [0 : 7],
    input  logic signed [15 : 0] xi [0 : 7],
    output logic signed [15 : 0] y  [0 : 7],
    output logic signed [15 : 0] yi [0 : 7],
    output logic resultValid
);

logic signed [15 : 0] c  [0 : 7];
logic signed [15 : 0] ci [0 : 7];

sine_lut sin (
    .start (start),
    .step  (step),
    .out   (c)
);

cosine_lut cos (
    .start (start),
    .step  (step),
    .out   (ci)
);

task BlockComplexMultiply(
    input  logic signed [15 : 0] x  [0 : 7],
    input  logic signed [15 : 0] xi [0 : 7],
    input  logic signed [15 : 0] c  [0 : 7],
    input  logic signed [15 : 0] ci [0 : 7],
    output logic signed [15 : 0] y  [0 : 7],
    output logic signed [15 : 0] yi [0 : 7]
);
    begin
        int j;
        for (j = 0; j < 8; j  = j + 1) begin
            ComplexMultiply(x[j], xi[j], c[j], ci[j], y[j], yi[j]);
        end
    end
endtask

task ComplexMultiply(input logic signed [15 : 0] a, ai, b, bi,
    output logic signed [15 : 0] c, ci);
    begin
        c  = a * b - ai * bi;
        ci = a * bi + b * ai;
    end
endtask

always_ff @( posedge clk ) begin : cm
    if (isValid === 1'b1) begin
        BlockComplexMultiply(x, xi, c, ci, y, yi);
    end
    resultValid <= isValid;
end

endmodule