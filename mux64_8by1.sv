module mux64_8by1 (out, ins, sel);
	input logic [7:0] [63:0] ins;
	input logic [2:0] sel;
	output logic [63:0] out;
	
	logic [63:0] [7:0] insTemp;
	logic [63:0] [1:0] out0;
	
	generate // connects writeMultitemp to writeMulti.
		for (genvar i = 0; i < 8; i++) begin
			for (genvar j = 0; j < 64; j++) begin
				assign insTemp[j][i] = ins[i][j]; // writeMulti is equal to writeMultiTemp.
			end
		end
	endgenerate
	
	generate
		for (genvar x = 0; x < 64; x++) begin
			mux8by1 mux0 (.out(out[x]), .ins(insTemp[x][7:0]), .sel(sel));
		end
	endgenerate
endmodule 

`timescale 1ns/10ps
module mux64_8by1_testbench();
	logic [63:0] out;
	logic [63:0][7:0] ins;
	logic [2:0] sel;
	mux64_8by1 dut(.out, .ins, .sel);
	
	initial begin
		for (integer i = 0; i < 8; i++) begin
			ins[0][i] = 0;
		end
		for (integer i = 0; i < 8; i++) begin
			if (i != 0)
				ins[i-1] = 0;
			ins[i] = 1;
			sel = i;
			#10;
		end
	end
//	initial begin
//		
//		
////		ins[63:0][0] = 0;
////		ins[63:0][1] = 1;
////		ins[63:0][2] = 2;
////		ins[63:0][3] = 3;
////		ins[63:0][4] = 4;
////		ins[63:0][5] = 5;
////		ins[63:0][6] = 6;
////		ins[63:0][7] = 7;
//		for (integer i = 0; i < 8; i++) begin
//			sel = i;
//		end
//	end
endmodule 