//alu is the head file where a 64 bit alu does all the logic: addition, subtraction ,setter, and, or, xor
module alu  (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic [7:0] tempInput;
	logic [7:0][63:0] outputs;
	logic [7:0] negativeA, zeroA, overflowA, carry_outA;
	logic [63:0] notB;
	
	
	//sets output = B
	resultB case000 (.B(B), .out(outputs[0][63:0]), .zero(zeroA[0]), .overflow(overflowA[0]), 
		.carryOut(carry_outA[0]), .negative(negativeA[0]));
	
	//useless case
	assign outputs[1][63:0] = 0;
	assign zeroA[1] = 0;
	assign overflowA[1] = 0;
	assign carry_outA[1] = 0;
	assign negativeA[1] = 0;

	//output = A + B
	addition case010 (.A(A), .B(B), .out(outputs[2][63:0]), .zero(zeroA[2]), .overflow(overflowA[2]), 
		.carryOut(carry_outA[2]), .negative(negativeA[2]), .control(1'b0));
		
	//ouput = A-B
	addition case011 (.A(A), .B(B), .out(outputs[3][63:0]), .zero(zeroA[3]), .overflow(overflowA[3]), 
		.carryOut(carry_outA[3]), .negative(negativeA[3]), .control(1'b1));

	//output= A & B
	aAndB case100 (.A(A), .B(B), .out(outputs[4][63:0]), .zero(zeroA[4]), .overflow(overflowA[4]), 
		.carryOut(carry_outA[4]), .negative(negativeA[4]));
	//output= A | B
	aOrB case101 (.A(A), .B(B), .out(outputs[5][63:0]), .zero(zeroA[5]), .overflow(overflowA[5]), 
		.carryOut(carry_outA[5]), .negative(negativeA[5]));	
	//output= A ^ B
	aXorB case110 (.A(A), .B(B), .out(outputs[6][63:0]), .zero(zeroA[6]), .overflow(overflowA[6]), 
		.carryOut(carry_outA[6]), .negative(negativeA[6]));	
	//useless case
	assign outputs[7][63:0] = 0;
	assign zeroA[7] = 0;
	assign overflowA[7] = 0;
	assign carry_outA[7] = 0;
	assign negativeA[7] = 0;
	
	//selectors for zero, overflow, carryout, and negative
	mux8by1 zeroMux (.out(zero), .ins(zeroA), .sel(cntrl));
	mux8by1 overflowMux (.out(overflow), .ins(overflowA), .sel(cntrl));
	mux8by1 carryOutMux (.out(carry_out), .ins(carry_outA), .sel(cntrl));
	mux8by1 negativeMux (.out(negative), .ins(negativeA), .sel(cntrl));
	
	//selecter for the output
	mux64_8by1 outputMux(.out(result), .ins(outputs), .sel(cntrl));
endmodule 