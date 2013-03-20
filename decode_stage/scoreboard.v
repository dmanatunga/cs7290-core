module scoreboard(
    clk,
    reset,
    pred_reg_addr,
    pred_reg_valid,
    dest_reg_addr,
    dest_reg_valid,
    reg_src1_addr,
    reg_src1_valid,
    reg_src2_addr,
    reg_src2_valid,
    dest_pred_addr,
    dest_pred_valid,
    pred_src1_addr,
    pred_src1_valid,
    pred_src2_addr,
    pred_src2_valid,
    func_unit,
    wr_reg,
    wr_reg_addr,
    wr_pred,
    wr_pred_addr,
    free_complex_alu,
    free_fpu,
    free_mem_unit, 
    stall
);

parameter REG_BITS = 4;
parameter PRED_REG_BITS = 2;
parameter FUNC_UNIT_BITS = 3;
parameter COMPLEX_ALU_ID = 3'b001;
parameter FPU_ID = 3'b011;
parameter MEM_UNIT_ID = 3'b100;

localparam REG_SIZE = 1 << REG_BITS;
localparam PRED_REG_SIZE = 1 << PRED_REG_BITS;
localparam NUM_FUNC_UNITS = 1 << FUNC_UNIT_BITS;

// Inputs
input                         clk;
input                         reset;
input   [PRED_REG_BITS-1:0]   pred_reg_addr;
input                         pred_reg_valid;
input   [REG_BITS-1:0]        dest_reg_addr;
input                         dest_reg_valid;
input   [REG_BITS-1:0]        reg_src1_addr;
input                         reg_src1_valid;
input   [REG_BITS-1:0]        reg_src2_addr;
input                         reg_src2_valid;
input   [PRED_REG_BITS-1:0]   dest_pred_addr;
input                         dest_pred_valid;
input   [PRED_REG_BITS-1:0]   pred_src1_addr;
input                         pred_src1_valid;
input   [PRED_REG_BITS-1:0]   pred_src2_addr;
input                         pred_src2_valid;
input   [FUNC_UNIT_BITS-1:0]  func_unit;
input                         wr_reg;
input   [REG_BITS-1:0]        wr_reg_addr;
input                         wr_pred;
input   [PRED_REG_BITS-1:0]   wr_pred_addr;
input                         free_complex_alu;
input                         free_fpu;
input                         free_mem_unit;

// Outputs
output  stall;

// Identify if the needed resource is busy
wire pred_reg_busy;
wire dest_reg_busy;
wire reg_src1_busy;
wire reg_src2_busy;
wire dest_pred_busy;
wire pred_src1_busy;
wire pred_src2_busy;
wire func_busy;

// Busy bits for register files
reg reg_file_busy[REG_SIZE-1:0];
reg pred_file_busy[PRED_REG_SIZE-1:0];
reg func_unit_busy[NUM_FUNC_UNITS-1:0];

integer i1, i2, i3;

// Identify if unit is busy if it is needed
assign pred_reg_busy = pred_reg_valid & pred_file_busy[pred_reg_addr];
assign dest_reg_busy = dest_reg_valid & reg_file_busy[dest_reg_addr];
assign reg_src1_busy = reg_src1_valid & reg_file_busy[reg_src1_addr];
assign reg_src2_busy = reg_src2_valid & reg_file_busy[reg_src2_addr];
assign dest_pred_busy = dest_pred_valid & pred_file_busy[dest_pred_addr];
assign pred_src1_busy = pred_src1_valid & pred_file_busy[pred_src1_addr];
assign pred_src2_busy = pred_src2_valid & pred_file_busy[pred_src2_addr];
assign func_busy = func_unit_busy[func_unit];

// Identify if we should stall due to a needed unit being busy
assign stall = pred_reg_busy |
               dest_reg_busy |
               reg_src1_busy |
               reg_src2_busy |
               dest_pred_busy |
               pred_src1_busy |
               pred_src2_busy |
               func_busy;


// Set the write register back to not busy and indicate certain functional units as free
always @(negedge clk) begin
  if (wr_reg) begin
    reg_file_busy[wr_reg_addr] <= 1'b0;
  end
  if (wr_pred) begin
    pred_file_busy[wr_pred_addr] <= 1'b0;
  end
  if (free_complex_alu) begin
    func_unit_busy[COMPLEX_ALU_ID] <= 1'b0;
  end
  if (free_fpu) begin
    func_unit_busy[FPU_ID] <= 1'b0;
  end
  if (free_mem_unit) begin
    func_unit_busy[MEM_UNIT_ID] <= 1'b0; 
  end
end

// If instruction issued, then set destination register to invalid
always @(posedge clk) begin
  if (reset) begin
    for (i1 = 0; i1 < REG_SIZE; i1 = i1 + 1) begin
      reg_file_busy[i1] <= 1'b0;
    end
    for (i2 = 0; i2 < PRED_REG_SIZE; i2 = i2 + 1) begin
      pred_file_busy[i2] <= 1'b0;
    end
    for (i3 = 0; i3 < NUM_FUNC_UNITS; i3 = i3 + 1) begin
      func_unit_busy[i2] <= 1'b0;
    end
  end else begin
    if (!stall && dest_reg_valid) begin
      reg_file_busy[dest_reg_addr] <= 1'b1;
    end
    if (!stall && dest_pred_valid) begin
      pred_file_busy[dest_pred_addr] <= 1'b1;
    end
    if (!stall) begin
      case (func_unit) 
        COMPLEX_ALU_ID: func_unit_busy[func_unit] <= 1'b1;
        FPU_ID: func_unit_busy[func_unit] <= 1'b1;
        MEM_UNIT_ID:  func_unit_busy[func_unit] <= 1'b1;
        default: func_unit_busy[func_unit] <= 1'b0;
      endcase      
    end  
  end
end    

endmodule