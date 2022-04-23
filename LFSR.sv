
module LFSR (clk, reset, out); 
	output logic [9:0] out;
	input logic clk, reset;
	
//	logic xnorOut;
//	
//	assign xnorOut = (out[0] ~^ out[3]); 
	
//	always_ff @(posedge clk) begin
//		if(reset) out <= 10'b0000000000;
//		
//		else out <= {xnorOut, out[9: 1]};
//	end
	always_ff @(posedge clk) begin
		if (reset) 
			out <= 10'b0000000000;
		else begin
			out[9] <= out[8];
			out[8] <= out[7];
			out[7] <= out[6];
			out[6] <= out[5];
			out[5] <= out[4];
			out[4] <= out[3];
			out[3] <= out[2];
			out[2] <= out[1];
			out[1] <= out[0];
			out[0] <= (out[6] ^~ out[9]);
		end
	end
	
	
endmodule
