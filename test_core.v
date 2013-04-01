`include "globals.vh"
`timescale 1ns / 1ps

module test_core();

localparam MEM_ID_SIZE = 4;
localparam MEM_SIZE = 1 << MEM_ID_SIZE;
reg clk;
reg reset;
reg mem_stall;

wire [`INS_WIDTH-1:0] ins_in;
wire [`DATA_WIDTH-1:0] ins_addr;
wire ins_addr_valid;
wire [`FETCH_ID_SIZE-1:0] ins_id;

reg [`DATA_WIDTH-1:0] MEMORY[0:MEM_SIZE-1];
core c(
	.clk(clk),
	.reset(reset),
	.icache_data_in(ins_in),
	.icache_id_in(ins_id),
	.icache_ready_in(ins_ready),
	.icache_stall_in(mem_stall),

	.dcache_data_in(),
	.dcache_id_in(),
	.dcache_ready_in(),
	.dcache_stall_in(),

	.icache_addr_out(ins_addr),
	.icache_data_out(),
	.icache_rw_out(),
	.icache_id_out(ins_id),
	.icache_valid_out(ins_addr_valid),
	.dcache_addr_out(),
	.dcache_data_out(),
	.dcache_rw_out(),
	.dcache_id_out(),
	.dcache_valid_out()
);

assign ins_in = MEMORY[ins_addr[MEM_ID_SIZE-1+2:2]];
assign ins_ready = ins_addr_valid;
integer i;
initial begin
	for (i = 1; i < MEM_SIZE; i = i + 1) begin
		MEMORY[i] = 0;
	end
	MEMORY[0] = {1'b0, 2'b00, 6'h0x14, 4'd0, 4'd1, 15'd3};
	clk = 1'b1;
	reset = 1'b1;
	mem_stall = 1'b0;
#210	reset = 1'b0;
#600
	$finish;
end


always begin
   #50 clk = ~clk;
end


endmodule
