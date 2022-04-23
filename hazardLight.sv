module hazardLight (clk, reset, SW, LEDR);
	input  logic  clk, reset;
	input logic [1:0] SW;
	output logic [2:0] LEDR;
	
	
	enum {leftL, rightL, midL, sideL } ps, ns;
	
	always_comb begin 
		case (ps)
			leftL:   if (SW[1] & ~SW[0])  
							ns = midL; 
						else  if (~SW[1] & SW[0])
							ns = rightL;
						else
							ns = sideL;
			rightL:  if (~SW[1] & SW[0])
							ns = midL;
						else if (SW[1] & ~SW[0])
							ns = leftL; 
						else 
							ns = sideL;
			midL:  if (~SW[1] & ~SW[0])
						ns = sideL; 
					else if (~SW[1] & SW[0])
						ns = leftL;
					else
						ns = rightL;
			sideL:  if (~SW[1] & ~SW[0])  
							ns = midL;	
					else if (~SW[1] & SW[0])
						ns = rightL;
					else 
						ns = leftL;
		endcase
	end
	
	always_comb begin 
		case (ps)
			leftL : LEDR = 3'b100;
			rightL: LEDR = 3'b001;
			sideL : LEDR = 3'b101;
			midL : LEDR = 3'b010;
		endcase
	end
	
	always_ff @(posedge clk) begin 
		if(reset)
			ps <= rightL;
		else 
			ps <= ns;
	end
endmodule

//
//module hazardLight_testbench();
//	logic  clk, reset, w; 
//	logic  out;
//	
//	simple dut (clk, reset, w, out);  
//	
//	parameter CLOCK_PERIOD=100; 
//	initial begin  
//		clk<= 0;
//		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock 
//	end
//	
//	initial begin  
//								 @(posedge clk);
//		reset <= 1;        @(posedge clk); 					 
//		reset <= 0; w <= 0; @(posedge clk);
//									@(posedge clk);  
//									@(posedge clk);  
//									@(posedge clk);  
//							  w <= 1; @(posedge clk);	  
//							w <= 0; @(posedge clk);
//							 w <= 1; @(posedge clk);
//										@(posedge clk);
//										@(posedge clk);
//										@(posedge clk);
//							w <= 0; @(posedge clk); 
//										@(posedge clk);
//			$stop;
//	end
//endmodule
