module MAC3(
  input [1:0] W0,W1,W2,
  input [1:0] X0,X1,X2,
  output [2:0] Y
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic [1:0] prod0, prod1, prod2;
  logic [2:0] sum0, sum1;
  logic cout0, cout1;
  

  ////////////////////////////////////
  // Instantiate copies of mult2x2 // 
  // and connect as needed.       //
  /////////////////////////////////
  mult2x2 mult1(.X(W0), .W(X0), .prod(prod0));
  mult2x2 mult2(.X(W1), .W(X1), .prod(prod1));
  mult2x2 mult3(.X(W2), .W(X2), .prod(prod2));
  
  /////////////////////////////////
  // Instantiate copies of add3 // 
  // and connect as needed.    //
  //////////////////////////////
  add3 add0 (
    .A({prod0[1], prod0}), // Sign extend to 3 bits
    .B({prod1[1], prod1}), // Sign extend to 3 bits
    .Cout(cout0),
    .S(sum0)
  );

  
  add3 add1 (
    .A(sum0),
    .B({prod2[1], prod2}), // Sign extend to 3 bits
    .Cout(cout1),
    .S(sum1)
  );
  
  assign Y = sum1;
 
  
endmodule