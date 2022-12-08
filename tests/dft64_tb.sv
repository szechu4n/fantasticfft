`timescale 1ns/10ps

// Andrew Sweeney
// CPE 527 Lab 004
// Multiplier Test Bench

`include "rtl/fixedpoint.sv"

module dft64_tb (
    dft64_if dft64if
);

int iterator;
int timeout = 0;

logic [15 : 0] samples [0 : 63];
int n, nn;
int fd;

initial begin
    $display("-----------------------------------------------------------------");
    $display("Beginning test...");

    $display("\tCreating samples for 1 kHz sine wave sampled at 48 kHz...");
    for (n = 0; n < 64; n = n + 1) begin
        samples[n] = $sin(2 * 3.1415926 * 1000 * n / 48000) * 2**8;
    end       
    $display("\tCreated samples.");

    $display("\tResetting dft64 module...");
    dft64if.sreset = 1'b1;
    @(posedge dft64if.clk);
    #1step;
    dft64if.sreset    = 1'b0;
    dft64if.calculate = 1'b1;
    $display("\tReset dft64 module.");

    $display("Starting test...");
    for (n = 0; n < 64; n = n + 8) begin
        $display("\tTest in progress, sample set %d clocking in...", n / 8);
        dft64if.samples = { samples[n],
                            samples[n + 1],
                            samples[n + 2],
                            samples[n + 3],
                            samples[n + 4],
                            samples[n + 5],
                            samples[n + 6],
                            samples[n + 7] };
        dft64if.rel = 1'b1;
        @(posedge dft64if.clk);
        #1step;
    end
    $display("\tAll samples clocked in.");

    fd= $fopen("results.csv", "w");
    while (dft64if.done !== 1'b1 && timeout < 6) begin
        timeout = timeout + 1;
        @(posedge dft64if.clk);
        #1step;
        $fwrite(fd, "%d,%d", timeout, dft64if.done);
        for (n = 0; n < 64; n = n + 1) begin
            for (nn = 0; nn < 64; nn = nn + 1) begin
                $fwrite(fd, "%d,", dft64if.realfft[nn][n]);
                $fwrite(fd, "%d,", dft64if.imagfft[nn][n]);
            end
        end
        $fwrite(fd, "\n");
    end

    if (timeout >= 6) begin
        $display("\tERROR: DFT64 failed to produce a valid result under the timeout.");
    end else begin
        $display("\tDesign produced a result in %d cycles.", timeout + (n / 8));        
    end
    $fclose(fd);
    $finish();
end
endmodule
