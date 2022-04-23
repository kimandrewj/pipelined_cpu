//non-pipelined single CPU
`timescale 1ns/10ps
module CPU_single( clk, reset);
	input logic clk, reset;
	//declaring variables 
	logic [63:0] address;
	logic [31:0] instruction;
	logic [10:0] check; 
	logic brTaken;
	logic [63:0] branchTo;
	logic [63:0] aluresult;
	logic blt, cbz, tempblt;
	logic negative, zero, overflow, carry_out; //flags
	
	//determing branches for blt, B, cbz
	xor #0.05 bltgate (tempblt, overflow, negative);
	and #0.05 bltand (blt, tempblt, check[4]);
	logic zerocbzcase;
	zeroCase asdad (.out(zercbzcase), .inputs(aluresult));
	and #0.05 cbzand (cbz, zercbzcase, check[5]);
	or #0.05 brControl (brTaken, check[3], blt, cbz);
	//stage 1: get the instruction and decode it
	updateAddress getAddress (.out(address), .clk(clk), .reset(reset), .checkB(check[3]), .brTaken(brTaken), .instruction(instruction)); //updates the PC counter
	instructmem getInstruction (.address(address), .instruction(instruction), .clk(clk));
	instructionDecoder decodeInstruct (.instruction(instruction), .check(check));
	//newaddress = address <<2 or IMM26<<2 or Imm19<<2

	
	//stage 2:get the registers
	//inputs/ouptus to register
	logic [4:0] Rd, Rm, Rn, Aa, Ab;
	logic [63:0] Da, Db;
	logic Reg2Loc;
	//register input logic
	assign Rn = instruction[9:5];
	assign Aa = Rn;
	or #0.05 reg2Locgate (Reg2Loc, check[9], check[5]);
	assign Rd = instruction[4:0];
	assign Rm = instruction[20:16];
	generate
		for(genvar x = 0; x < 5; x++) begin
				//determine inputs to register
			mux2_1 regMux (.out(Ab[x]), .i0(Rm[x]), .i1(Rd[x]), .sel(Reg2Loc));	
		end
	endgenerate
	
	//determine inputs for ALU
	logic [63:0] Imm12, Imm9, signZero, aluB;
	logic aluBsel, alusrc;
	assign aluBsel = check[0];
	or aluorGateB (alusrc, check[0], check[7], check[9]);
	//creates the Imm12 and Imm9
	zeroExtend12 zero12 (Imm12, instruction[21:10]);	//sets Imm12
	signExtend9 sign9	 (Imm9, instruction[20:12]); //sets Imm9
	
	//figure out imm12 and Imm9 and which one to use
	generate
		for(genvar x=0; x < 64; x++) begin
			//determine inputs to register
			mux2_1 alumux (.out(signZero[x]), .i0(Imm9[x]), .i1(Imm12[x]), .sel(aluBsel));	
		end
	endgenerate
	//dettermines the input B for ALU
	generate
		for(genvar x=0; x < 64; x++) begin
			//determine inputs to register
			mux2_1 alumux (.out(aluB[x]), .i0(Db[x]), .i1(signZero[x]), .sel(alusrc));	
		end
	endgenerate

	
	//stage 3:execute the command in ALU
	logic [2:0] ALUcontrol;
	logic [5:0] shifterD;
	logic [63:0] rdResult;
	logic [63:0] lsrResult;
	assign shifterD = instruction[15:10];
	
	logic tempN, tempZ, tempO, tempC;
	logic flagControl;
	
	shifter shift (.value(Da), .direction(1'b1), .distance(shifterD), .result(lsrResult)); //shifts the LSR
	//addi check3 -> 1,0 ,0, 0 ....
	assign ALUcontrol[0] = check[10]; // subs
	logic tempalu1;
	//determining the ALU selector
	or #0.05 aluorgate1 (tempalu1, check[2], check[5]);
	not #0.05 notalugate (ALUcontrol[1] , tempalu1); //sets alu[1]
	or #0.05 oralugate2 (ALUcontrol[2] , check[2], check[6]);
	//using ALU
	alu aluModule(.A(Da), .B(aluB), .cntrl(ALUcontrol), .result(aluresult), .negative(tempN), .zero(tempZ), .overflow(tempO), .carry_out(tempC));
	
	//determines if flags should be updated or not
	or #0.05 flagorgate (flagControl, check[1], check[10]);
	//setting the flags
	D_FF_enabled flagN (.q(negative), .d1(negative), .d(tempN), .reset(reset), .clk(clk), .enabler(flagControl)); 
	D_FF_enabled flagZ (.q(zero), .d1(zero), .d(tempZ), .reset(reset), .clk(clk), .enabler(flagControl)); 
	D_FF_enabled flagO (.q(overflow), .d1(overflow), .d(tempO), .reset(reset), .clk(clk), .enabler(flagControl)); 
	D_FF_enabled flagC (.q(carry_out), .d1(carry_out), .d(tempC), .reset(reset), .clk(clk), .enabler(flagControl)); 
	
	//stage 4: write it to data Memory
	logic checkStore, checkLoad;
	assign checkStore = check[9];
	assign checkLoad = check[7]; 
	logic [63:0] memOut, notlsrResult;
	datamem data (.address(aluresult), .write_enable(checkStore), .read_enable(checkLoad), .write_data(Db), .clk(clk), .xfer_size(8), .read_data(memOut));
	
	//stage 5: Write back
	logic WrEn, WrEntemp;
	or #0.05 writeRegEn0 (WrEntemp, check[0], check[1], check[6], check[7], check[8]);
	or #0.05 writeRegEn1 (WrEn, WrEntemp, check[2], check[10]);
	generate
		for(genvar x=0; x < 64; x++) begin
			//determine inputs to register
			mux2_1 resultMux (.out(rdResult[x]), .i0(notlsrResult[x]), .i1(lsrResult[x]), .sel(check[8]));	
		end
	endgenerate	
	
	//	logic memToreg;
   //	or #0.05 memGate (memToreg, check[7], check[9]); 
	generate
		for(genvar x=0; x < 64; x++) begin
			//determine inputs to register
			mux2_1 resultMux (.out(notlsrResult[x]), .i0(aluresult[x]), .i1(memOut[x]), .sel(checkLoad));	
		end
	endgenerate	
	
	//Regfile logic
	//reading at stage 2/wrtting at stage 5
	regfile Regfile(.ReadData1(Da), .ReadData2(Db), .WriteData(rdResult), .ReadRegister1(Aa), .ReadRegister2(Ab), 
		.WriteRegister(Rd), .RegWrite(WrEn), .clk(clk));	
		
endmodule


module CPU_single_testbench();
	logic clk, reset;
	CPU_single dut (clk, reset);
	
	parameter ClockDelay = 500;
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset = 1;
		#500;
		reset = 0;
		//test 11 and 12 use 650000
		#30000;
		$stop;
	end
endmodule 