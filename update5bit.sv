module update5bit(dataIn, dataOut, clk, reset);
	input logic [4:0] dataIn;
	output logic [4:0] dataOut;
	input logic clk, reset;
	
	// update 5 bit input
	logic [4:0] tempIn;
	generate 
		for( genvar x = 0; x < 5; x++) begin
			mux2_1 inmux (.out(tempIn[x]), .i0(dataIn[x]), .i1(0), .sel(reset));
		end
	endgenerate
	
	generate
		for(genvar x =0 ; x <5; x++) begin
			D_FF instrcutionDFF (.q(dataOut[x]), .d(tempIn[x]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule 