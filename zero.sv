`timescale 1ns/10ps
module zero(out, inputs);
    input logic [63:0] inputs;
    output logic out;
    logic [15:0] a;
    logic [3:0] b;
	 logic notOut;
    generate
        for(genvar x = 0; x < 16; x++) begin
            or #0.05 orGate0 (a[x], inputs[4 * x], inputs[4 * x + 1], inputs[4 * x + 2], inputs[4* x + 3]);
        end
    endgenerate
    generate
        for(genvar y = 0; y < 4; y++) begin
            or #0.05 orGate1 (b[y], a[4 * y], a[4 * y + 1], a[4 * y + 2], a[4 * y + 3]);
        end
    endgenerate
    or #0.05 orGate2 (notOut, b[0], a[1], a[2], a[3]);
	 not #0.05 notGate (out, notOut);
endmodule

module zero_testbench();
	logic [63:0] inputs;
	logic out;
	zero dut (.out, .inputs);
	
	initial begin
		inputs = 64'h1000000000000000; #10;
		inputs = 64'h1111111111111111; #10;
		inputs = 0; #10;
		inputs = 64'h0000000010000000; #10;
	end
	
endmodule
