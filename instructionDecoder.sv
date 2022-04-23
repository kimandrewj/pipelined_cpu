`timescale 1ns/10ps
module instructionDecoder(instruction, check);
	input logic [31:0] instruction;
	output logic [10:0] check;
	
	//x[0] is addi enambled
	logic [9:0] check0, a0;
	logic b0, c0, d0;
	assign check0 = 10'b1001000100;
	generate 
		for(genvar x = 0; x<10; x++) begin
			xnor #0.05 xnorgate0(a0[x], check0[x], instruction[22+x]);
		end
	endgenerate 
	and #0.05 andgate00(b0,a0[0], a0[1], a0[2], a0[3]);
	and #0.05 andgate01(c0,a0[4], a0[5], a0[6], a0[7]);
	and #0.05 andgate02(d0,a0[8], a0[9]);
	and #0.05 andgate03(check[0], b0, c0, d0);
	
	//x[1] is adds enambled
	logic [10:0] check1, a1;
	logic b1, c1, d1;
	assign check1 = 11'b10101011000;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate1(a1[x], check1[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate10(b1,a1[0], a1[1], a1[2], a1[3]);
	and #0.05 andgate11(c1,a1[4], a1[5], a1[6], a1[7]);
	and #0.05 andgate12(d1,a1[8], a1[9], a1[10]);
	and #0.05 andgate13(check[1], b1, c1, d1);
	
	//x[2] is and enambled
	logic [10:0] check2, a2;
	logic b2, c2, d2;
	assign check2 = 11'b10001010000;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate2(a2[x], check2[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate20(b2,a2[0], a2[1], a2[2], a2[3]);
	and #0.05 andgate21(c2,a2[4], a2[5], a2[6], a2[7]);
	and #0.05 andgate22(d2,a2[8], a2[9], a2[10]);
	and #0.05 andgate23(check[2], b2, c2, d2);
	
	//x[3] is B enambled
	logic [5:0] check3, a3;
	logic b3, c3, d3;
	assign check3 = 6'b000101;
	generate 
		for(genvar x = 0; x<6; x++) begin
			xnor #0.05 xnorgate3(a3[x], check3[x], instruction[26+x]);
		end
	endgenerate 
	and #0.05 andgate30(b3,a3[0], a3[1], a3[2], a3[3]);
	and #0.05 andgate31(c3,a3[4], a3[5]);
	and #0.05 andgate32(check[3], b3, c3);
	
	//x[4] is B.Lt
	logic [7:0] check4, a4;
	logic b4, c4, d4;
	assign check4 = 8'b01010100;
	generate 
		for(genvar x = 0; x<8; x++) begin
			xnor #0.05 xnorgate4(a4[x], check4[x], instruction[24+x]);
		end
	endgenerate 
	and #0.05 andgate40(b4,a4[0], a4[1], a4[2], a4[3]);
	and #0.05 andgate41(c4,a4[4], a4[5], a4[6], a4[7]);
	and #0.05 andgate42(check[4], b4, c4);
	
	//x[5] is CBZ
	logic [7:0] check5, a5;
	logic b5, c5;
	assign check5 = 8'b10110100;
	generate 
		for(genvar x = 0; x<8; x++) begin
			xnor #0.05 xnorgate5(a5[x], check5[x], instruction[24+x]);
		end
	endgenerate 
	and #0.05 andgate50(b5,a5[0], a5[1], a5[2], a5[3]);
	and #0.05 andgate51(c5,a5[4], a5[5], a5[6], a5[7]);
	and #0.05 andgate52(check[5], b5, c5);
	
	//x[6] is EOR
	logic [10:0] check6, a6;
	logic b6, c6, d6;
	assign check6 = 11'b11001010000;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate6(a6[x], check6[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate60(b6,a6[0], a6[1], a6[2], a6[3]);
	and #0.05 andgate61(c6,a6[4], a6[5], a6[6], a6[7]);
	and #0.05 andgate62(d6,a6[8], a6[9], a6[10]);
	and #0.05 andgate63(check[6], b6, c6, d6);
	
	//x[7] is LDUR
	logic [10:0] check7, a7;
	logic b7, c7, d7;
	assign check7 = 11'b11111000010;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate7(a7[x], check7[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate70(b7,a7[0], a7[1], a7[2], a7[3]);
	and #0.05 andgate71(c7,a7[4], a7[5], a7[6], a7[7]);
	and #0.05 andgate72(d7,a7[8], a7[9], a7[10]);
	and #0.05 andgate73(check[7], b7, c7, d7);
	
	//x[8] is LSR
	logic [10:0] check8, a8;
	logic b8, c8, d8;
	assign check8 = 11'b11010011010;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate8(a8[x], check8[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate80(b8,a8[0], a8[1], a8[2], a8[3]);
	and #0.05 andgate81(c8,a8[4], a8[5], a8[6], a8[7]);
	and #0.05 andgate82(d8,a8[8], a8[9], a8[10]);
	and #0.05 andgate83(check[8], b8, c8, d8);
	
	//x[9] is STUR
	logic [10:0] check9, a9;
	logic b9, c9, d9;
	assign check9 = 11'b11111000000;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate9(a9[x], check9[x], instruction[21+x]);
		end
	endgenerate 
	and #0.05 andgate90(b9,a9[0], a9[1], a9[2], a9[3]);
	and #0.05 andgate91(c9,a9[4], a9[5], a9[6], a9[7]);
	and #0.05 andgate92(d9,a9[8], a9[9], a9[10]);
	and #0.05 andgate93(check[9], b9, c9, d9);
	
	//x[10] is Subs
	logic [10:0] check10, a10;
	logic b10, c10, d10;
	assign check10 = 11'b11101011000;
	generate 
		for(genvar x = 0; x<11; x++) begin
			xnor #0.05 xnorgate10(a10[x], check10[x], instruction[21+x]);
		end
	endgenerate  
	and #0.05 andgate100(b10,a10[0], a10[1], a10[2], a10[3]);
	and #0.05 andgate101(c10,a10[4], a10[5], a10[6], a10[7]);
	and #0.05 andgate102(d10,a10[8], a10[9], a10[10]);
	and #0.05 andgate103(check[10], b10, c10, d10);
 endmodule


module instructionDecoder_testbench();
	logic [31:0] instruction;
	logic [10:0] check;
	
	instructionDecodern dut (instruction, check);
	
	initial begin
		instruction = 32'b00000000000000000000000000000000; #50; //case
		instruction = 32'b10010001000000000000000000000000; #50; //1
		instruction = 32'b10101011000000000000000000000000; #50; //2
		instruction = 32'b10001010000000000000000000000000; #50;
		instruction = 32'b10010110000000000000000000000000; #50;
		instruction = 32'b11010110000000000000000000000000; #50;
		instruction = 32'b01010110000000000000000000000000; #50;
		instruction = 32'b00010110000000000000000000000000; #50;
		instruction = 32'b00010110000000000000000000000000; #50;
		instruction = 32'b01110110000000000000000000000000; #50;
		instruction = 32'b00010110000000000000000000000000; #50;
		instruction = 32'b11110110000000000000000000000000; #50;
		instruction = 32'b11010110000000000000000000000000; #50;
	end
endmodule 