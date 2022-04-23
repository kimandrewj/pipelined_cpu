module topCase (Clock, Reset, L, R, NL, NR, lightOn, next); 
	input logic Clock, Reset; 
 
   // L is true when left key is pressed, R is true when the right key 
 // is pressed, NL is true when the light on the left is on, and NR 
 // is true when the light on the right is on.  
	input logic L, R, NL, NR, next; 
 
 // when lightOn is true, the center light should be on. 
	output logic lightOn; 
 
 // Your code goes here!! 
	enum {on, off} ps, ns;
	
	always_comb begin 
		case (ps)
			on:
				if(L & ~R)
					ns = off;
				else if(R & ~L)
					ns = off;
				else 
					ns = on;
			off:
				if(L & NR)
					ns = on;
				else
					ns = off;
		endcase
	end
	
	always_comb begin 
		case (ps)
			on : lightOn = 1;
			off: lightOn = 0;
		endcase
	end
	
	always_ff @(posedge Clock) begin 
		if(Reset || next)
			ps <= on;
		else 
			ps <= ns;
	end
endmodule 

module bottomCase (Clock, Reset, L, R, NL, NR, lightOn, next); 
	input logic Clock, Reset; 
 
   // L is true when left key is pressed, R is true when the right key 
 // is pressed, NL is true when the light on the left is on, and NR 
 // is true when the light on the right is on.  
	input logic L, R, NL, NR, next; 
 
 // when lightOn is true, the center light should be on. 
	output logic lightOn; 
 
 // Your code goes here!! 
	enum {on, off} ps, ns;
	
	always_comb begin 
		case (ps)
			on:
				if(L & ~R)
					ns = off;
				else if(R & ~L)
					ns = off;
				else
					ns = on;
			off:
				if(R & NL)
					ns = on;
				else
					ns = off;
		endcase
	end
	
	always_comb begin 
		case (ps)
			on : lightOn = 1;
			off: lightOn = 0;
		endcase
	end
	
	always_ff @(posedge Clock) begin 
		if(Reset || next)
			ps <= on;
		else 
			ps <= ns;
	end
endmodule 