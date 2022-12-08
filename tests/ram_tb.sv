import mine::*;

module ram_tb
#(parameter data_width = 16, data_depth = 8)(
input logic bus_clr,
output logic reset, read_write,
output logic [data_depth-1:0] address,
inout [data_width-1:0] data_bus);


logic in_out_tri;
logic [data_width-1:0] data_buffer;	
logic [data_width-1:0] last_val, val;
logic [data_depth-1:0] last_addr,read_addr,addr;

assign data_bus = in_out_tri ? data_buffer : {data_width'('bz)};


RAM_Values v;
initial begin
		last_addr = {data_width'('b0)};
		read_addr = {data_width'('b0)};
		v=new();
		reset=1;
		#20;
		reset=0;
		repeat(10)
		begin
			//Writing into new address each round and then reading the previously written to addresss
			#20;
			in_out_tri = 0;
			v.randomize();
			addr = v.addr;
			val = v.value;
			read_write = 1;
			@(posedge bus_clr);
      address = addr;
      last_addr = address;
			data_buffer = val;
			in_out_tri = 1;
			#20;
      in_out_tri = 0;
      read_write = 0;
     	@(negedge bus_clr);
			address = read_addr;
			#20;
      read_addr = last_addr;
		end
  	$finish;
	end

endmodule	