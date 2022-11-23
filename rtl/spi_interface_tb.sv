module spi_interface_tb(
input logic send_complete, clk, 
output logic s_clk, slave_sel, reset, master_out,
output logic [7:0] mcu_out);

logic last_send = 0;
logic [7:0] master_data = 8'h72;
logic [7:0] controller_data = 8'h66;
logic [2:0] counter;

assign master_out = master_data[counter];
assign mcu_out = controller_data;

initial begin
	counter = 3'd7;
	s_clk = 1;
	slave_sel = 1;
	reset = 1;
	#20
	reset = 0;
	#20
	
	
	//Single Byte Test
	slave_sel = 0;
	s_clk = 0;
	repeat(8)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	counter = 3'd7;
	#20
	s_clk = 1;
	slave_sel = 1;
	#80 // 2 s_clock cycles
	
	//Multiple Byte Test
	slave_sel = 0;
	s_clk = 0;
	repeat(8)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	counter = 3'd7;
	repeat(8)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	counter = 3'd7;
	#20
	s_clk = 1;
	slave_sel = 1;
	#80 // 2 s_clock cycles
	
	//Reset Interrupt Test
	slave_sel = 0;
	s_clk = 0;
	repeat(4)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	reset = 1;
	repeat(4)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	reset = 0;
	counter = 3'd7;
	#20
	s_clk = 1;
	slave_sel = 1;
	#80 // 2 s_clock cycles
	
	//Single Byte After Reset
	slave_sel = 0;
	s_clk = 0;
	repeat(8)
	begin
		#20
		s_clk = ~s_clk;//rising edge
		#20
		s_clk = ~s_clk;//falling edge
		counter = counter - 1'd1;
	end
	counter = 3'd7;
	#20
	s_clk = 1;
	slave_sel = 1;
	#80 // 2 s_clock cycles
	
	$finish;
end


//Simulating Main Controller Incrementing Outgoing Buffer
always @(send_complete) begin

	if(~send_complete && last_send) begin //falling edge of send_complete
		#10 //Simulating clock cycle
		last_send = 0;
	end
	else if (send_complete && ~last_send) begin //falling edge of send_complete
		#10 //Simulating clock cycle
		last_send = 1;
		controller_data = controller_data + 1'd1;
		master_data = master_data + + 1'd1;
	end
	
	
end
