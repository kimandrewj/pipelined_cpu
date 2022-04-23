`timescale 1ns / 10ps
//determines the logic out = A | B
module aOrB (A, B, out, zero, overflow, carryOut, negative);
	input logic [63:0] A, B;
	output logic [63:0] out;
	output logic zero, overflow, carryOut, negative;
	
	assign overflow = 1'b0;
	assign carryOut = 1'b0;
	
	//creates 64 or gates to set the logic 
	generate
		for (genvar x = 0; x < 64; x++) begin
			or #0.05 orGate (out[x], A[x], B[x]);
		end
	endgenerate
	
	//determines if out is zero or negative
	assign negative = out[63];
	zeroCase orZero (.out(zero), .inputs(out));
endmodule 


module aOrB_testbench();
	
	logic [63:0] A, B;
	logic [63:0] out;
	logic zero, overflow, carryOut, negative;	

	aOrB dut (.A, .B, .out, .zero, .overflow, .carryOut, .negative);
	
	initial begin
		A = 0; B = 0; #10;
		
		A = 1; B = 0; #10;
		
		A = 0; B = 1; #10;
		
		A = 1; B = 1; #10;
		
		A = 2; B = 0; #10;
	end
endmodule
