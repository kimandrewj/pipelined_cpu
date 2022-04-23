//sets out = B
module resultB (B, out, zero, overflow, carryOut, negative);
	input logic [63:0] B;
	output logic [63:0] out;
	output logic zero, overflow, carryOut, negative;
	
	assign overflow = 0;
	assign carryOut = 0;
	
	//sets all out bits = B bits
	generate
		for (genvar x = 0; x < 64; x++) begin
			assign out[x] = B[x];
		end
	endgenerate
	
	assign negative = B[63];
	
	zeroCase orZero (.out(zero), .inputs(out));
endmodule
