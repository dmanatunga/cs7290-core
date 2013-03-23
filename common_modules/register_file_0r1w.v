module register_file_0r1w (  
    // Inputs
    clk,
    reset,
    wr_en,
    wr_addr,
    wr_data,  
);

parameter DATA_WIDTH = 32;
parameter ADDR_SIZE = 4;
localparam NUM_REG = 1 << ADDR_SIZE;

//----------------------------------
// Input Ports
//----------------------------------
input                  clk;
input                  reset;
input                  wr_en;
input [ADDR_SIZE-1:0]   wr_addr;
input [DATA_WIDTH-1:0] wr_data;

// Register File
reg [DATA_WIDTH-1:0]  reg_file[NUM_REG-1:0];
integer i;

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





