module mux8to1(
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    sel,
    out
);

parameter DATA_WIDTH = 32;
input   [DATA_WIDTH-1:0]    a;
input   [DATA_WIDTH-1:0]    b;
input   [DATA_WIDTH-1:0]    c;
input   [DATA_WIDTH-1:0]    d;
input   [DATA_WIDTH-1:0]    e;
input   [DATA_WIDTH-1:0]    f;
input   [DATA_WIDTH-1:0]    g;
input   [DATA_WIDTH-1:0]    h;
input   [2:0]               sel;

output    [DATA_WIDTH-1:0]  out;

assign out = sel[2] ? 
               (sel[1] ? 
                  (sel[0] ? h : g) : 
                  (sel[0] ? f : e))             
             : (sel[1] ? 
                  (sel[0] ? d : c) : 
                  (sel[0] ? b : a));

endmodule
