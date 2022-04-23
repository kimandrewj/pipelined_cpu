module mux32by1(out, ins, sel);
	input logic [31:0] ins;
   input logic [4:0] sel;
   output logic out; 
   logic [3:0] out0;
	
	//use 4 8x1 mux and then 1 4x1 mux to create 32x1 mux
	mux8by1 mux1(.out(out0[0]), .ins(ins[7:0]), .sel(sel[2:0]));
	mux8by1 mux2(.out(out0[1]), .ins(ins[15:8]), .sel(sel[2:0]));
	mux8by1 mux3(.out(out0[2]), .ins(ins[23:16]), .sel(sel[2:0]));
	mux8by1 mux4(.out(out0[3]), .ins(ins[31:24]), .sel(sel[2:0]));
	
	mux4by1 fIn(.out(out), .ins(out0), .sel(sel[4:3]));
	
	 
endmodule


`timescale 1ns/10ps
module mux32by1_testbench();
	logic out;
	logic [31:0]ins;
	logic [4:0]sel;
	
	mux32by1 dut(.out, .ins, .sel);
	
	initial begin
		for (integer i = 0; i < 32; i++) begin
			ins[i] = 0;
		end
		for (integer i = 0; i < 32; i++) begin
			if (i != 0)
				ins[i-1] = 0;
			ins[i] = 1;
			sel = i;
			#10;
		end
	end
endmodule 