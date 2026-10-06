module Wweights(
  input [1:0] sel,
  output [1:0] W0,W1,W2
);

  reg [1:0]Ws[0:2][0:2];
  
  initial
    Ws <= '{'{2'b11,2'b00,2'b01},
            '{2'b01,2'b11,2'b00},
            '{2'b00,2'b00,2'b01}};
  
  assign W0 = Ws[sel][0];
  assign W1 = Ws[sel][1];
  assign W2 = Ws[sel][2];
  
endmodule
  
            