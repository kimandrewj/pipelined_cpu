`timescale 1ns / 10ps
//determines out = A & B
module aAndB (A, B, out, zero, overflow, carryOut, negative);
	input logic [63:0] A, B;
	output logic [63:0] out;
	output logic zero, overflow, carryOut, negative;
	
	assign overflow = 1'b0;
	assign carryOut = 1'b0;
	
	//creates 64 and gates
	generate
		for (genvar x = 0; x < 64; x++) begin
			and #0.05 andGate (out[x], A[x], B[x]);
		end
	endgenerate
	
	//determintes if out is 0 or negative
	assign negative = out[63];
	zeroCase orZero (.out(zero), .inputs(out));
endmodule

module aAndB_testbench();
	
	logic [63:0] A, B;
	logic [63:0] out;
	logic zero, overflow, carryOut, negative;	

	aAndB dut (.A, .B, .out, .zero, .overflow, .carryOut, .negative);
	
	initial begin
		A = 0; B = 0; #10;
		
		
		A = 0; B = 1; #10;
		
		A = 1; B = 0; #10;
		
		A = 1; B = 1; #10;
		A = 3; B = 3; #10;
		A = 4; B = 3; #10;
		A = 10; B=15; #10;
		A = 7723; B = 4135; #10;
		A= 200412; B= 312456; #10;
	end
endmodule
