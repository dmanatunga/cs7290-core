module alu_pred (
	ctrl_sigs,
	srcA,
	srcB,
	result)/* synthesis synthesis_clearbox = 1 */;

	input	[3:0]ctrl_sigs;
	input	  srcA;
	input	  srcB;
	output	reg  result;

always@(*)
begin
   case(ctrl_sigs)
      4'h1:begin
      	   result    = srcA && srcB;
       end
      4'h2:begin
      	   result    = srcA || srcB;
       end
      4'h3:begin
      	   result    = ((!srcA)&&(srcB)) || ((srcA)&&(!srcB));
       end
      4'h4:begin
      	   result    = !srcA;
       end
      //4'h4:begin				
      //	   result    = !srcA; // is_neg
      // end
      //4'h4:begin
      //	   result    = !srcA; // is_zero
      // end
       default: begin
      	   result    = 0;
      	end
   endcase
end

endmodule
