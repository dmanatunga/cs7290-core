module control_unit(
	// Inputs
	clk,
	reset,
	opcode,
	// Outputs - Control Signals
% for sig in ctrl_signals:
	${sig}${',' if not loop.last else ''}
% endfor
);

parameter OPCODE_SIZE = 6;
localparam NUM_OPS = 1 << OPCODE_SIZE;

// Inputs
input clk;
input reset;
input	[OPCODE_SIZE-1:0]	opcode;

//Outputs
% for sig in ctrl_signals:
	% if ctrl_signal_sizes[sig] == 1:
output 	${sig};
	% else:
output	[${ctrl_signal_sizes[sig] - 1}:0]		${sig};
	% endif
% endfor

// Registers for storing signal data
% for sig in ctrl_signals:
	% if ctrl_signal_sizes[sig] == 1:
reg 	${sig}_reg[0:NUM_OPS-1];
	% else:
reg	[${ctrl_signal_sizes[sig] - 1}:0]		${sig}_reg[0:NUM_OPS-1];
  % endif
% endfor

// Output control signals
% for sig in ctrl_signals:
assign ${sig} = ${sig}_reg[opcode];
% endfor

// Control Signal Table
always @(posedge clk) begin
	if (reset) begin
		% for op in ops:
		// ${op['name']} - ${op['opcode_hex']}
			% for sig in ctrl_signals:
		${sig}_reg[${op['opcode']}] <= ${op[sig]};
			% endfor
			% if not loop.last:

		% endif
		% endfor
	end
end

endmodule
