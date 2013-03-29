module rob_unit(
    // Inputs
    clk,
    reset,
    add_entry,
    entry_dest_addr, 
    entry_ins_type,
	entry_ins_state,
    set_ins_finished,   
    ins_rob_id,   
    commit_head,
    
    // Outputs
    head_id,
    tail_id,
    head_state,
    head_dest_addr,
    head_ins_type,
    is_full
);

parameter ROB_ADDR_SIZE = 5;
parameter DEST_ADDR_SIZE = 4;
parameter INS_TYPE_SIZE = 2;
parameter INS_STATE_SIZE = 1;
parameter FINISHED_STATE = 1'b1;

localparam ROB_ENTRY_SIZE = DEST_ADDR_SIZE + INS_TYPE_SIZE + INS_STATE_SIZE;
localparam STATE_BIT_LOW_LOC = 0;
localparam TYPE_BIT_LOW_LOC = INS_STATE_SIZE;
localparam DEST_BIT_LOW_LOC = TYPE_BIT_LOW_LOC + INS_TYPE_SIZE;
localparam ROB_SIZE = 1 << ROB_ADDR_SIZE;

// Inputs
input             				clk;
input             				reset;
input                     		add_entry;
input	[DEST_ADDR_SIZE-1:0]	entry_dest_addr;
input	[INS_TYPE_SIZE-1:0]		entry_ins_type;
input	[INS_STATE_SIZE-1:0]	entry_ins_state;
input	[ROB_ADDR_SIZE-1:0]		ins_rob_id;
input                     		set_ins_finished;
input                     		commit_head;

// Outputs
output	[INS_STATE_SIZE-1:0]		head_state;
output                          	head_entry_dest_addr;
output	[INS_TYPE_SIZE-1:0]	       	head_ins_type;
output reg    [ROB_ADDR_SIZE-1:0]	head_id;
output reg	[ROB_ADDR_SIZE-1:0]		tail_id;
output reg							is_full;  



reg	[ROB_ENTRY_SIZE-1:0]	rob[0:ROB_SIZE-1];
wire	[ROB_ADDR_SIZE-1:0]		next_entry;
wire	[ROB_ADDR_SIZE-1:0]		next_head;
wire	[ROB_ENTRY_SIZE-1:0]	head_entry;
integer i;

assign head_entry = rob[head_id];
assign head_state = head_entry[INS_STATE_SIZE+STATE_BIT_LOW_LOC-1:STATE_BIT_LOW_LOC];
assign head_dest_addr = head_entry[TYPE_BIT_LOW_LOC+INS_TYPE_SIZE-1:TYPE_BIT_LOW_LOC];
assign head_ins_type = head_entry[DEST_BIT_LOW_LOC+DEST_ADDR_SIZE-1:DEST_BIT_LOW_LOC];

assign next_head = head_id + 1;
assign next_entry = tail_id + 1;

always @(posedge clk) begin
	if (reset) begin
		is_full <= 0;
		head_id <= 0;
		tail_id <= 0;
		for (i = 0; i < ROB_SIZE; i = i + 1) begin
			rob[i] <= 0;
		end
	end else begin
		if (add_entry) begin
			// Add entry to ROB
			rob[tail_id] <= {entry_dest_addr, entry_ins_type, entry_ins_state};
			tail_id <= next_entry;
			if (commit_head) begin
				is_full <= next_head == next_entry;
			end else begin
				// Set full status register if next entry points to head
				// and if we are not comitting an entry
				is_full <= head_id == next_entry;
			end
		end else begin
			if (commit_head) begin
				is_full <= 0;
			end
		end
    
		if (commit_head) begin
			// Commit top entry by moving head pointer
			head_id <= next_head;
		end 
      
		if (set_ins_finished) begin
			// Set the given instruction as finished
			rob[ins_rob_id][STATE_BIT_LOC] <= FINISHED_STATE;
		end
	end  
end

endmodule
