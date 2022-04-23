module signExtend26(out, in);
	output logic [63:0] out;
	input logic [25:0] in;
	assign out[25:0] = in[25:0];
	generate 
		for( genvar x = 26; x < 64; x++)
			assign out[x] = in[25]; 
	endgenerate 
endmodule
