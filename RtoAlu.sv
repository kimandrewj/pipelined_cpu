module RtoAlu(AluB, Da, oAluB, oDa, clk);
	output logic [63:0] AluB, Da;
	input logic clk;
	input logic [63:0] oAluB, oDa;
	
	always_ff @(posedge clk) begin
		AluB <= oAluB;
		Da <= oDa;
	end
endmodule 