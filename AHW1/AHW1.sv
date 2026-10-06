module AHW1(
  input		[17:0] SW,		// 18 slide switches on board
  input		[3:0] KEY,		// hooked to the 4 push buttons
  output 	[17:0] LEDR,	// 18 red LEDs
  output	[7:0] LEDG		// 8 green LEDs
);

  ///////////////////////////////////////////////////////////////////
  // Instantiate your RCA4 block and make appropriate connections //
  /////////////////////////////////////////////////////////////////
  wire [3:0] A, B, S;
  wire Cin, Cout;
  assign A = SW[17:14];   
  assign B = SW[3:0];     
  assign Cin = ~KEY[0];

  ////////////////////////////////////////////////////////////////////
  // Need a couple of assign statements below to have LEDR[17:14]  //
  // represent SW[17:14] and LEDR[3:0] represent SW[3:0].         //
  /////////////////////////////////////////////////////////////////
  RCA4 iRCA4 (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );
  assign LEDR[17:14] = A;  
  assign LEDR[3:0]   = B; 
  assign LEDG[3:0]   = S; 
  assign LEDG[7]     = Cout; 
				
  
endmodule
