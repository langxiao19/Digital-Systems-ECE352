module segGdec
(
	input [3:0] D,
	output segG
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic D3_not, D2_not, D1_not;
  logic B1, B2;
  
  //////////////////////////////////////////////////////
  // Write STRUCTURAL verilog to implement segment G //
  ////////////////////////////////////////////////////
  not not3 (D3_not, D[3]);  // D3'
  not not2 (D2_not, D[2]);  // D2'
  not not1 (D1_not, D[1]);  // D1'
  


  and and1(B1, D3_not, D2_not, D1_not);  
  and and2(B2, D3_not, D[2], D[1], D[0]); 
   

       // Combine terms
  or or1(segG, B1, B2); 

    // Active-low output (flip logic)
    
  
endmodule


 
