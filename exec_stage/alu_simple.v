module alu_simple (
	clock,
	srcA,
	srcB,
	ctrl_sigs,
	result)/* synthesis synthesis_clearbox = 1 */;

input	[3:0]  ctrl_sigs;
input   [31:0] srcA;
input   [31:0] srcB;
input          clock;
output reg  [31:0] result;

wire   [31:0] result1;
wire   [31:0] result2;
wire   [31:0] result3;
wire   [31:0] result4;

wire add_sub;
assign add_sub = 1;	// temporary
always@(*)
begin
   case(ctrl_sigs)
      4'h1:begin
      	   result    = result1;
       end
      4'h2:begin
      	   result    = result3;
       end
      4'h3:begin
      	   result    = result4;
       end
      4'h4:begin
      	   result    = srcA << srcB;
       end
      4'h5:begin				
      	   result    = srcA >> srcB; // is_neg
       end
      4'h6:begin
      	   result    = srcA | srcB; // is_zero
       end
      4'h7:begin
      	   result    = srcA & srcB; // is_zero
       end
      4'h8:begin
      	   result    = srcA ^ srcB; // is_zero
       end
      4'h9:begin
	   result    = {!srcA[31],srcA[30:0]};	//f_neg
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
   
   fp_add_sub fp_add_sub1(
      .add_sub(add_sub),
      .clock (clock),
      .dataa (srcA),
      .datab (srcB),
      .result(result3)
   );
   
   //int mode operation??
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
