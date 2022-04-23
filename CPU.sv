`timescale 1ns/10ps
module CPU( clk, reset);
	input logic clk, reset;
	logic [63:0] address;
	logic [31:0] instruction0, instruction1, instruction2, instruction3, instruction4;
	logic [10:0] check0, check1, check2, check3, check4; 
	logic branch;
	logic [63:0] branchTo;
	 //temp code TODO delete later
	assign branch = 0;
	
	//stage 1: get the instruction and decode it
	updateAddress getAddress (.out(address), .clk(clk), .reset(reset) );
	instructmem getInstruction (.address(address), .instruction(instruction0), .clk(clk));
	instructionDecoder decodeInstruct (.instruction(instruction0), .check(check0));
	updateInstructionandCheck upd1 (.in(instruction0), .inC(check0), .out(instruction1), .outC(check1), .clk(clk), .reset(reset));
	updateInstructionandCheck upd2 (.in(instruction1), .inC(check1), .out(instruction2), .outC(check2), .clk(clk), .reset(reset));
	updateInstructionandCheck upd3 (.in(instruction2), .inC(check2), .out(instruction3), .outC(check3), .clk(clk), .reset(reset));
	updateInstructionandCheck upd4 (.in(instruction3), .inC(check3), .out(instruction4), .outC(check4), .clk(clk), .reset(reset));
	//newaddress = address <<2 or IMM26<<2 or Imm19<<2

	
	//stage 2:get the registers
	//inputs/ouptus to register
	logic [4:0] Rd, Rm, Rn, Aa, Ab;
	logic [63:0] Da, Db;
	logic Reg2Loc;
	//register input logic
	assign Rn = instruction1[9:5];
	assign Aa = Rn;
	assign Reg2Loc = check1[9];
	assign Rd = instruction1[4:0];
	assign Rm = instruction1[9:5];
	generate
		for(genvar x = 0; x < 5; x++) begin
				//determine inputs to register
			mux2_1 regMux (.out(Ab[x]), .i0(Rm[x]), .i1(Rd[x]), .sel(Reg2Loc));	
		end
	endgenerate
	
	//determine inputs for ALU
	logic [63:0] Imm12, aluB;
	logic aluBsel;
	assign aluBsel = check2[0];
	zeroExtend12 zero12 (Imm12, instruction2[21:10]); //sets Imm12
	generate
		for(genvar x=0; x < 64; x++) begin
			//determine inputs to register
			mux2_1 alumux (.out(aluB[x]), .i0(Db[x]), .i1(Imm12[x]), .sel(aluBsel));	
		end
	endgenerate
	
	//puts the new ouputs to stage 3
	logic [63:0] nDa, nAluB;
	RtoAlu toAlu (.AluB(nAluB), .Da(nDa), .oAluB(aluB), .oDa(Da), .clk(clk));
	
	//stage 3:execute the command
	logic [63:0] aluresult;
	logic [2:0] ALUcontrol;
	
	logic negative, zero, overflow, carry_out;
	logic tempN, tempZ, tempO, tempC;
	logic flagControl;
	
	assign ALUcontrol[0] = check3[10]; //addi check3 -> 1,0 ,0, 0 ....
	not #0.05 notalugate (ALUcontrol[1] , check3[2]);
	or #0.05 oralugate (ALUcontrol[2] , check3[2], check3[6]);
	alu aluModule(.A(nDa), .B(nAluB), .cntrl(ALUcontrol), .result(aluresult), .negative(tempN), .zero(tempZ), .overflow(tempO), .carry_out(tempC));
	
	//determines if flags should be updated or not
	or #0.05 flagorgate (flagControl, check3[1], check3[10]);
	mux2_1 alumux0 (.out(negative), .i0(negative), .i1(tempN), .sel(flagControl));
	mux2_1 alumux1 (.out(zero), .i0(zero), .i1(tempZ), .sel(flagControl));
	mux2_1 alumux2 (.out(overflow), .i0(overflow), .i1(tempO), .sel(flagControl));
	mux2_1 alumux3 (.out(carry_out), .i0(carry_out), .i1(tempC), .sel(flagControl));
	
	//new output into stage 4
	logic [63:0] Memaddress; //change later
	alutoMem AtoM (.newData(Memaddress), .oldData(aluresult), .clk(clk));
	//stage 4: write it to data Memory
	
	
	//new output into stage 5
	//change later
	logic [63:0] Dw;
	MemtoWrite write (.newMemout(Dw), .oldMemout(Memaddress), .clk(clk));
	//stage 5: Write back
	logic [4:0] Aw;
	logic WrEn, WrEntemp;
	or #0.05 writeRegEn0 (WrEntemp, check4[0], check4[1], check4[6], check4[7], check4[8]);
	or #0.05 writeRegEn1 (WrEn, WrEntemp, check4[9], check4[2], check4[10]);
	assign Aw =  instruction4[4:0]; // mux later
	
	//Regfile logic
	//reading at stage 2/wrtting at stage 5
	regfile Regfile(.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Aa), .ReadRegister2(Ab), 
		.WriteRegister(Aw), .RegWrite(WrEn), .clk(clk));	
		
endmodule


module CPU_testbench();
	logic clk, reset;
	CPU dut (clk, reset);
	
	parameter ClockDelay = 5000;
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset = 1;
		#5000;
		reset = 0;
		#5000;
		#5000;
		#5000;
		#5000;
		#5000;
		#5000;
		#5000;
		$stop;
	end
endmodule 