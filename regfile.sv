//regfile is overall control module that contains all 32 64bit registers for ARM processsor
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, 
			WriteRegister, RegWrite, clk);
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	
	logic [31:0] writeEnabled;
	logic [63:0][31:0] writeMulti; // do we need to include 64 bit in this case?
	logic [63:0] zeroRegister;
	logic [31:0][63:0] writeMultitemp;
	logic reset;
	
	
	//inputs the writeRegister and Regwrite(enabler) to enable or disable writing to all registers except 31th register.
	Fiveby32decoder Decoder(.finalIn(WriteRegister), .finalOut(writeEnabled), .enabler(RegWrite));
	
	generate // this generates 31 registers that has 64bit.
		for (genvar i = 0; i < 31; i++) begin
			register theRegister(.dataOut(writeMultitemp[i][63:0]), .dataIn(WriteData), .writeEnable(writeEnabled[i]), .reset(reset), .clk(clk));
		end
	endgenerate
	
	assign writeMultitemp[31][63:0] = 0;// register 31 is equal to 0.
	
	generate // connects writeMultitemp to writeMulti.
		for (genvar i = 0; i < 32; i++) begin
			for (genvar j = 0; j < 64; j++) begin
				assign writeMulti[j][i] = writeMultitemp[i][j]; // writeMulti is equal to writeMultiTemp.
			end
		end
	endgenerate

	
	generate //inputs the 64bit data from register into 32 by 1 multiplexor and readRegister1 selects one of the registers data a writes it to ReadData1
		for (genvar i = 0; i < 64; i++) begin
			mux32by1 multiplexor(.out(ReadData1[i]), .ins(writeMulti[i][31:0]), .sel(ReadRegister1));
		end
	endgenerate
	
	generate //inputs the 64bit data from register into 32 by 1 multiplexor and readRegister2 selects one of the registers data a writes it to ReadData2
		for (genvar i = 0; i < 64; i++) begin
			mux32by1 multiplexor(.out(ReadData2[i]), .ins(writeMulti[i][31:0]), .sel(ReadRegister2));
		end
	endgenerate
		
		
endmodule;

// Test bench for Register file
`timescale 1ns/10ps

module regstim(); 		

	parameter ClockDelay = 5000;

	logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	logic [63:0]	WriteData;
	logic 			RegWrite, clk;
	logic [63:0]	ReadData1, ReadData2;

	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	regfile dut (.ReadData1, .ReadData2, .WriteData, 
					 .ReadRegister1, .ReadRegister2, .WriteRegister,
					 .RegWrite, .clk);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	initial begin
		// Try to write the value 0xA0 into register 31.
		// Register 31 should always be at the value of 0.
		RegWrite <= 5'd0;
		ReadRegister1 <= 5'd0;
		ReadRegister2 <= 5'd0;
		WriteRegister <= 5'd31;
		WriteData <= 64'h00000000000000A0;
		@(posedge clk);
		
		$display("%t Attempting overwrite of register 31, which should always be 0", $time);
		RegWrite <= 1;
		@(posedge clk);

		// Write a value into each  register.
		$display("%t Writing pattern to all registers.", $time);
		for (i=0; i<31; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000010204080001;
			@(posedge clk);
			
			RegWrite <= 1;
			@(posedge clk);
		end

		// Go back and verify that the registers
		// retained the data.
		$display("%t Checking pattern.", $time);
		for (i=0; i<32; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000000000000100+i;
			@(posedge clk);
		end
		$stop;
	end
endmodule

	