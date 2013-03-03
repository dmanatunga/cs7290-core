module core(
    clk
);
// Inputs
input clk;

// Instruction Fetch Wires
wire    [31:0]    if_next_pc;
wire    [31:0]    if_ins;

// Instruction Decode Wires
wire    [31:0]    id_next_pc;
wire    [31:0]    id_ins;
wire    [2:0]     id_dest_reg;
wire    [31:0]    id_r1_data;
wire    [31:0]    id_r2_data;
wire    [31:0]    id_r3_data;
wire    [31:0]    id_imm22;
wire    [31:0]    id_imm16;
wire              id_pred_val;

wire              id_muxA_sel;
wire    [1:0]     id_muxB_sel;
wire    [1:0]     id_alu_op;
wire              id_br_ins;
wire              id_br_type;
wire              id_mem_ins;
wire              id_mem_type;
wire              id_sel_data;
wire              id_wr_reg;

// Execute wires
wire    [31:0]    ex_next_pc;
wire    [2:0]     ex_dest_reg;
wire    [31:0]    ex_r1_data;
wire    [31:0]    ex_r2_data;
wire    [31:0]    ex_r3_data;
wire    [31:0]    ex_imm22;
wire    [31:0]    ex_imm16;
wire              ex_pred_val;
wire    [31:0]    ex_alu_out;

wire              ex_muxA_sel;
wire    [1:0]     ex_muxB_sel;
wire    [1:0]     ex_alu_op;
wire              ex_br_ins;
wire              ex_br_type;
wire              ex_mem_ins;
wire              ex_mem_type;
wire              ex_sel_data;
wire              ex_wr_reg;

// Memory wires
wire    [31:0]    mem_alu_out;
wire    [31:0]    mem_r1_data;
wire    [2:0]     mem_dest_reg;
wire              mem_pred_val;
wire              mem_br_ins;
wire              mem_br_type;
wire              mem_mem_ins;
wire              mem_mem_type;
wire              mem_sel_data;
wire              mem_wr_reg;

wire    [31:0]    mem_mem_data;
wire    [31:0]    mem_br_targ;

// Writeback wires
wire    [31:0]    wb_alu_out;
wire    [31:0]    wb_mem_data;
wire    [2:0]     wb_dest_reg;
wire              wb_pred_val;
wire              wb_mem_ins;
wire              wb_wr_reg;
wire              wb_wr_en;
wire    [2:0]     wb_wr_addr;
wire    [31:0]    wb_wr_data;

     
// Instruction Fetch Stage
IF if_stage(.clk(clk), 
            .sel_br(mem_br_ins), 
            .br_targ(mem_br_targ), 
            .next_pc(if_next_pc), 
            .ins(if_ins)
);

// Latch between Instruction Fetch and Instruction Decode
IF_ID_latch if_id_latch(.clk(clk), 
                        .in_next_pc(if_next_pc), 
                        .in_ins(if_ins), 
                        .out_next_pc(id_next_pc), 
                        .out_ins(id_ins)
);

// Instruction Decode Stage
ID id(.clk(clk),
      .ins(id_ins),
      .wr_en(wb_wr_en),
      .wr_data(wb_wr_data),
      .wr_addr(wb_wr_addr),
      .dest_reg(id_dest_reg),
      .r1_data(id_r1_data),
      .r2_data(id_r2_data),
      .r3_data(id_r3_data),
      .imm16(id_imm16),
      .imm22(id_imm22),
      .pred_val(id_pred_val),
      .muxA_sel(id_muxA_sel),
      .muxB_sel(id_muxB_sel),
      .alu_op(id_alu_op),
      .br_ins(id_br_ins),
      .br_type(id_br_type),
      .mem_ins(id_mem_ins),
      .mem_type(id_mem_type),
      .wr_reg(id_wr_reg) 
);

// Latch between Instruction Decode and Execute
ID_EX_latch id_ex_latch(.clk(clk),
                        .in_next_pc(id_next_pc),
                        .in_dest_reg(id_dest_reg),
                        .in_r1_data(id_r1_data),
                        .in_r2_data(id_r2_data),
                        .in_r3_data(id_r3_data),
                        .in_imm22(id_imm22),
                        .in_imm16(id_imm16),
                        .in_pred_val(id_pred_val),
                        .in_muxA_sel(id_muxA_sel),
                        .in_muxB_sel(id_muxB_sel),
                        .in_alu_op(id_alu_op),
                        .in_br_ins(id_br_ins),
                        .in_br_type(id_br_type),
                        .in_mem_ins(id_mem_ins),
                        .in_mem_type(id_mem_type),
                        .in_wr_reg(id_wr_reg),
    
                        .out_next_pc(ex_next_pc),
                        .out_dest_reg(ex_dest_reg),
                        .out_r1_data(ex_r1_data),
                        .out_r2_data(ex_r2_data),
                        .out_r3_data(ex_r3_data),
                        .out_imm22(ex_imm22),
                        .out_imm16(ex_imm16),
                        .out_pred_val(ex_pred_val),
                        .out_muxA_sel(ex_muxA_sel),
                        .out_muxB_sel(ex_muxB_sel),
                        .out_alu_op(ex_alu_op),
                        .out_br_ins(ex_br_ins),
                        .out_br_type(ex_br_type),
                        .out_mem_ins(ex_mem_ins),
                        .out_mem_type(ex_mem_type),
                        .out_wr_reg(ex_wr_reg)
);

// Execute stage
EX  ex(.clk(clk), 
       .next_pc(ex_next_pc), 
       .r2_data(ex_r2_data), 
       .r3_data(ex_r3_data),
       .imm16(ex_imm16),
       .imm22(ex_imm22),
       .muxA_sel(ex_muxA_sel),
       .muxB_sel(ex_muxB_sel),
       .alu_op(ex_alu_op),
       .alu_out(ex_alu_out)
);

// Latch between Execute and Memory
EX_MEM_latch ex_mem_latch(.clk(clk),
                          .in_alu_out(ex_alu_out),
                          .in_r1_data(ex_r1_data),
                          .in_dest_reg(ex_dest_reg),
                          .in_pred_val(ex_pred_val),
                          .in_br_ins(ex_br_ins),
                          .in_br_type(ex_br_type),
                          .in_mem_ins(ex_mem_ins),
                          .in_mem_type(ex_mem_type),
                          .in_wr_reg(ex_wr_reg),
                          .out_alu_out(mem_alu_out),
                          .out_r1_data(mem_r1_data),
                          .out_dest_reg(mem_dest_reg),
                          .out_pred_val(mem_pred_val),
                          .out_br_ins(mem_br_ins),
                          .out_br_type(mem_br_type),
                          .out_mem_ins(mem_mem_ins),
                          .out_mem_type(mem_mem_type),
                          .out_wr_reg(mem_wr_reg)
);

// Memory stage
MEM mem(.clk(clk),
    .alu_out(mem_alu_out),
    .r1_data(mem_r1_data),
    .pred_val(mem_pred_val),
    .br_type(mem_br_type),
    .mem_ins(mem_mem_ins),
    .mem_type(mem_mem_type),
    .br_targ(mem_br_targ),
    .mem_data(mem_mem_data)
);

// Latch between Memory and Writeback
MEM_WB_latch mem_wb_latch(.clk(clk),
                          .in_alu_out(mem_alu_out),
                          .in_mem_data(mem_mem_data),
                          .in_dest_reg(mem_dest_reg),
                          .in_pred_val(mem_pred_val),
                          .in_mem_ins(mem_mem_ins),
                          .in_wr_reg(mem_wr_reg),
                          .out_alu_out(wb_alu_out),
                          .out_mem_data(wb_mem_data),
                          .out_dest_reg(wb_dest_reg),
                          .out_pred_val(wb_pred_val),
                          .out_mem_ins(wb_mem_ins),
                          .out_wr_reg(wb_wr_reg)
);

// Writeback stage
WB  wb(.clk(clk),
       .alu_out(wb_alu_out),
       .mem_data(wb_mem_data),
       .dest_reg(wb_dest_reg),
       .pred_val(wb_pred_val),
       .mem_ins(wb_mem_ins),
       .wr_reg(wb_wr_reg),
       .wr_en(wb_wr_en),
       .wr_addr(wb_wr_addr),
       .wr_data(wb_wr_data)
);
endmodule

