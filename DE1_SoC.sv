// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 // Turn off HEX displays

    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 logic [31:0] clk;
	parameter clockUp = 20;
	parameter clockPipe = 20;
	clockDiv div (CLOCK_50, clk);
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
		
	 assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	 
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	logic key2In, key0In, upButton, downButton, next, botPlayer, RST, collision, counts,botKey, birdc, birdTop, birdBot, inflow, overflow, overflow1;
	logic [5:0] finalLfsr;
	logic [9:0] birdLfsr;
	genvar i;
	logic [7:0] greenColumn0, greenColumn1, greenColumn2, greenColumn3, greenColumn4, greenColumn5, greenColumn6,greenColumn7;
//	assign greenColumn0[i] = 8'b00000000;
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel
			assign GrnPixels[i][0] = greenColumn0[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel0
			assign GrnPixels[i][1] = greenColumn1[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel1
			assign GrnPixels[i][2] = greenColumn2[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel2
			assign GrnPixels[i][3] = greenColumn3[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel3
			assign GrnPixels[i][4] = greenColumn4[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel4
			assign GrnPixels[i][5] = greenColumn5[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel5
			assign GrnPixels[i][6] = greenColumn6[i];
		end
	endgenerate
	
	generate
		for (i = 0; i < 8; i = i + 1) begin : eachPixel6
			assign GrnPixels[i][7] = greenColumn7[i];
		end
	endgenerate
//	GrnPixels[15:8][0] = greenColumn0
	
	
	assign RST = SW[9];
	LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	
	
	
	
	flipFlop ff_down (.clk(SYSTEM_CLOCK), .reset(SW[9]), .D(botPlayer), .O(botKey));
	flipFlop ff_up (.clk(SYSTEM_CLOCK), .reset(SW[9]), .D(~KEY[0]), .O(key0In));
	
	userInput userDown (.clk(SYSTEM_CLOCK), .reset(SW[9]), .D(botKey), .O(upButton));
	userInput userUp (.clk(SYSTEM_CLOCK), .reset(SW[9]), .D(key0In), .O(downButton));
	
	normalLight ledZero (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[02][07]), .NR(RedPixels[00][07]), .lightOn(RedPixels[01][07]), .next(next), .collision(collision));
	normalLight ledOne (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[03][07]), .NR(RedPixels[01][07]), .lightOn(RedPixels[02][07]), .next(next), .collision(collision));
	normalLight ledTwo (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[04][07]), .NR(RedPixels[02][07]), .lightOn(RedPixels[03][07]), .next(next), .collision(collision));
	centerLight ledThree (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[05][07]), .NR(RedPixels[03][07]), .lightOn(RedPixels[04][07]), .next(next), .collision(collision));
	normalLight ledFour (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[06][07]), .NR(RedPixels[04][07]), .lightOn(RedPixels[05][07]), .next(next), .collision(collision));
	normalLight ledFive (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[07][07]), .NR(RedPixels[05][07]), .lightOn(RedPixels[06][07]), .next(next), .collision(collision));
	normalLight ledSix (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[08][07]), .NR(RedPixels[06][07]), .lightOn(RedPixels[07][07]), .next(next), .collision(collision));
	normalLight ledSeven (.Clock(SYSTEM_CLOCK), .Reset(SW[9]), .L(upButton), .R(downButton), .NL(RedPixels[09][07]), .NR(RedPixels[07][07]), .lightOn(RedPixels[08][07]), .next(next), .collision(collision));
	
	LFSRBird lfsr (.clk(SYSTEM_CLOCK), .reset(SW[9]), .out(finalLfsr));
	pipePattern startPipe (.clk(SYSTEM_CLOCK), .reset(SW[9]), .lfsr(finalLfsr), .top(greenColumn7), .mid(greenColumn3), .bottom(greenColumn0), .collision(collision));
	normalPipe n1  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn0), .lightOut(greenColumn1), .collision(collision));
	normalPipe n2  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn1), .lightOut(greenColumn2), .collision(collision));
	normalPipe n3  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn2), .lightOut(greenColumn3), .collision(collision));
	normalPipe n4  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn3), .lightOut(greenColumn4), .collision(collision));
	normalPipe n5  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn4), .lightOut(greenColumn5), .collision(collision));
	normalPipe n6  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn5), .lightOut(greenColumn6), .collision(collision));
	normalPipe n7  (.clk(SYSTEM_CLOCK), .reset(SW[9]), .right(greenColumn6), .lightOut(greenColumn7), .collision(collision));
	
	die gameOver (.clk(SYSTEM_CLOCK), .reset(SW[9]), .redPix1(RedPixels[00][07]), .redPix2(RedPixels[01][07]), .redPix3(RedPixels[02][07]), .redPix4(RedPixels[03][07]), 
	.redPix5(RedPixels[04][07]), .redPix6(RedPixels[05][07]), .redPix7(RedPixels[06][07]), .redPix8(RedPixels[07][07]), .greenPix1(GrnPixels[00][07]), .greenPix2(GrnPixels[01][07]), 
	.greenPix3(GrnPixels[02][07]), .greenPix4(GrnPixels[03][07]), .greenPix5(GrnPixels[04][07]), .greenPix6(GrnPixels[05][07]), .greenPix7(GrnPixels[06][07]), .greenPix8(GrnPixels[07][07]), .collision(collision));
	
	LFSR lfsr1 (.clk(SYSTEM_CLOCK), .reset(SW[9]), .out(birdLfsr));
//	alive continueGame (.top(GrnPixels[00][07]), .bottom(GrnPixels[07][07]), .counts(counts));
	cyberPlayer bot(.clk(SYSTEM_CLOCK), .reset(SW[9]), .SW(SW[8:0]), .lfsr(birdLfsr), .bot1(botPlayer));
	birdCounter birdAlive (.clk(SYSTEM_CLOCK), .reset(SW[9]), .birdTop(GrnPixels[00][07]), .birdBot(GrnPixels[07][07]), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2)); 
	
	

	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
//	 LED_test test (.RST(~KEY[0]), .RedPixels, .GrnPixels);
	 
endmodule 

module DE1_SoC_testbench();
  logic CLOCK_50, reset, clk; 
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;
  logic [35:0] GPIO_0;
  logic  [3:0] KEY;
  logic  [9:0] SW;
  
  DE1_SoC dut (.CLOCK_50(clk), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0);

  parameter CLOCK_PERIOD = 100;
  initial clk = 1;
  always begin
    #(CLOCK_PERIOD/2); clk = ~clk;
  end
  initial begin
    @(posedge clk); SW[9] <= 1; KEY[0]<=0;  
    @(posedge clk); SW[9] <= 0;
	 @(posedge clk); 
	 @(posedge clk); 
	 @(posedge clk); KEY[0] <= 1;
	 @(posedge clk); 
	 @(posedge clk); 
	 @(posedge clk); 
	 @(posedge clk); KEY[0] <= 0;
	 @(posedge clk); 
	 @(posedge clk); SW[9] <= 1;
	 @(posedge clk); SW[9] <= 0;
	 @(posedge clk); 
	 @(posedge clk); 
	 @(posedge clk); KEY[0] <= 1;
	 @(posedge clk); KEY[0] <= 0;
	 @(posedge clk);
	 @(posedge clk); KEY[0] <= 1;
	 @(posedge clk);
	 @(posedge clk); KEY[0] <= 0;
	 @(posedge clk); 
	 @(posedge clk); KEY[0] <= 1;
	 @(posedge clk); KEY[0] <= 0;
	 @(posedge clk); SW[9] <= 1;
	 @(posedge clk); SW[9] <= 0;
	 @(posedge clk); 
	 @(posedge clk); KEY[0] <= 1;
	 @(posedge clk); 
	 @(posedge clk); 
	 @(posedge clk); 

	
	 $stop;        
  end
endmodule
