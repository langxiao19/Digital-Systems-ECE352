module neural_dp_stg1(
  input clk,
  input [1:0] step,         // step of computation
  input [1:0] X0,X1,X2,     // inputs we are classifying
  output [2:0] Z0,          // output reg of row Wx0 * X
  output [2:0] Z1,          // output reg of row Wx1 * X
  output [2:0] Z2           // output reg of row Wx2 * X
);
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [1:0] W0,W1,W2;
  wire [2:0] Y,Yrect;
  
  /////////////////////////////////////////////////////////////
  // Instantiate all components that makeup neural_datapath //
  ///////////////////////////////////////////////////////////
  Wweights iWs(.sel(step),.W0(W0),.W1(W1),.W2(W2));
  MAC3 iMAC3(.W0(W0),.W1(W1),.W2(W2),.X0(X0),.X1(X1),.X2(X2),.Y(Y));
  RELU3 iREL3(.Y(Y),.Yrect(Yrect));
  stg1flops iSTG1(.clk(clk),.Y(Yrect),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2));
  
endmodule
