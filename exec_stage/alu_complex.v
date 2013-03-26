module alu_complex (
	clock,
	srcA,
	srcB,
	complex_alu_op,
	select,
	result)/* synthesis synthesis_clearbox = 1 */;

input          clock;
input   [31:0] srcA;
input   [31:0] srcB;
input	[2:0]  complex_alu_op;
input   [2:0]  select;
output  [31:0] result;


wire   [31:0] srcA1;
wire   [31:0] srcA2;
wire   [31:0] srcA3;
wire   [31:0] srcA4;
wire   [31:0] srcA5;
wire   [31:0] result1;
wire   [31:0] result2;
wire   [31:0] result3;
wire   [31:0] result4;
wire   [31:0] result5;

assign srcA1 = (complex_alu_op == 3'h1)?srcA:32'd0;	//is this needed?
assign srcA2 = (complex_alu_op == 3'h2)?srcA:32'd0;
assign srcA3 = (complex_alu_op == 3'h3)?srcA:32'd0;
assign srcA4 = (complex_alu_op == 3'h4)?srcA:32'd0;
assign srcA5 = (complex_alu_op == 3'h5)?srcA:32'd0;

assign result = (select == 1)? result1 : ((select == 2)? result2 : ((select == 3)? result3:((select == 4)? result4 : ((select == 5)? result5 : 0))));


//******ALU Blocks Instantiation start******
   int_mult int_mult1(
      .clock (clock),
      .dataa (srcA1),
      .datab (srcB),
      .result(result1)
   );
   
   int_div int_div1(
      .clock (clock),
      .numer (srcA2),
      .denom (srcB),
      .quotient(result2)
   );
   
   int_mod int_mod1(
      .clock (clock),
      .dataa (srcA3),
      .datab (srcB),
      .result(result3)
   );
   
   int_shl int_shl1(
      .clock (clock),
      .dataa (srcA4),
      .datab (srcB),
      .result(result4)
   );

   int_shr int_shlr1(
      .clock (clock),
      .dataa (srcA5),
      .datab (srcB),
      .result(result5)
   );
//******ALU Blocks Instantiation end******
endmodule

//******ALU Blocks Definition start******
module int_mod(
      clock ,
      dataa ,
      datab ,
      result);
input    [31:0] dataa;
input    [31:0] datab;
output   [31:0] result;
input          clock;

assign result = dataa % datab;	//FIX
endmodule

module int_shl(
      clock ,
      dataa ,
      datab ,
      result);
input    [31:0] dataa;
input    [31:0] datab;
output   [31:0] result;
input          clock;

assign result = dataa << datab;	//FIX
endmodule

module int_shr(
      clock ,
      dataa ,
      datab ,
      result);
input    [31:0] dataa;
input    [31:0] datab;
output   [31:0] result;
input          clock;

assign result = dataa >> datab;	//FIX
endmodule
//******ALU Blocks Definition end******


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

//Dead code
//always@(complex_alu_op, select)
////always@(complex_alu_op)
//begin
//      case(complex_alu_op)
//	4'h1: select = 1;
//	4'h2: select = 2;
//	4'h3: select = 3;
//	4'h4: select = 4;
//	default: select = select;	//FIX this
//      endcase
//end

