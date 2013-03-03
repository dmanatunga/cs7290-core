module IF_ID_latch(
  // Inputs
  clk,
  stall,
  clr_latch,
  in_next_pc,
  in_ins,
  // Outputs
  out_next_pc,
  out_ins
);

parameter INS_SIZE = 32;
// Inputs
input                     clk;
input                     stall;
input                     clr_latch;
input   [INS_SIZE-1:0]    in_next_pc;
input   [INS_SIZE-1:0]    in_ins;
// Outputs
output reg [INS_SIZE-1:0]    out_next_pc;
output reg [INS_SIZE-1:0]    out_ins;

initial begin
  out_next_pc <= 32'd0;
  out_ins <= 32'd0;
end

always @(posedge clk) begin
  if (clr_latch)
    begin
      out_next_pc <= 32'd0;
      out_ins <= 32'd0;
    end
  else if (~stall)
    out_next_pc <= in_next_pc;
    out_ins <= in_ins;
end
endmodule
