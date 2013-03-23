module IF(
    // Inputs
    clk,
    sel_br,
    br_targ,
    pc_stall,
    // Outputs
    next_pc,
    ins
);

parameter MEM_SIZE = 32;
parameter MEM_BITS = 5;
parameter WORD_BITS = 2;
parameter WORD_SIZE = 32;

// Inputs
input            clk;
input    [31:0]  br_targ;
input            sel_br;
input            pc_stall;
 
// Outputs
output      [31:0]           next_pc;
output reg  [WORD_SIZE-1:0]  ins;

reg      [31:0]  pc;
wire     [31:0]  new_pc;
wire     [31:0]  mem_addr;  

reg      [31:0]  MEMORY[MEM_SIZE-1:0];

initial begin
  pc <= 32'd0;
  /**
  MEMORY[0] <= 32'h05110003;
  MEMORY[1] <= 32'h05190005;
  MEMORY[2] <= 32'h07400024;
  MEMORY[3] <= 0;
  MEMORY[4] <= 0;
  MEMORY[5] <= 0;
  MEMORY[6] <= 0;
  MEMORY[7] <= 0;
  MEMORY[8] <= 0;
  MEMORY[9] <= 32'h02a26000;
  MEMORY[10] <= 32'h02eb4000;
  MEMORY[11] <= 32'h0b800000;
  MEMORY[12] <= 0;
  MEMORY[13] <= 0;
  MEMORY[14] <= 0;
  MEMORY[15] <= 0;
  MEMORY[16] <= 0;
  MEMORY[17] <= 0;
  MEMORY[18] <= 32'h02e26000;
  MEMORY[19] <= 32'h02ab4000;
  MEMORY[20] <= 0;
  MEMORY[21] <= 0;
  MEMORY[22] <= 0;
  MEMORY[23] <= 0;
  **/
  
  MEMORY[0] <= 32'h05110003;
  MEMORY[1] <= 32'h05190005;
  MEMORY[2] <= 0;
  MEMORY[3] <= 0;
  MEMORY[4] <= 0;
  MEMORY[5] <= 0;
  MEMORY[6] <= 0;
  MEMORY[7] <= 0;
  MEMORY[8] <= 32'h02a26000;
  MEMORY[9] <= 32'h02eb4000;
end

assign mem_addr = pc;
assign next_pc = pc + 4;
mux2to1 m1(.a(next_pc), .b(br_targ), .sel(sel_br), .out(new_pc));

always @(posedge clk) begin
  if (~pc_stall)
    begin
      pc = new_pc;
    end
end

always @(pc) begin
  ins <= MEMORY[pc[MEM_BITS-1+WORD_BITS:WORD_BITS]];
end

endmodule
  