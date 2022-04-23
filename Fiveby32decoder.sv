module Fiveby32decoder (finalIn, finalOut, enabler) ;
	output logic [31:0] finalOut;
	input logic [4:0] finalIn;
	input enabler;
	
	logic [3:0] finalEnabler;
	twoBy4decoder twoByFourOne (.in(finalIn[4:3]), .out(finalEnabler[3:0]), .enabler(enabler));
	
	//uses 4 3x8 decoders to create 5X32 decoder and uses the output of 2X4 decoder as 3 X 8 enablers.
	threeBy8decoder threeByEightOne (.in(finalIn[2:0]), .out(finalOut[7:0]), .enabler(finalEnabler[0]));
	threeBy8decoder threeByEightTwo (.in(finalIn[2:0]), .out(finalOut[15:8]), .enabler(finalEnabler[1]));
	threeBy8decoder threeByEightThree (.in(finalIn[2:0]), .out(finalOut[23:16]), .enabler(finalEnabler[2]));
	threeBy8decoder threeByEightFour (.in(finalIn[2:0]), .out(finalOut[31:24]), .enabler(finalEnabler[3]));

endmodule

`timescale 1ns/10ps

module Fiveby32decoder_testbench();
	logic [31:0] finalOut;
	logic [4:0] finalIn;
	logic enabler;
	Fiveby32decoder dut (.finalIn, .finalOut, .enabler);
	
	initial begin
		integer i;
		enabler = 1;
		for(i = 0; i < 32; i++) begin
			finalIn = i;
			#10;
		end
		enabler = 0;
		for(i = 0; i < 32; i++) begin
			finalIn = i;
			#10;
		end
	end
endmodule 