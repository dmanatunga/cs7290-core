module alu_fp_simple (
	clock,
	srcA,
	srcB,
	float_op,
	select,
	result)/* synthesis synthesis_clearbox = 1 */;

input          clock;
input   [31:0] srcA;
input   [31:0] srcB;
input	[2:0]  float_op;
input	[2:0]  select;
output  [31:0] result;

wire   [31:0] srcA1;	//Later: declare them as array
wire   [31:0] srcA2;
wire   [31:0] srcA3;
wire   [31:0] srcA4;
wire   [31:0] srcA5;
wire   [31:0] srcA6;
wire   [31:0] srcA7;
wire   [31:0] result1;
wire   [31:0] result2;
wire   [31:0] result3;
wire   [31:0] result4;
wire   [31:0] result5;
wire   [31:0] result6;
wire   [31:0] result7;
wire 	      add;
wire 	      sub;

assign srcA1 = (float_op == 3'h1)?srcA:32'd0;	//itof
assign srcA2 = (float_op == 3'h2)?srcA:32'd0;  //ftoi
assign srcA3 = (float_op == 3'h3)?srcA:32'd0;  //fadd_sub	//FIX
assign srcA4 = (float_op == 3'h4)?srcA:32'd0;  //fadd_sub	//FIX
assign srcA5 = (float_op == 3'h5)?srcA:32'd0;  //fmul
assign srcA6 = (float_op == 3'h6)?srcA:32'd0;  //fdiv
assign srcA7 = (float_op == 3'h7)?srcA:32'd0;  //fneg

assign result = (select == 1)? result1 : ((select == 2)? result2 : ((select == 3)? result3:((select == 4)? result4 : ((select == 5)? result5 : ((select == 6)? result6 : ((select == 7)? result7 : 0 ))))));
assign add = 1;
assign sub = 0;	//temporary

//******ALU Blocks Instantiation start******
   fp_itof fp_itof1(
      .clock (clock),
      .dataa (srcA1),
      .result(result1)
   );

   fp_ftoi fp_ftoi1(
      .clock (clock),
      .dataa (srcA2),
      .result(result2)
   );

   fp_add_sub fp_add_sub1(
      .add_sub(add),
      .clock (clock),
      .dataa (srcA3),
      .datab (srcB),
      .result(result3)
   );

   fp_add_sub fp_add_sub2(	//FIX , you can use only one add_sub block Optimize this
      .add_sub(sub),
      .clock (clock),
      .dataa (srcA4),
      .datab (srcB),
      .result(result4)
   );

   fp_mult fp_mult1(
      .clock (clock),
      .dataa (srcA5),
      .datab (srcB),
      .result(result5)
   );
   
   fp_div fp_div1(
      .clock (clock),
      .dataa (srcA6),
      .datab (srcB),
      .result(result6)
   );

   fp_neg fp_neg1(
      .dataa (srcA7),
      .result(result7)
   );
//******ALU Blocks Instantiation end******
endmodule

//******ALU Blocks Definition start******
module fp_itof(
      clock ,
      dataa ,
      result);
input    [31:0] dataa;
output   [31:0] result;
input          clock;

assign result = dataa;	//FIX
endmodule

module fp_ftoi(
      clock ,
      dataa ,
      result);
input    [31:0] dataa;
output   [31:0] result;
input          clock;

assign result = dataa;	//FIX
endmodule

module fp_neg(
      dataa ,
      result);
input    [31:0] dataa;
output   [31:0] result;

assign result = {!dataa[31],dataa[30:0]};	//FIX
endmodule
//******ALU Blocks Definition end******
