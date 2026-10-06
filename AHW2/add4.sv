module add4(
  input [3:0] A,
  input [3:0] B,
  output [3:0] S
);
  logic [4:0] C; 


  assign C[0] = 1'b0;


  FA iFA[3:0] (
    .A(A),     
    .B(B),      
    .Cin(C[3:0]), 
    .S(S),     
    .Cout(C[4:1])
  );  
  
endmodule