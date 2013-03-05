module alu_complex (
	clock,
	srcA,
	srcB,
	ctrl_sigs,
	result)/* synthesis synthesis_clearbox = 1 */;

input	[3:0]  ctrl_sigs;
input   [31:0] srcA;
input   [31:0] srcB;
output   [31:0] result;
input          clock;

wire   [31:0] srcA1;
wire   [31:0] srcA2;
wire   [31:0] srcA3;
wire   [31:0] srcA4;
wire   [31:0] result1;
wire   [31:0] result2;
wire   [31:0] result3;
wire   [31:0] result4;

assign srcA1 = (ctrl_sigs == 4'h1)?srcA:32'd0;
assign srcA2 = (ctrl_sigs == 4'h2)?srcA:32'd0;
assign srcA3 = (ctrl_sigs == 4'h3)?srcA:32'd0;
assign srcA4 = (ctrl_sigs == 4'h4)?srcA:32'd0;

assign result = result1 | result2 | result3 | result4;

   int_mult int_mult1(
      .clock (clock),
      .dataa (srcA1),
      .datab (srcB),
      .result(result1)
   );
   
   int_div int_div1(
      .clock (clock),
      .denom (srcA2),
      .numer (srcB),
      .quotient(result2)
   );
   
   fp_mult fp_mult1(
      .clock (clock),
      .dataa (srcA3),
      .datab (srcB),
      .result(result3)
   );
   
   fp_div fp_div1(
      .clock (clock),
      .dataa (srcA4),
      .datab (srcB),
      .result(result4)
   );

   //int mode operation??
endmodule

//module int_mult(
//      clock ,
//      dataa ,
//      datab ,
//      result);
//input   [31:0] dataa;
//input   [31:0] datab;
//output   [31:0] result;
//input          clock;
//
//assign result = dataa * datab;
//
//endmodule
