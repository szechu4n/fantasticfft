`timescale 1ns/100ps

module dft64 (
    input  logic clk,
    input  logic sreset,
    input  logic calculate,
    input  logic rel,
    input  logic [15 : 0] samples [0 : 7],
    output logic [15 : 0] realfft [0 : 7][0 : 7],
    output logic [15 : 0] imagfft [0 : 7][0 : 7],
    output logic done
);

logic [15 : 0] realt  [0 : 7];
logic [15 : 0] imagt  [0 : 7];

logic [15 : 0] realc  [0 : 7][0 : 7];
logic [15 : 0] imagc  [0 : 7][0 : 7];

logic [5 : 0]  starts [0 : 7];
logic [5 : 0]  steps  [0 : 7];
logic fft8_valid;
logic resultValid [0 : 7];

fantasticfft_fft8 fft8_(
    .clk         (clk),
    .isValid     (rel),
    .resultValid (fft8_valid),
    .x           (samples),
    .y           (realt),
    .yi          (imagt)
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin    
        complexmultiplier cm_ (
            .clk         (clk),
            .isValid     (fft8_valid),
            .start       (starts[i]),
            .step        (steps[i]),
            .x           (realt),
            .xi          (imagt),
            .y           (realc[i]),
            .yi          (imagc[i]),
            .resultValid (resultValid[i])
        );
    end
endgenerate

logic [3:0] j;
logic [3:0] k;
logic [3:0] l;
logic [3:0] counter;

always_ff @(clk) begin : control
    if (sreset === 1'b1) begin
        counter = 0;
        for (j = 0; j < 8; j = j + 1) begin
            starts[j]  = 0;
            steps[j]   = 0;
            for (k = 0; k < 8; k = k + 1) begin
                realfft[j][k] = 0;
                imagfft[j][k] = 0;
            end
        end
        done <= 1'b0;
    end else begin
        done <= 1'b0;

        if (rel) begin
            counter = counter + 1;
            if (counter < 8) begin
                for (j = 0; j < 8; j = j + 1) begin
                    starts[j] = counter * 8 * j;
                    steps[j]  = counter * j;
                end
            end else begin
                for (j = 0; j < 8; j = j + 1) begin
                    starts[j] = 0;
                    steps[j]  = 0;
                end
                done <= 1'b1;
            end
        end

        if (calculate) begin
            
            for (k = 0; k < 8; k = k + 1) begin
                if (resultValid[k]) begin
                    for (l = 0; l < 8; l = l + 1) begin
                        realfft[l][k] = realfft[l][k] + realc[l][k];
                        imagfft[l][k] = imagfft[l][k] + imagc[l][k];
                    end
                end
            end
        end
    end
end

endmodule