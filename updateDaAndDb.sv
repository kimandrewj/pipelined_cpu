module updateDaAndDb(oldDa, oldDb, Da, Db, clk, reset);
	input logic [63:0] oldDa, oldDb;
	output logic [63:0] Da, Db;
	input logic clk, reset;
	
	logic [63:0] tempDa, tempDb;
	// updating 64 bit da and db
	generate 
		for( genvar x = 0; x < 64; x++) begin
			mux2_1 inmux (.out(tempDa[x]), .i0(oldDa[x]), .i1(0), .sel(reset));
			mux2_1 inmux1 (.out(tempDb[x]), .i0(oldDb[x]), .i1(0), .sel(reset));
		end
	endgenerate
	
	generate
		for(genvar x =0 ; x <64; x++) begin
			D_FF instrcutionDFF (.q(Da[x]), .d(tempDa[x]), .reset(reset), .clk(clk));
			D_FF instrcutionDFF1 (.q(Db[x]), .d(tempDb[x]), .reset(reset), .clk(clk));
		end
	endgenerate

endmodule 