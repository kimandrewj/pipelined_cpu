module mux8by1(out, ins, sel);
    input logic [7:0] ins;
    input logic [2:0] sel;
    output logic out;
    logic [1:0] out0;

    mux4by1 mux0(.out(out0[0]), .ins(ins[3:0]), .sel(sel[1:0]));
    mux4by1 mux1(.out(out0[1]), .ins(ins[7:4]), .sel(sel[1:0]));
    mux2by1 fin (.out(out), .ins(out0[1:0]), .sel(sel[2]));
	 
endmodule

`timescale 1ns/ 10ps
module mux8by1_testbench();
	logic out;
	logic [7:0] ins;
	logic [2:0] sel;
	mux8by1 dut(.out, .ins, .sel);
	initial begin
		for (integer i = 0; i < 8; i++) begin
			ins[i] = 0;
		end
		for (integer i = 0; i < 8; i++) begin
			if (i != 0)
				ins[i-1] = 0;
			ins[i] = 1;
			sel = i;
			#10;
		end
	end
endmodule
