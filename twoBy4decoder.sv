`timescale 1ns/10ps

module twoBy4decoder (in, out, enabler);
	output logic [3:0] out;
	input logic [1:0] in;
	input enabler;
	logic [1:0] notin;
	
	not #0.05 firstNot(notin[1], in[1]);
	not #0.05 secondNot(notin[0], in[0]);
	
	and #0.05 firstAnd(out[3], in[0], in[1], enabler);
	and #0.05 secondAnd(out[2], notin[0], in[1], enabler);
	and #0.05 thirdAnd(out[1], in[0], notin[1], enabler);
	and #0.05 fourAnd(out[0], notin[0], notin[1], enabler);
endmodule

module twoBy4decoder_testbench();
	logic [3:0] out;
	logic [1:0] in;
	logic enabler;
	
	twoBy4decoder dut (.in, .out, .enabler);
	
	initial begin
		integer i;
		enabler = 1;
		for(i = 0; i < 4; i++) begin
			in = i;
			#10;
		end
	end
endmodule 