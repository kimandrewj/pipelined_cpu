module simple (clk, reset, w, out);
	input  logic  clk, reset, w;
	output logic  out;
	
	enum { none, got_one, got_two } ps, ns;
	
	always_comb begin 
		case (ps)
			none:   if (w)  ns = got_one; 
						else  ns = none;
			got_one:  if (w)  ns = got_two;
						else  ns = none; 
			got_two:  if (w)  ns = got_two; 
						else  ns = none; 
		endcase
	end
	
	assign out = (ps == got_two); 
	
	always_ff @(posedge clk) begin 
		if(reset)
			ps <= none;
		else 
			ps <= ns;
	end
endmodule


module simple_testbench();
	logic  clk, reset, w; 
	logic  out;
	
	simple dut (clk, reset, SW, LEDR);  
	
	parameter CLOCK_PERIOD=100; 
	initial begin  
		clk<= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
	end
	
	initial begin  
								 @(posedge clk);
		reset <= 1;        @(posedge clk); 					 
		reset <= 0; w <= 0; @(posedge clk);
									@(posedge clk);  
									@(posedge clk);  
									@(posedge clk);  
							  w <= 1; @(posedge clk);	  
							w <= 0; @(posedge clk);
							 w <= 1; @(posedge clk);
										@(posedge clk);
										@(posedge clk);
										@(posedge clk);
							w <= 0; @(posedge clk); 
										@(posedge clk);
			$stop;
	end
endmodule