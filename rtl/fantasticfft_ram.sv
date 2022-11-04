module ram
#(parameter data_width = 8, data_depth = 16)
(
input logic clk, reset, read_write,
input logic [data_depth-1:0] address,
inout [data_width-1:0] data_bus);
typedef enum logic [1:0] {RESET, READ, WRITE} e_state;
e_state state;

logic in_out_tri;
logic [data_width-1:0] data_buffer;
logic [data_depth-1:0] memory [data_width-1:0];

assign data_bus = in_out_tri ? data_buffer : {data_width'('bz)};

always @(posedge clk) begin
	if(reset) begin
		state = RESET;
		in_out_tri = 0;
	end
	else begin
		case(read_write)
			0: begin
				state = READ;
				in_out_tri = 1;
			end
			1: begin
				state = WRITE;
				in_out_tri = 0;
			end
		endcase;
	end
end


always @(posedge clk) begin
	case(state)
		RESET: begin
			for(int i=0; i<data_depth;i++) begin
				memory[i] = {data_width'('h0)};
			end
		end
		READ: data_buffer = memory[address];
		WRITE: memory[address] = data_buffer;
	endcase;
end

endmodule
