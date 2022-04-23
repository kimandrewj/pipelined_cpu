module cyberPlayer(clk, reset, SW, lfsr, bot1);
	input logic clk, reset;
	input logic [8:0] SW;
	input logic [9:0] lfsr;
	output logic bot1;
	logic [9:0] tenByteSW;
	assign tenByteSW = {1'b0, SW};
	
	comparator bot(.clk, .reset, .A(tenByteSW), .B(lfsr), .out(bot1));
	
endmodule 