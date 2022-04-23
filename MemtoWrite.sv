module MemtoWrite(newMemout, oldMemout, clk);
	input logic [63:0] oldMemout;
	output logic [63:0] newMemout;
	input logic clk;
	always_ff @(posedge clk) begin
		newMemout <= oldMemout; 
	end
endmodule 