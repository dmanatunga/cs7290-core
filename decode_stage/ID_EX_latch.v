module ID_EX_latch(
  // Inputs
  clk			,
  reset			,
  stall			,
  clr_latch		,
  in_dest_addr		,
  in_reg_src1		,
  in_reg_src2		,
  in_imm_0reg		,
  in_imm_1reg		,
  in_imm_2reg		,
  in_pred_src1		,
  in_pred_src2		,
  in_latency_counter	,
  in_ins_id		,
  in_func_select	,
  in_mem_type		,
  in_is_mem		,
  in_simple_alu_op	,
  in_complex_alu_op	,
  in_pred_op		,
  in_float_op		,
  in_ins_type		,
  in_muxa		,
  in_muxb		,
  in_next_pc		,
  // Outputs
  out_dest_addr		,
  out_reg_src1		,
  out_reg_src2		,
  out_imm_0reg		,
  out_imm_1reg		,
  out_imm_2reg		,
  out_pred_src1		,
  out_pred_src2		,
  out_latency_counter	,
  out_ins_id		,
  out_func_select	,
  out_mem_type		,
  out_is_mem		,
  out_simple_alu_op	,
  out_complex_alu_op	,
  out_pred_op		,
  out_float_op		,
  out_ins_type		,
  out_ins_nop		,
  out_muxa		,
  out_muxb		,
  out_next_pc		
);

// Inputs
input				clk;
input				reset;
input				stall;
input				clr_latch;
input	[`DEST_ADDR_SIZE-1:0]	in_dest_addr;
input	[`REG_DATA_WIDTH-1:0]	in_reg_src1;
input	[`REG_DATA_WIDTH-1:0]	in_reg_src2;
input	[`DATA_WIDTH-1:0]	in_imm_0reg;
input	[`DATA_WIDTH-1:0]	in_imm_1reg;
input	[`DATA_WIDTH-1:0]	in_imm_2reg;
input	[`PRED_DATA_WIDTH-1:0]	in_pred_src1;
input	[`PRED_DATA_WIDTH-1:0]	in_pred_src2;
input	[3:0]			in_latency_counter;
input	[`INS_TYPE_SIZE-1:0]	in_ins_type;
input	[2:0]			in_func_select;
input				in_mem_type;
input				in_is_mem;
input	[2:0]			in_simple_alu_op;
input	[2:0]			in_complex_alu_op;
input	[2:0]			in_pred_op;
input	[2:0]			in_float_op;
input	[`ROB_ID_SIZE-1:0]	in_ins_id;
input				in_muxa;
input	[1:0]			in_muxb;
input   [`DATA_WIDTH-1:0]	in_next_pc; // Also to ex latch



// Outputs
output reg				out_ins_nop;
output reg	[`DEST_ADDR_SIZE-1:0]	out_dest_addr;
output reg	[`REG_DATA_WIDTH-1:0]	out_reg_src1;
output reg	[`REG_DATA_WIDTH-1:0]	out_reg_src2;
output reg	[`DATA_WIDTH-1:0]	out_imm_0reg;
output reg	[`DATA_WIDTH-1:0]	out_imm_1reg;
output reg	[`DATA_WIDTH-1:0]	out_imm_2reg;
output reg	[`PRED_DATA_WIDTH-1:0]	out_pred_src1;
output reg	[`PRED_DATA_WIDTH-1:0]	out_pred_src2;
output reg	[3:0]			out_latency_counter;
output reg	[`INS_TYPE_SIZE-1:0]	out_ins_type;
output reg	[2:0]			out_func_select;
output reg				out_mem_type;
output reg				out_is_mem;
output reg	[2:0]			out_simple_alu_op;
output reg	[2:0]			out_complex_alu_op;
output reg	[2:0]			out_pred_op;
output reg	[2:0]			out_float_op;
output reg	[`ROB_ID_SIZE-1:0]	out_ins_id;
output reg				out_muxa;
output reg	[1:0]			out_muxb;
output reg      [`DATA_WIDTH-1:0]	out_next_pc; // Also to ex latch


always @(posedge clk) begin
	if (reset || (clr_latch && !stall)) begin
		out_next_pc 		<= 32'd0		;
		out_ins_nop 		<= 1'd1			;
    end else if (!stall) begin
		out_ins_nop 		<= 1'b0			;
		out_dest_addr		<= in_dest_addr		;
		out_reg_src1		<= in_reg_src1		;
		out_reg_src2		<= in_reg_src2		;
		out_imm_0reg		<= in_imm_0reg		;
		out_imm_1reg		<= in_imm_1reg		;
		out_imm_2reg		<= in_imm_2reg		;
		out_pred_src1		<= in_pred_src1		;
		out_pred_src2		<= in_pred_src2		;
		out_latency_counter	<= in_latency_counter	;
		out_ins_type		<= in_ins_type		;
		out_func_select		<= in_func_select	;
		out_mem_type		<= in_mem_type		;
		out_is_mem		<= in_is_mem		;
		out_simple_alu_op	<= in_simple_alu_op	;
		out_complex_alu_op	<= in_complex_alu_op	;
		out_pred_op		<= in_pred_op		;
		out_float_op		<= in_float_op		;
		out_ins_id		<= in_ins_id		;
		out_muxa		<= in_muxa		;
		out_muxb		<= in_muxb		;
		out_next_pc		<= in_next_pc		;
	end
end
endmodule
