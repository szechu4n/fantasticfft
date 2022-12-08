module spi_interface(
input logic clk, s_clk, mosi, slave_sel, reset,
input logic [7:0] data_in,
output logic miso, send_complete,
output logic [7:0] data_out);

logic last_sel, miso_tri, miso_buf; 
logic [2:0] bit_counter;
logic [7:0] mosi_buf, in_buf;

assign miso = miso_tri ? miso_buf : 1'bz;
assign miso_buf = in_buf[bit_counter];//outgoing

always @(slave_sel, s_clk, reset)begin

	if(reset)begin
		miso_tri = 0;
		bit_counter = 3'd7;
		in_buf = 8'h00;
		last_sel = 1;
		send_complete = 0;
	end
	
	else if(slave_sel == 0)begin
		send_complete = 0;
		miso_tri = 1;
		if(last_sel) begin //negedge of slave select
			in_buf = data_in; //negedge of slave_sel, loading in first byte 
			last_sel = 0;
		end
		else begin
			if(s_clk) mosi_buf[bit_counter] = mosi;//posedge of s_clk, read incoming bit
			else if(!s_clk)  begin //s_clk negedge
				if(bit_counter == 3'd0) begin 
					bit_counter = 3'd7; //reset counter
					in_buf = data_in; //loading in subsequent byte for multiple byte transmission
					data_out = mosi_buf;
					send_complete = 1;
				end
				else bit_counter = bit_counter - 1'd1;//decrement bit to be read in/out
			end
		end
	end
	 
	else begin //Not selected/reset
		miso_tri = 0;
		bit_counter = 3'd7;
		last_sel = 1;
		send_complete = 0;
	end
end
endmodule