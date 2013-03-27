module scoreboard(
    // Inputs
    clk,
    reset,
    pred_addr,
    pred_ins,
    reg_dest_addr,
    reg_dest_valid,
    reg_src1_addr,
    reg_src1_valid,
    reg_src2_addr,
    reg_src2_valid,
    pred_dest_addr,
    pred_dest_valid,
    pred_src1_addr,
    pred_src1_valid,
    pred_src2_addr,
    pred_src2_valid,
    func_unit,
    wr_reg,
    wr_reg_addr,
    wr_pred,
    wr_pred_addr,
    free_unit,
    free_unit_id,
    mem_ins,
    mem_busy,
    
    // Outputs
    resource_stall
);

parameter REG_ADDR_SIZE = 4;
parameter PRED_ADDR_SIZE = 2;
parameter FUNC_UNIT_OP_SIZE = 3;
parameter COMPLEX_ALU_ID = 3'b001;
parameter FPU_ID = 3'b011;
parameter MEM_UNIT_ID = 3'b100;

localparam REG_FILE_SIZE = 1 << REG_ADDR_SIZE;
localparam PRED_FILE_SIZE = 1 << PRED_ADDR_SIZE;
localparam NUM_FUNC_UNITS = 1 << FUNC_UNIT_OP_SIZE;

// Inputs
input                               clk;
input                               reset;
input   [PRED_ADDR_SIZE-1:0]        pred_addr;
input                               pred_valid;
input   [REG_ADDR_SIZE-1:0]         reg_dest_addr;
input                               reg_dest_valid;
input   [REG_ADDR_SIZE-1:0]         reg_src1_addr;
input                               reg_src1_valid;
input   [REG_ADDR_SIZE-1:0]         reg_src2_addr;
input                               reg_src2_valid;
input   [PRED_ADDR_SIZE-1:0]        pred_dest_addr;
input                               pred_dest_valid;
input   [PRED_ADDR_SIZE-1:0]        pred_src1_addr;
input                               pred_src1_valid;
input   [PRED_ADDR_SIZE-1:0]        pred_src2_addr;
input                               pred_src2_valid;
input   [FUNC_UNIT_OP_SIZE-1:0]     func_unit;
input                               wr_reg;
input   [REG_ADDR_SIZE-1:0]         wr_reg_addr;
input                               wr_pred;
input   [PRED_ADDR_SIZE-1:0]        wr_pred_addr;
input                               free_unit;
input   [FUNC_UNIT_OP_SIZE-1:0]     free_unit_id;
input                               issue;
input                               mem_ins;
input                               mem_busy;

// Outputs
output  resource_stall;

// Identify if the needed resource is busy
wire pred_busy;
wire reg_dest_busy;
wire reg_src1_busy;
wire reg_src2_busy;
wire pred_dest_busy;
wire pred_src1_busy;
wire pred_src2_busy;
wire unit_busy;
wire func_busy;

// Busy bits for register files
reg reg_file_busy[REG_FILE_SIZE-1:0];
reg pred_file_busy[PRED_FILE_SIZE-1:0];
reg func_unit_busy[NUM_FUNC_UNITS-1:0];

integer i1, i2, i3;

// Identify if unit is busy if it is needed
assign pred_busy = pred_ins & pred_file_busy[pred_addr];
assign reg_dest_busy = reg_dest_valid & reg_file_busy[reg_dest_addr];
assign reg_src1_busy = reg_src1_valid & reg_file_busy[reg_src1_addr];
assign reg_src2_busy = reg_src2_valid & reg_file_busy[reg_src2_addr];
assign pred_dest_busy = pred_dest_valid & pred_file_busy[pred_dest_addr];
assign pred_src1_busy = pred_src1_valid & pred_file_busy[pred_src1_addr];
assign pred_src2_busy = pred_src2_valid & pred_file_busy[pred_src2_addr];
assign unit_busy = func_unit_busy[func_unit];

// Mux to identify if instruction's functional unit is busy
mux2to1 #(.DATA_WIDTH(1))
  funcMux(
    .A(unit_busy),
    .B(mem_busy),
    .sel(mem_ins),
    .out(func_busy)
);

// Identify if we should stall due to a needed unit being busy
assign resource_stall = pred_busy |
                        reg_dest_busy |
                        reg_src1_busy |
                        reg_src2_busy |
                        pred_dest_busy |
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
  if (free_unit) begin
    func_unit_busy[free_unit_id] <= 1'b0;
  end
end

// If instruction issued, then set destination register to invalid
always @(posedge clk) begin
  if (reset) begin
    for (i1 = 0; i1 < REG_FILE_SIZE; i1 = i1 + 1) begin
      reg_file_busy[i1] <= 1'b0;
    end
    for (i2 = 0; i2 < PRED_FILE_SIZE; i2 = i2 + 1) begin
      pred_file_busy[i2] <= 1'b0;
    end
    for (i3 = 0; i3 < NUM_FUNC_UNITS; i3 = i3 + 1) begin
      func_unit_busy[i2] <= 1'b0;
    end
  end else begin
    if (issue && reg_dest_valid) begin
      reg_file_busy[reg_dest_addr] <= 1'b1;
    end
    if (issue && pred_dest_valid) begin
      pred_file_busy[pred_dest_addr] <= 1'b1;
    end
    if (issue) begin
      func_unit_busy[func_unit] <= 1'b1;   
    end  
  end
end    

endmodule