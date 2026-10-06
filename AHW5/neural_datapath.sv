module neural_datapath(
  input clk,
  input [1:0] X0,           // motion
  input [1:0] X1,           // orientation
  input [1:0] step,
  input capture,            // enable capture of result (classifier) in stg2
  output [3:0] classifier   // 0=>walk/run 1=>fidget/stand  2+ => sitting
);
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic [2:0] Z0,Z1,Z2;     // connections between stg1 & stg2
  
  
  ///////////////////////////////////////////////////
  // Instantiate two stages of datapath pipelined //
  /////////////////////////////////////////////////
  neural_dp_stg1 iDUT1(.clk(clk),.step(step),.X0(X0),.X1(X1),.X2(2'b01),
                       .Z0(Z0),.Z1(Z1),.Z2(Z2));
  neural_dp_stg2 iDUT2(.clk(clk),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2),
                       .en(capture),.classifier(classifier));
  
endmodule