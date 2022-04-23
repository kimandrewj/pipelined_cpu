module register(dataOut, dataIn, writeEnable, reset, clk);
	input logic [63:0] dataIn;
	output logic [63:0] dataOut;
	input logic reset, clk, writeEnable;
	
	//calls 64 D_FF_enableds that sets the correct data for Dataout = dataIN
	genvar i;
	generate
		for(i = 0; i < 64; i++) begin
			D_FF_enabled flipFlop (.q(dataOut[i]), .d(dataIn[i]), .d1(dataOut[i]), .reset(reset), .clk(clk), .enabler(writeEnable));  
		end
	endgenerate
endmodule

`timescale 1ns/10ps
module register_testbench();
	logic [63:0] dataIn;
	logic [63:0] dataOut;
	logic reset, clk, writeEnable;
	register dut(.dataOut, .dataIn, .writeEnable, .reset, .clk);
	parameter ClockDelay = 5000;
	
	initial begin 
	// Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	initial begin 
		reset = 1;
		reset = 0;
		dataOut = 2; @(posedge clk);
		dataIn = 0; @(posedge clk);
		writeEnable = 1; @(posedge clk);
		#10; 
		writeEnable = 0; @(posedge clk);
		dataIn = 1; @(posedge clk);
		#10;
		writeEnable = 1; @(posedge clk);
		writeEnable = 0; @(posedge clk);
		dataIn = 0; @(posedge clk);
		#10;
		dataIn = 1; @(posedge clk);
		#10;
		$stop;
	end
endmodule 