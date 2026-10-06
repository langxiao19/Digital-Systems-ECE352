module AHW4(clk,KEY0,RX,GND1,GND2,LEDG);

  input clk;                // 50MHz clock
  input KEY0;               // serves as active low reset
  input RX;			        // serial line from activity board
  output GND1, GND2;        // Cheesy as all getout, but using these as two
                            // signals to the remote activity sensing board
  output [7:0] LEDG;		// Green LEDs (we only use 7:6 & 1:0
  
  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  wire [3:0] rcvd_nibble;     // nibble (half-byte) received from our SerialRX
  
  /////////////////////////////////////
  // Declare any internal registers //
  ///////////////////////////////////
  reg RST1_n, rst_n;       // used to synch reset
 
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
    
  //////////////////////////////////////////
  // Activity board needs a GND connection from the FPGA board
  // Due to availability of jumper wire and pin layout on 
  // connector I had to use two GPIO to serve as GND to the
  // activity board.  Kinda cheesy but it works.
  ///////////////////////////////////////////
  assign GND1 = (KEY0) ? 1'b0 : 1'bz;
  assign GND2 = (KEY0) ? 1'b0 : 1'bz;
  
  ////////////////////////////////////////////////////////
  // instantiate our main Device Under Test (SerialRX) //
  //////////////////////////////////////////////////////
  SerialRX iDUT(.clk(clk),.rst_n(rst_n),.RX(RX),.rx_data(rcvd_nibble),.rdy(enLEDG));
  
  ////////////////////////////////////////////////////////////////////////////
  // Instantiate 4 copies of your d_en_ff to drive LEDG[7:6] & LEDG[1:0]   //
  // Don't have to use vectored instantiation...you can just bit blast it //
  /////////////////////////////////////////////////////////////////////////
  d_en_ff LEDG7(.clk(clk),.D(rcvd_nibble[3]),.CLRN(rst_n),.EN(enLEDG),.Q(LEDG[7]));
  d_en_ff LEDG6(.clk(clk),.D(rcvd_nibble[2]),.CLRN(rst_n),.EN(enLEDG),.Q(LEDG[6]));
  d_en_ff LEDG1(.clk(clk),.D(rcvd_nibble[1]),.CLRN(rst_n),.EN(enLEDG),.Q(LEDG[1]));
  d_en_ff LEDG0(.clk(clk),.D(rcvd_nibble[0]),.CLRN(rst_n),.EN(enLEDG),.Q(LEDG[0]));
 
endmodule
  
  