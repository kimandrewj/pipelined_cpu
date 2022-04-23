`timescale 1ns / 10ps
module subtraction (B, out);
	input logic [63:0]B;
	output logic [63:0] out;
	logic [63:0] one, c;
	logic [63:0] tempOut;
	logic zero, overflow, carryout, negative;
	
	generate
		for (genvar x = 0; x < 64; x++) begin
			not #0.05 notGate (tempOut[x], B[x]); 
		end
	endgenerate
	
	assign one[63:0] = 1;
	addition adder (.A(tempOut), .B(one), .out(out), .zero(zero), .overflow(overflow), .carryOut(carryout),.negative(negative));
	
	
//	xor xorGate (out[0], tempOut[0], one[0]); 
//	and andGate (c[0], tempOut[0], one);
//	
//	generate
//		for (genvar x = 1; x < 64; x++) begin
//			xor xorGate1 (out[x], tempOut[x], c[x - 1]); 
//			and andGate1 (c[x], tempOut[x], c[x]);
//		end
//	endgenerate
	
endmodule
