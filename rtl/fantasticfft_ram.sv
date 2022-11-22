module ram
#(parameter data_width = 16, data_depth = 8)
(
input logic clk, reset, read_write,
input logic [data_depth-1:0] address,
output logic bus_clr,
inout [data_width-1:0] data_bus);
typedef enum logic [1:0] {RESET, READ, WRITE} e_state;
e_state state;

logic in_out_tri;
logic [data_width-1:0] data_buffer;
logic [data_width-1:0] memory [data_depth-1:0];

assign data_bus = in_out_tri ? data_buffer : {data_width'('bz)};

always @(posedge clk) begin
	if(reset) begin
		state = RESET;
	end
	else begin
		case(read_write)
			0: state = READ;
			1: state = WRITE;
		endcase;
	end
end


always @(posedge clk) begin
	case(state)
		RESET: begin
      in_out_tri = 0;
			for(int i=0; i<data_depth;i++) begin
				memory[i] = {data_width'('h0)};
			end
		end
		READ: begin
      data_buffer = memory[address];
      bus_clr = 0;
      in_out_tri = 1;
    end
		WRITE: begin
       memory[address] = data_bus; //Last value on bus before read_write goes low gets stored
       bus_clr = 1; //Writing module should not drive bus until bus_clr is received
       in_out_tri = 0;
     end
	endcase;
end

endmodule

