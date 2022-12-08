module datagen;
    
logic [15 : 0] samples [0 : 63];
int n;


initial begin
    for (n = 0; n < 64; n = n + 1) begin
        samples[n] = $sin(2 * 3.1415926 * 1000 * n / 48000) * 2**8;
    end
end

endmodule