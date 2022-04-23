//determines the what the PC counter should be
module updateAddress( out, clk, reset, checkB, brTaken, instruction);
	output logic [63:0] out;
	input logic clk, reset;
	input logic	[31:0] instruction;
	logic [63:0] four, ns, ps, seOut, seadd, tempseadd, minus4, Imm19, Imm26, tempseOut;
	logic [3:0] idc;
	logic	[31:0] number4;
	input logic checkB, brTaken; 
	assign number4 = 4;
	assign minus4 = -4;
	addition add4 (.A(ps), .B(number4), .out(four), .zero(idc[0]), .overflow(idc[1]), .carryOut(idc[2]), .negative(idc[3]), .control(0));
	
	//two different sign extend for the B an blt
	signExtend19 sign19 (Imm19, instruction[24:5]);
	signExtend26 sign26 (Imm26, instruction[25:0]);
	//selector for B or Blt
	generate
		for(genvar x =0 ; x <64; x++) begin
			mux2_1 updateAddress (.out(tempseOut[x]), .i0(Imm19[x]), .i1(Imm26[x]), .sel(checkB));
		end
	endgenerate
	//multiplies it by 4 to converet it to address
	assign seOut = tempseOut << 2;
	addition addSE (.A(ps), .B(seOut), .out(tempseadd), .zero(idc[0]), .overflow(idc[1]), .carryOut(idc[2]), .negative(idc[3]), .control(0));
	addition sub4SE (.A(tempseadd), .B(minus4), .out(seadd), .zero(idc[0]), .overflow(idc[1]), .carryOut(idc[2]), .negative(idc[3]), .control(0));

	//determines if +4 or got the the branch location
	generate
		for(genvar x =0 ; x <64; x++) begin
			mux2_1 updateAddress (.out(ns[x]), .i0(four[x]), .i1(seadd[x]), .sel(brTaken));
		end
	endgenerate 
	
	//ouput
	always_comb begin
		out = ps;
	end
	//always_ff statement for ps and ns
	generate
		for(genvar x =0 ; x <64; x++) begin
			D_FF addressDFF (.q(ps[x]), .d(ns[x]), .reset(reset), .clk(clk));
		end
	endgenerate 

endmodule 

`timescale 1ns/10ps
module updateAddress_testbench();
	logic [63:0] out;
	logic clk, reset;
	updateAddress dut (out, clk, reset);
	
	parameter ClockDelay = 5000;
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset = 1;
		#5000;
		reset = 0;
		#5000;
		#5000;
		#5000;
		#5000;
		#5000;
		$stop;
	end
endmodule 