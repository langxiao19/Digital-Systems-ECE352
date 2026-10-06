module accum_reg(
  input clk,
  input zero,
  input [3:0] sum,
  output [3:0] accum
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic [3:0] next_accum;
  
  ///////////////////////////////////////////////////////////
  // Infer logic needed to synch zero out accum registers //
  // Dataflow is a decent choice for this.               //
  ////////////////////////////////////////////////////////
  assign next_accum = (zero) ? 4'b0000 : sum;
  
  //////////////////////////////////////////
  // Perform a vectored instantiation of // 
  // 4 d_ff's to form the accum resiter //
  ///////////////////////////////////////
  d_en_ff ff0(
    .CLK(clk),
    .D(next_accum[0]),
    .CLRN(1'b1),
    .EN(1'b1),    
    .Q(accum[0])
  );

  d_en_ff ff1(
    .CLK(clk),
    .D(next_accum[1]),
    .CLRN(1'b1),
    .EN(1'b1),
    .Q(accum[1])
  );

  d_en_ff ff2(
    .CLK(clk),
    .D(next_accum[2]),
    .CLRN(1'b1),
    .EN(1'b1),
    .Q(accum[2])
  );

  d_en_ff ff3(
    .CLK(clk),
    .D(next_accum[3]),
    .CLRN(1'b1),
    .EN(1'b1),
    .Q(accum[3])
  );

endmodule