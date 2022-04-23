module signExtend19(out, in);
	output logic [63:0] out;
	input logic [18:0] in;
	assign out[18:0] = in[18:0];
	generate 
		for( genvar x = 19; x < 64; x++)
			assign out[x] = in[18]; 
	endgenerate 
endmodule
