`timescale 1ns/10ps

module dft64_tb_top;
    logic clk = 0;
    always #5 clk = ~clk;

    dft64_if dft64if(clk);

    dft64 dut(
        .clk       (dft64if.clk),
        .sreset    (dft64if.sreset),
        .calculate (dft64if.calculate),
        .rel       (dft64if.rel),
        .done      (dft64if.done),
        .samples   (dft64if.samples),
        .realfft   (dft64if.realfft),
        .imagfft   (dft64if.imagfft)
    );

    dft64_tb t1(dft64if);
endmodule
