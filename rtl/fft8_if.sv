interface fantasticfft_fft8_if #(
    // Determines size of integer component of fixed point
    parameter INT_SIZE   = 8,

    // Determines size of fractional component of fixed point
    parameter FRAC_SIZE  = 8
) (input logic clk);
    logic isValid, resultValid;

    logic [INT_SIZE + FRAC_SIZE - 1:0] 
        x0, x1, x2, x3, x4, x5, x6, x7,
        y0, y1, y2, y3, y4, y5, y6, y7,
        y0_i, y1_i, y2_i, y3_i, y4_i, y5_i, y6_i, y7_i;

    modport fft8_device (
        input clk, isValid,
            x0, x1, x2, x3, x4, x5, x6, x7,
        output y0, y1, y2, y3, y4, y5, y6, y7,
            y0_i, y1_i, y2_i, y3_i, y4_i, y5_i, y6_i, y7_i, 
            resultValid
    );
    // input  logic clk,
    // input  logic isValid,
    // output logic resultValid, 

    // // 8 point FFT inputs
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x0,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x1,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x2,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x3,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x4,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x5,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x6,
    // input logic [INT_SIZE - 1 : -FRAC_SIZE] x7,

    // // 8 point FFT real outputs
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y0,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y1,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y2,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y3,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y4,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y5,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y6,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y7,

    // // 8 point FFT imaginary outputs
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y0_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y1_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y2_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y3_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y4_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y5_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y6_i,
    // output logic [INT_SIZE - 1 : -FRAC_SIZE] y7_i
    
endinterface