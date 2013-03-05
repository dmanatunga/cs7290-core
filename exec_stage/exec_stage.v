module exec_stage(
   clk,
   dest_reg,
   R1_DataDst,
   ctrl_sigs,
   pc,
   R2_DataSrcA,
   R3_DataSrcB,
   imm16,   
   imm22, 
   pred_src1;
   pred_src2;
   alu_out,
   pred_out,
   ctrl_sigs_pass,
   R1_DataDst_pass,
   dest_reg_pass
   );
   input clk;
   input [2:0]dest_reg;
   input [31:0]R1_DataDst;
   input [5:0]ctrl_sigs;
   input [31:0]pc;
   input [31:0]R2_DataSrcA;
   input [31:0]R3_DataSrcB;
   input [31:0]imm16;
   input [31:0]imm22;
   input pred_src1;
   input pred_src2;

   output [31:0]alu_out;
   output       pred_out,
   output reg [5:0]ctrl_sigs_pass;
   output reg [31:0]R1_DataDst_pass;
   output reg [2:0]dest_reg_pass;
   
   reg [31:0]alu_inA;
   reg [31:0]alu_inB;
   reg operation;
   //always@(posedge clk)
   always@(*)
   begin
      ctrl_sigs_pass 		= ctrl_sigs;
      dest_reg_pass	 	= dest_reg;
      R1_DataDst_pass 		= R1_DataDst;

      case(ctrl_sigs) 
         6'h24,6'h23,6'h14,6'h15: begin 
   		   alu_inA 	= R2_DataSrcA;
   		   alu_inB 	= imm22;
		   operation    = 0;
   		end
         6'h1d : begin 
   		   alu_inA 	= pc;
   		   alu_inB 	= imm16;
		   operation    = 0;
   		end
         6'h1e : begin 
   		   alu_inA 	= R1_DataDst;
   		   alu_inB 	= 0;
		   operation    = 0;
   		end
	 6'h15,6'h0b:begin
   		   alu_inA 	= R2_DataSrcA;
   		   alu_inB 	= R3_DataSrcB;
		   operation    = 1;
   		end
         default: begin
   		   alu_inA 	<= R2_DataSrcA;
   		   alu_inB 	<= R3_DataSrcB;
		   operation    <= 0;
   		end
      endcase
   end

//   assign alu_out = (operation)?(alu_inA - alu_inB):(alu_inA + alu_inB);
alu_complex alu_complex1(
	.clock(clk),
	.srcA(R2_DataSrcA),
	.srcB(R3_DataSrcB),
	.ctrl_sigs(ctrl_sigs),
	.result(result_complex));

alu_pred alu_pred(
	.srcA(pred_src1),
	.srcB(pred_src2),
	.ctrl_sigs(ctrl_sigs),
	.result(result_pred));

alu_simple alu_simple1(
	.clock(clk),
	.srcA(R2_DataSrcA),
	.srcB(R3_DataSrcB),
	.ctrl_sigs(ctrl_sigs),
	.result(result_simple));
//alu_arbt alu_arbt1(
//);
endmodule
