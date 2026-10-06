module mult2x2(
  input [1:0] X,
  input [1:0] W,
  output [1:0] prod
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic p1_1, p1_2;
  logic notW1, notX1;
	
  //////////////////////////////////////////////////
  // Implement multiply using structural verilog //
  // (instantiation of gate primitives          //
  ///////////////////////////////////////////////
  not not1(notW1,W[1]);
  not not2(notX1,X[1]);

  and and1(p1_1, notW1,W[0],X[1]);
  and and2(p1_2, W[1],notX1,X[0]);
  or or1(prod[1], p1_1, p1_2);

  and and3(prod[0],W[0],X[0]);
  
endmodule