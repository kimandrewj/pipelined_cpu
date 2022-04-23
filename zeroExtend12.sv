module zeroExtend12(out, in);
	output logic [63:0] out;
	input logic [11:0] in;
	assign out[11:0] = in[11:0];
	assign out[63:12] = 0;
endmodule
