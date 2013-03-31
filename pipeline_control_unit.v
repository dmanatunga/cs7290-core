module pipeline_control_unit(
	// Inputs
	// For IF stage
	if_nop,
	id_stalls_if,
	sel_br,
	// For ID stage
	id_nop,
	// Outputs
	// IF stage latch signals
	if_stall_latch,
	if_clr_latch,
	
	// ID stage
	id_clr_latch
);

// Inputs
input	if_nop;
input	id_stalls_if;
input	sel_br;
// Outputs
input	id_nop;
// IF stage signals
output if_stall_latch;
output if_clr_latch;
// ID stage signals
output id_clr_latch;

assign if_clr_latch 	= if_nop | sel_br;
assign if_stall_latch 	= id_stalls_if;
assign id_clr_latch 	= id_stalls_if | id_nop;

endmodule

