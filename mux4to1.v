module mux4to1(
    a,
    b,
    c,
    d,
    sel,
    out
);

parameter DATA_WIDTH = 32;
input   [DATA_WIDTH-1:0]    a;
input   [DATA_WIDTH-1:0]    b;
input   [DATA_WIDTH-1:0]    c;
input   [DATA_WIDTH-1:0]    d;
input   [1:0]               sel;

output    [DATA_WIDTH-1:0]  out;

assign out = sel[1] ? 
              (sel[0] ? d : c)
              : (sel[0] ? b : a);

endmodule
  
