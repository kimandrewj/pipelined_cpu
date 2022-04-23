`timescale 1ns/10ps

module threeBy8decoder (in, out, enabler) ;
	output logic [7:0] out;
	input logic [2:0] in;
	input enabler;
	logic [2:0] notin;
	
	not #0.05 firstNot(notin[2], in[2]);
	not #0.05 secondNot(notin[1], in[1]);
	not #0.05 thirdNot(notin[0], in[0]);
	
	and #0.05 firstAnd(out[7], in[0], in[1], in[2], enabler);
	and #0.05 secondAnd(out[6], notin[0], in[1], in[2], enabler);
	and #0.05 thirdAnd(out[5], in[0], notin[1], in[2], enabler);
	and #0.05 fourAnd(out[4], notin[0],notin[1], in[2], enabler);
	and #0.05 fiveAnd(out[3], in[0], in[1], notin[2], enabler);
	and #0.05 sixAnd(out[2], notin[0], in[1], notin[2], enabler);
	and #0.05 sevenAnd(out[1], in[0], notin[1], notin[2], enabler);
	and #0.05 eightAnd(out[0], notin[0], notin[1], notin[2], enabler);

endmodule

module threeBy8decoder_testbench();
	logic [7:0] out;
	logic [2:0] in;
	logic enabler;
	
	threeBy8decoder dut (.in, .out, .enabler);
	
	initial begin
		integer i;
		enabler = 1;
		for(i = 0; i < 8; i++) begin
			in = i;
			#10;
		end
	end
endmodule
