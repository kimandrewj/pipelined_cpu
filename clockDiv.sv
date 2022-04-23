module clockDiv (clkIn, clkOut);
	input logic clkIn;
	output logic [31:0] clkOut = 0;
	
	always_ff @(posedge clkIn) begin
		clkOut <= clkOut + 1;
	end
endmodule
