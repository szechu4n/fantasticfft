`timescale 1ns/10ps

module fantastic_fft8_tb_top;
    logic clk = 0;
    always #5 clk = ~clk;

    fantasticfft_fft8_if fft8if(clk);

    fantasticfft_fft8 dut(
        .clk     (fft8if.clk),
        .isValid (fft8if.isValid),
        .x       (fft8if.x),
        .y       (fft8if.y),
        .yi      (fft8if.yi)
    );

    fantastic_fft8_tb t1(fft8if);
endmodule
