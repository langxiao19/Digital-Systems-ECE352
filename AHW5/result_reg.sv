module result_reg(
  input clk,
  input capture,
  input [3:0] Yrect,
  output [3:0] classifier
);

  //////////////////////////////////////////////////////////////////////////////////
  // Instantiate 4 copies of d_en_ff to form result (will not use CLRN function) //
  ////////////////////////////////////////////////////////////////////////////////
  
  d_en_ff d0(.clk(clk), .D(Yrect[0]), .CLRN(1'b1), .EN(capture), .Q(classifier[0]));
  d_en_ff d1(.clk(clk), .D(Yrect[1]), .CLRN(1'b1), .EN(capture), .Q(classifier[1]));
  d_en_ff d2(.clk(clk), .D(Yrect[2]), .CLRN(1'b1), .EN(capture), .Q(classifier[2]));
  d_en_ff d3(.clk(clk), .D(Yrect[3]), .CLRN(1'b1), .EN(capture), .Q(classifier[3]));

endmodule