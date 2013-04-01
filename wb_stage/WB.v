`include "../globals.vh"
module WB(
    // Inputs
    clk,
    reset,
    // From ID stage
    add_rob_entry,
    entry_dest_addr,
    entry_ins_type,
    entry_exception,
    entry_ins_state,
    commit_reg_data,
    commit_pred_data,
    // From EX stage
    ins_rob_id,
    dest_addr, 
    ins_type,
    ins_data,
    ins_exception,
    is_nop,
    
    // Outputs
    // To IF stage
    halt,
    // To ID stage
    commit_reg_addr,
    commit_pred_addr,
    rob_full,	
    add_entry_id,
    wr_reg_en,
    wr_reg_addr,
    wr_reg_data,
    wr_pred_en,
    wr_pred_addr,
    wr_pred_data,
    // To EX stage
    commit_st
);

// Inputs
input				clk;
input				reset;
// Inputs from ID stage
input				add_rob_entry;
input	[`DEST_ADDR_SIZE-1:0]	entry_dest_addr;
input	[`INS_TYPE_SIZE-1:0]	entry_ins_type;
input	[`EXCEPTION_ID_SIZE-1:0]	entry_exception;	
input	[`INS_STATE_SIZE-1:0]	entry_ins_state;
input	[`REG_DATA_WIDTH-1:0]	commit_reg_data;
input	[`PRED_DATA_WIDTH-1:0]	commit_pred_data;
// Inputs from EX stage
input	[`ROB_ID_SIZE-1:0]	ins_rob_id;
input	[`DEST_ADDR_SIZE-1:0]	dest_addr;
input	[`INS_TYPE_SIZE-1:0]	ins_type;
input				is_nop;
input	[`DATA_WIDTH-1:0]	ins_data;
input	[`EXCEPTION_ID_SIZE-1:0]	ins_exception;	


// Outputs
output reg halt;
output	[`REG_ADDR_SIZE-1:0]	commit_reg_addr;
output	[`PRED_ADDR_SIZE-1:0]	commit_pred_addr;
output				rob_full;
output	[`ROB_ID_SIZE-1:0]	add_entry_id;
output				wr_reg_en;
output	[`REG_ADDR_SIZE-1:0]	wr_reg_addr;
output	[`REG_DATA_WIDTH-1:0]	wr_reg_data;
output				wr_pred_en;
output	[`PRED_ADDR_SIZE-1:0]	wr_pred_addr;
output	[`PRED_DATA_WIDTH-1:0]	wr_pred_data;
output				commit_st;

reg	[`EXCEPTION_ID_SIZE-1:0]	exception_register;
wire	commit;
wire	ins_is_head;
wire	[`ROB_ID_SIZE-1:0]	head_id;
wire	[`INS_STATE_SIZE-1:0]	head_finished;
wire	[`EXCEPTION_ID_SIZE-1:0]	head_exception;
wire	is_rob_full;

wire				set_ins_finished;
wire	[`DEST_ADDR_SIZE-1:0]	commit_dest_addr;
wire	[`INS_TYPE_SIZE-1:0]	commit_ins_type;
wire				commit_reg;
wire				commit_pred;
wire	[`REG_ADDR_SIZE-1:0]	arch_reg_addr;
wire	[`REG_DATA_WIDTH-1:0]	arch_reg_data;
wire	[`PRED_ADDR_SIZE-1:0]	arch_pred_addr;
wire	[`PRED_DATA_WIDTH-1:0]	arch_pred_data;

wire				ex_set_exception;
wire				throw_exception;
// If instruction is head, then write data to physical and architectural file
assign ins_is_head = ~is_nop & (ins_rob_id == head_id);
// Set the instruction as finished if it is not a NOP, and it is not already being 
// commited due to the instruction being the head
assign set_ins_finished = ~(is_nop | ins_is_head); 
// Commit instruction if the head is completed or current instruction is head
assign commit = (head_finished | ins_is_head) & ~throw_exception;
// Addresses for general and predicate register
assign commit_reg_addr = commit_dest_addr[`REG_ADDR_SIZE-1:0];
assign commit_pred_addr = commit_dest_addr[`PRED_ADDR_SIZE-1:0];

// Writeback signals for write stage (wr-reg is type 10, and wr-pred is type 11)
assign wr_reg_en = ins_type[1] & ~ins_type[0];
assign wr_pred_en = ins_type[1] & ins_type[0];
assign wr_reg_addr = dest_addr[`REG_ADDR_SIZE-1:0];
assign wrt_pred_addr = dest_addr[`PRED_ADDR_SIZE-1:0];

// Indicate if rob_full based on full signal, or if we are commiting
assign rob_full = ~commit & is_rob_full;

// Decoder to generate commit signals
decoder_2bit commit_decoder(
  .in(commit_ins_type),
  .enable(commit),
  .a(),
  .b(commit_st),
  .c(commit_reg),
  .d(commit_pred)
);

// Get data for register or predicate register
assign wr_reg_data = ins_data[`REG_DATA_WIDTH-1:0];
assign wr_pred_data = ins_data[`PRED_DATA_WIDTH-1:0];

// Arch. Register File
register_file_0r1w_asyncRposW #(.DATA_WIDTH(`REG_DATA_WIDTH), 
								.ADDR_SIZE(`REG_ADDR_SIZE)) 
  arch_register_file(
    .clk(clk),
    .reset(reset),
    .wr_en(commit_reg),
    .wr_addr(commit_reg_addr),
    .wr_data(commit_reg_data)
);

// Arch. Predicate Register File
register_file_0r1w_asyncRposW #(.DATA_WIDTH(`PRED_DATA_WIDTH), 
								.ADDR_SIZE(`PRED_ADDR_SIZE)) 
  arch_predicate_file(
    .clk(clk),
    .reset(reset),
    .wr_en(commit_pred),
    .wr_addr(commit_pred_addr),
    .wr_data(commit_pred_data)
);  

rob_unit #(.ROB_ADDR_SIZE(`ROB_ID_SIZE), 
           .DEST_ADDR_SIZE(`DEST_ADDR_SIZE), 
           .INS_TYPE_SIZE(`INS_TYPE_SIZE),
	   .EXCEPTION_ID_SIZE(`EXCEPTION_ID_SIZE)) 
  rob(
    .clk(clk),
    .reset(reset),
    .add_entry(add_rob_entry),
    .entry_dest_addr(entry_dest_addr),
    .entry_ins_type(entry_ins_type),
    .entry(exception(entry_exception),
	.entry_ins_state(entry_ins_state),
    .ins_rob_id(ins_rob_id),
    .set_ins_finished(set_ins_finished),
    .set_exception(ex_set_exception),
    .exception(ins_exception),
    .commit_head(commit),
    
    .head_id(head_id),
	.tail_id(add_entry_id),
    .head_state(head_finished),
    .head_exception(head_exception),
    .head_dest_addr(commit_dest_addr),
    .head_ins_type(commit_ins_type),
    .is_full(is_rob_full)
);

assign ex_set_exception = |ins_exception;
assign throw_exception = |head_exception | (ex_set_exception & ins_is_head);
always @(posedge clk) begin
	if (reset) begin
		halt <= 0;
		exception_reg <= 0;
	end else if (throw_exception) begin
		halt <= 1;
		if (ins_is_head) begin
			exception_reg <= head_exception;
		else
			exception_reg <= ins_exception;
		end
	end
end
endmodule
