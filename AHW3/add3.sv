module add3(
  input [2:0] A,
  input [2:0] B,
  output [2:0] S,
  output Cout
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic [3:0] C; 
  

  //////////////////////////////////////////////////////
  // Implement adder using instances of FA from AHW1 //
  // --- Use a vectored instantiation !! ---        //
  ///////////////////////////////////////////////////

  assign C[0] = 1'b0;


  FA iFA[2:0] (
    .A(A),     
    .B(B),
    .Cin(C[2:0]),     
    .S(S),
    .Cout(C[3:1])    
  );  
  
  
endmodule