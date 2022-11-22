`timescale 1ns/1ps
module spi_tb_top();

logic s_clk_w, slave_sel_w, new_byte_w, reset_w, mosi_w, miso_w, send_comp_w;
logic [7:0] mcu_out_w, data_to_mcu_w;

always #5 clk_w=~clk_w;

spi_interface si(.clk(clk_w), .s_clk(s_clk_w), .reset(reset_w), .mosi(mosi_w), .slave_sel(slave_sel_w), .new_byte(new_byte_w), .data_in(mcu_out_w), .miso(miso_w), .send_complete(send_comp_w),
.data_out(data_to_mcu_w));


spi_interface_tb stb(.send_complete(send_comp_w), .clk(clk_w), .s_clk(s_clk_w), .slave_sel(slave_sel_w), .new_byte(new_byte_w), .reset(reset_w), .master_out(mosi_w),
.mcu_out(mcu_out_w));

endmodule
