`include "globals.vh"
module core(
	// Inputs
    clk,
	reset,
	// From icache controller
	icache_data_in,
	icache_id_in,
	icache_ready_in,
	icache_stall_in,
	// From dcache controller
	dcache_data_in,
	dcache_id_in,
	dcache_ready_in,
	dcache_stall_in,
	// Ouputs
	// To icache controller
	icache_addr_out,
	icache_data_out,
	icache_rw_out,
	icache_id_out,
	icache_valid_out,
	// To dcache controller
	dcache_addr_out,
	dcache_data_out,
	dcache_rw_out,
	dcache_id_out,
	dcache_valid_out
);
// Inputs
input clk;
input reset;
// From icache controller
input	[`DATA_WIDTH-1:0]	icache_data_in;
input	[3:0]				icache_id_in;
input						icache_ready_in;
input						icache_stall_in;
// From dcache controller
input	[`DATA_WIDTH-1:0]	dcache_data_in;
input	[3:0]				dcache_id_in;
input						dcache_ready_in;
input						dcache_stall_in;
// Outputs
// To icache controller
output	[`DATA_WIDTH-1:0]	icache_addr_out;
output	[`DATA_WIDTH-1:0]	icache_data_out;
output						icache_rw_out;
output	[3:0]				icache_id_out;
output						icache_valid_out;
// To dcache controller
output	[`DATA_WIDTH-1:0]	dcache_addr_out;
output	[`DATA_WIDTH-1:0]	dcache_data_out;
output						dcache_rw_out;
output	[3:0]				dcache_id_out;
output						dcache_valid_out;

// From IF stage to IF latch
wire	[`DATA_WIDTH-1:0]	if_next_pc;
wire    [`INS_WIDTH-1:0]    if_ins;
wire						if_nop;

// From stall unit to IF latch 
wire	if_stall_latch;
wire	if_clr_latch;

// From IF latch to ID stage
wire    [`DATA_WIDTH-1:0]	id_next_pc;
wire    [`INS_WIDTH-1:0]	id_ins;
wire						id_ins_is_nop;

// From ID stage to IF stage
wire							if_sel_br;
wire    [`DATA_WIDTH-1:0]		if_br_target;	
wire							id_stalls_if;

// From ID stage to WB stage
wire							add_rob_entry;
wire	[`DEST_ADDR_SIZE-1:0]	entry_dest_addr;
wire	[`INS_TYPE_SIZE-1:0]	entry_ins_type;
wire	[`INS_STATE_SIZE-1:0]	entry_ins_state;
wire	[`REG_DATA_WIDTH-1:0]	commit_reg_data;
wire	[`PRED_DATA_WIDTH-1:0]	commit_pred_data;

// From EX stage to WB latch
wire	[`ROB_ID_SIZE-1:0]		ex_ins_rob_id;
wire	[`DEST_ADDR_SIZE-1:0]	ex_dest_addr;
wire	[`INS_TYPE_SIZE-1:0]	ex_ins_type;
wire    [`DATA_WIDTH-1:0]		ex_ins_data;
wire    [`DATA_WIDTH-1:0]		ex_ins_is_nop;
    
// From WB stage to ID stage
wire	[`REG_ADDR_SIZE-1:0]	commit_reg_addr;
wire	[`PRED_ADDR_SIZE-1:0]	commit_pred_addr;
wire							rob_full;
wire	[`ROB_ID_SIZE-1:0]		entry_id;
wire							wr_reg_en;
wire	[`REG_ADDR_SIZE-1:0]	wr_reg_addr;
wire	[`REG_DATA_WIDTH-1:0]	wr_reg_data;
wire							wr_pred_en;
wire	[`PRED_ADDR_SIZE-1:0]	wr_pred_addr;
wire	[`PRED_DATA_WIDTH-1:0]	wr_pred_en;



pipeline_control_unit pipeline(
	.if_nop(if_nop),
	.id_stalls_if(id_stalls_if),
	.sel_br(if_sel_br),
	.id(id_nop),
	
	.if_stall_latch(if_stall_latch),
	.if_clr_latch(if_clr_latch),
); 

assign icache_rw_out = 1'b0; // i-cache only ever reads
// Instruction Fetch Stage
IF if_stage(
	.clk(clk), 
	.reset(reset),
	// From outside core memory
	.mem_stall(icache_stall_in),
	.mem_data(icache_data_in),
	.mem_id(icache_data_id),
	.mem_valid(icache_ready_in),
	// From ID stage
	.sel_br(if_sel_br), 
    .br_target(if_br_target),
	// From stall unit
	.if_stall(if_stall_latch),
	// To outside core memory
	.fetch_addr(icache_addr_out),
	.fetch_id(icache_id_out),
	.fetch_valid(icache_valid_out),
	// To latch
    .next_pc(if_next_pc), 
    .ins(if_ins),
	.ins_is_nop(if_nop)
);

// Latch between Instruction Fetch and Instruction Decode
IF_ID_latch if_id_latch(
	.clk(clk),
	.reset(reset),
	.stall(if_stall_latch),
	.clr_latch(if_clr_latch),
    .in_next_pc(if_next_pc), 
    .in_ins(if_ins), 
    .out_next_pc(id_next_pc), 
    .out_ins(id_ins),
	.out_is_nop(id_is_nop)
);

// Instruction Decode Stage
ID id(
	.clk(clk),
    .reset(reset),
	
	// From IF stage latch
	.ins(id_ins),
	.ins_is_nop(id_is_nop),
	.next_pc(id_next_pc),

	// From EX stage
	.free_unit(ex_free_unit),
	.free_unit_id(ex_free_unit_id),
	
	// From WB stage
	.rob_full(rob_full),
	.entry_id(entry_id),
	.commit_reg_addr(commit_reg_addr),
	.commit_pred_addr(commit_pred_addr),
	.wr_reg_en(wr_reg_en),
	.wr_reg_addr(wr_reg_addr),
	.wr_reg_data(wr_reg_data),
	.wr_pred_en(wr_pred_en),
	.wr_pred_addr(wr_pred_addr),
	.wr_pred_data(wr_pred_data),
  
	// Outputs
	.id_stalls_if(id_stalls_if),
	// To IF stage
	.sel_br(if_sel_br),
	.br_target(if_br_target),
	// To EX stage
	.ins_nop,
	.ins_id,
	.ins_type,
	.predicate,
	.dest_addr,
	.reg_src1,
	.reg_src2,
	.pred_src1,
	.pred_src2,
	.imm_0reg,
	.imm_1reg,
	.imm_2reg,
	.mem_type,
  
	// To WB stage
	.add_rob_entry(add_rob_entry),
	.entry_dest_addr(entry_dest_addr),
	.entry_ins_type(entry_ins_type),
	.entry_ins_state(entry_ins_state),
	.commit_reg_data(commit_reg_data),
	.commit_pred_data(commit_pred_data)	
);

// Latch between Instruction Decode and Execute
ID_EX_latch id_ex_latch(
	.clk(clk),
	.reset(reset),
	
);


// Writeback stage
WB  wb(
	.clk(clk),
	.reset(reset),
	// From ID stage
	.add_rob_entry(add_rob_entry),
    .entry_dest_addr(entry_dest_addr),
    .entry_ins_type(entry_ins_type),
	.entry_ins_state(entry_ins_state),
    .commit_reg_data(commit_reg_data),
    .commit_pred_data(commit_pred_data),
    // From EX-WB latch
    .ins_rob_id(ex_ins_rob_id),
    .dest_addr(ex_dest_addr), 
    .ins_type(ex_ins_type),
    .ins_data(ex_ins_data),
	.ins_is_nop(ex_ins_is_nop),    
    
    // To ID stage
    .commit_reg_addr(commit_reg_addr),
    .commit_pred_addr(commit_pred_addr),
	.rob_full(rob_full), 
	.add_entry_id(entry_id),
    .wr_reg_en(wr_reg_en),
    .wr_reg_addr(wr_reg_addr),
    .wr_reg_data(wr_reg_data),
    .wr_pred_en(wr_pred_en),
    .wr_pred_addr(wr_pred_addr),
    .wr_pred_data(wr_pred_en),
);

endmodule
