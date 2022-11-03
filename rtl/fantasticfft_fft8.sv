module fantasticfft_fft8 #(
    parameter INPUT_SIZE = 8,
    parameter K = 0,
    parameter N = 8
)(
    input  logic clk,

    input logic [INPUT_SIZE - 1 : 0] x0,
    input logic [INPUT_SIZE - 1 : 0] x1,
    input logic [INPUT_SIZE - 1 : 0] x2,
    input logic [INPUT_SIZE - 1 : 0] x3,
    input logic [INPUT_SIZE - 1 : 0] x4,
    input logic [INPUT_SIZE - 1 : 0] x5,
    input logic [INPUT_SIZE - 1 : 0] x6,
    input logic [INPUT_SIZE - 1 : 0] x7,

    output logic [INPUT_SIZE - 1 : 0] y0,
    output logic [INPUT_SIZE - 1 : 0] y1,
    output logic [INPUT_SIZE - 1 : 0] y2,
    output logic [INPUT_SIZE - 1 : 0] y3,
    output logic [INPUT_SIZE - 1 : 0] y4,
    output logic [INPUT_SIZE - 1 : 0] y5,
    output logic [INPUT_SIZE - 1 : 0] y6,
    output logic [INPUT_SIZE - 1 : 0] y7
);

///////////////////////////////////////////////////
// Layer 0
///////////////////////////////////////////////////

logic [INPUT_SIZE - 1 : 0] t0, t1, t2, t3, t4, t5, t6, t7;
logic [INPUT_SIZE - 1 : 0] m0, m1, m2, m3, m4, m5, m6, m7;
logic [INPUT_SIZE - 1 : 0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9;
logic [INPUT_SIZE - 1 : 0] cm0, cm1;

localparam CONSTANT = 0.707;

butterfly1 layer0_bf1_0_4(
    .x0(x0),
    .x1(x4),
    .y0(t0),
    .y1(t1)
);

butterfly1 layer0_bf1_2_6(
    .x0(x2),
    .x1(x6),
    .y0(t2),
    .y1(t3)
);

butterfly1 layer0_bf1_1_5(
    .x0(x1),
    .x1(x5),
    .y0(t4),
    .y1(t5)
);

butterfly1 layer0_bf1_3_7(
    .x0(x3),
    .x1(x7),
    .y0(t6),
    .y1(t7)
);


// Layer 1
butterfly1 layer1_bf1_0_2(
    .x0 (t0),
    .x1 (t2),
    .y0 (m0),
    .y1 (m1)
);

butterfly2 layer1_bf2_1_3(
    .x0    (t1),
    .x1    (t3),
    .r     (m2),
    .i     (),
    .i_neg ()
);

butterfly1 layer1_bf1_4_6(
    .x0 (t4),
    .x1 (t6),
    .y0 (m3),
    .y1 (m4)
);

butterfly2 layer1_bf2_5_7(
    .x0    (t5),
    .x1    (t7),
    .r     (m5),
    .i     (m6),
    .i_neg (m7)
);

// Delay layer

always_ff @( posedge clk ) begin : delay_and_multipliers
    d0 <= m0;
    d1 <= m1;

    d2 <= m2;
    d3 <= m2;

    d4 <= m3;
    d5 <= m4;

    d6 <= m5 + m6;
    d7 <= m5 + m7; // whats the right sign here?
end

always_comb begin : constant_multiplier
    cm0 = d6 * CONSTANT;
    cm1 = d7 * CONSTANT;
end

// Final Layer

butterfly1 layer2_bf1_0_4(
    .x0 (d0),
    .x1 (d4),
    .y0 (y0),
    .y1 (y4)
);

butterfly1 layer2_bf1_2_6(
    .x0 (d2),
    .x1 (cm0),
    .y0 (y1),
    .y1 (y5)
);

butterfly2 layer2_bf2_5_7(
    .x0    (d1),
    .x1    (d5),
    .r     (y2),
    .i     (y6),
    .i_neg ()
);

butterfly1 layer2_bf1_1_5(
    .x0 (d3),
    .x1 (cm1),
    .y0 (y3),
    .y1 (y7)
);
    
endmodule

module butterfly1 #(
    parameter INPUT_SIZE = 8,
    parameter K = 0,
    parameter N = 8
)(
    input  signed [INPUT_SIZE - 1 : 0] x0,
    input  signed [INPUT_SIZE - 1 : 0] x1,

    output signed [INPUT_SIZE - 1 : 0] y0,
    output signed [INPUT_SIZE - 1 : 0] y1
    
);
    
endmodule

module butterfly2 #(
    parameter INPUT_SIZE = 8,
    parameter K = 0,
    parameter N = 8
)(
    input  signed [INPUT_SIZE - 1 : 0] x0,
    input  signed [INPUT_SIZE - 1 : 0] x1,

    output signed [INPUT_SIZE - 1 : 0] r,
    output signed [INPUT_SIZE - 1 : 0] i,
    output signed [INPUT_SIZE - 1 : 0] i_neg
);
    
endmodule
