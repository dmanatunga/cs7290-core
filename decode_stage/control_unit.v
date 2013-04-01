module control_unit(
	// Inputs
	clk,
	reset,
	opcode,
	// Outputs - Control Signals
	invalid_op,
	reg_dest_valid,
	reg_src1_valid,
	reg_src2_valid,
	pred_dest_valid,
	pred_src1_valid,
	pred_src2_valid,
	dest_is_src,
	pred_src_reg,
	ins_type,
	br_ins,
	br_type,
	mem_ins,
	mem_type,
	func_unit,
	muxa,
	muxb,
	alu_op,
	complex_alu_op,
	pred_op,
	float_op,
	latency
);

parameter OPCODE_SIZE = 6;
localparam NUM_OPS = 1 << OPCODE_SIZE;

// Inputs
input clk;
input reset;
input	[OPCODE_SIZE-1:0]	opcode;

//Outputs
output 	invalid_op;
output 	reg_dest_valid;
output 	reg_src1_valid;
output 	reg_src2_valid;
output 	pred_dest_valid;
output 	pred_src1_valid;
output 	pred_src2_valid;
output 	dest_is_src;
output 	pred_src_reg;
output	[1:0]		ins_type;
output 	br_ins;
output	[1:0]		br_type;
output 	mem_ins;
output 	mem_type;
output	[2:0]		func_unit;
output 	muxa;
output	[1:0]		muxb;
output	[2:0]		alu_op;
output	[2:0]		complex_alu_op;
output	[2:0]		pred_op;
output	[2:0]		float_op;
output	[3:0]		latency;

// Registers for storing signal data
reg 	invalid_op_reg[0:NUM_OPS-1];
reg 	reg_dest_valid_reg[0:NUM_OPS-1];
reg 	reg_src1_valid_reg[0:NUM_OPS-1];
reg 	reg_src2_valid_reg[0:NUM_OPS-1];
reg 	pred_dest_valid_reg[0:NUM_OPS-1];
reg 	pred_src1_valid_reg[0:NUM_OPS-1];
reg 	pred_src2_valid_reg[0:NUM_OPS-1];
reg 	dest_is_src_reg[0:NUM_OPS-1];
reg 	pred_src_reg_reg[0:NUM_OPS-1];
reg	[1:0]		ins_type_reg[0:NUM_OPS-1];
reg 	br_ins_reg[0:NUM_OPS-1];
reg	[1:0]		br_type_reg[0:NUM_OPS-1];
reg 	mem_ins_reg[0:NUM_OPS-1];
reg 	mem_type_reg[0:NUM_OPS-1];
reg	[2:0]		func_unit_reg[0:NUM_OPS-1];
reg 	muxa_reg[0:NUM_OPS-1];
reg	[1:0]		muxb_reg[0:NUM_OPS-1];
reg	[2:0]		alu_op_reg[0:NUM_OPS-1];
reg	[2:0]		complex_alu_op_reg[0:NUM_OPS-1];
reg	[2:0]		pred_op_reg[0:NUM_OPS-1];
reg	[2:0]		float_op_reg[0:NUM_OPS-1];
reg	[3:0]		latency_reg[0:NUM_OPS-1];

// Output control signals
assign invalid_op = invalid_op_reg[opcode];
assign reg_dest_valid = reg_dest_valid_reg[opcode];
assign reg_src1_valid = reg_src1_valid_reg[opcode];
assign reg_src2_valid = reg_src2_valid_reg[opcode];
assign pred_dest_valid = pred_dest_valid_reg[opcode];
assign pred_src1_valid = pred_src1_valid_reg[opcode];
assign pred_src2_valid = pred_src2_valid_reg[opcode];
assign dest_is_src = dest_is_src_reg[opcode];
assign pred_src_reg = pred_src_reg_reg[opcode];
assign ins_type = ins_type_reg[opcode];
assign br_ins = br_ins_reg[opcode];
assign br_type = br_type_reg[opcode];
assign mem_ins = mem_ins_reg[opcode];
assign mem_type = mem_type_reg[opcode];
assign func_unit = func_unit_reg[opcode];
assign muxa = muxa_reg[opcode];
assign muxb = muxb_reg[opcode];
assign alu_op = alu_op_reg[opcode];
assign complex_alu_op = complex_alu_op_reg[opcode];
assign pred_op = pred_op_reg[opcode];
assign float_op = float_op_reg[opcode];
assign latency = latency_reg[opcode];

// Control Signal Table
always @(posedge clk) begin
	if (reset) begin
		// NOP - 0x00
		invalid_op_reg[0] <= 1'b0;
		reg_dest_valid_reg[0] <= 1'b0;
		reg_src1_valid_reg[0] <= 1'd0;
		reg_src2_valid_reg[0] <= 1'b0;
		pred_dest_valid_reg[0] <= 1'b0;
		pred_src1_valid_reg[0] <= 1'b0;
		pred_src2_valid_reg[0] <= 1'b0;
		dest_is_src_reg[0] <= 1'b0;
		pred_src_reg_reg[0] <= 1'b0;
		ins_type_reg[0] <= 2'b00;
		br_ins_reg[0] <= 1'b0;
		br_type_reg[0] <= 2'b00;
		mem_ins_reg[0] <= 1'b0;
		mem_type_reg[0] <= 1'b0;
		func_unit_reg[0] <= 3'b000;
		muxa_reg[0] <= 1'b0;
		muxb_reg[0] <= 2'b00;
		alu_op_reg[0] <= 3'b000;
		complex_alu_op_reg[0] <= 3'b000;
		pred_op_reg[0] <= 3'b000;
		float_op_reg[0] <= 3'b000;
		latency_reg[0] <= 4'b0001;

		// DI - 0x01
		invalid_op_reg[1] <= 1'b1;
		reg_dest_valid_reg[1] <= 1'd0;
		reg_src1_valid_reg[1] <= 1'd0;
		reg_src2_valid_reg[1] <= 1'd0;
		pred_dest_valid_reg[1] <= 1'd0;
		pred_src1_valid_reg[1] <= 1'd0;
		pred_src2_valid_reg[1] <= 1'd0;
		dest_is_src_reg[1] <= 1'd0;
		pred_src_reg_reg[1] <= 1'd0;
		ins_type_reg[1] <= 2'd0;
		br_ins_reg[1] <= 1'd0;
		br_type_reg[1] <= 2'd0;
		mem_ins_reg[1] <= 1'd0;
		mem_type_reg[1] <= 1'd0;
		func_unit_reg[1] <= 3'd0;
		muxa_reg[1] <= 1'd0;
		muxb_reg[1] <= 2'd0;
		alu_op_reg[1] <= 3'd0;
		complex_alu_op_reg[1] <= 3'd0;
		pred_op_reg[1] <= 3'd0;
		float_op_reg[1] <= 3'd0;
		latency_reg[1] <= 4'd0;

		// EI - 0x02
		invalid_op_reg[2] <= 1'b1;
		reg_dest_valid_reg[2] <= 1'd0;
		reg_src1_valid_reg[2] <= 1'd0;
		reg_src2_valid_reg[2] <= 1'd0;
		pred_dest_valid_reg[2] <= 1'd0;
		pred_src1_valid_reg[2] <= 1'd0;
		pred_src2_valid_reg[2] <= 1'd0;
		dest_is_src_reg[2] <= 1'd0;
		pred_src_reg_reg[2] <= 1'd0;
		ins_type_reg[2] <= 2'd0;
		br_ins_reg[2] <= 1'd0;
		br_type_reg[2] <= 2'd0;
		mem_ins_reg[2] <= 1'd0;
		mem_type_reg[2] <= 1'd0;
		func_unit_reg[2] <= 3'd0;
		muxa_reg[2] <= 1'd0;
		muxb_reg[2] <= 2'd0;
		alu_op_reg[2] <= 3'd0;
		complex_alu_op_reg[2] <= 3'd0;
		pred_op_reg[2] <= 3'd0;
		float_op_reg[2] <= 3'd0;
		latency_reg[2] <= 4'd0;

		// TLBADD - 0x03
		invalid_op_reg[3] <= 1'b1;
		reg_dest_valid_reg[3] <= 1'd0;
		reg_src1_valid_reg[3] <= 1'd0;
		reg_src2_valid_reg[3] <= 1'd0;
		pred_dest_valid_reg[3] <= 1'd0;
		pred_src1_valid_reg[3] <= 1'd0;
		pred_src2_valid_reg[3] <= 1'd0;
		dest_is_src_reg[3] <= 1'd0;
		pred_src_reg_reg[3] <= 1'd0;
		ins_type_reg[3] <= 2'd0;
		br_ins_reg[3] <= 1'd0;
		br_type_reg[3] <= 2'd0;
		mem_ins_reg[3] <= 1'd0;
		mem_type_reg[3] <= 1'd0;
		func_unit_reg[3] <= 3'd0;
		muxa_reg[3] <= 1'd0;
		muxb_reg[3] <= 2'd0;
		alu_op_reg[3] <= 3'd0;
		complex_alu_op_reg[3] <= 3'd0;
		pred_op_reg[3] <= 3'd0;
		float_op_reg[3] <= 3'd0;
		latency_reg[3] <= 4'd0;

		// TLBFLUSH - 0x04
		invalid_op_reg[4] <= 1'b1;
		reg_dest_valid_reg[4] <= 1'd0;
		reg_src1_valid_reg[4] <= 1'd0;
		reg_src2_valid_reg[4] <= 1'd0;
		pred_dest_valid_reg[4] <= 1'd0;
		pred_src1_valid_reg[4] <= 1'd0;
		pred_src2_valid_reg[4] <= 1'd0;
		dest_is_src_reg[4] <= 1'd0;
		pred_src_reg_reg[4] <= 1'd0;
		ins_type_reg[4] <= 2'd0;
		br_ins_reg[4] <= 1'd0;
		br_type_reg[4] <= 2'd0;
		mem_ins_reg[4] <= 1'd0;
		mem_type_reg[4] <= 1'd0;
		func_unit_reg[4] <= 3'd0;
		muxa_reg[4] <= 1'd0;
		muxb_reg[4] <= 2'd0;
		alu_op_reg[4] <= 3'd0;
		complex_alu_op_reg[4] <= 3'd0;
		pred_op_reg[4] <= 3'd0;
		float_op_reg[4] <= 3'd0;
		latency_reg[4] <= 4'd0;

		// NEG - 0x05
		invalid_op_reg[5] <= 1'b0;
		reg_dest_valid_reg[5] <= 1'b1;
		reg_src1_valid_reg[5] <= 1'b1;
		reg_src2_valid_reg[5] <= 1'b0;
		pred_dest_valid_reg[5] <= 1'b0;
		pred_src1_valid_reg[5] <= 1'b0;
		pred_src2_valid_reg[5] <= 1'b0;
		dest_is_src_reg[5] <= 1'b0;
		pred_src_reg_reg[5] <= 1'b0;
		ins_type_reg[5] <= 2'b10;
		br_ins_reg[5] <= 1'b0;
		br_type_reg[5] <= 2'b00;
		mem_ins_reg[5] <= 1'b0;
		mem_type_reg[5] <= 1'b0;
		func_unit_reg[5] <= 3'b000;
		muxa_reg[5] <= 1'b1;
		muxb_reg[5] <= 2'b00;
		alu_op_reg[5] <= 3'b001;
		complex_alu_op_reg[5] <= 3'b000;
		pred_op_reg[5] <= 3'b000;
		float_op_reg[5] <= 3'b000;
		latency_reg[5] <= 4'b0001;

		// NOT - 0x06
		invalid_op_reg[6] <= 1'b0;
		reg_dest_valid_reg[6] <= 1'b1;
		reg_src1_valid_reg[6] <= 1'b1;
		reg_src2_valid_reg[6] <= 1'b1;
		pred_dest_valid_reg[6] <= 1'b0;
		pred_src1_valid_reg[6] <= 1'b0;
		pred_src2_valid_reg[6] <= 1'b0;
		dest_is_src_reg[6] <= 1'b0;
		pred_src_reg_reg[6] <= 1'b0;
		ins_type_reg[6] <= 2'b10;
		br_ins_reg[6] <= 1'b0;
		br_type_reg[6] <= 2'b00;
		mem_ins_reg[6] <= 1'b0;
		mem_type_reg[6] <= 1'b0;
		func_unit_reg[6] <= 3'b000;
		muxa_reg[6] <= 1'b1;
		muxb_reg[6] <= 2'b00;
		alu_op_reg[6] <= 3'b010;
		complex_alu_op_reg[6] <= 3'b000;
		pred_op_reg[6] <= 3'b000;
		float_op_reg[6] <= 3'b000;
		latency_reg[6] <= 4'b0001;

		// AND - 0x07
		invalid_op_reg[7] <= 1'b0;
		reg_dest_valid_reg[7] <= 1'b1;
		reg_src1_valid_reg[7] <= 1'b1;
		reg_src2_valid_reg[7] <= 1'b1;
		pred_dest_valid_reg[7] <= 1'b0;
		pred_src1_valid_reg[7] <= 1'b0;
		pred_src2_valid_reg[7] <= 1'b0;
		dest_is_src_reg[7] <= 1'b0;
		pred_src_reg_reg[7] <= 1'b0;
		ins_type_reg[7] <= 2'b10;
		br_ins_reg[7] <= 1'b0;
		br_type_reg[7] <= 2'b00;
		mem_ins_reg[7] <= 1'b0;
		mem_type_reg[7] <= 1'b0;
		func_unit_reg[7] <= 3'b000;
		muxa_reg[7] <= 1'b1;
		muxb_reg[7] <= 2'b11;
		alu_op_reg[7] <= 3'b011;
		complex_alu_op_reg[7] <= 3'b000;
		pred_op_reg[7] <= 3'b000;
		float_op_reg[7] <= 3'b000;
		latency_reg[7] <= 4'b0001;

		// OR - 0x08
		invalid_op_reg[8] <= 1'b0;
		reg_dest_valid_reg[8] <= 1'b1;
		reg_src1_valid_reg[8] <= 1'b1;
		reg_src2_valid_reg[8] <= 1'b1;
		pred_dest_valid_reg[8] <= 1'b0;
		pred_src1_valid_reg[8] <= 1'b0;
		pred_src2_valid_reg[8] <= 1'b0;
		dest_is_src_reg[8] <= 1'b0;
		pred_src_reg_reg[8] <= 1'b0;
		ins_type_reg[8] <= 2'b10;
		br_ins_reg[8] <= 1'b0;
		br_type_reg[8] <= 2'b00;
		mem_ins_reg[8] <= 1'b0;
		mem_type_reg[8] <= 1'b0;
		func_unit_reg[8] <= 3'b000;
		muxa_reg[8] <= 1'b1;
		muxb_reg[8] <= 2'b11;
		alu_op_reg[8] <= 3'b100;
		complex_alu_op_reg[8] <= 3'b000;
		pred_op_reg[8] <= 3'b000;
		float_op_reg[8] <= 3'b000;
		latency_reg[8] <= 4'b0001;

		// XOR - 0x09
		invalid_op_reg[9] <= 1'b0;
		reg_dest_valid_reg[9] <= 1'b1;
		reg_src1_valid_reg[9] <= 1'b1;
		reg_src2_valid_reg[9] <= 1'b1;
		pred_dest_valid_reg[9] <= 1'b0;
		pred_src1_valid_reg[9] <= 1'b0;
		pred_src2_valid_reg[9] <= 1'b0;
		dest_is_src_reg[9] <= 1'b0;
		pred_src_reg_reg[9] <= 1'b0;
		ins_type_reg[9] <= 2'b10;
		br_ins_reg[9] <= 1'b0;
		br_type_reg[9] <= 2'b00;
		mem_ins_reg[9] <= 1'b0;
		mem_type_reg[9] <= 1'b0;
		func_unit_reg[9] <= 3'b000;
		muxa_reg[9] <= 1'b1;
		muxb_reg[9] <= 2'b11;
		alu_op_reg[9] <= 3'b101;
		complex_alu_op_reg[9] <= 3'b000;
		pred_op_reg[9] <= 3'b000;
		float_op_reg[9] <= 3'b000;
		latency_reg[9] <= 4'b0001;

		// ADD - 0x0a
		invalid_op_reg[10] <= 1'b0;
		reg_dest_valid_reg[10] <= 1'b1;
		reg_src1_valid_reg[10] <= 1'b1;
		reg_src2_valid_reg[10] <= 1'b1;
		pred_dest_valid_reg[10] <= 1'b0;
		pred_src1_valid_reg[10] <= 1'b0;
		pred_src2_valid_reg[10] <= 1'b0;
		dest_is_src_reg[10] <= 1'b0;
		pred_src_reg_reg[10] <= 1'b0;
		ins_type_reg[10] <= 2'b10;
		br_ins_reg[10] <= 1'b0;
		br_type_reg[10] <= 2'b00;
		mem_ins_reg[10] <= 1'b0;
		mem_type_reg[10] <= 1'b0;
		func_unit_reg[10] <= 3'b000;
		muxa_reg[10] <= 1'b1;
		muxb_reg[10] <= 2'b11;
		alu_op_reg[10] <= 3'b110;
		complex_alu_op_reg[10] <= 3'b000;
		pred_op_reg[10] <= 3'b000;
		float_op_reg[10] <= 3'b000;
		latency_reg[10] <= 4'b0001;

		// SUB - 0x0b
		invalid_op_reg[11] <= 1'b0;
		reg_dest_valid_reg[11] <= 1'b1;
		reg_src1_valid_reg[11] <= 1'b1;
		reg_src2_valid_reg[11] <= 1'b1;
		pred_dest_valid_reg[11] <= 1'b0;
		pred_src1_valid_reg[11] <= 1'b0;
		pred_src2_valid_reg[11] <= 1'b0;
		dest_is_src_reg[11] <= 1'b0;
		pred_src_reg_reg[11] <= 1'b0;
		ins_type_reg[11] <= 2'b10;
		br_ins_reg[11] <= 1'b0;
		br_type_reg[11] <= 2'b00;
		mem_ins_reg[11] <= 1'b0;
		mem_type_reg[11] <= 1'b0;
		func_unit_reg[11] <= 3'b000;
		muxa_reg[11] <= 1'b1;
		muxb_reg[11] <= 2'b11;
		alu_op_reg[11] <= 3'b111;
		complex_alu_op_reg[11] <= 3'b000;
		pred_op_reg[11] <= 3'b000;
		float_op_reg[11] <= 3'b000;
		latency_reg[11] <= 4'b0001;

		// MUL - 0x0c
		invalid_op_reg[12] <= 1'b0;
		reg_dest_valid_reg[12] <= 1'b1;
		reg_src1_valid_reg[12] <= 1'b1;
		reg_src2_valid_reg[12] <= 1'b1;
		pred_dest_valid_reg[12] <= 1'b0;
		pred_src1_valid_reg[12] <= 1'b0;
		pred_src2_valid_reg[12] <= 1'b0;
		dest_is_src_reg[12] <= 1'b0;
		pred_src_reg_reg[12] <= 1'b0;
		ins_type_reg[12] <= 2'b10;
		br_ins_reg[12] <= 1'b0;
		br_type_reg[12] <= 2'b00;
		mem_ins_reg[12] <= 1'b0;
		mem_type_reg[12] <= 1'b0;
		func_unit_reg[12] <= 3'b001;
		muxa_reg[12] <= 1'b1;
		muxb_reg[12] <= 2'b11;
		alu_op_reg[12] <= 3'b000;
		complex_alu_op_reg[12] <= 3'b001;
		pred_op_reg[12] <= 3'b000;
		float_op_reg[12] <= 3'b000;
		latency_reg[12] <= 4'b0100;

		// DIV - 0x0d
		invalid_op_reg[13] <= 1'b0;
		reg_dest_valid_reg[13] <= 1'b1;
		reg_src1_valid_reg[13] <= 1'b1;
		reg_src2_valid_reg[13] <= 1'b1;
		pred_dest_valid_reg[13] <= 1'b0;
		pred_src1_valid_reg[13] <= 1'b0;
		pred_src2_valid_reg[13] <= 1'b0;
		dest_is_src_reg[13] <= 1'b0;
		pred_src_reg_reg[13] <= 1'b0;
		ins_type_reg[13] <= 2'b10;
		br_ins_reg[13] <= 1'b0;
		br_type_reg[13] <= 2'b00;
		mem_ins_reg[13] <= 1'b0;
		mem_type_reg[13] <= 1'b0;
		func_unit_reg[13] <= 3'b001;
		muxa_reg[13] <= 1'b1;
		muxb_reg[13] <= 2'b11;
		alu_op_reg[13] <= 3'b000;
		complex_alu_op_reg[13] <= 3'b010;
		pred_op_reg[13] <= 3'b000;
		float_op_reg[13] <= 3'b000;
		latency_reg[13] <= 4'b0100;

		// MOD - 0x0e
		invalid_op_reg[14] <= 1'b0;
		reg_dest_valid_reg[14] <= 1'b1;
		reg_src1_valid_reg[14] <= 1'b1;
		reg_src2_valid_reg[14] <= 1'b1;
		pred_dest_valid_reg[14] <= 1'b0;
		pred_src1_valid_reg[14] <= 1'b0;
		pred_src2_valid_reg[14] <= 1'b0;
		dest_is_src_reg[14] <= 1'b0;
		pred_src_reg_reg[14] <= 1'b0;
		ins_type_reg[14] <= 2'b10;
		br_ins_reg[14] <= 1'b0;
		br_type_reg[14] <= 2'b00;
		mem_ins_reg[14] <= 1'b0;
		mem_type_reg[14] <= 1'b0;
		func_unit_reg[14] <= 3'b001;
		muxa_reg[14] <= 1'b1;
		muxb_reg[14] <= 2'b11;
		alu_op_reg[14] <= 3'b000;
		complex_alu_op_reg[14] <= 3'b011;
		pred_op_reg[14] <= 3'b000;
		float_op_reg[14] <= 3'b000;
		latency_reg[14] <= 4'b0100;

		// SHL - 0x0f
		invalid_op_reg[15] <= 1'b0;
		reg_dest_valid_reg[15] <= 1'b1;
		reg_src1_valid_reg[15] <= 1'b1;
		reg_src2_valid_reg[15] <= 1'b1;
		pred_dest_valid_reg[15] <= 1'b0;
		pred_src1_valid_reg[15] <= 1'b0;
		pred_src2_valid_reg[15] <= 1'b0;
		dest_is_src_reg[15] <= 1'b0;
		pred_src_reg_reg[15] <= 1'b0;
		ins_type_reg[15] <= 2'b10;
		br_ins_reg[15] <= 1'b0;
		br_type_reg[15] <= 2'b00;
		mem_ins_reg[15] <= 1'b0;
		mem_type_reg[15] <= 1'b0;
		func_unit_reg[15] <= 3'b001;
		muxa_reg[15] <= 1'b1;
		muxb_reg[15] <= 2'b11;
		alu_op_reg[15] <= 3'b000;
		complex_alu_op_reg[15] <= 3'b100;
		pred_op_reg[15] <= 3'b000;
		float_op_reg[15] <= 3'b000;
		latency_reg[15] <= 4'b0001;

		// SHR - 0x10
		invalid_op_reg[16] <= 1'b0;
		reg_dest_valid_reg[16] <= 1'b1;
		reg_src1_valid_reg[16] <= 1'b1;
		reg_src2_valid_reg[16] <= 1'b1;
		pred_dest_valid_reg[16] <= 1'b0;
		pred_src1_valid_reg[16] <= 1'b0;
		pred_src2_valid_reg[16] <= 1'b0;
		dest_is_src_reg[16] <= 1'b0;
		pred_src_reg_reg[16] <= 1'b0;
		ins_type_reg[16] <= 2'b10;
		br_ins_reg[16] <= 1'b0;
		br_type_reg[16] <= 2'b00;
		mem_ins_reg[16] <= 1'b0;
		mem_type_reg[16] <= 1'b0;
		func_unit_reg[16] <= 3'b001;
		muxa_reg[16] <= 1'b1;
		muxb_reg[16] <= 2'b11;
		alu_op_reg[16] <= 3'b000;
		complex_alu_op_reg[16] <= 3'b101;
		pred_op_reg[16] <= 3'b000;
		float_op_reg[16] <= 3'b000;
		latency_reg[16] <= 4'b0001;

		// ANDI - 0x11
		invalid_op_reg[17] <= 1'b0;
		reg_dest_valid_reg[17] <= 1'b1;
		reg_src1_valid_reg[17] <= 1'b1;
		reg_src2_valid_reg[17] <= 1'b0;
		pred_dest_valid_reg[17] <= 1'b0;
		pred_src1_valid_reg[17] <= 1'b0;
		pred_src2_valid_reg[17] <= 1'b0;
		dest_is_src_reg[17] <= 1'b0;
		pred_src_reg_reg[17] <= 1'b0;
		ins_type_reg[17] <= 2'b10;
		br_ins_reg[17] <= 1'b0;
		br_type_reg[17] <= 2'b00;
		mem_ins_reg[17] <= 1'b0;
		mem_type_reg[17] <= 1'b0;
		func_unit_reg[17] <= 3'b000;
		muxa_reg[17] <= 1'b1;
		muxb_reg[17] <= 2'b01;
		alu_op_reg[17] <= 3'b011;
		complex_alu_op_reg[17] <= 3'b000;
		pred_op_reg[17] <= 3'b000;
		float_op_reg[17] <= 3'b000;
		latency_reg[17] <= 4'b0001;

		// ORI - 0x12
		invalid_op_reg[18] <= 1'b0;
		reg_dest_valid_reg[18] <= 1'b1;
		reg_src1_valid_reg[18] <= 1'b1;
		reg_src2_valid_reg[18] <= 1'b0;
		pred_dest_valid_reg[18] <= 1'b0;
		pred_src1_valid_reg[18] <= 1'b0;
		pred_src2_valid_reg[18] <= 1'b0;
		dest_is_src_reg[18] <= 1'b0;
		pred_src_reg_reg[18] <= 1'b0;
		ins_type_reg[18] <= 2'b10;
		br_ins_reg[18] <= 1'b0;
		br_type_reg[18] <= 2'b00;
		mem_ins_reg[18] <= 1'b0;
		mem_type_reg[18] <= 1'b0;
		func_unit_reg[18] <= 3'b000;
		muxa_reg[18] <= 1'b1;
		muxb_reg[18] <= 2'b01;
		alu_op_reg[18] <= 3'b100;
		complex_alu_op_reg[18] <= 3'b000;
		pred_op_reg[18] <= 3'b000;
		float_op_reg[18] <= 3'b000;
		latency_reg[18] <= 4'b0001;

		// XORI - 0x13
		invalid_op_reg[19] <= 1'b0;
		reg_dest_valid_reg[19] <= 1'b1;
		reg_src1_valid_reg[19] <= 1'b1;
		reg_src2_valid_reg[19] <= 1'b0;
		pred_dest_valid_reg[19] <= 1'b0;
		pred_src1_valid_reg[19] <= 1'b0;
		pred_src2_valid_reg[19] <= 1'b0;
		dest_is_src_reg[19] <= 1'b0;
		pred_src_reg_reg[19] <= 1'b0;
		ins_type_reg[19] <= 2'b10;
		br_ins_reg[19] <= 1'b0;
		br_type_reg[19] <= 2'b00;
		mem_ins_reg[19] <= 1'b0;
		mem_type_reg[19] <= 1'b0;
		func_unit_reg[19] <= 3'b000;
		muxa_reg[19] <= 1'b1;
		muxb_reg[19] <= 2'b01;
		alu_op_reg[19] <= 3'b101;
		complex_alu_op_reg[19] <= 3'b000;
		pred_op_reg[19] <= 3'b000;
		float_op_reg[19] <= 3'b000;
		latency_reg[19] <= 4'b0001;

		// ADDI - 0x14
		invalid_op_reg[20] <= 1'b0;
		reg_dest_valid_reg[20] <= 1'b1;
		reg_src1_valid_reg[20] <= 1'b1;
		reg_src2_valid_reg[20] <= 1'b0;
		pred_dest_valid_reg[20] <= 1'b0;
		pred_src1_valid_reg[20] <= 1'b0;
		pred_src2_valid_reg[20] <= 1'b0;
		dest_is_src_reg[20] <= 1'b0;
		pred_src_reg_reg[20] <= 1'b0;
		ins_type_reg[20] <= 2'b10;
		br_ins_reg[20] <= 1'b0;
		br_type_reg[20] <= 2'b00;
		mem_ins_reg[20] <= 1'b0;
		mem_type_reg[20] <= 1'b0;
		func_unit_reg[20] <= 3'b000;
		muxa_reg[20] <= 1'b1;
		muxb_reg[20] <= 2'b01;
		alu_op_reg[20] <= 3'b110;
		complex_alu_op_reg[20] <= 3'b000;
		pred_op_reg[20] <= 3'b000;
		float_op_reg[20] <= 3'b000;
		latency_reg[20] <= 4'b0001;

		// SUBI - 0x15
		invalid_op_reg[21] <= 1'b0;
		reg_dest_valid_reg[21] <= 1'b1;
		reg_src1_valid_reg[21] <= 1'b1;
		reg_src2_valid_reg[21] <= 1'b0;
		pred_dest_valid_reg[21] <= 1'b0;
		pred_src1_valid_reg[21] <= 1'b0;
		pred_src2_valid_reg[21] <= 1'b0;
		dest_is_src_reg[21] <= 1'b0;
		pred_src_reg_reg[21] <= 1'b0;
		ins_type_reg[21] <= 2'b10;
		br_ins_reg[21] <= 1'b0;
		br_type_reg[21] <= 2'b00;
		mem_ins_reg[21] <= 1'b0;
		mem_type_reg[21] <= 1'b0;
		func_unit_reg[21] <= 3'b000;
		muxa_reg[21] <= 1'b1;
		muxb_reg[21] <= 2'b01;
		alu_op_reg[21] <= 3'b111;
		complex_alu_op_reg[21] <= 3'b000;
		pred_op_reg[21] <= 3'b000;
		float_op_reg[21] <= 3'b000;
		latency_reg[21] <= 4'b0001;

		// MULI - 0x16
		invalid_op_reg[22] <= 1'b0;
		reg_dest_valid_reg[22] <= 1'b1;
		reg_src1_valid_reg[22] <= 1'b1;
		reg_src2_valid_reg[22] <= 1'b0;
		pred_dest_valid_reg[22] <= 1'b0;
		pred_src1_valid_reg[22] <= 1'b0;
		pred_src2_valid_reg[22] <= 1'b0;
		dest_is_src_reg[22] <= 1'b0;
		pred_src_reg_reg[22] <= 1'b0;
		ins_type_reg[22] <= 2'b10;
		br_ins_reg[22] <= 1'b0;
		br_type_reg[22] <= 2'b00;
		mem_ins_reg[22] <= 1'b0;
		mem_type_reg[22] <= 1'b0;
		func_unit_reg[22] <= 3'b001;
		muxa_reg[22] <= 1'b1;
		muxb_reg[22] <= 2'b01;
		alu_op_reg[22] <= 3'b000;
		complex_alu_op_reg[22] <= 3'b001;
		pred_op_reg[22] <= 3'b000;
		float_op_reg[22] <= 3'b000;
		latency_reg[22] <= 4'b0001;

		// DIVI - 0x17
		invalid_op_reg[23] <= 1'b0;
		reg_dest_valid_reg[23] <= 1'b1;
		reg_src1_valid_reg[23] <= 1'b1;
		reg_src2_valid_reg[23] <= 1'b0;
		pred_dest_valid_reg[23] <= 1'b0;
		pred_src1_valid_reg[23] <= 1'b0;
		pred_src2_valid_reg[23] <= 1'b0;
		dest_is_src_reg[23] <= 1'b0;
		pred_src_reg_reg[23] <= 1'b0;
		ins_type_reg[23] <= 2'b10;
		br_ins_reg[23] <= 1'b0;
		br_type_reg[23] <= 2'b00;
		mem_ins_reg[23] <= 1'b0;
		mem_type_reg[23] <= 1'b0;
		func_unit_reg[23] <= 3'b001;
		muxa_reg[23] <= 1'b1;
		muxb_reg[23] <= 2'b01;
		alu_op_reg[23] <= 3'b000;
		complex_alu_op_reg[23] <= 3'b010;
		pred_op_reg[23] <= 3'b000;
		float_op_reg[23] <= 3'b000;
		latency_reg[23] <= 4'b0001;

		// MODI - 0x18
		invalid_op_reg[24] <= 1'b0;
		reg_dest_valid_reg[24] <= 1'b1;
		reg_src1_valid_reg[24] <= 1'b1;
		reg_src2_valid_reg[24] <= 1'b0;
		pred_dest_valid_reg[24] <= 1'b0;
		pred_src1_valid_reg[24] <= 1'b0;
		pred_src2_valid_reg[24] <= 1'b0;
		dest_is_src_reg[24] <= 1'b0;
		pred_src_reg_reg[24] <= 1'b0;
		ins_type_reg[24] <= 2'b10;
		br_ins_reg[24] <= 1'b0;
		br_type_reg[24] <= 2'b00;
		mem_ins_reg[24] <= 1'b0;
		mem_type_reg[24] <= 1'b0;
		func_unit_reg[24] <= 3'b001;
		muxa_reg[24] <= 1'b1;
		muxb_reg[24] <= 2'b01;
		alu_op_reg[24] <= 3'b000;
		complex_alu_op_reg[24] <= 3'b011;
		pred_op_reg[24] <= 3'b000;
		float_op_reg[24] <= 3'b000;
		latency_reg[24] <= 4'b0001;

		// SHLI - 0x19
		invalid_op_reg[25] <= 1'b0;
		reg_dest_valid_reg[25] <= 1'b1;
		reg_src1_valid_reg[25] <= 1'b1;
		reg_src2_valid_reg[25] <= 1'b0;
		pred_dest_valid_reg[25] <= 1'b0;
		pred_src1_valid_reg[25] <= 1'b0;
		pred_src2_valid_reg[25] <= 1'b0;
		dest_is_src_reg[25] <= 1'b0;
		pred_src_reg_reg[25] <= 1'b0;
		ins_type_reg[25] <= 2'b10;
		br_ins_reg[25] <= 1'b0;
		br_type_reg[25] <= 2'b00;
		mem_ins_reg[25] <= 1'b0;
		mem_type_reg[25] <= 1'b0;
		func_unit_reg[25] <= 3'b001;
		muxa_reg[25] <= 1'b1;
		muxb_reg[25] <= 2'b01;
		alu_op_reg[25] <= 3'b000;
		complex_alu_op_reg[25] <= 3'b100;
		pred_op_reg[25] <= 3'b000;
		float_op_reg[25] <= 3'b000;
		latency_reg[25] <= 4'b0001;

		// SHRI - 0x1a
		invalid_op_reg[26] <= 1'b0;
		reg_dest_valid_reg[26] <= 1'b1;
		reg_src1_valid_reg[26] <= 1'b1;
		reg_src2_valid_reg[26] <= 1'b0;
		pred_dest_valid_reg[26] <= 1'b0;
		pred_src1_valid_reg[26] <= 1'b0;
		pred_src2_valid_reg[26] <= 1'b0;
		dest_is_src_reg[26] <= 1'b0;
		pred_src_reg_reg[26] <= 1'b0;
		ins_type_reg[26] <= 2'b10;
		br_ins_reg[26] <= 1'b0;
		br_type_reg[26] <= 2'b00;
		mem_ins_reg[26] <= 1'b0;
		mem_type_reg[26] <= 1'b0;
		func_unit_reg[26] <= 3'b001;
		muxa_reg[26] <= 1'b1;
		muxb_reg[26] <= 2'b01;
		alu_op_reg[26] <= 3'b000;
		complex_alu_op_reg[26] <= 3'b101;
		pred_op_reg[26] <= 3'b000;
		float_op_reg[26] <= 3'b000;
		latency_reg[26] <= 4'b0001;

		// JALI - 0x1b
		invalid_op_reg[27] <= 1'b0;
		reg_dest_valid_reg[27] <= 1'b1;
		reg_src1_valid_reg[27] <= 1'b1;
		reg_src2_valid_reg[27] <= 1'b0;
		pred_dest_valid_reg[27] <= 1'b0;
		pred_src1_valid_reg[27] <= 1'b0;
		pred_src2_valid_reg[27] <= 1'b0;
		dest_is_src_reg[27] <= 1'b0;
		pred_src_reg_reg[27] <= 1'b0;
		ins_type_reg[27] <= 2'b10;
		br_ins_reg[27] <= 1'b1;
		br_type_reg[27] <= 2'b01;
		mem_ins_reg[27] <= 1'b0;
		mem_type_reg[27] <= 1'b0;
		func_unit_reg[27] <= 3'b000;
		muxa_reg[27] <= 1'b0;
		muxb_reg[27] <= 2'b00;
		alu_op_reg[27] <= 3'b011;
		complex_alu_op_reg[27] <= 3'b000;
		pred_op_reg[27] <= 3'b000;
		float_op_reg[27] <= 3'b000;
		latency_reg[27] <= 4'b0001;

		// JALR - 0x1c
		invalid_op_reg[28] <= 1'b0;
		reg_dest_valid_reg[28] <= 1'b1;
		reg_src1_valid_reg[28] <= 1'b1;
		reg_src2_valid_reg[28] <= 1'b0;
		pred_dest_valid_reg[28] <= 1'b0;
		pred_src1_valid_reg[28] <= 1'b0;
		pred_src2_valid_reg[28] <= 1'b0;
		dest_is_src_reg[28] <= 1'b0;
		pred_src_reg_reg[28] <= 1'b0;
		ins_type_reg[28] <= 2'b10;
		br_ins_reg[28] <= 1'b1;
		br_type_reg[28] <= 2'b10;
		mem_ins_reg[28] <= 1'b0;
		mem_type_reg[28] <= 1'b0;
		func_unit_reg[28] <= 3'b000;
		muxa_reg[28] <= 1'b1;
		muxb_reg[28] <= 2'b00;
		alu_op_reg[28] <= 3'b000;
		complex_alu_op_reg[28] <= 3'b000;
		pred_op_reg[28] <= 3'b000;
		float_op_reg[28] <= 3'b000;
		latency_reg[28] <= 4'b0001;

		// JMPI - 0x1d
		invalid_op_reg[29] <= 1'b0;
		reg_dest_valid_reg[29] <= 1'b0;
		reg_src1_valid_reg[29] <= 1'b0;
		reg_src2_valid_reg[29] <= 1'b0;
		pred_dest_valid_reg[29] <= 1'b0;
		pred_src1_valid_reg[29] <= 1'b0;
		pred_src2_valid_reg[29] <= 1'b0;
		dest_is_src_reg[29] <= 1'b0;
		pred_src_reg_reg[29] <= 1'b0;
		ins_type_reg[29] <= 2'b00;
		br_ins_reg[29] <= 1'b1;
		br_type_reg[29] <= 2'b00;
		mem_ins_reg[29] <= 1'b0;
		mem_type_reg[29] <= 1'b0;
		func_unit_reg[29] <= 3'b000;
		muxa_reg[29] <= 1'b0;
		muxb_reg[29] <= 2'b00;
		alu_op_reg[29] <= 3'b011;
		complex_alu_op_reg[29] <= 3'b000;
		pred_op_reg[29] <= 3'b000;
		float_op_reg[29] <= 3'b000;
		latency_reg[29] <= 4'b0001;

		// JMPR - 0x1e
		invalid_op_reg[30] <= 1'b0;
		reg_dest_valid_reg[30] <= 1'b0;
		reg_src1_valid_reg[30] <= 1'b1;
		reg_src2_valid_reg[30] <= 1'b0;
		pred_dest_valid_reg[30] <= 1'b0;
		pred_src1_valid_reg[30] <= 1'b0;
		pred_src2_valid_reg[30] <= 1'b0;
		dest_is_src_reg[30] <= 1'b1;
		pred_src_reg_reg[30] <= 1'b0;
		ins_type_reg[30] <= 2'b00;
		br_ins_reg[30] <= 1'b1;
		br_type_reg[30] <= 2'b11;
		mem_ins_reg[30] <= 1'b0;
		mem_type_reg[30] <= 1'b0;
		func_unit_reg[30] <= 3'b000;
		muxa_reg[30] <= 1'b1;
		muxb_reg[30] <= 2'b00;
		alu_op_reg[30] <= 3'b000;
		complex_alu_op_reg[30] <= 3'b000;
		pred_op_reg[30] <= 3'b000;
		float_op_reg[30] <= 3'b000;
		latency_reg[30] <= 4'b0001;

		//  CLONE - 0x1f
		invalid_op_reg[31] <= 1'b1;
		reg_dest_valid_reg[31] <= 1'd0;
		reg_src1_valid_reg[31] <= 1'd0;
		reg_src2_valid_reg[31] <= 1'd0;
		pred_dest_valid_reg[31] <= 1'd0;
		pred_src1_valid_reg[31] <= 1'd0;
		pred_src2_valid_reg[31] <= 1'd0;
		dest_is_src_reg[31] <= 1'd0;
		pred_src_reg_reg[31] <= 1'd0;
		ins_type_reg[31] <= 2'd0;
		br_ins_reg[31] <= 1'd0;
		br_type_reg[31] <= 2'd0;
		mem_ins_reg[31] <= 1'd0;
		mem_type_reg[31] <= 1'd0;
		func_unit_reg[31] <= 3'd0;
		muxa_reg[31] <= 1'd0;
		muxb_reg[31] <= 2'd0;
		alu_op_reg[31] <= 3'd0;
		complex_alu_op_reg[31] <= 3'd0;
		pred_op_reg[31] <= 3'd0;
		float_op_reg[31] <= 3'd0;
		latency_reg[31] <= 4'd0;

		// JALIS - 0x20
		invalid_op_reg[32] <= 1'b1;
		reg_dest_valid_reg[32] <= 1'd0;
		reg_src1_valid_reg[32] <= 1'd0;
		reg_src2_valid_reg[32] <= 1'd0;
		pred_dest_valid_reg[32] <= 1'd0;
		pred_src1_valid_reg[32] <= 1'd0;
		pred_src2_valid_reg[32] <= 1'd0;
		dest_is_src_reg[32] <= 1'd0;
		pred_src_reg_reg[32] <= 1'd0;
		ins_type_reg[32] <= 2'd0;
		br_ins_reg[32] <= 1'd0;
		br_type_reg[32] <= 2'd0;
		mem_ins_reg[32] <= 1'd0;
		mem_type_reg[32] <= 1'd0;
		func_unit_reg[32] <= 3'd0;
		muxa_reg[32] <= 1'd0;
		muxb_reg[32] <= 2'd0;
		alu_op_reg[32] <= 3'd0;
		complex_alu_op_reg[32] <= 3'd0;
		pred_op_reg[32] <= 3'd0;
		float_op_reg[32] <= 3'd0;
		latency_reg[32] <= 4'd0;

		// JALRS - 0x21
		invalid_op_reg[33] <= 1'b1;
		reg_dest_valid_reg[33] <= 1'd0;
		reg_src1_valid_reg[33] <= 1'd0;
		reg_src2_valid_reg[33] <= 1'd0;
		pred_dest_valid_reg[33] <= 1'd0;
		pred_src1_valid_reg[33] <= 1'd0;
		pred_src2_valid_reg[33] <= 1'd0;
		dest_is_src_reg[33] <= 1'd0;
		pred_src_reg_reg[33] <= 1'd0;
		ins_type_reg[33] <= 2'd0;
		br_ins_reg[33] <= 1'd0;
		br_type_reg[33] <= 2'd0;
		mem_ins_reg[33] <= 1'd0;
		mem_type_reg[33] <= 1'd0;
		func_unit_reg[33] <= 3'd0;
		muxa_reg[33] <= 1'd0;
		muxb_reg[33] <= 2'd0;
		alu_op_reg[33] <= 3'd0;
		complex_alu_op_reg[33] <= 3'd0;
		pred_op_reg[33] <= 3'd0;
		float_op_reg[33] <= 3'd0;
		latency_reg[33] <= 4'd0;

		// JMPRT - 0x22
		invalid_op_reg[34] <= 1'b1;
		reg_dest_valid_reg[34] <= 1'd0;
		reg_src1_valid_reg[34] <= 1'd0;
		reg_src2_valid_reg[34] <= 1'd0;
		pred_dest_valid_reg[34] <= 1'd0;
		pred_src1_valid_reg[34] <= 1'd0;
		pred_src2_valid_reg[34] <= 1'd0;
		dest_is_src_reg[34] <= 1'd0;
		pred_src_reg_reg[34] <= 1'd0;
		ins_type_reg[34] <= 2'd0;
		br_ins_reg[34] <= 1'd0;
		br_type_reg[34] <= 2'd0;
		mem_ins_reg[34] <= 1'd0;
		mem_type_reg[34] <= 1'd0;
		func_unit_reg[34] <= 3'd0;
		muxa_reg[34] <= 1'd0;
		muxb_reg[34] <= 2'd0;
		alu_op_reg[34] <= 3'd0;
		complex_alu_op_reg[34] <= 3'd0;
		pred_op_reg[34] <= 3'd0;
		float_op_reg[34] <= 3'd0;
		latency_reg[34] <= 4'd0;

		// LD - 0x23
		invalid_op_reg[35] <= 1'b0;
		reg_dest_valid_reg[35] <= 1'b0;
		reg_src1_valid_reg[35] <= 1'b1;
		reg_src2_valid_reg[35] <= 1'b1;
		pred_dest_valid_reg[35] <= 1'b0;
		pred_src1_valid_reg[35] <= 1'b0;
		pred_src2_valid_reg[35] <= 1'b0;
		dest_is_src_reg[35] <= 1'b0;
		pred_src_reg_reg[35] <= 1'b0;
		ins_type_reg[35] <= 2'b10;
		br_ins_reg[35] <= 1'b0;
		br_type_reg[35] <= 2'b00;
		mem_ins_reg[35] <= 1'b1;
		mem_type_reg[35] <= 1'b0;
		func_unit_reg[35] <= 3'b100;
		muxa_reg[35] <= 1'b1;
		muxb_reg[35] <= 2'b01;
		alu_op_reg[35] <= 3'b000;
		complex_alu_op_reg[35] <= 3'b000;
		pred_op_reg[35] <= 3'b000;
		float_op_reg[35] <= 3'b000;
		latency_reg[35] <= 4'b0001;

		// ST - 0x24
		invalid_op_reg[36] <= 1'b0;
		reg_dest_valid_reg[36] <= 1'b0;
		reg_src1_valid_reg[36] <= 1'b1;
		reg_src2_valid_reg[36] <= 1'b1;
		pred_dest_valid_reg[36] <= 1'b0;
		pred_src1_valid_reg[36] <= 1'b0;
		pred_src2_valid_reg[36] <= 1'b0;
		dest_is_src_reg[36] <= 1'b1;
		pred_src_reg_reg[36] <= 1'b0;
		ins_type_reg[36] <= 2'b01;
		br_ins_reg[36] <= 1'b0;
		br_type_reg[36] <= 2'b00;
		mem_ins_reg[36] <= 1'b1;
		mem_type_reg[36] <= 1'b1;
		func_unit_reg[36] <= 3'b100;
		muxa_reg[36] <= 1'b1;
		muxb_reg[36] <= 2'b01;
		alu_op_reg[36] <= 3'b000;
		complex_alu_op_reg[36] <= 3'b000;
		pred_op_reg[36] <= 3'b000;
		float_op_reg[36] <= 3'b000;
		latency_reg[36] <= 4'b0001;

		// LDI - 0x25
		invalid_op_reg[37] <= 1'b0;
		reg_dest_valid_reg[37] <= 1'b0;
		reg_src1_valid_reg[37] <= 1'b1;
		reg_src2_valid_reg[37] <= 1'b0;
		pred_dest_valid_reg[37] <= 1'b0;
		pred_src1_valid_reg[37] <= 1'b0;
		pred_src2_valid_reg[37] <= 1'b0;
		dest_is_src_reg[37] <= 1'b0;
		pred_src_reg_reg[37] <= 1'b0;
		ins_type_reg[37] <= 2'b10;
		br_ins_reg[37] <= 1'b0;
		br_type_reg[37] <= 2'b00;
		mem_ins_reg[37] <= 1'b1;
		mem_type_reg[37] <= 1'b0;
		func_unit_reg[37] <= 3'b100;
		muxa_reg[37] <= 1'b0;
		muxb_reg[37] <= 2'b10;
		alu_op_reg[37] <= 3'b000;
		complex_alu_op_reg[37] <= 3'b000;
		pred_op_reg[37] <= 3'b000;
		float_op_reg[37] <= 3'b000;
		latency_reg[37] <= 4'b0001;

		// ANDP - 0x27
		invalid_op_reg[39] <= 1'b0;
		reg_dest_valid_reg[39] <= 1'b0;
		reg_src1_valid_reg[39] <= 1'b0;
		reg_src2_valid_reg[39] <= 1'b0;
		pred_dest_valid_reg[39] <= 1'b1;
		pred_src1_valid_reg[39] <= 1'b1;
		pred_src2_valid_reg[39] <= 1'b1;
		dest_is_src_reg[39] <= 1'b0;
		pred_src_reg_reg[39] <= 1'b0;
		ins_type_reg[39] <= 2'b11;
		br_ins_reg[39] <= 1'b0;
		br_type_reg[39] <= 2'b00;
		mem_ins_reg[39] <= 1'b0;
		mem_type_reg[39] <= 1'b0;
		func_unit_reg[39] <= 3'b010;
		muxa_reg[39] <= 1'b0;
		muxb_reg[39] <= 2'b00;
		alu_op_reg[39] <= 3'b000;
		complex_alu_op_reg[39] <= 3'b000;
		pred_op_reg[39] <= 3'b001;
		float_op_reg[39] <= 3'b000;
		latency_reg[39] <= 4'b0001;

		// ORP - 0x28
		invalid_op_reg[40] <= 1'b0;
		reg_dest_valid_reg[40] <= 1'b0;
		reg_src1_valid_reg[40] <= 1'b0;
		reg_src2_valid_reg[40] <= 1'b0;
		pred_dest_valid_reg[40] <= 1'b1;
		pred_src1_valid_reg[40] <= 1'b1;
		pred_src2_valid_reg[40] <= 1'b1;
		dest_is_src_reg[40] <= 1'b0;
		pred_src_reg_reg[40] <= 1'b0;
		ins_type_reg[40] <= 2'b11;
		br_ins_reg[40] <= 1'b0;
		br_type_reg[40] <= 2'b00;
		mem_ins_reg[40] <= 1'b0;
		mem_type_reg[40] <= 1'b0;
		func_unit_reg[40] <= 3'b010;
		muxa_reg[40] <= 1'b0;
		muxb_reg[40] <= 2'b00;
		alu_op_reg[40] <= 3'b000;
		complex_alu_op_reg[40] <= 3'b000;
		pred_op_reg[40] <= 3'b010;
		float_op_reg[40] <= 3'b000;
		latency_reg[40] <= 4'b0001;

		// XORP - 0x29
		invalid_op_reg[41] <= 1'b0;
		reg_dest_valid_reg[41] <= 1'b0;
		reg_src1_valid_reg[41] <= 1'b0;
		reg_src2_valid_reg[41] <= 1'b0;
		pred_dest_valid_reg[41] <= 1'b1;
		pred_src1_valid_reg[41] <= 1'b1;
		pred_src2_valid_reg[41] <= 1'b1;
		dest_is_src_reg[41] <= 1'b0;
		pred_src_reg_reg[41] <= 1'b0;
		ins_type_reg[41] <= 2'b11;
		br_ins_reg[41] <= 1'b0;
		br_type_reg[41] <= 2'b00;
		mem_ins_reg[41] <= 1'b0;
		mem_type_reg[41] <= 1'b0;
		func_unit_reg[41] <= 3'b010;
		muxa_reg[41] <= 1'b0;
		muxb_reg[41] <= 2'b00;
		alu_op_reg[41] <= 3'b000;
		complex_alu_op_reg[41] <= 3'b000;
		pred_op_reg[41] <= 3'b011;
		float_op_reg[41] <= 3'b000;
		latency_reg[41] <= 4'b0001;

		// NOTP - 0x2a
		invalid_op_reg[42] <= 1'b0;
		reg_dest_valid_reg[42] <= 1'b0;
		reg_src1_valid_reg[42] <= 1'b0;
		reg_src2_valid_reg[42] <= 1'b0;
		pred_dest_valid_reg[42] <= 1'b1;
		pred_src1_valid_reg[42] <= 1'b1;
		pred_src2_valid_reg[42] <= 1'b0;
		dest_is_src_reg[42] <= 1'b0;
		pred_src_reg_reg[42] <= 1'b0;
		ins_type_reg[42] <= 2'b11;
		br_ins_reg[42] <= 1'b0;
		br_type_reg[42] <= 2'b00;
		mem_ins_reg[42] <= 1'b0;
		mem_type_reg[42] <= 1'b0;
		func_unit_reg[42] <= 3'b010;
		muxa_reg[42] <= 1'b0;
		muxb_reg[42] <= 2'b00;
		alu_op_reg[42] <= 3'b000;
		complex_alu_op_reg[42] <= 3'b000;
		pred_op_reg[42] <= 3'b100;
		float_op_reg[42] <= 3'b000;
		latency_reg[42] <= 4'b0001;

		// ISNEG - 0x2b
		invalid_op_reg[43] <= 1'b0;
		reg_dest_valid_reg[43] <= 1'b0;
		reg_src1_valid_reg[43] <= 1'b1;
		reg_src2_valid_reg[43] <= 1'b0;
		pred_dest_valid_reg[43] <= 1'b1;
		pred_src1_valid_reg[43] <= 1'b0;
		pred_src2_valid_reg[43] <= 1'b0;
		dest_is_src_reg[43] <= 1'b0;
		pred_src_reg_reg[43] <= 1'b1;
		ins_type_reg[43] <= 2'b11;
		br_ins_reg[43] <= 1'b0;
		br_type_reg[43] <= 2'b00;
		mem_ins_reg[43] <= 1'b0;
		mem_type_reg[43] <= 1'b0;
		func_unit_reg[43] <= 3'b010;
		muxa_reg[43] <= 1'b1;
		muxb_reg[43] <= 2'b00;
		alu_op_reg[43] <= 3'b000;
		complex_alu_op_reg[43] <= 3'b000;
		pred_op_reg[43] <= 3'b101;
		float_op_reg[43] <= 3'b000;
		latency_reg[43] <= 4'b0001;

		// ISZERO - 0x2c
		invalid_op_reg[44] <= 1'b0;
		reg_dest_valid_reg[44] <= 1'b0;
		reg_src1_valid_reg[44] <= 1'b1;
		reg_src2_valid_reg[44] <= 1'b0;
		pred_dest_valid_reg[44] <= 1'b1;
		pred_src1_valid_reg[44] <= 1'b0;
		pred_src2_valid_reg[44] <= 1'b0;
		dest_is_src_reg[44] <= 1'b0;
		pred_src_reg_reg[44] <= 1'b1;
		ins_type_reg[44] <= 2'b11;
		br_ins_reg[44] <= 1'b0;
		br_type_reg[44] <= 2'b00;
		mem_ins_reg[44] <= 1'b0;
		mem_type_reg[44] <= 1'b0;
		func_unit_reg[44] <= 3'b010;
		muxa_reg[44] <= 1'b1;
		muxb_reg[44] <= 2'b00;
		alu_op_reg[44] <= 3'b000;
		complex_alu_op_reg[44] <= 3'b000;
		pred_op_reg[44] <= 3'b110;
		float_op_reg[44] <= 3'b000;
		latency_reg[44] <= 4'b0001;

		// HALT - 0x2d
		invalid_op_reg[45] <= 1'b1;
		reg_dest_valid_reg[45] <= 1'd0;
		reg_src1_valid_reg[45] <= 1'd0;
		reg_src2_valid_reg[45] <= 1'd0;
		pred_dest_valid_reg[45] <= 1'd0;
		pred_src1_valid_reg[45] <= 1'd0;
		pred_src2_valid_reg[45] <= 1'd0;
		dest_is_src_reg[45] <= 1'd0;
		pred_src_reg_reg[45] <= 1'd0;
		ins_type_reg[45] <= 2'd0;
		br_ins_reg[45] <= 1'd0;
		br_type_reg[45] <= 2'd0;
		mem_ins_reg[45] <= 1'd0;
		mem_type_reg[45] <= 1'd0;
		func_unit_reg[45] <= 3'd0;
		muxa_reg[45] <= 1'd0;
		muxb_reg[45] <= 2'd0;
		alu_op_reg[45] <= 3'd0;
		complex_alu_op_reg[45] <= 3'd0;
		pred_op_reg[45] <= 3'd0;
		float_op_reg[45] <= 3'd0;
		latency_reg[45] <= 4'd0;

		// TRAP - 0x2e
		invalid_op_reg[46] <= 1'b1;
		reg_dest_valid_reg[46] <= 1'd0;
		reg_src1_valid_reg[46] <= 1'd0;
		reg_src2_valid_reg[46] <= 1'd0;
		pred_dest_valid_reg[46] <= 1'd0;
		pred_src1_valid_reg[46] <= 1'd0;
		pred_src2_valid_reg[46] <= 1'd0;
		dest_is_src_reg[46] <= 1'd0;
		pred_src_reg_reg[46] <= 1'd0;
		ins_type_reg[46] <= 2'd0;
		br_ins_reg[46] <= 1'd0;
		br_type_reg[46] <= 2'd0;
		mem_ins_reg[46] <= 1'd0;
		mem_type_reg[46] <= 1'd0;
		func_unit_reg[46] <= 3'd0;
		muxa_reg[46] <= 1'd0;
		muxb_reg[46] <= 2'd0;
		alu_op_reg[46] <= 3'd0;
		complex_alu_op_reg[46] <= 3'd0;
		pred_op_reg[46] <= 3'd0;
		float_op_reg[46] <= 3'd0;
		latency_reg[46] <= 4'd0;

		// JMPRU - 0x2f
		invalid_op_reg[47] <= 1'b1;
		reg_dest_valid_reg[47] <= 1'd0;
		reg_src1_valid_reg[47] <= 1'd0;
		reg_src2_valid_reg[47] <= 1'd0;
		pred_dest_valid_reg[47] <= 1'd0;
		pred_src1_valid_reg[47] <= 1'd0;
		pred_src2_valid_reg[47] <= 1'd0;
		dest_is_src_reg[47] <= 1'd0;
		pred_src_reg_reg[47] <= 1'd0;
		ins_type_reg[47] <= 2'd0;
		br_ins_reg[47] <= 1'd0;
		br_type_reg[47] <= 2'd0;
		mem_ins_reg[47] <= 1'd0;
		mem_type_reg[47] <= 1'd0;
		func_unit_reg[47] <= 3'd0;
		muxa_reg[47] <= 1'd0;
		muxb_reg[47] <= 2'd0;
		alu_op_reg[47] <= 3'd0;
		complex_alu_op_reg[47] <= 3'd0;
		pred_op_reg[47] <= 3'd0;
		float_op_reg[47] <= 3'd0;
		latency_reg[47] <= 4'd0;

		// SKEP - 0x30
		invalid_op_reg[48] <= 1'b1;
		reg_dest_valid_reg[48] <= 1'd0;
		reg_src1_valid_reg[48] <= 1'd0;
		reg_src2_valid_reg[48] <= 1'd0;
		pred_dest_valid_reg[48] <= 1'd0;
		pred_src1_valid_reg[48] <= 1'd0;
		pred_src2_valid_reg[48] <= 1'd0;
		dest_is_src_reg[48] <= 1'd0;
		pred_src_reg_reg[48] <= 1'd0;
		ins_type_reg[48] <= 2'd0;
		br_ins_reg[48] <= 1'd0;
		br_type_reg[48] <= 2'd0;
		mem_ins_reg[48] <= 1'd0;
		mem_type_reg[48] <= 1'd0;
		func_unit_reg[48] <= 3'd0;
		muxa_reg[48] <= 1'd0;
		muxb_reg[48] <= 2'd0;
		alu_op_reg[48] <= 3'd0;
		complex_alu_op_reg[48] <= 3'd0;
		pred_op_reg[48] <= 3'd0;
		float_op_reg[48] <= 3'd0;
		latency_reg[48] <= 4'd0;

		// RETI - 0x31
		invalid_op_reg[49] <= 1'b1;
		reg_dest_valid_reg[49] <= 1'd0;
		reg_src1_valid_reg[49] <= 1'd0;
		reg_src2_valid_reg[49] <= 1'd0;
		pred_dest_valid_reg[49] <= 1'd0;
		pred_src1_valid_reg[49] <= 1'd0;
		pred_src2_valid_reg[49] <= 1'd0;
		dest_is_src_reg[49] <= 1'd0;
		pred_src_reg_reg[49] <= 1'd0;
		ins_type_reg[49] <= 2'd0;
		br_ins_reg[49] <= 1'd0;
		br_type_reg[49] <= 2'd0;
		mem_ins_reg[49] <= 1'd0;
		mem_type_reg[49] <= 1'd0;
		func_unit_reg[49] <= 3'd0;
		muxa_reg[49] <= 1'd0;
		muxb_reg[49] <= 2'd0;
		alu_op_reg[49] <= 3'd0;
		complex_alu_op_reg[49] <= 3'd0;
		pred_op_reg[49] <= 3'd0;
		float_op_reg[49] <= 3'd0;
		latency_reg[49] <= 4'd0;

		// TLBRM - 0x32
		invalid_op_reg[50] <= 1'b1;
		reg_dest_valid_reg[50] <= 1'd0;
		reg_src1_valid_reg[50] <= 1'd0;
		reg_src2_valid_reg[50] <= 1'd0;
		pred_dest_valid_reg[50] <= 1'd0;
		pred_src1_valid_reg[50] <= 1'd0;
		pred_src2_valid_reg[50] <= 1'd0;
		dest_is_src_reg[50] <= 1'd0;
		pred_src_reg_reg[50] <= 1'd0;
		ins_type_reg[50] <= 2'd0;
		br_ins_reg[50] <= 1'd0;
		br_type_reg[50] <= 2'd0;
		mem_ins_reg[50] <= 1'd0;
		mem_type_reg[50] <= 1'd0;
		func_unit_reg[50] <= 3'd0;
		muxa_reg[50] <= 1'd0;
		muxb_reg[50] <= 2'd0;
		alu_op_reg[50] <= 3'd0;
		complex_alu_op_reg[50] <= 3'd0;
		pred_op_reg[50] <= 3'd0;
		float_op_reg[50] <= 3'd0;
		latency_reg[50] <= 4'd0;

		// ITOF - 0x33
		invalid_op_reg[51] <= 1'b0;
		reg_dest_valid_reg[51] <= 1'b1;
		reg_src1_valid_reg[51] <= 1'b1;
		reg_src2_valid_reg[51] <= 1'b0;
		pred_dest_valid_reg[51] <= 1'b0;
		pred_src1_valid_reg[51] <= 1'b0;
		pred_src2_valid_reg[51] <= 1'b0;
		dest_is_src_reg[51] <= 1'b0;
		pred_src_reg_reg[51] <= 1'b0;
		ins_type_reg[51] <= 2'b10;
		br_ins_reg[51] <= 1'b0;
		br_type_reg[51] <= 2'b00;
		mem_ins_reg[51] <= 1'b0;
		mem_type_reg[51] <= 1'b0;
		func_unit_reg[51] <= 3'b011;
		muxa_reg[51] <= 1'b1;
		muxb_reg[51] <= 2'b00;
		alu_op_reg[51] <= 3'b000;
		complex_alu_op_reg[51] <= 3'b000;
		pred_op_reg[51] <= 3'b000;
		float_op_reg[51] <= 3'b001;
		latency_reg[51] <= 4'b1010;

		// FTOI - 0x34
		invalid_op_reg[52] <= 1'b0;
		reg_dest_valid_reg[52] <= 1'b1;
		reg_src1_valid_reg[52] <= 1'b1;
		reg_src2_valid_reg[52] <= 1'b0;
		pred_dest_valid_reg[52] <= 1'b0;
		pred_src1_valid_reg[52] <= 1'b0;
		pred_src2_valid_reg[52] <= 1'b0;
		dest_is_src_reg[52] <= 1'b0;
		pred_src_reg_reg[52] <= 1'b0;
		ins_type_reg[52] <= 2'b10;
		br_ins_reg[52] <= 1'b0;
		br_type_reg[52] <= 2'b00;
		mem_ins_reg[52] <= 1'b0;
		mem_type_reg[52] <= 1'b0;
		func_unit_reg[52] <= 3'b011;
		muxa_reg[52] <= 1'b1;
		muxb_reg[52] <= 2'b00;
		alu_op_reg[52] <= 3'b000;
		complex_alu_op_reg[52] <= 3'b000;
		pred_op_reg[52] <= 3'b000;
		float_op_reg[52] <= 3'b010;
		latency_reg[52] <= 4'b1010;

		// FADD - 0x35
		invalid_op_reg[53] <= 1'b0;
		reg_dest_valid_reg[53] <= 1'b1;
		reg_src1_valid_reg[53] <= 1'b1;
		reg_src2_valid_reg[53] <= 1'b1;
		pred_dest_valid_reg[53] <= 1'b0;
		pred_src1_valid_reg[53] <= 1'b0;
		pred_src2_valid_reg[53] <= 1'b0;
		dest_is_src_reg[53] <= 1'b0;
		pred_src_reg_reg[53] <= 1'b0;
		ins_type_reg[53] <= 2'b10;
		br_ins_reg[53] <= 1'b0;
		br_type_reg[53] <= 2'b00;
		mem_ins_reg[53] <= 1'b0;
		mem_type_reg[53] <= 1'b0;
		func_unit_reg[53] <= 3'b011;
		muxa_reg[53] <= 1'b1;
		muxb_reg[53] <= 2'b11;
		alu_op_reg[53] <= 3'b000;
		complex_alu_op_reg[53] <= 3'b000;
		pred_op_reg[53] <= 3'b000;
		float_op_reg[53] <= 3'b011;
		latency_reg[53] <= 4'b1010;

		// FSUB - 0x36
		invalid_op_reg[54] <= 1'b0;
		reg_dest_valid_reg[54] <= 1'b1;
		reg_src1_valid_reg[54] <= 1'b1;
		reg_src2_valid_reg[54] <= 1'b1;
		pred_dest_valid_reg[54] <= 1'b0;
		pred_src1_valid_reg[54] <= 1'b0;
		pred_src2_valid_reg[54] <= 1'b0;
		dest_is_src_reg[54] <= 1'b0;
		pred_src_reg_reg[54] <= 1'b0;
		ins_type_reg[54] <= 2'b10;
		br_ins_reg[54] <= 1'b0;
		br_type_reg[54] <= 2'b00;
		mem_ins_reg[54] <= 1'b0;
		mem_type_reg[54] <= 1'b0;
		func_unit_reg[54] <= 3'b011;
		muxa_reg[54] <= 1'b1;
		muxb_reg[54] <= 2'b11;
		alu_op_reg[54] <= 3'b000;
		complex_alu_op_reg[54] <= 3'b000;
		pred_op_reg[54] <= 3'b000;
		float_op_reg[54] <= 3'b100;
		latency_reg[54] <= 4'b1010;

		// FMUL - 0x37
		invalid_op_reg[55] <= 1'b0;
		reg_dest_valid_reg[55] <= 1'b1;
		reg_src1_valid_reg[55] <= 1'b1;
		reg_src2_valid_reg[55] <= 1'b1;
		pred_dest_valid_reg[55] <= 1'b0;
		pred_src1_valid_reg[55] <= 1'b0;
		pred_src2_valid_reg[55] <= 1'b0;
		dest_is_src_reg[55] <= 1'b0;
		pred_src_reg_reg[55] <= 1'b0;
		ins_type_reg[55] <= 2'b10;
		br_ins_reg[55] <= 1'b0;
		br_type_reg[55] <= 2'b00;
		mem_ins_reg[55] <= 1'b0;
		mem_type_reg[55] <= 1'b0;
		func_unit_reg[55] <= 3'b011;
		muxa_reg[55] <= 1'b1;
		muxb_reg[55] <= 2'b11;
		alu_op_reg[55] <= 3'b000;
		complex_alu_op_reg[55] <= 3'b000;
		pred_op_reg[55] <= 3'b000;
		float_op_reg[55] <= 3'b101;
		latency_reg[55] <= 4'b1010;

		// FDIV - 0x38
		invalid_op_reg[56] <= 1'b0;
		reg_dest_valid_reg[56] <= 1'b1;
		reg_src1_valid_reg[56] <= 1'b1;
		reg_src2_valid_reg[56] <= 1'b1;
		pred_dest_valid_reg[56] <= 1'b0;
		pred_src1_valid_reg[56] <= 1'b0;
		pred_src2_valid_reg[56] <= 1'b0;
		dest_is_src_reg[56] <= 1'b0;
		pred_src_reg_reg[56] <= 1'b0;
		ins_type_reg[56] <= 2'b10;
		br_ins_reg[56] <= 1'b0;
		br_type_reg[56] <= 2'b00;
		mem_ins_reg[56] <= 1'b0;
		mem_type_reg[56] <= 1'b0;
		func_unit_reg[56] <= 3'b011;
		muxa_reg[56] <= 1'b1;
		muxb_reg[56] <= 2'b11;
		alu_op_reg[56] <= 3'b000;
		complex_alu_op_reg[56] <= 3'b000;
		pred_op_reg[56] <= 3'b000;
		float_op_reg[56] <= 3'b110;
		latency_reg[56] <= 4'b1010;

		// FNEG - 0x39
		invalid_op_reg[57] <= 1'b0;
		reg_dest_valid_reg[57] <= 1'b1;
		reg_src1_valid_reg[57] <= 1'b1;
		reg_src2_valid_reg[57] <= 1'b0;
		pred_dest_valid_reg[57] <= 1'b0;
		pred_src1_valid_reg[57] <= 1'b0;
		pred_src2_valid_reg[57] <= 1'b0;
		dest_is_src_reg[57] <= 1'b0;
		pred_src_reg_reg[57] <= 1'b0;
		ins_type_reg[57] <= 2'b10;
		br_ins_reg[57] <= 1'b0;
		br_type_reg[57] <= 2'b00;
		mem_ins_reg[57] <= 1'b0;
		mem_type_reg[57] <= 1'b0;
		func_unit_reg[57] <= 3'b011;
		muxa_reg[57] <= 1'b1;
		muxb_reg[57] <= 2'b00;
		alu_op_reg[57] <= 3'b000;
		complex_alu_op_reg[57] <= 3'b000;
		pred_op_reg[57] <= 3'b000;
		float_op_reg[57] <= 3'b111;
		latency_reg[57] <= 4'b1010;

		// UNUSED - 0x3a
		invalid_op_reg[58] <= 1'b1;
		reg_dest_valid_reg[58] <= 1'd0;
		reg_src1_valid_reg[58] <= 1'd0;
		reg_src2_valid_reg[58] <= 1'd0;
		pred_dest_valid_reg[58] <= 1'd0;
		pred_src1_valid_reg[58] <= 1'd0;
		pred_src2_valid_reg[58] <= 1'd0;
		dest_is_src_reg[58] <= 1'd0;
		pred_src_reg_reg[58] <= 1'd0;
		ins_type_reg[58] <= 2'd0;
		br_ins_reg[58] <= 1'd0;
		br_type_reg[58] <= 2'd0;
		mem_ins_reg[58] <= 1'd0;
		mem_type_reg[58] <= 1'd0;
		func_unit_reg[58] <= 3'd0;
		muxa_reg[58] <= 1'd0;
		muxb_reg[58] <= 2'd0;
		alu_op_reg[58] <= 3'd0;
		complex_alu_op_reg[58] <= 3'd0;
		pred_op_reg[58] <= 3'd0;
		float_op_reg[58] <= 3'd0;
		latency_reg[58] <= 4'd0;

		// UNUSED - 0x3b
		invalid_op_reg[59] <= 1'b1;
		reg_dest_valid_reg[59] <= 1'd0;
		reg_src1_valid_reg[59] <= 1'd0;
		reg_src2_valid_reg[59] <= 1'd0;
		pred_dest_valid_reg[59] <= 1'd0;
		pred_src1_valid_reg[59] <= 1'd0;
		pred_src2_valid_reg[59] <= 1'd0;
		dest_is_src_reg[59] <= 1'd0;
		pred_src_reg_reg[59] <= 1'd0;
		ins_type_reg[59] <= 2'd0;
		br_ins_reg[59] <= 1'd0;
		br_type_reg[59] <= 2'd0;
		mem_ins_reg[59] <= 1'd0;
		mem_type_reg[59] <= 1'd0;
		func_unit_reg[59] <= 3'd0;
		muxa_reg[59] <= 1'd0;
		muxb_reg[59] <= 2'd0;
		alu_op_reg[59] <= 3'd0;
		complex_alu_op_reg[59] <= 3'd0;
		pred_op_reg[59] <= 3'd0;
		float_op_reg[59] <= 3'd0;
		latency_reg[59] <= 4'd0;

		// UNUSED - 0x3c
		invalid_op_reg[60] <= 1'b1;
		reg_dest_valid_reg[60] <= 1'd0;
		reg_src1_valid_reg[60] <= 1'd0;
		reg_src2_valid_reg[60] <= 1'd0;
		pred_dest_valid_reg[60] <= 1'd0;
		pred_src1_valid_reg[60] <= 1'd0;
		pred_src2_valid_reg[60] <= 1'd0;
		dest_is_src_reg[60] <= 1'd0;
		pred_src_reg_reg[60] <= 1'd0;
		ins_type_reg[60] <= 2'd0;
		br_ins_reg[60] <= 1'd0;
		br_type_reg[60] <= 2'd0;
		mem_ins_reg[60] <= 1'd0;
		mem_type_reg[60] <= 1'd0;
		func_unit_reg[60] <= 3'd0;
		muxa_reg[60] <= 1'd0;
		muxb_reg[60] <= 2'd0;
		alu_op_reg[60] <= 3'd0;
		complex_alu_op_reg[60] <= 3'd0;
		pred_op_reg[60] <= 3'd0;
		float_op_reg[60] <= 3'd0;
		latency_reg[60] <= 4'd0;

		// UNUSED - 0x3d
		invalid_op_reg[61] <= 1'b1;
		reg_dest_valid_reg[61] <= 1'd0;
		reg_src1_valid_reg[61] <= 1'd0;
		reg_src2_valid_reg[61] <= 1'd0;
		pred_dest_valid_reg[61] <= 1'd0;
		pred_src1_valid_reg[61] <= 1'd0;
		pred_src2_valid_reg[61] <= 1'd0;
		dest_is_src_reg[61] <= 1'd0;
		pred_src_reg_reg[61] <= 1'd0;
		ins_type_reg[61] <= 2'd0;
		br_ins_reg[61] <= 1'd0;
		br_type_reg[61] <= 2'd0;
		mem_ins_reg[61] <= 1'd0;
		mem_type_reg[61] <= 1'd0;
		func_unit_reg[61] <= 3'd0;
		muxa_reg[61] <= 1'd0;
		muxb_reg[61] <= 2'd0;
		alu_op_reg[61] <= 3'd0;
		complex_alu_op_reg[61] <= 3'd0;
		pred_op_reg[61] <= 3'd0;
		float_op_reg[61] <= 3'd0;
		latency_reg[61] <= 4'd0;

		// UNUSED - 0x3e
		invalid_op_reg[62] <= 1'b1;
		reg_dest_valid_reg[62] <= 1'd0;
		reg_src1_valid_reg[62] <= 1'd0;
		reg_src2_valid_reg[62] <= 1'd0;
		pred_dest_valid_reg[62] <= 1'd0;
		pred_src1_valid_reg[62] <= 1'd0;
		pred_src2_valid_reg[62] <= 1'd0;
		dest_is_src_reg[62] <= 1'd0;
		pred_src_reg_reg[62] <= 1'd0;
		ins_type_reg[62] <= 2'd0;
		br_ins_reg[62] <= 1'd0;
		br_type_reg[62] <= 2'd0;
		mem_ins_reg[62] <= 1'd0;
		mem_type_reg[62] <= 1'd0;
		func_unit_reg[62] <= 3'd0;
		muxa_reg[62] <= 1'd0;
		muxb_reg[62] <= 2'd0;
		alu_op_reg[62] <= 3'd0;
		complex_alu_op_reg[62] <= 3'd0;
		pred_op_reg[62] <= 3'd0;
		float_op_reg[62] <= 3'd0;
		latency_reg[62] <= 4'd0;

		// UNUSED - 0x3f
		invalid_op_reg[63] <= 1'b1;
		reg_dest_valid_reg[63] <= 1'd0;
		reg_src1_valid_reg[63] <= 1'd0;
		reg_src2_valid_reg[63] <= 1'd0;
		pred_dest_valid_reg[63] <= 1'd0;
		pred_src1_valid_reg[63] <= 1'd0;
		pred_src2_valid_reg[63] <= 1'd0;
		dest_is_src_reg[63] <= 1'd0;
		pred_src_reg_reg[63] <= 1'd0;
		ins_type_reg[63] <= 2'd0;
		br_ins_reg[63] <= 1'd0;
		br_type_reg[63] <= 2'd0;
		mem_ins_reg[63] <= 1'd0;
		mem_type_reg[63] <= 1'd0;
		func_unit_reg[63] <= 3'd0;
		muxa_reg[63] <= 1'd0;
		muxb_reg[63] <= 2'd0;
		alu_op_reg[63] <= 3'd0;
		complex_alu_op_reg[63] <= 3'd0;
		pred_op_reg[63] <= 3'd0;
		float_op_reg[63] <= 3'd0;
		latency_reg[63] <= 4'd0;
	end
end

endmodule
