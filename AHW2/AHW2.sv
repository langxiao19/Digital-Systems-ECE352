module AHW2(SW,LEDR,HEX6,HEX4,HEX3,HEX1,LEDG);

  input [17:0] SW;			// slide switches [17:14] & [3:0] used
  output [17:0] LEDR;		// Red LEDs above swithes
  output [6:0] HEX6;		// from bcd7seg driven by SW[17:14] connected to "HEX6" display
  output [6:0] HEX4;        // from bcd7seg driven by SW[13:10] connected to "HEX4" display
  output [6:0] HEX3;        // displays sum of SW[17:14] with SW[13:10]
  output [6:0] HEX1;		// displays the RELU output of SW[13:10]
  output [7:0] LEDG;		// the green LEDs
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [3:0] sum4,relu4;
  
  /////////////////////////////////////////////////////////
  // instantiate bcd7seg drivers for 7-segment displays //
  ///////////////////////////////////////////////////////
  bcd7seg iBCD6(.num(SW[17:14]),.seg(HEX6));
  bcd7seg iBCD4(.num(SW[13:10]),.seg(HEX4));
  bcd7seg iBCD3(.num(sum4),.seg(HEX3));
  bcd7seg iBCD1(.num(relu4),.seg(HEX1)); 
  
  ////////////////////////////
  // Instantiate add4 unit //
  //////////////////////////
  add4 iADD(.A(SW[17:14]),.B(SW[13:10]),.S(sum4));

  /////////////////////////////
  // Instantiate RELU4 unit //
  ///////////////////////////
  RELU4 iRELU(.Y(SW[13:10]),.Yrect(relu4));

  //////////////////////////////
  // Instantiate Multipliers //
  ////////////////////////////
  mult2x2 iM0(.X(SW[1:0]),.W(SW[3:2]),.prod(LEDG[1:0]));
  mult3x2 iM1(.Z(SW[4:2]),.U(SW[1:0]),.prod(LEDG[7:5]));

  assign LEDR = SW;

endmodule
  
  