module decoder_2bit(
	// Inputs
	in,
	enable,
	// Outputs
	a,
	b,
	c,
	d
);

input	[1:0]	in;
input		enable;

output	a;
output	b;
output	c;
output	d;

assign a = enable & (in == 2'b00);
assign b = enable & (in == 2'b01);
assign c = enable & (in == 2'b10);
assign d = enable & (in == 2'b11);

endmodule
