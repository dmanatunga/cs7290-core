`include "globals.vh"

module WB(
    // Inputs
    clk,
    reset,
    // From ID stage
    add_rob_entry,
    entry_dest_addr,
    entry_ins_type,
    commit_reg_data,
    commit_pred_data,
    // From EX stage
    ins_rob_id,
    dest_addr, 
    ins_type,
    is_nop,
    ins_data,    
    
    // Outputs
    // To ID stage
    commit_reg_addr,
    commit_pred_addr,
    rob_full, 
    wr_reg_en,
    wr_reg_addr,
    wr_reg_data,
    wr_pred_en,
    wr_pred_addr,
    wr_pred_data
);


// Inputs
input                          clk;
input                          reset;
// Inputs from ID stage
input                          add_rob_entry;
input   [`DEST_ADDR_SIZE-1:0]  entry_dest_addr;
input   [`INS_TYPE_SIZE-1:0]   entry_ins_type;
input   [`REG_DATA_SIZE-1:0]   commit_reg_data;
input   [`PRED_DATA_SIZE-1:0]  commit_pred_data;
// Inputs from EX stage
input   [`ROB_ADDR_SIZE-1:0]   ins_rob_id;
input   [`DEST_ADDR_SIZE-1:0]  dest_addr;
input   [`INS_TYPE_SIZE-1:0]   ins_type;
input                          is_nop;
input   [`DATA_WIDTH-1:0]      ins_data;


// Outputs
output    [`REG_ADDR_SIZE-1:0]  commit_reg_addr;
output    [`PRED_ADDR_SIZE-1:0] commit_pred_addr;
output                          rob_full;
output                          wr_reg_en;
output    [`REG_ADDR_SIZE-1:0]  wr_reg_addr;
output    [`REG_DATA_SIZE-1:0]  wr_reg_data;
output                          wr_pred_en;
output    [`PRED_ADDR_SIZE-1:0] wr_pred_addr;
output    [`PRED_DATA_SIZE-1:0] wr_pred_data;

wire commit;
wire ins_is_head;
wire head_id;
wire head_finished;

wire                            set_ins_finished;
wire    [`DEST_ADDR_SIZE-1:0]   commit_dest_addr;
wire    [`INS_TYPE_SIZE-1:0]    commit_ins_type;
wire                            commit_st;
wire                            commit_reg;
wire                            commit_pred;
wire    [`REG_ADDR_SIZE-1:0]    arch_reg_addr;
wire    [`REG_DATA_SIZE-1:0]    arch_reg_data;
wire    [`PRED_ADDR_SIZE-1:0]   arch_pred_addr;
wire    [`PRED_DATA_SIZE-1:0]   arch_pred_data;

// If instruction is head, then write data to physical and architectural file
assign ins_is_head = ~is_nop & (ins_rob_id == head_id);
// Set the instruction as finished if it is not a NOP, and it is not already being 
// commited due to the instruction being the head
assign set_ins_finished = ~is_nop & ~ins_is_head; 
// Commit instruction if the head is completed or current instruction is head
assign commit = head_finished | ins_is_head;
// Addresses for general and predicate register
assign commit_reg_addr = commit_dest_addr[`REG_ADDR_SIZE-1:0];
assign commit_pred_addr = commit_pred_addr[`PRED_ADDR_SIZE-1:0];

// Writeback signals for write stage (wr-reg is type 10, and wr-pred is type 11)
assign wr_reg_en = ins_type[1] & ~commit_ins_type[0];
assign wr_pred_en = ins_type[1] & commit_ins_type[0];

// Decoder to generate commit signals
decoder2 commit_dec(
  .in(commit_ins_type),
  .enable(commit),
  .A(),
  .B(commit_st),
  .C(commit_reg),
  .D(commit_pred)
);

// Get data for register or predicate register
assign wr_reg_data = ins_data[`REG_DATA_SIZE-1:0];
assign wr_pred_data = ins_data[`PRED_DATA_SIZE-1:0];

// Arch. Register File
register_file_0r1w #(.DATA_WIDTH(`REG_DATA_SIZE), 
                     .REG_ADDR_SIZE(`REG_ADDR_SIZE)) 
  arch_register_file(
    .clk(clk),
    .reset(reset),
    .wr_en(commit_reg),
    .wr_addr(commit_reg_addr),
    .wr_data(commit_reg_data)
);

// Arch. Predicate Register File
register_file_0r1w #(.DATA_WIDTH(`PRED_DATA_SIZE), 
                     .ADDR_SIZE(`PRED_ADDR_SIZE)) 
  arch_predicate_file(
    .clk(clk),
    .reset(reset),
    .wr_en(commit_pred),
    .wr_addr(commit_pred_addr),
    .wr_data(commit_pred_data)
);  

rob_unit #(.ROB_ADDR_SIZE(`ROB_ADDR_SIZE), 
           .DEST_ADDR_SIZE(`DEST_ADDR_SIZE), 
           .INS_TYPE_SIZE(`INS_TYPE_SIZE)) 
  rob(
    .clk(clk),
    .reset(reset),
    .add_entry(add_rob_entry),
    .entry_dest_addr(entry_dest_addr),
    .entry_ins_type(entry_ins_type),
    .ins_rob_id(ins_rob_id),
    .set_ins_finished(set_ins_finished),
    .commit_head(commit),
    
    .head_id(head_id),
    .head_finished(head_finished),
    .head_dest_addr(commit_dest_addr),
    .head_ins_type(commit_ins_type),
    .is_full(rob_full)
);

endmodule