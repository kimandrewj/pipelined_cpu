//module that does the logic for both addition and subtraction for the alu
//if control = 0, ouput = A + B
//if cotrol = 1, output = A -B
`timescale 1ns / 10ps
module addition (A, B, out, zero, overflow, carryOut, negative, control);
	input logic [63:0] A, B;
	output logic [63:0] out;
	output logic zero, overflow, carryOut, negative;
	input logic control;
	
	logic [63:0] notB, usedB;
	
	///comment create not B
	generate
		for(genvar x=0; x<64; x++)  begin
			not #0.05 notgateB (notB[x], B[x]);
		end
	endgenerate 
	
	
	//figure out what usedB is based on whether its addition or subtraction
	generate
		for(genvar x=0; x<64; x++)  begin
			mux2by1 mux1 (.out(usedB[x]), .ins({notB[x],B[x]}), .sel(control));
		end
	endgenerate 
	
	logic carryI, carryO;

	logic [63:0] carries;
	logic [63:0] o, o1, o2;
	
	//logic for the first case output[0]
	xor #0.05 xorGate1 (o[0], A[0], usedB[0]);
	xor #0.05 xorGate2 (out[0], o[0], control); 
	and #0.05 andGate1 (o1[0], A[0],  usedB[0]);
	and #0.05 andGate2 (o2[0], control, o[0]);
	or  #0.05 orGate (carries[0], o1[0], o2[0]);
	
	// logic for the output[63:1] , determine the overflow and carryout
	generate
		for (genvar x = 1; x < 64; x++) begin
			xor #0.05 xorGate3 (o[x], A[x],  usedB[x]);
			xor #0.05 xorGate4 (out[x], o[x], carries[x-1]);
			and #0.05 andGate3 (o1[x], A[x],  usedB[x]);
			and #0.05 andGate4 (o2[x], carries[x-1], o[x]);
			or  #0.05 orGate1 (carries[x], o1[x], o2[x]);
		end
	endgenerate

	//calls zerocase module to determine if out ==0
	zeroCase orZero (.out(zero), .inputs(out));
	
	//determines overflow, negative, or carryOut
	xor #0.05 xorGate5 (overflow, carries[62], carries[63]);
	assign negative = out[63];
	assign carryOut = carries[63];

endmodule

module addition_testbench();
	logic [63:0] A, B;
	logic [63:0] out;
	logic zero, overflow, carryOut, negative;	

	addition dut (.A, .B, .out, .zero, .overflow, .carryOut, .negative);
	
	initial begin
		A = 0; B = 0; #10;
		A = 2; B = 3; #10;
		
		A = 0; B = 1; #10;
		
		A = 1; B = 0; #10;
		
		A = 1; B = 1; #10;
		
		A = 15; B = 15; #10;
		
		A = 255; B = 256; #10;
		
		A = 255; B = 256; #10;
		
		A = 64'h8000000000000000; B = 64'h8000000000000000; #10;
	end
endmodule





