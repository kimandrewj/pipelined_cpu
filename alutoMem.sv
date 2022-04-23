module alutoMem (newData, oldData, clk);
	input logic [63:0] oldData;
	output logic [63:0] newData;
	input logic clk;
	always_ff @(posedge clk) begin
		newData <= oldData; 
	end
endmodule 