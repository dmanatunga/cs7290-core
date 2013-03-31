module register_file_3r1w (
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

parameter ADDR_SIZE = 4;
parameter DATA_WIDTH = 32;

localparam NUM_REG = 1 << ADDR_SIZE;
//----------------------------------
// Input Ports
//----------------------------------
input                  clk;
input                  reset;
input [ADDR_SIZE-1:0]   rd_addr1;
input [ADDR_SIZE-1:0]   rd_addr2;
input [ADDR_SIZE-1:0]   rd_addr3;
input                  wr_en;
input [ADDR_SIZE-1:0]   wr_addr;
input [DATA_WIDTH-1:0] wr_data;

//----------------------------------
// Output Ports
//----------------------------------
output  [DATA_WIDTH-1:0] data1;
output  [DATA_WIDTH-1:0] data2;
output  [DATA_WIDTH-1:0] data3;

// Register File
reg [DATA_WIDTH-1:0] reg_file[NUM_REG-1:0];
integer i;

assign data1 = reg_file[rd_addr1];
assign data2 = reg_file[rd_addr2];
assign data3 = reg_file[rd_addr3];

// Write register phase
always @(negedge clk) begin
  if (reset) begin
    for (i = 0; i < NUM_REG; i = i + 1) begin
      reg_file[i] <= 0;
    end
  end else if (wr_en) begin
    reg_file[wr_addr] <= wr_data;
  end
end

    
endmodule
