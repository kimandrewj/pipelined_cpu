module signExtend9(out, in);
	
	output logic [63:0] out;
	input logic [8:0] in;
	assign out[8:0] = in[8:0];
	generate 
		for( genvar x = 9; x < 64; x++)
			assign out[x] = in[8]; 
	endgenerate 
endmodule 