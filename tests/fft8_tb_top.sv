`timescale 1ns/10ps

module fantastic_fft8_tb_top;
    logic clk = 0;
    always #5 clk = ~clk;

    fantasticfft_fft8_if fft8if(clk);

    fantasticfft_fft8 dut(fft8if.fft8_device);

    fantastic_fft8_tb t1(fft8if);
endmodule
