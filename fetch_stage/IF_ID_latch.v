module IF_ID_latch(
  // Inputs
  clk,
  reset,
  stall,
  clr_latch,
  in_next_pc,
  in_ins,
  // Outputs
  out_next_pc,
  out_ins,
  out_is_nop
);

parameter INS_SIZE = 32;
// Inputs
input					clk;
input					reset;
input                   stall;
input                   clr_latch;
input	[`INS_SIZE-1:0]	in_next_pc;
input	[`INS_SIZE-1:0]	in_ins;
// Outputs
output reg [INS_SIZE-1:0]    out_next_pc;
output reg [INS_SIZE-1:0]    out_ins;
output reg 					 out_is_nop;


always @(posedge clk) begin
	if (reset || (clr_latch && !stall)) begin
		out_next_pc <= 32'd0;
		out_ins <= 32'd0;
		out_is_nop <= 1'd1;
    end else if (!stall) begin
		out_next_pc <= in_next_pc;
		out_ins <= in_ins;
		out_is_nop <= 1'b0;
	end
end
endmodule
