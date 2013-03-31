module IF_ID_latch(
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
  out_next_pc		,
);

// Inputs
input					clk;
input					reset;
input	[`INS_SIZE-1:0]	in_next_pc;

























// Outputs


always @(posedge clk) begin
	if (reset || (clr_latch && !stall)) begin
		out_next_pc <= 32'd0;
		out_ins <= 32'd0;
		out_is_nop <= 1'd1;
    end else if (!stall) begin
		out_next_pc <= in_next_pc;
		out_ins <= in_ins;
		out_is_nop <= 1'b0;
	end
end
endmodule
