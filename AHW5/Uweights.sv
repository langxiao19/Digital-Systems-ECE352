module Uweights(
  input [1:0] sel,
  output [1:0] Ux
);

  reg [1:0]Us[0:2];
  
  initial
    Us <= '{2'b01,2'b11,2'b01};

  assign Ux = Us[sel];
  
endmodule
  
            