module neural_dp_stg2_part(
  input clk,
  input [1:0] step,
  input [2:0] Z0,Z1,Z2,
  output [3:0] accum
);
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [1:0] Ux;
  
  ////////////////////////////////////////////////////////////
  // Instantiate all components of stg2 of neural datapath //
  //////////////////////////////////////////////////////////
  Uweights Us(.sel(step),.Ux(Ux));
  MAC iMAC2(.clk(clk),.zero(&step),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2),.Ux(Ux),.accum(accum));
  
endmodule
