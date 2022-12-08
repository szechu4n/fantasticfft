interface fantasticfft_fft8_if #(
    // Determines size of integer component of fixed point
    parameter INT_SIZE   = 8,

    // Determines size of fractional component of fixed point
    parameter FRAC_SIZE  = 8
) (input logic clk);
    logic isValid, resultValid;

    logic [INT_SIZE + FRAC_SIZE - 1:0] x [0 : 7], y [0 : 7], yi [0 : 7];
    
endinterface