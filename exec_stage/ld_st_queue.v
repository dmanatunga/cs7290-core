module ld_st_queue(
    clk,
    reset,
    add_entry,
    addr_in, 
    data_in, 
    rw_in,
    rob_entry_in,
    commit_head,
    
    head_id,
    head_finished,
    head_addr_out,
    head_data_out,
    head_rob_entry_out,
    head_rw_in,
    tail_id,  
    is_full
);

parameter ROB_BITS = 4;
parameter ADDR_BITS = 32;
parameter DATA_BITS = 32;
parameter TYPE_BITS = 2;
localparam ROB_ENTRY_SIZE = ADDR_BITS + DATA_BITS + 1 + ROB_BITS + 1;
localparam ROB_SIZE = 1 << ROB_BITS;

// Inputs
input                   	clk;
input                   	reset;
input         [ADDR_BITS-1:0]   addr_in;
input         [ROB_BITS-1:0]    rob_entry_in;
input         [DATA_BITS-1:0]   data_in;
input         [TYPE_BITS-1:0]   rw_in;
input                           add_entry;
input                           commit_head;

// Outputs
output reg    [ROB_BITS-1:0]    head_id;
output                          head_finished;
output                          head_addr_out;
output        [DATA_BITS-1:0]   head_data_out;
output        [ROB_BITS-1:0]    head_rob_entry_out;
output                          head_rw_in;
output reg    [ROB_BITS-1:0]    tail_id;
output reg                      is_full;  


reg     [ROB_ENTRY_SIZE-1:0]    queue[0:ROB_SIZE-1];
wire    [ROB_BITS-1:0]          next_entry;
wire    [ROB_ENTRY_SIZE-1:0]    head_entry;
wire    [DATA_BITS-1:0] 	mem_data_out;
wire      		        set_ins_finished;
wire    [ROB_BITS-1:0] 		ins_queue_id;
integer i;
reg 				mem_send;

assign head_entry 	= queue[head_id];
assign head_finished 	= head_entry[0];
assign head_addr_out 	= 0;
assign head_data_out 	= 0;
assign head_rob_entry_out = 0;
assign head_rw_in 	= 0;
assign next_entry 	= tail_id + 1;

always @(posedge clk) begin
  if (reset) begin
    is_full <= 0;
    head_id <= 0;
    tail_id <= 0;
    for (i = 0; i < ROB_SIZE; i = i + 1) begin
      queue[i] = 0;
    end
  end else begin
    if (!is_full && add_entry) begin
      // Add entry to ROB
      queue[tail_id] <= {addr_in, data_in, rw_in, rob_entry_in, 1'b0};
      tail_id <= next_entry;
      //Add entry to memory system as well if its not stalled
      mem_send <= 1;			//FIX you can add separate 
    end else begin
      mem_send <= 0;
    end
    
    if (commit_head) begin	
      // Commit top entry by moving head pointer
      head_id <= head_id + 1; 
      is_full <= 0;
    end else begin
      // Set full status register to if next entry points to head
      // and if we are not comitting an entry
      is_full <= add_entry & (head_id == next_entry);
    end
    
    if (set_ins_finished)		//should be set by memory system
      queue[ins_queue_id][0] <= 1'b1;	//FIX: you may not drive register simultaneously
      //queue[ins_queue_id][ROB_ENTRY_SIZE-ADDR_BITS-1:ROB_ENTRY_SIZE-ADDR_BITS-DATA_BITS-1] <= {mem_data_out};	//add data coming back
  end  
end

/*memory_system mem_module(
addr_in.(addr_in), 
data_in.(data_in), 
rw_in.(rw_in), 
id_in.(tail_id), 
valid_in.(mem_send), 
data_out.(mem_data_out), 
id_out.(ins_queue_id), 
ready_out.(set_ins_finished), 
stall_out.(mem_stall));
*/
endmodule
//module memory_system(addr_in, data_in, rw_in, id_in, valid_in, data_out, id_out, ready_out, stall_out);
//input [31:0] addr_in, data_in;
//input rw_in, valid_in; // r/w, valid input on the addr, data buses
//input [3:0] id_in; // ld/st Q id for request
//output [31:0] data_out;
//output [3:0] id_out; // ld/st Q id for request being satisfied
//output ready_out; // the oldest memory request data is ready
//output stall_out; // the memory system cannot accept anymore requests
