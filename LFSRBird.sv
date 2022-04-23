
module LFSRBird (clk, reset, out); 
	output logic [5:0] out;
	input logic clk, reset;
	
	
	always_ff @(posedge clk) begin
		if (reset) 
			out <= 10'b0000000000;
		else begin
			out[5] <= out[4];
			out[4] <= out[3];
			out[3] <= out[2];
			out[2] <= out[1];
			out[1] <= out[0];
			out[0] <= (out[4] ^~ out[5]);
		end
	end
	
	
endmodule

module LFSRBird_testbench();
  
	logic [5:0] out;
	logic clk, reset;
  
  LFSRBird dut  (.clk, .reset, .out); 

  parameter CLOCK_PERIOD = 100;
  initial clk = 1;
  always begin
    #(CLOCK_PERIOD/2); clk = ~clk;
  end
  initial begin
	 @(posedge clk); reset<=1;
	 @(posedge clk); reset<=0;
	 @(posedge clk);
	 @(posedge clk);

	 $stop;     
  end 
  
endmodule
