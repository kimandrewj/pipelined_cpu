module updateInstructionandCheck(in, inC, out, outC, clk, reset);
	input logic [31:0] in;
	output logic [31:0] out;
	input logic clk, reset;
	input logic [10:0] inC; //check for CPU
	output logic [10:0] outC;
	
	logic [31:0] tempout;
	logic [10:0] tempoutC;
	generate 
		for( genvar x = 0; x < 32; x++) begin
			mux2_1 inmux (.out(tempout[x]), .i0(in[x]), .i1(0), .sel(reset));
		end
	endgenerate
	generate
		for( genvar x = 0; x < 11; x++) begin
			mux2_1 inmux (.out(tempoutC[x]), .i0(inC[x]), .i1(0), .sel(reset));
		end
	endgenerate
	generate
		for(genvar x =0 ; x <64; x++) begin
			D_FF instrcutionDFF (.q(out[x]), .d(tempout[x]), .reset(reset), .clk(clk));
			D_FF instrcutionDFF1 (.q(outC[x]), .d(tempoutC[x]), .reset(reset), .clk(clk));
		end
	endgenerate

	
endmodule 