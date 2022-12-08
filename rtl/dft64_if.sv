interface dft64_if #(
    // Determines size of integer component of fixed point
    parameter INT_SIZE   = 8,

    // Determines size of fractional component of fixed point
    parameter FRAC_SIZE  = 8
) (input logic clk);
    logic sreset, calculate, rel, done;
    logic [15 : 0] samples [0 : 7];
    logic [15 : 0] realfft [0 : 7][0 : 7], imagfft [0 : 7][0 : 7];    
endinterface