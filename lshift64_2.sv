module lshift64_2(dataIn, dataOut);
	input logic [63:0] dataIn;
	output logic [63:0] dataOut;
	
	assign dataOut[0] = 0;
	assign dataOut[1] = 0;
	generate
		for(genvar x = 2; x <64; x++) begin
			dataOut[x] = dataIn[x-2];
		end
	endgenerate 
endmodule 