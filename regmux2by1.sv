`timescale 1ns/10ps

module regmux2by1(out, inp1, inp2, sel);
   output out;
   input inp1, inp2, sel;

   logic out1, out2, notSel;

   not #0.05 firstNot (notSel, sel);
   and #0.05 firstAnd(out1, inp1, sel);
	and #0.05 secondAnd(out2, inp2, notSel);
   or #0.05 firstOr(out, out1, out2);

endmodule
