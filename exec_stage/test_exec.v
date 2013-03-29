`timescale 1ns / 1ps

module test_exec();

   reg   clk;
   reg   [31:0]srcA;
   reg   [31:0]srcB;
   reg   [5:0]ctrl_sigs;
   reg   [3:0]rob_entry;
   reg   [2:0]dest_reg;
   reg   [2:0]func_unit;
   reg   [4:0]latency_counter;
   reg   [2:0]simple_alu_op;
   reg   [2:0]complex_alu_op;
   reg   [2:0]pred_op;
   reg   [2:0]float_op;
   reg   [2:0]ins_type;
   reg 	 pred_src1;
   reg 	 pred_src2;
   reg   reset;
	
initial begin
   clk = 0;
   reset = 1;
   simple_alu_op = 3'b011;
   complex_alu_op= 3'b001;
   pred_op = 3'b001;
   float_op = 3'b001;
   ctrl_sigs = 6'b00_0001;
   ins_type = 3'b011;
   pred_src1 = 1;
   pred_src2 = 7;
#160	reset = 0;
	srcA = 7;
	srcB = 10;
	dest_reg = 3'b001;
	rob_entry = 4'b0001;
	latency_counter = 5'b01110;
	func_unit = 2;
#100	func_unit = 1;
	rob_entry = 4'b00010;
	dest_reg = 3'b010;
   	ins_type = 3'b001;
#100	func_unit = 0;
	latency_counter = 5'b00001;
	rob_entry = 4'b00011;
	dest_reg = 3'b011;
#100	func_unit = 3;
   	pred_op = 3'b001;
	//srcB = 1;
	latency_counter = 5'b00001;
	rob_entry = 4'b00100;
	dest_reg = 3'b100;
   	ins_type = 3'b000;
#100	func_unit = 5;
#630 	ctrl_sigs = 0;
	//#105 ctrl_sigs = 4'h4;
   //#230 ctrl_sigs = 4'h7;
	//#105 ctrl_sigs = 4'h9;
	//srcA = 32'b0_10000001_00000000000000000000000;
	//srcB = 32'b0_10000011_00000000000000000000000;
	   
   #2000 $finish;
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
	.R3_DataSrcB(srcB),
	.func_unit(func_unit),
	.ins_type(ins_type),
	.float_op(float_op),
	.pred_op(pred_op),
	.complex_alu_op(complex_alu_op),
	.simple_alu_op(simple_alu_op),
	.pred_src1(pred_src1),
	.pred_src2(pred_src2)
);

endmodule
/*alu_simple alu_simple_test(
	clk,
	srcA,
	srcB,
	ctrl_sigs,
	result
   );
	
initial begin
   clk = 0;
   reset = 1;
   //pc_fd = 100;
   //ireg = 32'b0000_001010_110_011_010_0000000000000;
   #40 srcA = 7;
   srcB = 10;
   ctrl_sigs = 4'h1;
	#105 ctrl_sigs = 4'h4;
   #230 ctrl_sigs = 4'h7;
	#105 ctrl_sigs = 4'h9;
	//srcA = 32'b0_10000001_00000000000000000000000;
	//srcB = 32'b0_10000011_00000000000000000000000;
	   
   #2000 $finish;
end
*/
