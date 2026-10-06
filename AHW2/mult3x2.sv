module mult3x2(
  input signed [2:0] Z,
  input [1:0] U,
  output [2:0] prod
);

  /////////////////////////////////////////////////
  // Implement the 3x2 multiply using a single  //
  // ternary dataflow assign statement. Not a  //
  // single line, but a single statement.     //
  // Remember that U can only be -1, 0, or 1 //
  ////////////////////////////////////////////
  
  assign prod = (U==2'b00) ? 3'b000 : (U==2'b01) ? Z : (U==2'b11) ? -Z : 2'b100; 
                
endmodule