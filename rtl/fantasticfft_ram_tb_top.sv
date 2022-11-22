`timescale 1ns/1ps
module ram_tb_top();

logic clk_w, bus_clr_w, reset_w, rw_w;
logic [8-1:0] address_w;
logic [16-1:0] data_bus_W;


ram_tb tb(.bus_clr(bus_clr_w), .reset(reset_w), .read_write(rw_w), .address(address_w), .data_bus(data_bus_w));
ram r( .clk(clk_w), .reset(reset_w), .read_write(rw_w), .address(address_w), .bus_clr(bus_clr_w), .data_bus(data_bus_w));

always #5 clk_w=~clk_w;

endmodule
