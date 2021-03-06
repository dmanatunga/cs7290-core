`include "../globals.vh"
module exec_stage(
   //inputs
   clk,
   reset,
   dest_reg,
//   R1_DataDst,	//not needed
   ctrl_sigs,
   R2_DataSrcA,
   R3_DataSrcB,
   imm1,
   imm2,
   imm3,
   pred_src1,
   pred_src2,
   latency_counter,
   rob_entry,
   func_select,
   mem_type,
   is_mem,
   simple_alu_op,
   complex_alu_op,
   pred_op,
   float_op,
   ins_type,
   ins_nop,
   muxa,
   muxb,
   next_pc,
   //outputs
   alu_out,
   ctrl_sigs_pass,	//only pass inst_type
//   R1_DataDst_pass,
   alu_free_out,
   rob_entry_out,
   ins_nop_out,
   ins_exception,
   commit_st,
   commit_st_rob_id,
   dest_reg_pass
   );

parameter CTRL_WIDTH 	= 32; //control signal width
parameter DATA_WIDTH 	= `DATA_WIDTH; //control signal width
parameter DUMMY_ALU  	= 3'b101;
parameter NUM_ALU    	= 5;  // +1 for a dummt alu
parameter ROB_SIZE    	= `ROB_ID_SIZE;  // +1 for a dummt alu
parameter DEST_REG_SIZE = `DEST_ADDR_SIZE;
parameter ALU_OP = `FUNC_UNIT_OP_SIZE;

//******Inputs******
   input        clk;
   input [DEST_REG_SIZE - 1 : 0]  dest_reg;
//   input [31:0] R1_DataDst;
   input [5:0]  ctrl_sigs;
   input [31:0] R2_DataSrcA;
   input [31:0] R3_DataSrcB;
   input [31:0] imm1;
   input [31:0] imm2;
   input [31:0] imm3;
   input [`PRED_DATA_WIDTH-1:0] 	pred_src1;
   input [`PRED_DATA_WIDTH-1:0] 	pred_src2;
   input [3:0]  latency_counter;        //FIX
   input [ROB_SIZE - 1:0]  rob_entry;
   input        reset;  //FIX
   input [2:0]   func_select;
   //new inputs
   input mem_type;
   input is_mem;
   input [ALU_OP-1:0] simple_alu_op;
   input [ALU_OP-1:0] complex_alu_op;
   input [ALU_OP-1:0] pred_op;
   input [ALU_OP-1:0] float_op;
   input [`INS_TYPE_SIZE-1:0] ins_type;
   input       ins_nop;
   input [31:0] next_pc;
   input [1:0]muxa;
   input [1:0] muxb;
   input       		commit_st;
   input [ROB_SIZE-1:0] commit_st_rob_id;

//******Internal regs/wires******
   reg  [3:0]    		alu_counter     [NUM_ALU - 1 :0];
   reg  [ROB_SIZE - 1:0]    	alu_rob_entry   [NUM_ALU - 1 :0];
   reg  [31:0]   		alu_result      [NUM_ALU - 1 :0];
   reg  [DEST_REG_SIZE - 1 :0]  alu_dest_reg    [NUM_ALU - 1 :0];
   reg  [CTRL_WIDTH-1:0]   	alu_ctrl_sigs   [NUM_ALU - 1 :0];
   reg  [NUM_ALU - 1 :0]   	alu_done;

   wire [31:0]  alu_inA;
   wire [31:0]  alu_inB;
   wire [31:0] 	pred_srcB;
   wire [31:0] 	pred_srcA;
   wire [31:0]  result_alu0;
   wire [31:0]  result_alu1;
   wire [31:0]  result_alu2;
   wire [31:0]  result_alu3;
   wire [31:0]  result_mem;
   wire          mem_commit;
   wire         mem_done;
   wire         mem_stall;
   wire [31:0]  mem_addr;
   wire [31:0]  mem_result;
   wire [DEST_REG_SIZE - 1:0]  mem_dest_reg;	//FIX
   wire [31:0]  mem_data_in;
   wire [ROB_SIZE - 1:0] mem_rob_entry;
   wire [CTRL_WIDTH-1:0] mem_ctrl_sigs;
   wire [2:0]   arb_alu_select;
   wire [CTRL_WIDTH- 3 - 1:0] ctrl_pass;
   wire [2:0]   func_unit;
   reg  [NUM_ALU - 1: 0]alu_free;
   wire send_to_mem;

//******Outputs******
   output     [31:0]    		alu_out;
   output     [5:0]     		ctrl_sigs_pass;
   output     [DEST_REG_SIZE - 1 :0] 	dest_reg_pass;
   output     [NUM_ALU - 1: 0]		alu_free_out;
   output     [ROB_SIZE - 1:0]  	rob_entry_out; 
   output       			ins_nop_out;
   output [`EXCEPTION_ID_SIZE-1:0] ins_exception;

//******Input selection Mux start******
   assign ins_exception = `EXCEPTION_ID_SIZE'd0;	
   assign mem_data_in = (mem_type) ? alu_inA 	: 32'h0000_0000;
   assign mem_addr    = (is_mem)   ?(alu_inA + alu_inB): 32'h0000_0000;
   assign send_to_mem = (is_mem)   ? ((func_unit == 3'b100)? 1'b1 : 1'b0) : 1'b0;//FIX
   assign ctrl_pass   = {ctrl_sigs,ins_type};	//FIX
   assign func_unit   = (ins_nop == 1) ? DUMMY_ALU : func_select;

mux4to1 #(.DATA_WIDTH(32)) 
  alu_MuxA(
    .a		(32'd0),
    .b		(32'd0),
    .c		(next_pc), 
    .d		(R2_DataSrcA),
    .sel	(muxa),
    .out	(alu_inA)
);

mux4to1 #(.DATA_WIDTH(32))
  alu_MuxB(
	.a	(32'd0),
	.b	(imm3),
	.c	(imm2),
	.d	(R3_DataSrcB),
	.sel	(muxb),
	.out	(alu_inB)
);

mux2to1 #(.DATA_WIDTH(32)) 
  pred_MuxA(
    .a		(pred_src1), 
    .b		(R2_DataSrcA),
    .sel	(muxa[0]),
    .out	(pred_srcA)
);

assign pred_srcB = pred_src2;
 
//******Input selection Mux end******


//******Each alu register setting start******
   always@(posedge clk)
   begin
      if(reset == 1) begin
         alu_done     	     <= 1'b0;
         alu_counter  [0]    <= 4'b0000;
         alu_counter  [1]    <= 4'b0000;
         alu_counter  [2]    <= 4'b0000;
         alu_counter  [3]    <= 4'b0000;
         alu_counter  [4]    <= 4'b0000;
         alu_free     [0]    <= 1'b1;
         alu_free     [1]    <= 1'b1;
         alu_free     [2]    <= 1'b1;
         alu_free     [3]    <= 1'b1;
         alu_free     [4]    <= 1'b1;
      end else begin
	 //SIMPLE 1CYCLE INT UNIT
         if(func_unit == 0) begin
            alu_counter  [0]    <= latency_counter;
            alu_rob_entry[0]    <= rob_entry;
            alu_dest_reg [0]    <= dest_reg;
            alu_ctrl_sigs[0]    <= {ctrl_pass, simple_alu_op}; //FIX add more ctrl sigs
            alu_done     [0]   	<= 1'b1;
            alu_free     [0]   	<= (arb_alu_select == 0) ? 1'b1 : 1'b0;	//FIX this !
            alu_result   [0]    <= result_alu0;
         end else begin
            alu_counter  [0]    <= 4'b0000;
            alu_done     [0]   	<= (arb_alu_select == 0) ? 1'b0 : alu_done[0];	//FIX this !
            alu_free     [0]   	<= (arb_alu_select == 0) ? 1'b1 : alu_free[0];	//FIX this !
         end

	 //FP UNIT
         if(func_unit == 1) begin
            alu_counter  [1]    <= latency_counter;
            alu_rob_entry[1]    <= rob_entry;
            alu_dest_reg [1]    <= dest_reg;
            alu_ctrl_sigs[1]    <= {ctrl_pass, float_op}; //FIX add more ctrl sigs
            alu_done     [1]    <= 1'b0;
            alu_free     [1]    <= 1'b0;
         end else begin
            if(alu_counter[1] == 0) begin
               alu_counter  [1]    	<= 4'b0000;
            end else begin
               alu_counter  [1]    	<= alu_counter[1] - 4'b0001;
	    end
            if(alu_counter[1] == 1) begin
               alu_result[1]            <= result_alu1;
               alu_done  [1]            <= 1'b1;
            end else begin
               alu_done  [1]    	<= (arb_alu_select == 1) ? 1'b0 : alu_done[1];	//FIX this !
               alu_free  [1]    	<= (arb_alu_select == 1) ? 1'b1 : alu_free[1];	//FIX this !
	    end
         end

	 //COMPLEX INT UNIT
         if(func_unit == 2) begin
            alu_counter[2]      <= latency_counter;
            alu_rob_entry[2]    <= rob_entry;
            alu_dest_reg [2]    <= dest_reg;
            alu_ctrl_sigs[2]    <= {ctrl_pass, complex_alu_op};
            alu_done     [2]    <= 1'b0;
            alu_free     [2]    <= 1'b0;
         end else begin
            if(alu_counter[2] == 0) begin
               alu_counter  [2]    	<= 4'b0000;
            end else begin
               alu_counter  [2]    	<= alu_counter[2] - 4'b0001;
	    end
            if(alu_counter[2] == 1) begin
               alu_result[2]            <= result_alu2;
               alu_done  [2]            <= 1'b1;
            end else begin
               alu_done  [2]    	<= (arb_alu_select == 2) ? 1'b0 : alu_done[2];	//FIX this !
               alu_free  [2]    	<= (arb_alu_select == 2) ? 1'b1 : alu_free[2];	//FIX this !
	    end
         end

	 //PRED UNIT
         if(func_unit == 3) begin
            alu_counter[3]      <= latency_counter;
            alu_rob_entry[3]    <= rob_entry;
            alu_dest_reg [3]    <= dest_reg;
            alu_ctrl_sigs[3]    <= {ctrl_pass, pred_op};
            alu_done     [3]    <= 1'b1;
            alu_free     [3]   	<= (arb_alu_select == 3) ? 1'b1 : 1'b0;	//FIX this !
            alu_result   [3]    <= {31'b0,result_alu3[0]};
         end else begin
            alu_counter  [0]    <= 4'b0000;
            alu_done  	 [3]   	<= (arb_alu_select == 3) ? 1'b0 : alu_done[3];	//FIX this !
            alu_free     [3]   	<= (arb_alu_select == 3) ? 1'b1 : alu_free[3];	//FIX this !
         end

	 //MEMORY UNIT
         //if(func_unit == 4) begin
         //   alu_counter[4]   	<= latency_counter;
         //end else begin
            alu_counter[4]   	<= 4'b0000;
            alu_rob_entry[4]    <= mem_rob_entry;
            alu_dest_reg [4]    <= mem_dest_reg;
            alu_ctrl_sigs[4]    <= mem_ctrl_sigs;//FIX
            alu_result[4]      	<= mem_result;
            alu_done  [4]    	<= mem_done;	//FIX , check this!
            alu_free  [4]    	<= mem_stall;
         //end
      end
   end
//******Each alu register setting end******

//******Mini-Arbitrator start******
assign arb_alu_select   = (alu_done[3] == 1'b1)? 3'b011 : ( (alu_done[2] == 1'b1)? 3'b010 : ( (alu_done[1] == 1'b1)? 3'b001 : ( (alu_done[0] == 1'b1)? 3'b000 : ((mem_done == 1'b1) ? 3'b100 : DUMMY_ALU))));	//FIX when are we setting free signal
assign alu_out          = (arb_alu_select == DUMMY_ALU)? 0 : ((arb_alu_select == 3'b100)? mem_result    : alu_result     [arb_alu_select]);
assign dest_reg_pass    = (arb_alu_select == DUMMY_ALU)? 0 : ((arb_alu_select == 3'b100)? mem_dest_reg  : alu_dest_reg   [arb_alu_select]);
assign rob_entry_out    = (arb_alu_select == DUMMY_ALU)? 0 : ((arb_alu_select == 3'b100)? mem_rob_entry : alu_rob_entry  [arb_alu_select]);
assign ctrl_sigs_pass   = (arb_alu_select == DUMMY_ALU)? 0 : ((arb_alu_select == 3'b100)? mem_ctrl_sigs[`INS_TYPE_SIZE-1 + ALU_OP:ALU_OP] : alu_ctrl_sigs  [arb_alu_select][`INS_TYPE_SIZE-1 + ALU_OP:ALU_OP]);
//assign ctrl_sigs_pass = alu_controls[`INS_TYPE_SIZE-1 + 3:3];
assign ins_nop_out   	= (arb_alu_select == DUMMY_ALU)? 1'b1 : 1'b0;

assign alu_free_out[4] = !mem_stall;//alu_free  [4];
assign alu_free_out[3] = 1'b1;
assign alu_free_out[2] = (func_unit == 2) ? 1'b0: ((arb_alu_select == 2) ? 1'b1 : alu_free[2]);
assign alu_free_out[1] = (func_unit == 1) ? 1'b0: ((arb_alu_select == 1) ? 1'b1 : alu_free[1]);
assign alu_free_out[0] = (func_unit == 0) ? ((alu_counter[2] == 1) ? 1'b0 : ((alu_done[2] == 1) ? 1'b0 : ((alu_counter[1] == 1) ? 1'b0 : ((alu_done[1] == 1) ? 1'b0 :1'b1)))) : ((arb_alu_select == 0) ? 1'b1 : alu_free[0]);	//FIX this is still one cycle late in case arbitrator selects it laters
assign mem_commit      = (arb_alu_select == 4) ? 1'b1 : 1'b0;	//FIX this !
//******Mini-Arbitrator end******


//******ALU Blocks Instantiation start******
alu_simple alu_0(
        .srcA(alu_inA),
        .srcB(alu_inB),
        .alu_op(simple_alu_op),
        .result(result_alu0));

alu_fp_simple alu_1(
        .clock(clk),
        .srcA(alu_inA),
        .srcB(alu_inB),
        .float_op(float_op),
        .select(alu_ctrl_sigs[1][ALU_OP-1:0]),
        .result(result_alu1));

alu_complex alu_2(
        .clock(clk),
        .srcA(alu_inA),
        .srcB(alu_inB),
        .complex_alu_op(complex_alu_op),
        .select(alu_ctrl_sigs[2][ALU_OP-1:0]),
        .result(result_alu2));

alu_pred alu_3(
        .srcA(pred_srcA),
        .srcB(pred_srcB),
        .pred_op(pred_op),
        .result(result_alu3[0]));
//******ALU Blocks Instantiation end******

//******MEM Instantiation start******
ld_st_queue alu_4(
      .clk(clk),
      .reset(reset),
      .add_entry(send_to_mem),
      .addr_in(mem_addr),
      .data_in(mem_data_in),
      .dest_reg_in(dest_reg),
      .rw_in(mem_type),	//FIX check
      .ctrl_in({ins_type,3'b000}),	//FIX check
      .rob_entry_in(rob_entry),
      .commit_head(mem_commit),
      .commit_st(commit_st),
      .commit_st_rob_id(commit_st_rob_id),
    
      .head_finished(mem_done),
      .head_dest_reg(mem_dest_reg),
      .head_data_out(mem_result),
      .head_rob_entry_out(mem_rob_entry),
      .head_ctrl_out(mem_ctrl_sigs[4:0]),
      .mem_stall_out(mem_stall));
//******MEM Instantiation end******
endmodule
