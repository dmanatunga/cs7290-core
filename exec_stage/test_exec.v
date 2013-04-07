`timescale 1ns / 1ps

module test_exec();

   reg   clk;
   reg   [31:0]srcA;
   reg   [31:0]srcB;
   reg   [5:0]ctrl_sigs;
   reg   [4:0]rob_entry;
   reg   [3:0]dest_reg;
   reg   [2:0]func_unit;
   reg   [4:0]latency_counter;
   reg   [2:0]simple_alu_op;
   reg   [2:0]complex_alu_op;
   reg   [2:0]pred_op;
   reg   [2:0]float_op;
   reg   [1:0]ins_type;
   reg 	 pred_src1;
   reg 	 pred_src2;
   reg   reset;
   reg   ins_nop;
   reg   muxa;
   reg   [1:0]muxb;
   reg mem_type;
   reg is_mem;
   reg       		commit_st;
   reg [4:0] commit_st_rob_id;
	
initial begin
   clk = 0;
   reset = 1;
   simple_alu_op = 3'b011;
   complex_alu_op= 3'b001;
   pred_op = 3'b001;
   float_op = 3'b001;
   ctrl_sigs = 6'b00_0001;
   ins_type = 2'b11;
   pred_src1 = 1;
   pred_src2 = 7;
   ins_nop = 1;
   srcA = 7;
   srcB = 10;
   muxa = 1;
   muxb = 3;
   is_mem = 0; 
   commit_st_rob_id = 5'b00000;
   commit_st = 0;
#200   ins_nop = 0;
#160	reset = 0;
	dest_reg = 4'b0001;
	rob_entry = 5'b00001;
	latency_counter = 5'b00110;
	func_unit = 4;
	mem_type = 0;
	is_mem = 1; 
#100	func_unit = 4;
	rob_entry = 5'b00010;
#100	func_unit = 4;
	mem_type = 1;
   	complex_alu_op= 3'b000;
	rob_entry = 5'b00011;
	dest_reg = 4'b0011;
   	ins_type = 2'b10;
//#100	func_unit = 0;
//	latency_counter = 5'b00001;
//	rob_entry = 4'b00011;
//	dest_reg = 3'b011;
//#100	ins_nop = 1;
#100	srcB = 5;
	srcA = 43;
	rob_entry = 5'b00100;
#100	ins_nop = 0;
	is_mem = 0; 
#1000   commit_st = 1;
       commit_st_rob_id = 5'b00011;
#100   commit_st = 0;
#100   commit_st = 1;
       commit_st_rob_id = 5'b00100;
#100   commit_st = 0;
//#100	func_unit = 0;
//#100	func_unit = 3;
//#430 	ctrl_sigs = 0;
   #1000 $finish;
end

always begin
   #50 clk = ~clk;
end
exec_stage exec_stage1(
   .clk(clk),
	.reset(reset),
	.dest_reg(dest_reg),
	.rob_entry(rob_entry),
	.ctrl_sigs(ctrl_sigs),
	.latency_counter(latency_counter),
	.R2_DataSrcA(srcA),
	.is_mem(is_mem),
	.mem_type(mem_type),
	.R3_DataSrcB(srcB),
	.func_select(func_unit),
	.ins_type(ins_type),
	.float_op(float_op),
	.pred_op(pred_op),
	.complex_alu_op(complex_alu_op),
	.simple_alu_op(simple_alu_op),
	.pred_src1(pred_src1),
	.ins_nop(ins_nop),
	.muxa(muxa),
	.muxb(muxb),
   	.commit_st(commit_st),
	.commit_st_rob_id(commit_st_rob_id),
	.pred_src2(pred_src2)
);

endmodule
//
//#160	reset = 0;
//	dest_reg = 3'b001;
//	rob_entry = 4'b0001;
//	latency_counter = 5'b00110;
//	func_unit = 2;
//#100	func_unit = 1;
//	srcB = 5;
//   	complex_alu_op= 3'b000;
//	rob_entry = 4'b00010;
//	dest_reg = 3'b010;
//   	ins_type = 3'b001;
//#100	func_unit = 0;
//	latency_counter = 5'b00001;
//	rob_entry = 4'b00011;
//	dest_reg = 3'b011;
//#100	func_unit = 3;
//   	pred_op = 3'b001;
//	//srcB = 1;
//	latency_counter = 5'b00001;
//	rob_entry = 4'b00100;
//	dest_reg = 3'b100;
//   	ins_type = 3'b000;
//#100	ins_nop = 1;
//#100	ins_nop = 0;
//#100	func_unit = 0;
//#100	func_unit = 3;
//#430 	ctrl_sigs = 0;
//	ins_nop = 1;
//	//#105 ctrl_sigs = 4'h4;
//   //#230 ctrl_sigs = 4'h7;
//	//#105 ctrl_sigs = 4'h9;
//	//srcA = 32'b0_10000001_00000000000000000000000;
//	//srcB = 32'b0_10000011_00000000000000000000000;
//	   
//   #2000 $finish;
