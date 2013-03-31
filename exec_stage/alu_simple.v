module alu_simple (
	srcA,
	srcB,
	alu_op,
	result)/* synthesis synthesis_clearbox = 1 */;


parameter ALU_OP  = 3;
input	[ALU_OP - 1 : 0]  alu_op;
input   [31:0] srcA;
input   [31:0] srcB;
output reg  [31:0] result;

wire   [31:0] result1;
wire   [31:0] result2;
wire   [31:0] result3;
wire   [31:0] result4;

wire add_sub;
assign add_sub = (alu_op == 3'b110)? 1'b1 : 1'b0;	// temporary
always@(*)
begin
   case(alu_op)
      3'h6,3'h7:begin
      	   result    = result1;
       end
      3'h1:begin
	   result    = {!srcA[31],srcA[30:0]};	//FIX this is not corrct
       end
      3'h2:begin
      	   result    = ~srcA;
       end
      3'h3:begin
      	   result    = srcA & srcB;
       end
      3'h4:begin
      	   result    = srcA | srcB;
       end
      3'h5:begin
      	   result    = srcA ^ srcB;
       end
       default: begin
      	   result    = 32'b0;
      	end
   endcase
end

   int_add_sub int_add_sub1(
      .add_sub(add_sub),
      .dataa (srcA),
      .datab (srcB),
      .result(result1)
   );
   
endmodule

module int_add_sub(
        add_sub,
        dataa ,
        datab ,
        result);
input add_sub;
input   [31:0] dataa;
input   [31:0] datab;
output   [31:0] result;

   assign result = (add_sub)?(dataa + datab) : (dataa - datab);
endmodule
