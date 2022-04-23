module PC(in, out, clk, reset);
	input logic [63:0] in;
	output logic [63:0] out;
	input logic clk, reset;
	
	generate
		for(genvar x =0; x<64; x++)
			D_FF flip(.q(out[x]), .d(in[x]), .reset(reset), .clk(clk));
	endgenerate
endmodule

module PC_testbench();

endmodule 