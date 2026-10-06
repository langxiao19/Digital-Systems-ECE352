module AHW5(clk,KEY0,RX,GND1,GND2,HEX1,LEDG);

  input clk;                // 50MHz clock
  input KEY0;               // serves as active low reset
  input RX;			        // serial receive line from activity board
  output [6:0] HEX1;		// displays the classified result (0=>walk/run, 1=>fidgeting/standing, 2-3 => still)
  output GND1,GND2;         // Two I/O in // that drive ground to activity board (super cheesy)
  output [7:0] LEDG;        // Used for some debug observability
 
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [3:0] classifier;
  wire [1:0] step;              // what step of computation are we on from 2-bit counter controlled by SM
  wire act_rdy;                 // new data from activity sensor is ready
  wire [3:0] act_nibble;        // the 4-bits received from the activity sensor board
  wire clk_gated;               // gated clock to our datapath units (gated for power savings)
  wire clk_en;                  // from SM to enable clock to datapath
  wire init_step;               // from SM to clear the step counter
  wire capture_result;          // from SM to stg2 of datapath to capture the result (classifier)
  
 /////////////////////////////////////
  // Declare any internal registers //
  ///////////////////////////////////
  reg RST1_n, rst_n;       // used to synch reset
  reg clk_en_shaped;
 
  /// Following is behavioral verilog   ///
  /// which you would learn in ECE551   ///
  /// This is to synch KEY0 pushbutton  ///
  /// to be an active low reset (rst_n) ///  
  always_ff @(negedge KEY0, negedge clk)
    if (!KEY0) begin
      RST1_n <= 1'b0;
      rst_n <= 1'b0;
    end else begin
      RST1_n <= 1'b1;
      rst_n <= RST1_n;
    end
  
  
  ///////////////////////////////////////////////////////////////
  // Instantiate our SerialRX block which provides act_nibble //
  /////////////////////////////////////////////////////////////
  SerialRX iDUT(.clk(clk),.rst_n(rst_n),.RX(RX),.rx_data(act_nibble),.rdy(act_rdy));
  
  
  ///////////////////////////////////////////////////////////////
  // Instantiate simple 2-bit counter that will be used by SM //
  // to keep track of which step of calculation we are in.   //
  ////////////////////////////////////////////////////////////
  stepCnt iSTP(.clk(clk),.init(init_step),.step(step));

  ////////////////////////////////////////////////////////////////
  // Instantiate the SM that controls calculation & power down //
  //////////////////////////////////////////////////////////////
  CalcCntrl iCNTRL(.clk(clk),.rst_n(rst_n),.act_rdy(act_rdy),.step(step),.clk_en(clk_en),
                   .init_step(init_step),.capture(capture_result));
                   
  ////////////////////////////////////////////////////////////////////////
  // Need to shape clk_en so it can only change at falling edge of clk //
  //////////////////////////////////////////////////////////////////////
  always @(negedge clk)
    clk_en_shaped <= clk_en;
    
  assign clk_gated = clk & clk_en_shaped;
  
  ////////////////////////////////////
  // Instantiate full datapath     //
  // NOTE: running on gated clock //
  /////////////////////////////////
  neural_datapath iDUT_DP(.clk(clk_gated),.X0(act_nibble[1:0]),.X1(act_nibble[3:2]),
                          .step(step),.capture(capture_result),.classifier(classifier));

  //////////////////////////////////////////////////////////////////////
  // instantiate bcd7seg drivers for 7-segment display of classifier //
  ////////////////////////////////////////////////////////////////////
  bcd7seg iBCD1(.num(classifier),.seg(HEX1)); 
  
  /////////////////////////////////////////////////
  // Due to pin out of header combined with available
  // cable, the easiest way to get GND to the activity
  // board was to use two I/O to drive 0 as GND.
  // This is cheesy, but works.  Use reset button
  // KEY0 to cycle power to activity board.
  //////////////////////////////////////
  assign GND1 = (KEY0) ? 1'b0 : 1'bz;
  assign GND2 = (KEY0) ? 1'b0 : 1'bz;
  
  ///////////////////////////////////////////////////
  // As a debug aid we will have act_nibble       //
  // (received via serialRX) output on LEDG[7:4] //
  ////////////////////////////////////////////////
  assign LEDG[7:6] = act_nibble[3:2];
  assign LEDG[3:2] = act_nibble[1:0];
  /// also output reset button (KEY0) for convenience
  assign LEDG[0] = ~KEY0;

endmodule
  
  