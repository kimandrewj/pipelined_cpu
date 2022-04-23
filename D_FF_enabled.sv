module D_FF_enabled (q, d, d1, reset, clk, enabler);   
	output reg q; 
	input logic d, d1, reset, clk; 
	 
	input logic enabler;
	logic enabledInput; // input that includes if it is enabled or not
	
	//use 2x1 mux to select whether old data is kept or new data is written based on enabler
	regmux2by1 mux1 (.out(enabledInput), .inp1(d), .inp2(d1), .sel(enabler));
	
	D_FF doubleFlip (.q(q), .d(enabledInput), .reset(reset), .clk(clk));
	
endmodule 

`timescale 1ns/10ps
module D_FF_enabled_testbench();
	reg q; 
	logic d, d1, reset, clk; 
	 
	logic enabler;
	parameter ClockDelay = 10;
	
	D_FF_enabled dut (.q, .d, .d1, .reset, .clk, .enabler);
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset = 1;
		reset = 0;
		enabler = 1;
		d = 0;
		d1= 0; @(posedge clk)
		#100; 
		d = 1;
		d1 = 0; @(posedge clk)
		#100;
		$stop;
	end
endmodule 