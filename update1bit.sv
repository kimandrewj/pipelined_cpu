module update1bit(dataIn, dataOut, clk, reset);
	input logic dataIn;
	output logic dataOut;
	input logic clk, reset;
	
	
	logic tempIn;
	// update 1 bit input
	mux2_1 inmux (.out(tempIn), .i0(dataIn), .i1(0), .sel(reset));
	D_FF instrcutionDFF (.q(dataOut), .d(tempIn), .reset(reset), .clk(clk));
endmodule 