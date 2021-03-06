`include "../globals.vh"
module ID(
	// Inputs
	clk,
	reset,
	// From IF stage
	ins,
	ins_is_nop,
	next_pc,
	// From EX stage
	ex_is_nop,
	ex_ins_type,
	ex_dest_addr,
	free_units,
	//free_unit,
	//free_unit_id,
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
	id_stalls_if,
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
	mem_ins,
	mem_type,
	func_unit,
	muxa,
	muxb,
	alu_op,
	complex_alu_op,
	pred_op,
	float_op,
	latency,
  
	// To WB stage
	add_rob_entry,
	entry_dest_addr,
	entry_ins_type,
	entry_exception,
	entry_ins_state,

	commit_reg_data,
	commit_pred_data
);


localparam IMM_0REG_SIZE = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE;
localparam IMM_1REG_SIZE = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `REG_ADDR_SIZE;
localparam IMM_2REG_SIZE = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `REG_ADDR_SIZE - `REG_ADDR_SIZE;

localparam INS_PRED_REG_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE;
localparam INS_OPCODE_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE;
localparam INS_REG_DEST_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `REG_ADDR_SIZE;
localparam INS_REG_SRC1_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `REG_ADDR_SIZE - `REG_ADDR_SIZE;
localparam INS_REG_SRC2_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `REG_ADDR_SIZE - `REG_ADDR_SIZE - `REG_ADDR_SIZE;
localparam INS_PRED_DEST_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `PRED_ADDR_SIZE;
localparam INS_PRED_SRC1_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `PRED_ADDR_SIZE - `PRED_ADDR_SIZE;
localparam INS_PRED_SRC2_LOW = `INS_WIDTH - 1 - `PRED_ADDR_SIZE - `OPCODE_SIZE - `PRED_ADDR_SIZE - `PRED_ADDR_SIZE - `PRED_ADDR_SIZE;
localparam INS_PRED_SRCREG_LOW = `INS_WIDTH - 1- `PRED_ADDR_SIZE - `OPCODE_SIZE - `PRED_ADDR_SIZE - `REG_ADDR_SIZE;


// Inputs
input								clk;
input								reset;
input	[`DATA_WIDTH-1:0]			next_pc;
input	[`INS_WIDTH-1:0]			ins;
input								ins_is_nop;
input						ex_is_nop;
input	[`INS_TYPE_SIZE-1:0]			ex_ins_type;
input	[`DEST_ADDR_SIZE-1:0]			ex_dest_addr;
input	[`NUM_FUNC_UNITS-1:0]			free_units;
//input								free_unit;
//input	[`FUNC_UNIT_OP_SIZE-1:0]	free_unit_id;
input								rob_full;
input	[`ROB_ID_SIZE-1:0]			entry_id;
input	[`REG_ADDR_SIZE-1:0]		commit_reg_addr;
input	[`PRED_ADDR_SIZE-1:0]		commit_pred_addr;
input								wr_reg_en;
input	[`REG_ADDR_SIZE-1:0]		wr_reg_addr;
input	[`INS_WIDTH-1:0]			wr_reg_data;
input								wr_pred_en;
input	[`PRED_ADDR_SIZE-1:0]		wr_pred_addr;
input								wr_pred_data;

// Output instruction information
// Output to IF stage
output							sel_br;
output  [`DATA_WIDTH-1:0]		br_target;
// Output to EX stage
output							ins_nop;
output	[`ROB_ID_SIZE-1:0]				ins_id;
output  [`PRED_DATA_WIDTH-1:0]	predicate;
output	[`INS_TYPE_SIZE-1:0]	ins_type;
output  [`DEST_ADDR_SIZE-1:0]	dest_addr;
output  [`REG_DATA_WIDTH-1:0]   reg_src1;
output  [`REG_DATA_WIDTH-1:0]   reg_src2;
output  [`DATA_WIDTH-1:0]       imm_0reg;
output  [`DATA_WIDTH-1:0]       imm_1reg;
output  [`DATA_WIDTH-1:0]       imm_2reg;
output  [`PRED_DATA_WIDTH-1:0]	pred_src1;
output	[`PRED_DATA_WIDTH-1:0]	pred_src2;
output							id_stalls_if;
// Output control signals
output 	mem_ins;
output 	mem_type;
output	[2:0]		func_unit;
output 	[1:0]muxa;
output	[1:0]		muxb;
output	[2:0]		alu_op;
output	[2:0]		complex_alu_op;
output	[2:0]		pred_op;
output	[2:0]		float_op;
output	[3:0]		latency;

// Output to WB stage
output							add_rob_entry;
output	[`INS_TYPE_SIZE-1:0]	entry_ins_type;
output  [`DEST_ADDR_SIZE-1:0]	entry_dest_addr;
output	[`EXCEPTION_ID_SIZE-1:0]	entry_exception;
output	[`INS_STATE_SIZE-1:0]	entry_ins_state;
output  [`REG_DATA_WIDTH-1:0]	commit_reg_data;
output	[`PRED_DATA_WIDTH-1:0]	commit_pred_data;


// Instruction values
wire                            pred_ins;
wire	[`PRED_ADDR_SIZE-1:0]   pred_addr;
wire    [`OPCODE_SIZE-1:0]      opcode;
wire    [`REG_ADDR_SIZE-1:0]    reg_dest_addr;
wire    [`REG_ADDR_SIZE-1:0]    reg_src1_addr;
wire    [`REG_ADDR_SIZE-1:0]    reg_src2_addr;
wire    [`PRED_ADDR_SIZE-1:0]   pred_dest_addr;
wire    [`PRED_ADDR_SIZE-1:0]   pred_src1_addr;
wire    [`PRED_ADDR_SIZE-1:0]   pred_src2_addr;
wire    [`REG_ADDR_SIZE-1:0]    pred_srcReg_addr;
wire	[`DATA_WIDTH-1:0]		pc_rel_br;
wire	[`DATA_WIDTH-1:0]		pc_link_br;
wire	[`DATA_WIDTH-1:0]		reg_br;
wire	[`DATA_WIDTH-1:0]		reg_link_br;

// Immediate values
wire                            pred_val; // Predicate register value

// Decoder's control signal wires
wire 							invalid_op;
wire							skip_to_retire;
wire 							reg_dest_valid;
wire 							reg_src1_valid;
wire 							reg_src2_valid;
wire 							pred_dest_valid;
wire 							pred_src1_valid;
wire 							pred_src2_valid;
wire 							dest_is_src;
wire 							pred_src_reg;
wire							br_ins;
wire	[1:0]		br_type;

wire							predicate_valid;
wire 							resource_stall;
wire 							issue;

wire                               issue_reg_dest_valid;
wire   [`REG_ADDR_SIZE-1:0]         issue_reg_dest_addr;
wire                               issue_pred_dest_valid;
wire   [`PRED_ADDR_SIZE-1:0]        issue_pred_dest_addr;

// Decode instruction to its componenets
assign pred_ins = ins[`INS_WIDTH-1];
assign pred_addr = ins[INS_PRED_REG_LOW + `PRED_ADDR_SIZE - 1:INS_PRED_REG_LOW];

assign opcode = ins[INS_OPCODE_LOW + `OPCODE_SIZE - 1:INS_OPCODE_LOW];
// Register addres bits
assign reg_dest_addr = ins[INS_REG_DEST_LOW + `REG_ADDR_SIZE - 1:INS_REG_DEST_LOW]; // Destination Register
assign pred_srcReg_addr = ins[INS_PRED_SRCREG_LOW + `REG_ADDR_SIZE - 1:INS_PRED_SRCREG_LOW];
// Identify src1 register address as either 
mux2to1 #(.DATA_WIDTH(`REG_ADDR_SIZE)) 
  regSrc1Mux(
    .a(ins[INS_REG_SRC1_LOW + `REG_ADDR_SIZE - 1:INS_REG_SRC1_LOW]), 
    .b(pred_srcReg_addr),
    .sel(pred_src_reg),
    .out(reg_src1_addr)
);

// Idenitfy second src address as either
mux2to1 #(.DATA_WIDTH(`REG_ADDR_SIZE)) 
  regSrc2Mux(
    .a(ins[INS_REG_SRC2_LOW + `REG_ADDR_SIZE - 1:INS_REG_SRC2_LOW]), 
    .b(reg_dest_addr),
    .sel(dest_is_src),
    .out(reg_src2_addr)
);

// Predicate register address bits
assign pred_dest_addr = ins[INS_PRED_DEST_LOW + `PRED_ADDR_SIZE - 1:INS_PRED_DEST_LOW];
assign pred_src1_addr = ins[INS_PRED_SRC1_LOW + `PRED_ADDR_SIZE - 1:INS_PRED_SRC1_LOW];
assign pred_src2_addr = ins[INS_PRED_SRC2_LOW + `PRED_ADDR_SIZE - 1:INS_PRED_SRC2_LOW];


// Select the destionation address based on type
mux2to1 #(.DATA_WIDTH(`REG_ADDR_SIZE)) destMux(
  .a(reg_dest_addr),
  .b({2'b0,pred_dest_addr}),
  .sel(ins_type[0]),
  .out(dest_addr)
);

// General Purpose Register File
register_file_3r1w #(.ADDR_SIZE(`REG_ADDR_SIZE),
                     .DATA_WIDTH(`REG_DATA_WIDTH))
  reg_file(
    .clk(clk),
    .reset(reset),
    .rd_addr1(reg_src1_addr),
    .rd_addr2(reg_src2_addr),
    .rd_addr3(commit_reg_addr),
    .wr_en(wr_reg_en),
    .wr_addr(wr_reg_addr),
    .wr_data(wr_reg_data),
	
    .data1(reg_src1),
    .data2(reg_src2),
    .data3(commit_reg_data)
);

// Predicate Register File
register_file_4r1w #(.ADDR_SIZE(`PRED_ADDR_SIZE),
                     .DATA_WIDTH(`PRED_DATA_WIDTH))
  pred_reg_file(
    .clk(clk),
    .reset(reset),
    .rd_addr1(pred_addr),
    .rd_addr2(pred_src1_addr),
    .rd_addr3(pred_src2_addr),
    .rd_addr4(commit_pred_addr),
    .wr_en(wr_pred_en),
    .wr_addr(wr_pred_addr),
    .wr_data(wr_pred_data),
	
    .data1(pred_val),
    .data2(pred_src1),
    .data3(pred_src2),
    .data4(commit_pred_data)
);

// Sign Extenders for immediate values
sign_ext #(.IN_SIZE(IMM_0REG_SIZE), 
           .OUT_SIZE(32)) 
  ext1(
    .in(ins[IMM_0REG_SIZE-1:0]), 
    .out(imm_0reg)
);

sign_ext #(.IN_SIZE(IMM_1REG_SIZE), 
           .OUT_SIZE(32)) 
  ext2(
    .in(ins[IMM_1REG_SIZE-1:0]), 
    .out(imm_1reg)
);

sign_ext #(.IN_SIZE(IMM_2REG_SIZE), 
           .OUT_SIZE(32)) 
  ext3(
    .in(ins[IMM_2REG_SIZE-1:0]), 
    .out(imm_2reg)
);

// Selecting predicate value based on whether instruction is predicate instruction
mux2to1 #(.DATA_WIDTH(`PRED_DATA_WIDTH)) 
  m1(
    .a(`PRED_DATA_WIDTH'b1), 
    .b(pred_val), 
    .sel(pred_ins), 
    .out(predicate)
);

assign issue_reg_dest_valid = ex_ins_type[1] & ~ex_ins_type[0];
assign issue_pred_dest_valid = ex_ins_type[1] & ex_ins_type[0];
assign issue_reg_dest_addr = ex_dest_addr[`REG_ADDR_SIZE-1:0];
assign issue_pred_dest_addr = ex_dest_addr[`PRED_ADDR_SIZE-1:0];
// Scoreboarding mechanism 
scoreboard #(.REG_ADDR_SIZE(`REG_ADDR_SIZE),
             .PRED_ADDR_SIZE(`PRED_ADDR_SIZE),
             .FUNC_UNIT_OP_SIZE(`FUNC_UNIT_OP_SIZE))
  score(
    .clk(clk),
    .reset(reset),
    .pred_addr(pred_addr),
    .pred_ins(pred_ins),
    .reg_dest_addr(reg_dest_addr),
    .reg_dest_valid(reg_dest_valid),
    .reg_src1_addr(reg_src1_addr),
    .reg_src1_valid(reg_src1_valid),
    .reg_src2_addr(reg_src2_addr),
    .reg_src2_valid(reg_src2_valid),
    .pred_dest_addr(pred_dest_addr),
    .pred_dest_valid(pred_dest_valid),
    .pred_src1_addr(pred_src1_addr),
    .pred_src1_valid(pred_src1_valid),
    .pred_src2_addr(pred_src2_addr),
    .pred_src2_valid(pred_src2_valid),
    .func_unit(func_unit),
    .wr_reg(wr_reg_en),
    .wr_reg_addr(wr_reg_addr),
    .wr_pred(wr_pred_en),
    .wr_pred_addr(wr_pred_addr),
    .free_units(free_units),
//    .free_unit(free_unit),
//    .free_unit_id(free_unit_id),
    .issue(~ex_is_nop),
    .issue_reg_dest_valid(issue_reg_dest_valid),
    .issue_reg_dest_addr(issue_reg_dest_addr),
    .issue_pred_dest_valid(issue_pred_dest_valid),
    .issue_pred_dest_addr(issue_pred_dest_addr),
	.predicate_valid(predicate_valid),
    .resource_stall(resource_stall)
);

// Control Unit to generate control signals
control_unit #(.OPCODE_SIZE(`OPCODE_SIZE))
  control(
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    
	.invalid_op(invalid_op),
	.skip_to_retire(skip_to_retire),
    // Mainly used by ID stage
    .reg_dest_valid(reg_dest_valid),
	.reg_src1_valid(reg_src1_valid),
	.reg_src2_valid(reg_src2_valid),
	.pred_dest_valid(pred_dest_valid),
	.pred_src1_valid(pred_src1_valid),
	.pred_src2_valid(pred_src2_valid),
	.dest_is_src(dest_is_src),
	.pred_src_reg(pred_src_reg),
	.ins_type(ins_type),
	.br_ins(br_ins),
	.br_type(br_type),
	// Mainly used by EX stage
	.mem_ins(mem_ins),
	.mem_type(mem_type),
	.func_unit(func_unit),
	.muxa(muxa),
	.muxb(muxb),
	.alu_op(alu_op),
	.complex_alu_op(complex_alu_op),
	.pred_op(pred_op),
	.float_op(float_op),
	.latency(latency)
 
);

assign pc_rel_br = next_pc + imm_0reg;
assign pc_link_br = next_pc + imm_1reg;
assign reg_br = reg_src2;
assign reg_link_br = reg_src2;

// Mux to determine the branch target
mux4to1 #(.DATA_WIDTH(`DATA_WIDTH))
  br_mux(
	.a(pc_rel_br),
	.b(pc_link_br),
	.c(reg_br),
	.d(reg_link_br),
	.sel(br_type),
	.out(br_target)
);

// Issue if we can add to ROB and send to EX stage
assign id_stalls_if = rob_full | (resource_stall & predicate) | ~predicate_valid;
// Issue instruction if we aren't stalling ID 
assign issue = predicate & ~id_stalls_if & ~skip_to_retire;
// If instruction was nop, then indicate so to next instruction
assign ins_nop = ins_is_nop | id_stalls_if | ~issue;

assign ins_id = entry_id;

// WB stage values
assign add_rob_entry = ~id_stalls_if & ~ins_is_nop;
assign entry_dest_addr = dest_addr;
assign entry_ins_type = predicate ? ins_type : `INS_TYPE_SIZE'b0;
assign entry_ins_state = ~predicate | skip_to_retire;
mux2to1 #(.DATA_WIDTH(`EXCEPTION_ID_SIZE))
	exception_mux(
		.a(`NO_EXCEPTION),
		.b(`INVALID_OP_EXCEPTION),
		.sel(invalid_op),
		.out(entry_exception)
);

// Selecting branch value
assign sel_br = br_ins & issue;	

endmodule
