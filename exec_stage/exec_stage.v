`define ctrl_width  32 //control signal width
`define dummy_alu   4
`define num_alu     4  // +1 for a dummt alu
module exec_stage(
   clk,
   dest_reg,
   R1_DataDst,
   ctrl_sigs,
   pc,
   R2_DataSrcA,
   R3_DataSrcB,
   imm16,
   imm22,
   pred_src1,
   pred_src2,
   latency_counter,
   rob_entry,
   reset,
   alu_out,
   pred_out,
   ctrl_sigs_pass,
   R1_DataDst_pass,
   alu_free,
   rob_entry_out,
   dest_reg_pass
   );

//******Inputs******
   input        clk;
   input [2:0]  dest_reg;
   input [31:0] R1_DataDst;
   input [5:0]  ctrl_sigs;
   input [31:0] pc;
   input [31:0] R2_DataSrcA;
   input [31:0] R3_DataSrcB;
   input [31:0] imm16;
   input [31:0] imm22;
   input        pred_src1;
   input        pred_src2;
   input [3:0]  latency_counter;        //FIX
   input [3:0]  rob_entry;      //FIX
   input        reset;  //FIX

//******Internal regs/wires******
   reg [3:0]    alu_counter     [`num_alu - 1 :0];
   reg [3:0]    alu_rob_entry   [`num_alu - 1 :0];
   reg [31:0]   alu_result      [`num_alu - 1 :0];
   reg [31:0]   alu_dest_reg    [`num_alu - 1 :0];
   reg [31:0]   alu_ctrl_sigs   [`num_alu - 1 :0];
   reg [`num_alu - 1 :0]alu_done;

   reg [31:0]   alu_inA;
   reg [31:0]   alu_inB;
   wire [31:0]  result_alu0;
   wire [31:0]  result_alu1;
   wire [31:0]  result_alu2;
   wire [31:0]  result_alu3;
   wire [31:0]  result_mem;
   reg          operation;
   wire [2:0]   func_unit;
   wire [2:0]   arb_alu_select;

//******Outputs******
   output     [31:0]    alu_out;
   output               pred_out;
   output     [5:0]     ctrl_sigs_pass;
   output reg [31:0]    R1_DataDst_pass;
   output     [2:0]     dest_reg_pass;
   output reg [`num_alu:0]alu_free;
   output [3:0] rob_entry_out;  //FIX

//******Input selection Mux start******
//   assign func_unit = ctrl_sigs[..];          //FIX this
     assign func_unit = {ctrl_sigs[1:0],1'b0};
   always@(*)                                           //specify a list of inputs!!
   begin
      case(ctrl_sigs)
         6'h24,6'h23,6'h14,6'h15: begin                 //FIX replace this with `define
                   alu_inA      = R2_DataSrcA;
                   alu_inB      = imm22;
                end
         6'h1d : begin
                   alu_inA      = pc;
                   alu_inB      = imm16;
                end
         6'h1e : begin
                   alu_inA      = R1_DataDst;
                   alu_inB      = 0;
                end
         6'h0b:begin
                   alu_inA      = R2_DataSrcA;
                   alu_inB      = R3_DataSrcB;
                end
         default: begin
                   alu_inA      = R2_DataSrcA;
                   alu_inB      = R3_DataSrcB;
                end
      endcase
   end
//******Input selection Mux end******


//******Each alu register setting start******
   always@(posedge clk) //add reset logic
   begin
      if(reset == 1) begin
         alu_done     	<= 0;
         alu_counter  [0]    <= 0;
         alu_counter  [1]    <= 0;
         alu_counter  [2]    <= 0;
         alu_counter  [3]    <= 0;
         alu_free[0]         <= 1;
         alu_free[1]         <= 1;
         alu_free[2]         <= 1;
         alu_free[3]         <= 1;
         alu_free[4]         <= 1;
      end else begin
         if(func_unit == 0) begin
            alu_counter  [0]    <= latency_counter;
            alu_rob_entry[0]    <= rob_entry;
            alu_dest_reg [0]    <= dest_reg;
            alu_ctrl_sigs[0]    <= ctrl_sigs;
            alu_done     [0]    <= 0;
            alu_free     [0]    <= 0;
         end else begin
            if(alu_counter[0] == 0) begin
               alu_counter  [0]    	<= 0;
            end else begin
               alu_counter  [0]  	<= alu_counter[0] - 4'b1;
	    end
            if(alu_counter[0] == 1) begin
               alu_result[0]            <= result_alu0;
               alu_done  [0]            <= 1;
            end else begin
               alu_done  [0]    	<= (arb_alu_select == 0) ? 0 : alu_done[0];	//FIX , this is a bad solution i think!
               alu_free  [0]    	<= (arb_alu_select == 0) ? 1 : alu_free[0];	//FIX , this is a bad solution i think!
	    end
         end

         if(func_unit == 1) begin
            alu_counter[1]      <= latency_counter;
            alu_rob_entry[1]    <= rob_entry;
            alu_dest_reg [1]    <= dest_reg;
            alu_ctrl_sigs[1]    <= ctrl_sigs;
            alu_done     [1]    <= 0;
            alu_free     [1]    <= 0;
         end else begin
            if(alu_counter[1] == 0) begin
               alu_counter  [1]    	<= 0;
            end else begin
               alu_counter  [1]    	<= alu_counter[1] - 4'b1;
	    end
            if(alu_counter[1] == 1) begin
               alu_result[1]            <= result_alu1;
               alu_done  [1]            <= 1;
            end else begin
               alu_done  [1]    	<= (arb_alu_select == 1) ? 0 : alu_done[1];	//FIX , this is a bad solution i think!
               alu_free  [1]    	<= (arb_alu_select == 1) ? 1 : alu_free[1];	//FIX , this is a bad solution i think!
	    end
         end

         if(func_unit == 2) begin
            alu_counter[2]      <= latency_counter;
            alu_rob_entry[2]    <= rob_entry;
            alu_dest_reg [2]    <= dest_reg;
            alu_ctrl_sigs[2]    <= ctrl_sigs;
            alu_done     [2]    <= 0;
            alu_free     [2]    <= 0;
         end else begin
            if(alu_counter[2] == 0) begin
               alu_counter  [2]    	<= 0;
            end else begin
               alu_counter  [2]    	<= alu_counter[2] - 4'b1;
	    end
            if(alu_counter[2] == 1) begin
               alu_result[2]            <= result_alu2;
               alu_done  [2]            <= 1;
            end else begin
               alu_done  [2]    	<= (arb_alu_select == 2) ? 0 : alu_done[2];	//FIX , this is a bad solution i think!
               alu_free  [2]    	<= (arb_alu_select == 2) ? 1 : alu_free[2];	//FIX , this is a bad solution i think!
	    end
         end

         if(func_unit == 3) begin
            alu_counter[3]      <= latency_counter;
            alu_rob_entry[3]    <= rob_entry;
            alu_dest_reg [3]    <= dest_reg;
            alu_ctrl_sigs[3]    <= ctrl_sigs;
            alu_done     [3]    <= 0;
         end else begin
            if(alu_counter[3] == 0) begin
               alu_counter  [3]    	<= 0;
            end else begin
               alu_counter  [3]    	<= alu_counter[3] - 4'b1;
	    end
            if(alu_counter[3] == 1) begin
                 alu_result[3]         	<= result_alu3;
                 alu_done  [3]          <= 1;
            end else begin
               alu_done  [3]    	<= (arb_alu_select == 3) ? 0 : alu_done[3];	//FIX , this is a bad solution i think!
               alu_free  [3]    	<= (arb_alu_select == 3) ? 1 : alu_free[3];	//FIX , this is a bad solution i think!
	    end
         end
      end
   end
//******Each alu register setting end******


//******Mini-Arbitrator start******
assign arb_alu_select   = (alu_done[0] == 1'b1)? 3'b000 : ( (alu_done[1] == 1'b1)? 3'b001 : ( (alu_done[2] == 1'b1)? 3'b010 : ( (alu_done[3] == 1'b1)? 3'b011 : `dummy_alu)));	//FIX who is resetting the alu_done signal?
assign alu_out          = (arb_alu_select == `dummy_alu)? 32'b0 : alu_result     [arb_alu_select];
assign dest_reg_pass    = (arb_alu_select == `dummy_alu)? 32'b0 : alu_dest_reg   [arb_alu_select];
assign rob_entry_out    = (arb_alu_select == `dummy_alu)? 32'b0 : alu_rob_entry  [arb_alu_select];
assign ctrl_sigs_pass   = (arb_alu_select == `dummy_alu)? 32'b0 : alu_ctrl_sigs  [arb_alu_select];
//assign R1_DataDst_pass        = (arb_alu_select == `dummy_alu)? 32'b0 : alu_R1_DataDst_pass[arb_alu_select];   //FIX this!, do we need this?

//always@(arb_alu_select or reset)
//begin
//      if(reset == 1) begin
//      end else begin
//         alu_free[arb_alu_select]    = 1;		//FIX not good code
//         //alu_free[3]         = (arb_alu_select == 3)? 1 : 0;
//         //alu_free[arb_alu_select] = (arb_alu_select == 4)? (~mem_stall) : 1;
//      end
//end
//******Mini-Arbitrator end******


//******ALU Blocks Instantiation start******
alu_simple alu_0(
        .clock(clk),
        .srcA(alu_inA),
        .srcB(alu_inB),
        .ctrl_sigs(alu_ctrl_sigs[0]),
        .result(result_alu0));

alu_fp_simple alu_1(
        .clock(clk),
        .srcA(alu_inA),
        .srcB(alu_inB),
        .ctrl_sigs(alu_ctrl_sigs[1]),
        .result(result_alu1));

alu_complex alu_2(
        .clock(clk),
        .srcA(alu_inA),
        .srcB(alu_inB),
        .ctrl_sigs(ctrl_sigs[3:0]),
        .result(result_alu2));

alu_pred alu_3(
        .srcA(pred_src1),
        .srcB(pred_src2),
        .ctrl_sigs(ctrl_sigs[3:0]),
        .result(result_alu3));
//******ALU Blocks Instantiation end******

//******MEM Instantiation start******
//alu_mem_wrapper alu_4(
//      .addr_in(addr_in),
//      .data_in(data_in),
//      .rw_in(rw_in),
//      .valid_in(valid_in),
//      .rob_entry(rob_entry),
//      .rob_entry_out(alu_rob_entry[4]),
//      .ready_out(alu_done[4]),
//      .stall_out(mem_stall),
//      .data_out(alu_result[4]));
//module memory_system(addr_in, data_in, rw_in, id_in, valid_in, data_out, id_out, ready_out, stall_out);
//input [31:0] addr_in, data_in;
//input rw_in, valid_in; // r/w, valid input on the addr, data buses
//input [3:0] id_in; // ld/st Q id for request
//output [31:0] data_out;
//output [3:0] id_out; // ld/st Q id for request being satisfied
//output ready_out; // the oldest memory request data is ready
//output stall_out; // the memory system cannot accept anymore requests

//******MEM Instantiation end******


//register all alu signal in a reg. when counter becomes zero set output as valid. When arbiter selects that inst set free register.
//alu_arbt alu_arbt1(
//);
endmodule
