`timescale 1ns/10ps
module normForwardAa (out, regLoc, dataIn3, dataIn4, dataIn5, dataLoc4, dataLoc5, check3, check4, check5, clk, reset);
	input logic [4:0] regLoc, dataLoc4, dataLoc5;
	input logic [63:0] dataIn3, dataIn4, dataIn5;
	input logic [10:0] check3, check4, check5;
	output logic [63:0] out;
	input logic clk, reset;
	// this forwarding is specifically for AB
	
	//if regloc = x31
	logic x31temp, x31;
	and #0.05 x31gate(x31temp, regLoc[4], regLoc[3], regLoc[2], regLoc[1], regLoc[0]);
	not #0.05 x31notgate(x31, x31temp);
	
	// to check if the function needs a forwarding or not
	logic controlReg, controlRegtemp1, controlRegtemp2;
	or #0.05 gate31 (controlRegtemp1, check3[0], check3[10], check3[1], check3[6], check3[7]);
	or #0.05 gate32 (controlRegtemp2, controlRegtemp1, check3[8], check3[2], check3[9]);
	and #0.05 gate33 (controlReg, x31, controlRegtemp2);
	
	// to check if functions that can forward to other function
	logic control4, control5, control4temp, control5temp;
	or #0.05 gate41 (control4temp, check4[0], check4[1], check4[2], check4[6], check4[7]);
	or #0.05 gate42 (control4, control4temp, check4[8], check4[10]);
	or #0.05 gate51 (control5temp, check5[0], check5[1], check5[2], check5[6], check5[7]);
	or #0.05 gate52 (control5, control5temp, check5[8], check5[10]);
	
	// compare the location of the stage 4 and current one to figure out if current stage is using same register.
	logic [4:0] compare4;
	logic forward4; //if location is same for 4
	xnor #0.05 gatecompare41 (compare4[0], regLoc[0], dataLoc4[0]);
	xnor #0.05 gatecompare42 (compare4[1], regLoc[1], dataLoc4[1]);
	xnor #0.05 gatecompare43 (compare4[2], regLoc[2], dataLoc4[2]);
	xnor #0.05 gatecompare44 (compare4[3], regLoc[3], dataLoc4[3]);
	xnor #0.05 gatecompare45 (compare4[4], regLoc[4], dataLoc4[4]);
	and  #0.05 gateequal41   (forward4, compare4[0], compare4[1], compare4[2], compare4[3], compare4[4]);
	
	// compare the location of the stage 5 and current one to figure out if current stage is using same register.
	logic [4:0] compare5;
	logic forward5; //if location is same for 5
	xnor #0.05 gatecompare51 (compare5[0], regLoc[0], dataLoc5[0]);
	xnor #0.05 gatecompare52 (compare5[1], regLoc[1], dataLoc5[1]);
	xnor #0.05 gatecompare53 (compare5[2], regLoc[2], dataLoc5[2]);
	xnor #0.05 gatecompare54 (compare5[3], regLoc[3], dataLoc5[3]);
	xnor #0.05 gatecompare55 (compare5[4], regLoc[4], dataLoc5[4]);
	and  #0.05 gateequal51   (forward5, compare5[0], compare5[1], compare5[2], compare5[3],compare5[4]);
	
	logic if4, if5, notif4;
	and  #0.05 ifgate4  (if4, forward4, control4, controlReg);
	not  #0.05 notifgate4 (notif4, if4); // to priortize the order of stage 4
	and  #0.05 ifgate5  (if5, forward5, control5, notif4, controlReg);
	logic [63:0] tempOut;
	generate 
		for( genvar x = 0; x < 64; x++) begin
			// forward the stage 4's data to output
			mux2_1 inmux1 (.out(tempOut[x]), .i0(dataIn3[x]), .i1(dataIn4[x]), .sel(if4));// priortize stage 4 one first one stage 5
		end
	endgenerate
	
	generate 
		for( genvar x = 0; x < 64; x++) begin
		// forward the stage 5's data to output
			mux2_1 inmux2 (.out(out[x]), .i0(tempOut[x]), .i1(dataIn5[x]), .sel(if5));
		end
	endgenerate
endmodule 