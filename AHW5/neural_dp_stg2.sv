module neural_dp_stg2(
  input clk,
  input [1:0] step,
  input [2:0] Z0,Z1,Z2,
  input en,                 // enables capture of classified results
  output [3:0] classifier
);
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [1:0] Ux;
  wire [3:0] accum;
  wire [3:0] Yrect;
  
  ////////////////////////////////////////////////////////////
  // Instantiate all components of stg2 of neural datapath //
  //////////////////////////////////////////////////////////
  Uweights Us(.sel(step),.Ux(Ux));
  MAC iMAC2(.clk(clk),.zero(&step),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2),.Ux(Ux),.accum(accum));
  RELU4 iREL4(.Y(accum),.Yrect(Yrect));
  result_reg iRES(.clk(clk),.capture(en),.Yrect(Yrect),.classifier(classifier));
  
endmodule
