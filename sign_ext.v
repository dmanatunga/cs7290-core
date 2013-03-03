module sign_ext(
  // Inputs
  in,
  
  //Outputs,
  out
);

parameter IN_SIZE = 16;
parameter OUT_SIZE = 32;

input   [IN_SIZE-1:0]   in;

output  [OUT_SIZE-1:0]  out;

assign out = {{(OUT_SIZE-IN_SIZE){in[IN_SIZE-1]}}, in};

endmodule