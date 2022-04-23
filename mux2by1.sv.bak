`timescale 1ns/10ps

module mux2by1(out, ins, sel);
	output logic out;
	input logic sel;
	input logic [1:0] ins;
	
	logic out1, out2, notSel;
	
	// creates a selector and based on sel it outputs when sel=1, ins[1] or when sel=0, ins[0]
	not #0.05 firstNot(notSel, sel);
	and #0.05 firstAnd(out1, ins[1], sel);
	and #0.05 secondAnd(out2, ins[0], notSel);
	or #0.05 firstOr(out, out1, out2);

endmodule

module mux2by1_testbench();
	logic out;
	logic inp1, inp2, sel;
	
	mux2by1 dut(.out, .inp1, .inp2, .sel);
	
	initial begin
		sel = 1;
		inp1 = 0; inp2 = 0;
		#5;
		inp1 = 0; inp2 = 1;
		#5;
		inp1 = 1; inp2 = 0;
		#5;
		inp1 = 1; inp2 = 1;
		#5;
		
		sel = 0;
		inp1 = 0; inp2 = 0;
		#5;
		inp1 = 0; inp2 = 1;
		#5;
		inp1 = 1; inp2 = 0;
		#5;
		inp1 = 1; inp2 = 1;
		#5;
	end
endmodule 