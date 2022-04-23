module mux4by1(out, ins, sel);
    input logic [3:0] ins;
    input logic [1:0] sel;
    output logic out;
    logic [1:0] out0;

    mux2by1 mux0(.out(out0[0]), .ins(ins[1:0]), .sel(sel[0]));
    mux2by1 mux1(.out(out0[1]), .ins(ins[3:2]), .sel(sel[0]));
    mux2by1 fin (.out(out), .ins(out0), .sel(sel[1]));
	 
endmodule
