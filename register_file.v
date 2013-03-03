module register_file (
  // Inputs
  clk,
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

parameter REG_BITS = 4;
localparam NUM_REG = 1 << REG_BITS;
//----------------------------------
// Input Ports
//----------------------------------
input                  clk;
input [REG_BITS-1:0]   rd_addr1;
input [REG_BITS-1:0]   rd_addr2;
input [REG_BITS-1:0]   rd_addr3;
input                  wr_en;
input [REG_BITS-1:0]   wr_addr;
input [31:0]           wr_data;

//----------------------------------
// Output Ports
//----------------------------------
output reg [31:0] data1;
output reg [31:0] data2;
output reg [31:0] data3;

// Register File
reg [31:0] reg_file[NUM_REG-1:0];

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

// Write register phase
always @(posedge clk) begin
  if (wr_en)
    begin
      reg_file[wr_addr] <= wr_data;
    end
end

// Read register phase
always @(negedge clk) begin
  begin
    data1 <= reg_file[rd_addr1];
    data2 <= reg_file[rd_addr2];
    data3 <= reg_file[rd_addr3];
  end
end

endmodule