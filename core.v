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
// From dcahce controller
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

// From IF stage
wire	[`DATA_WIDTH-1:0]	if_next_pc;
wire    [`INS_WIDTH-1:0]    if_ins;
wire						if_nop;
// To IF latch from stall unit
wire	if_stall_latch;
wire	if_clr_latch;

// To ID stage
wire    [`DATA_WIDTH-1:0]	id_next_pc;
wire    [`INS_WIDTH-1:0]	id_ins;
wire						id_ins_is_nop;


// From ID stage to stall unit
wire						id_stall;

wire              id_muxA_sel;
wire    [1:0]     id_muxB_sel;
wire    [1:0]     id_alu_op;
wire              id_br_ins;
wire              id_br_type;
wire              id_mem_ins;
wire              id_mem_type;
wire              id_sel_data;
wire              id_wr_reg;

// Execute wires
wire    [31:0]    ex_next_pc;
wire    [2:0]     ex_dest_reg;
wire    [31:0]    ex_r1_data;
wire    [31:0]    ex_r2_data;
wire    [31:0]    ex_r3_data;
wire    [31:0]    ex_imm22;
wire    [31:0]    ex_imm16;
wire              ex_pred_val;
wire    [31:0]    ex_alu_out;

wire              ex_muxA_sel;
wire    [1:0]     ex_muxB_sel;
wire    [1:0]     ex_alu_op;
wire              ex_br_ins;
wire              ex_br_type;
wire              ex_mem_ins;
wire              ex_mem_type;
wire              ex_sel_data;
wire              ex_wr_reg;

// Memory wires
wire    [31:0]    mem_alu_out;
wire    [31:0]    mem_r1_data;
wire    [2:0]     mem_dest_reg;
wire              mem_pred_val;
wire              mem_br_ins;
wire              mem_br_type;
wire              mem_mem_ins;
wire              mem_mem_type;
wire              mem_sel_data;
wire              mem_wr_reg;

wire    [31:0]    mem_mem_data;
wire    [31:0]    mem_br_targ;

// Writeback wires
wire    [31:0]    wb_alu_out;
wire    [31:0]    wb_mem_data;
wire    [2:0]     wb_dest_reg;
wire              wb_pred_val;
wire              wb_mem_ins;
wire              wb_wr_reg;
wire              wb_wr_en;
wire    [2:0]     wb_wr_addr;
wire    [31:0]    wb_wr_data;

// Stall wires
wire	id_stalls_if;

pipeline_control_unit pipeline(
	.if_nop(if_nop),
	.id_stalls_if(id_stalls_if),
	.sel_br(if_sel_br),
	
	.if_stall_latch(if_stall_latch),
	.if_clr_latch(if_clr_latch),
); 

assign icache_rw_out = 1'b0; // i-cache only ever reads
// Instruction Fetch Stage
IF if_stage(
	.clk(clk), 
	.reset(reset),
	.mem_stall(icache_stall_in),
	.mem_data(icache_data_in),
	.mem_id(icache_data_id),
	.mem_valid(icache_ready_in),
	
	.sel_br(if_sel_br), 
    .br_target(if_br_target),
	.if_stall(if_stall_latch),
	
	.fetch_addr(icache_addr_out),
	.fetch_id(icache_id_out),
	.fetch_valid(icache_valid_out),
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
	
	// From IF/ID latch
	.ins(id_ins),
	.next_pc(id_next_pc),
	.is_nop(id_is_nop),

	// From EX stage
	.free_unit(),
	.free_unit_id(),
	// From WB stage
	rob_full,
	entry_id,
	commit_reg_addr,
	commit_pred_addr,
	wr_reg_en,
	wr_reg_addr,
	wr_reg_data,
	wr_pred_en,
	wr_pred_addr,
	wr_pred_data,
  
	// Outputs
	.id_stall(id_stall),
	// To IF stage
	sel_br,
	br_target,
	// To EX stage
	ins_nop,
	ins_id,
  ins_type,
  predicate,
  dest_addr,
  reg_src1,
  reg_src2,
  pred_src1,
  pred_src2,
  imm_0reg,
  imm_1reg,
  imm_2reg,
  mem_type,
  
  // To WB stage
  add_entry,
  entry_ins_type,
  entry_dest_addr,
  commit_reg_value,
  commit_pred_value
		
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
    ins_rob_id,
    dest_addr, 
    ins_type,
    ins_data,
	is_nop,    
    
    // Outputs
    // To ID stage
    .commit_reg_addr(commit_reg_addr),
    .commit_pred_addr(commit_pred_addr),
	.rob_full(rob_full), 
    .wr_reg_en(wr_reg_en),
    .wr_reg_addr(wr_reg_addr),
    .wr_reg_data(wr_reg_data),
    .wr_pred_en(wr_pred_en),
    .wr_pred_addr(wr_pred_addr),
    .wr_pred_data(wr_pred_en),
);

endmodule

