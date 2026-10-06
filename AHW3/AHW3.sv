module AHW3(clk,KEY0,SW,LEDR,HEX1,LEDG0);

  input clk;                // 50MHz clock
  input KEY0;               // on release lets 1 clock through on clk_pulse
  input [17:0] SW;			// slide switches [17:14] & [3:0] used
  output [17:0] LEDR;		// Red LEDs above swithes
  output [6:0] HEX1;		// displays the accum from stg2 MAC
  output LEDG0;
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [2:0] Z0,Z1,Z2;
  wire [3:0] accum;
  
  assign LEDG0 = KEY0; // give user indication of KEY0 state
  
  ///////////////////////////////////////
  // Declare signals needed to create //
  // clk_pulse from KEY0.            //
  ////////////////////////////////////
  reg KEY0_ff1,KEY0_ff2,KEY0_ff3;
  wire clk_pulse;

  /// Following is behavioral verilog ///
  /// which you would learn in ECE551 ///  
  always @(posedge clk)
    begin
      KEY0_ff1 <= KEY0;
      KEY0_ff2 <= KEY0_ff1;
      KEY0_ff3 <= KEY0_ff2;
    end
    
  assign clk_pulse = KEY0_ff2 & ~KEY0_ff3;
  
  /////////////////////////////////////////////////////////
  // instantiate bcd7seg drivers for 7-segment displays //
  ///////////////////////////////////////////////////////
  bcd7seg iBCD1(.num(accum),.seg(HEX1)); 
  
  /////////////////////////////////
  // Instantiate datapath units //
  ///////////////////////////////
  neural_dp_stg1 iDUT1(.clk(clk_pulse),.step(SW[17:16]),.X0(SW[1:0]),.X1(SW[3:2]),.X2(2'b01),
                       .Z0(Z0),.Z1(Z1),.Z2(Z2));
  neural_dp_stg2_part iDUT2(.clk(clk_pulse),.step(SW[17:16]),.Z0(Z0),.Z1(Z1),.Z2(Z2),
                       .accum(accum));

  assign LEDR = SW;

endmodule
  
  