`timescale 1ns / 1ps
`include "../globals.vh"

module ld_st_queue(
    clk,
    reset,
    add_entry,
    addr_in, 
    data_in, 
    rw_in,
    rob_entry_in,
    commit_head,
    ctrl_in,
    commit_st,
    commit_st_rob_id,
    dest_reg_in,
    
    head_finished,
    head_dest_reg,
    head_data_out,
    head_rob_entry_out,
    head_ctrl_out,
    mem_stall_out
);

parameter DEST_REG_SIZE = `DEST_ADDR_SIZE;
parameter  ROB_BITS 	= `ROB_ID_SIZE;
parameter  ADDR_BITS 	= 32;
parameter  DATA_BITS 	= 32;//`DATA_WIDTH;
parameter  TYPE_BITS 	= 1;
parameter  CTRL_WIDTH 	= 5;
parameter  DATA_OFF 	= 1 + ROB_BITS + 1 + CTRL_WIDTH;
parameter  ADD_OFF 	= DEST_REG_SIZE + DATA_OFF + DATA_BITS;
localparam ROB_ENTRY_SIZE = ADDR_BITS + DEST_REG_SIZE + DATA_BITS + 1 + ROB_BITS + 1 + CTRL_WIDTH;
localparam ROB_SIZE 	= 1 << ROB_BITS;

// Inputs
input                   	clk;
input                   	reset;
input         [ADDR_BITS-1:0]   addr_in;
input         [ROB_BITS-1:0]    rob_entry_in;
input         [DATA_BITS-1:0]   data_in;
input         [TYPE_BITS-1:0]   rw_in;	//FIX can we rd/wr or control signals
input                           add_entry;
input                           commit_head;
input         [CTRL_WIDTH-1:0]  ctrl_in;
input       			commit_st;
input 	      [ROB_BITS-1:0] 	commit_st_rob_id;
input        [DEST_REG_SIZE-1:0]dest_reg_in;

// Outputs
output                          head_finished;
output        [DATA_BITS-1:0]   head_data_out;
output        [ROB_BITS-1:0]    head_rob_entry_out;
output        [CTRL_WIDTH-1:0]  head_ctrl_out;
output                      	mem_stall_out;  
output        [DEST_REG_SIZE-1:0]head_dest_reg;  


wire          [ADDR_BITS-1:0]   head_addr_out;	//FIX this is size of dest reg
wire                            head_rw_in;
reg                      	is_full;  
reg    	[ROB_BITS-1:0]    	head_id;
reg     [ROB_BITS-1:0]    	tail_id;
reg     [ROB_ENTRY_SIZE-1:0]    queue[0:ROB_SIZE-1];
wire    [ROB_BITS-1:0]          next_entry;
wire    [ROB_ENTRY_SIZE-1:0]    head_entry;
reg    [DATA_BITS-1:0] 	mem_data_out;//FIX change to wire
reg      		        set_ins_finished;
reg    [ROB_BITS-1:0] 		ins_queue_id; //FIX change to wire
integer 			i;
wire 				mem_send;
wire 				mem_stall;
reg 				mem_inflight;

assign head_entry 	  = queue[head_id];
assign head_finished 	  = head_entry[0];
assign head_addr_out 	  = head_entry[ADDR_BITS -1 + ADD_OFF  : ADD_OFF];
assign head_data_out 	  = head_entry[DATA_BITS -1 + DATA_OFF : DATA_OFF];
assign head_rob_entry_out = head_entry[ROB_BITS:1];
assign head_rw_in 	  = head_entry[ROB_BITS+1];	//FIX
assign head_ctrl_out 	  = head_entry[DATA_OFF -1 : DATA_OFF - CTRL_WIDTH];	//FIX
assign head_dest_reg 	  = head_entry[DATA_OFF + DEST_REG_SIZE -1 + DATA_BITS: DATA_BITS + DATA_OFF];	//FIX
assign next_entry 	  = tail_id + 1;
assign mem_stall_out 	  = is_full;	//OR mem_stall

assign mem_send = (mem_inflight == 1'b0)?(((commit_st == 1'b1 ) && (commit_st_rob_id ==  queue[head_id][ROB_BITS:1]))? 1 : (((head_id!=tail_id)&&(queue[head_id][ROB_BITS+1] == 1'b0))? 1 : 0)) : 1'b0;

always @(posedge clk) begin
  if (reset) begin
    is_full	<= 0;
    head_id 	<= 0;
    tail_id 	<= 0;
    mem_inflight<= 0;
    for (i = 0; i < ROB_SIZE; i = i + 1) begin
      queue[i] = 0;
    end
  end else begin
    if (!is_full && add_entry) begin
      // Add entry to ROB
      queue[tail_id] 	<= {addr_in, dest_reg_in, data_in, ctrl_in, rw_in, rob_entry_in, 1'b0};
      tail_id 		<= next_entry;
    //  mem_send <= 1;			//FIX you can add separate 
    //end else begin
    //  mem_send <= 0;
    end
    
    if (commit_head) begin	
      head_id 		<= head_id + 1; 
      is_full 		<= 0;
      mem_inflight 	<= 1'b0; 
    end else begin
      is_full 		<= add_entry & (head_id == next_entry);
      if(mem_send == 1'b1) mem_inflight <= 1'b1; 
    end
    
    if (set_ins_finished) begin		//should be set by memory system
      queue[ins_queue_id][0] <= 1'b1;	//FIX: you may not drive register simultaneously
     queue[ins_queue_id][DATA_BITS - 1 + DATA_OFF : DATA_OFF] <= mem_data_out;	//FIX
      
    end else if((commit_st == 1 ) && (commit_st_rob_id ==  queue[head_id][ROB_BITS:1])) begin
      queue[head_id][0]      <= 1'b1;	
    end    
  end  
end

initial begin
#980 set_ins_finished 	= 1;
ins_queue_id = 0;
mem_data_out 		= 32'd99;
#100 set_ins_finished 	= 0; 
#100 set_ins_finished 	= 1; 
mem_data_out 		= 32'd75;
ins_queue_id = 1;
#100 set_ins_finished 	= 0; 
#400 set_ins_finished 	= 1; 
mem_data_out 		= 32'd420;
ins_queue_id = 2;
#100 set_ins_finished 	= 0; 
end
/*memory_system mem_module(
.clk(clk),
.reset(reset),
.addr_in(head_addr_out), 
.data_in(head_data_out), 
.rw_in(head_rw_in), 
.id_in(head_id), 
.valid_in(mem_send), 
.data_out(mem_data_out), 
.id_out(ins_queue_id), 
.ready_out(set_ins_finished), 
.stall_out(mem_stall));
*/
endmodule
