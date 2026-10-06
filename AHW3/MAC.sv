module MAC(
  input clk,
  input [1:0] step,
  input zero,
  input [2:0] Z0,Z1,Z2,
  input [1:0] Ux,
  output [3:0] accum
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic [2:0] Z, mult_output;
  logic [3:0] add_output, last_accum;

  
  /////////////////////////////////////////////////////////
  // Infer 3:1 mux to form Z into MAC from Z0,Z1, or Z2 //
  ///////////////////////////////////////////////////////
  assign Z = (step == 2'b00) ? Z0 : (step == 2'b01) ? Z1 : (step == 2'b10) ? Z2 : 3'b000;       
  /////////////////////////////////////////////
  // Instantiate sub-modules mult3x2, add4, //
  // and accum_reg to complete MAC.        //
  //////////////////////////////////////////
  mult3x2 mult(.Z(Z), .U(Ux), .prod(mult_output));
  add4 add(.A({mult_output[2], mult_output}), .B(last_accum), .S(add_output));
  accum_reg accumulate(.clk(clk), .zero(zero), .sum(add_output), .accum(last_accum));
  
  assign accum = last_accum;
 


endmodule
  
  