`timescale 1ns / 1ps

module test_exec();

   reg   clk;
   reg   [31:0]srcA;
   reg   [31:0]srcB;
   reg   [3:0]ctrl_sigs;
   reg reset;
	wire [31:0]result;
	
   //reg [31:0]pc_fd;
   //reg [31:0]ireg;
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

always begin
   #50 clk = ~clk;
end

alu_simple alu_simple_test(
	clk,
	srcA,
	srcB,
	ctrl_sigs,
	result
   );

endmodule
