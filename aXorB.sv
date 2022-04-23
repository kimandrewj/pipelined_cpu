`timescale 1ns / 10ps
//determines logic for out = A ^ B
module aXorB (A, B, out, zero, overflow, carryOut, negative);
	input logic [63:0] A, B;
	output logic [63:0] out;
	output logic zero, overflow, carryOut, negative;
	
	assign overflow = 1'b0;
	assign carryOut = 1'b0;
	
	//creates 64 xor gates 
	generate
		for (genvar x = 0; x < 64; x++) begin
			xor #0.05 xorGate (out[x], A[x], B[x]);
		end
	endgenerate
	
	//determines if out is negative or zero
	assign negative = out[63];
	zeroCase orZero (.out(zero), .inputs(out));
endmodule 

module aXorB_testbench();
	
	logic [63:0] A, B;
	logic [63:0] out;
	logic zero, overflow, carryOut, negative;	

	aXorB dut (.A, .B, .out, .zero, .overflow, .carryOut, .negative);
	
	initial begin
		A = 0; B = 0; #10;
		
		
		A = 0; B = 1; #10;
		
		A = 1; B = 0; #10;
		
		A = 1; B = 1; #10;
		
		A = 15; B = 15; #10;
		
		A = 255; B = 256; #10;
		
	end
endmodule
