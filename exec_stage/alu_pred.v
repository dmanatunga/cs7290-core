module alu_pred (
	pred_op,
	srcA,
	srcB,
	result)/* synthesis synthesis_clearbox = 1 */;

	input	[2:0]pred_op;
	input	[31:0]srcA;
	input	[31:0]srcB;
	output	reg  result;

always@(*)
begin
   case(pred_op)
      3'h1:begin
      	   result    = srcA[0] && srcB[0];
       end
      3'h2:begin
      	   result    = srcA[0] || srcB[0];
       end
      3'h3:begin
      	   result    = ((!srcA[0])&&(srcB[0])) || ((srcA[0])&&(!srcB[0]));
       end
      3'h4:begin
      	   result    = ~srcA[0];
       end
      3'h5:begin
      	   result    = srcA[31];	//FIX check this
       end
      3'h6:begin
      	   result    = (srcA == 0) ? 1'b1 : 1'b0;     //FIX check this
       end
       default: begin
      	   result    = 0;
      	end
   endcase
end

endmodule
