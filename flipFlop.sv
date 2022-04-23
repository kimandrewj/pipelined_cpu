module flipFlop (clk, reset, D, O);
	input logic D; // Data input 
	input logic clk, reset; // clock input 
	output logic O; // output Q  
	logic O_1;
	always @(posedge clk) begin
		O <= D; 
	end
	always @(posedge clk) begin
		O_1 <= O; 
	end
endmodule
