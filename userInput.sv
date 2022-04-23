module userInput (clk, reset, D, O);
	input logic clk, reset, D;
	output logic O; // output Q  
	enum {on, off} ps, ns;
	
	always_comb begin
		case(ps)
			on: 	if(D)
						ns = on; //out = 0;
					else 
						ns = off; //out = 1;
				
			off: 	if(D)
						ns = on; //out = 0;
					else 
						ns = off; //out = 0;
			endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= off;
		else
			ps <= ns;
	end
	
	assign O = (ns == off & ps == on);
			
		
	
endmodule