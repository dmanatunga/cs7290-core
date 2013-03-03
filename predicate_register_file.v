module predicate_register_file (
  // Inputs
  clk,
  reset,
  rd_addr1,
  rd_addr2,
  rd_addr3,
  wr_en,
  wr_addr,
  wr_data,  
  
  // Outputs
  data1,
  data2,
  data3
);

parameter REG_BITS = 2;
localparam NUM_REG = 1 << REG_BITS;

//----------------------------------
// Input Ports
//----------------------------------
input                  clk;
input                  reset;
input [REG_BITS-1:0]   rd_addr1;
input [REG_BITS-1:0]   rd_addr2;
input [REG_BITS-1:0]   rd_addr3;
input                  wr_en;
input [REG_BITS-1:0]   wr_addr;
input                  wr_data;

//----------------------------------
// Output Ports
//----------------------------------
output reg  data1;
output reg  data2;
output reg  data3;

// Register File
reg reg_file[NUM_REG-1:0];
integer i;

initial begin
    reg_file[0] <= 0;
    reg_file[1] <= 0;
    reg_file[2] <= 0;
    reg_file[3] <= 0;
    reg_file[4] <= 0;
    reg_file[5] <= 0;
    reg_file[6] <= 0;
    reg_file[7] <= 0;
end

assign data1 = reg_file[rd_addr1];
assign data2 = reg_file[rd_addr2];
assign data3 = reg_file[rd_addr3];
    
// Register Write
always @(negedge clk) begin
  if (wr_en)
    begin
      reg_file[wr_addr] <= wr_data;
    end
end

// Reset Register File
always @(posedge clk) begin
  if (reset) begin
    for (i = 0; i < NUM_REG; i = i + 1) begin
      reg_file[i] <= 0;
    end
  end
end
endmodule

