module func_3LUTs(
  input A,
  input B,
  input C,
  input D,
  input E,
  output F
);

  ///////////////////////////////////////////////////////////////////////////////////////////
  // Put your name below...if you worked with a partner ensure there name is also present //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Langlang Xiao

  ///////////////////////////////////////////////////////
  // You might need a couple of intermediat signals.  //
  // If you do declare them as type logic below here //
  ////////////////////////////////////////////////////
  logic output1, output2, output3;

  ///////////////////////////////////////////////////////////////////
  // Below is an instantiation of a 3-LUT producing the function: //
  // F = ABC.  Rip this out and replace it with instantiations   //
  // of as many LUTs as required to produce the function you    //
  // were requested to produce.                                //
  //////////////////////////////////////////////////////////////
  // D[7:0] is connected to 10000000 so only D[7] is connected to a 1,
  // therefore the function produces a 1 only when the select is 111.
  // The select is connected to {A,B,C} so output is 1 only when ABC is true
  LUT3 iLUT1(.D(8'b00001101), .SEL({A, B, E}), .LUT_out(output1));
  LUT3 iLUT2(.D(8'b01000000), .SEL({A, C, D}), .LUT_out(output2)); 
  LUT3 iLUT3(.D(8'b01010100), .SEL({output1, output2, 1'b0}), .LUT_out(F)); 	
  
endmodule
  
  
  
  