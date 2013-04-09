`include "globals.vh"
`timescale 1ns / 1ps

module test_core();

localparam MEM_ID_SIZE = 7;
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
      //$readmemh("/home/nnigania/Dropbox/Personal/Acads/adv.micro/Project/cs7290-core/Insts.hex", MEMORY);
//	MEMORY[0]  = {1'b0, 2'b00, 6'h0x23, 4'd1, 4'd0, 15'd10};		// R1 <= LD(dest 10)
//	MEMORY[1]  = {1'b0, 2'b00, 6'h0x23, 4'd3, 4'd2, 15'd20};		// R3 <= LD(dest 20)
//	MEMORY[2]  = {1'b0, 2'b00, 6'h0x23, 4'd5, 4'd4, 15'd91};		// R5 <= LD(dest 91)
//	MEMORY[3]  = {1'b0, 2'b00, 6'h0x24, 4'd7, 4'd6, 15'd999};		// R5 <= LD(dest 91)
//	MEMORY[4]  = {1'b0, 2'b00, 6'h0x14, 4'd0, 4'd5, 15'd3};		// R0 = R1 + 3     => R0 = 3
	MEMORY[0]  = {1'b0, 2'b00, 6'h0x14, 4'd0, 4'd1, 15'd3};		// R0 = R1 + 3     => R0 = 3
	MEMORY[1]  = {1'b0, 2'b00, 6'h0x14, 4'd2, 4'd0, 15'd1}; 	// R2 = R0 + 1     => R2 = 4
	MEMORY[2]  = {1'b0, 2'b00, 6'h0x15, 4'd3, 4'd0, 15'd1}; 	// R3 = R0 - 1     => R3 = 2
	MEMORY[3]  = {1'b0, 2'b00, 6'h0x16, 4'd4, 4'd2, 15'd4}; 	// R4 = R2 * 4     => R4 = 16
	MEMORY[4]  = {1'b0, 2'b00, 6'h0x1d, 23'd40};			// Branch to PC + 4 + 40 = 60 (register no. 15)
	MEMORY[15] = {1'b0, 2'b00, 6'h0x14, 4'd0, 4'd1, 15'd10};	// R0 = R1 + 10    => R0 = 10 
	MEMORY[16] = {1'b0, 2'b00, 6'h0x14, 4'd1, 4'd0, 15'd111};	// R1 = R0 + 111   => R1 = 121
	MEMORY[17] = {1'b0, 2'b00, 6'h0x27, 2'd2, 2'd0, 2'd1, 17'd0}; 	// PR2 = PR0 & PR1 => PR0 = 0
	MEMORY[18] = {1'b0, 2'b00, 6'h0x2a, 2'd3, 2'd0, 2'd1, 17'd0}; 	// PR3 = NOT( PR0) => PR3 = 1
	MEMORY[19] = {1'b1, 2'b10, 6'h0x14, 4'd2, 4'd1, 15'd111};     	// (PR2) R2 = R1 + 111 => R2 = old value
	MEMORY[20] = {1'b1, 2'b11, 6'h0x14, 4'd5, 4'd1, 15'd111};     	// (PR2) R2 = R1 + 111 => R2 = old value
	//MEMORY[17] = {1'b0, 2'b00, 6'h0x07, 4'd2, 4'd1, 4'd4,11'd0 };   // 
	//MEMORY[17] = {1'b0, 2'b00, 6'h0x0d, 4'd2, 4'd1, 4'd4,11'd0 }; //R2 = R1 / R4 
	//MEMORY[18] = {1'b0, 2'b00, 6'h0x14, 4'd5, 4'd4, 15'd3};	//R5 = R4 + 3
	//MEMORY[19] = {1'b0, 2'b00, 6'h0x15, 4'd6, 4'd4, 15'd1};	//R6 = R4 - 1
	//MEMORY[20] = {1'b0, 2'b00, 6'h0x16, 4'd4, 4'd5, 15'd4};	//R4 = R5 * 4
	//MEMORY[21] = {1'b0, 2'b00, 6'h0x15, 4'd7, 4'd6, 15'd1};	//R7 = R6 - 1
	//MEMORY[17] = {1'b0, 2'b00, 6'h0x0f, 4'd5, 4'd0, 4'd3,11'd0 };   // R5 = R0 << R3 => R5 = 40	

	clk = 1'b1;
	reset = 1'b1;
	mem_stall = 1'b0;
#210	reset = 1'b0;
#4500
	$finish;
end


always begin
   #50 clk = ~clk;
end


endmodule
