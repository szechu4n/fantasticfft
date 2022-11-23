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
        input clk, isValid, resultValid,
            x0, x1, x2, x3, x4, x5, x6, x7,
        output y0, y1, y2, y3, y4, y5, y6, y7,
            y0_i, y1_i, y2_i, y3_i, y4_i, y5_i, y6_i, y7_i
    );
    
endinterface