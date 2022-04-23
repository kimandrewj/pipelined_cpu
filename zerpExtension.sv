module zeroExtension(in, out);
	input logic [8:0] in;
	output logic [63:0] out;
	
	generate
		for (genvar i = 0; i < legnth of in?; i++)
			out[i] = in[i];
		for (genvar i = legnth of in?; i < 64; i++)
			out[i] = 0;
	endgenerate
endmodule
