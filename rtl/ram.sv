module ram
#(parameter data_width = 16, data_depth = 8)
(
  input logic read_write, reset,
  input logic [data_depth-1:0] address,
  input logic [data_width-1:0] in_data,
  output logic [data_width-1:0] out_data
);


logic [data_width-1:0] memory [data_depth-1:0];

always @(posedge read_write) begin
  memory[address] = in_data;
end

always @(address, read_write) begin
  if(~read_write)out_data = memory[address];
end


endmodule

