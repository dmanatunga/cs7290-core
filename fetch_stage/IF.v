`include "../globals.vh"
module IF(
    // Inputs
    clk,
	reset,
	// Inputs
	mem_stall,
	mem_data,
	mem_id,
	mem_valid,
	// From ID stage
    sel_br,
    br_target,
    if_stall,
    // Outputs
	// To memory
	fetch_addr,
	fetch_id, 
	fetch_valid,
	// To EX stage
    next_pc,
    ins,
	ins_is_nop
);

// Inputs
input            				clk;
input							reset;
input							mem_stall;
input	[`DATA_WIDTH-1:0]		mem_data;
input	[`FETCH_ID_SIZE-1:0]	mem_id;
input							mem_valid;
input							sel_br;
input	[`DATA_WIDTH-1:0]		br_target;
input							if_stall;
 
// Outputs
// To memory
output 		[`DATA_WIDTH-1:0]		fetch_addr;
output reg	[`FETCH_ID_SIZE-1:0]	fetch_id;
output								fetch_valid;
// To ex stage
output	[`DATA_WIDTH-1:0]		next_pc;
output	[`INS_WIDTH-1:0]			ins;
output							ins_is_nop;

reg	[`DATA_WIDTH-1:0]	pc;
reg	[`DATA_WIDTH-1:0]	mem_addr; 
reg						addr_valid;
reg	[`DATA_WIDTH-1:0]	ins_queue;
reg						ins_queue_valid;
reg						fetch_ready;
wire	[`DATA_WIDTH-1:0]	new_pc;


assign fetch_addr = pc;
assign ins_is_nop = ~(((fetch_id == mem_id) & mem_valid) | ins_queue_valid);

assign next_pc = pc + 4;
assign fetch_valid = fetch_ready & ~mem_stall;


mux2to1 #(.DATA_WIDTH(`DATA_WIDTH))
    ins_mux(
      .a(mem_data),
      .b(ins_queue),
      .sel(ins_queue_valid),
      .out(ins)
);


always @(posedge clk) begin
	if (reset)	begin
		pc <= 32'd0;
		fetch_id <= 0;
		fetch_ready <= 1;
		
		ins_queue <= 0;
		ins_queue_valid <= 0;
	end else begin
		if (ins_queue_valid) begin
			if (!if_stall) begin
				ins_queue_valid <= 1'b0;
				if (sel_br) begin
					pc <= br_target;
				end else begin
					pc <= next_pc;
				end
				fetch_id <= fetch_id + `FETCH_ID_SIZE'd1;
				fetch_ready <= 1'b1;
			end
		end else begin
			if (mem_valid) begin
				if (if_stall) begin
					ins_queue_valid <= 1'b1;
					ins_queue <= mem_data;
				end else begin
					if (sel_br) begin
						pc <= br_target;
					end else begin
						pc <= next_pc;
					end
					fetch_id <= fetch_id + `FETCH_ID_SIZE'd1;
					fetch_ready <= 1'b1;
				end
			end else begin
				if (sel_br) begin
					pc <= br_target;
					fetch_id <= fetch_id + `FETCH_ID_SIZE'd1;
					fetch_ready <= 1'b1;
				end else begin
					if (fetch_valid) begin
						fetch_ready <= 0;
					end
				end
			end
		end
	end
end
endmodule
  
