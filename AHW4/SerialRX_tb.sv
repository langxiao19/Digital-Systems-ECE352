module SerialRX_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  reg clk,rst_n;        // clock and asynch active low reset
  reg RX;               // models serial data from accelerometer
  
  /////////////////////////////////////////////
  // Declare signals to monitor DUT outputs //
  ///////////////////////////////////////////
  wire [3:0] rx_data;   // data received from DUT
  wire rdy;             // DUT has data ready

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  SerialRX iDUT(.clk(clk), .rst_n(rst_n), .RX(RX), .rx_data(rx_data), .rdy(rdy));
  
  initial begin
    clk = 0;
    rst_n = 0;
    RX = 1;
    
    @(negedge clk);
    rst_n = 1;      // deassert reset
    
    @(negedge clk);
    if (rdy!==0) begin
      $display("ERR1: rdy should be zero at this time");
      $stop();
    end else
      $display("GOOD: 1st check passed");
    
    RX = 0;         // start of the start bit
    repeat(131) @(negedge clk);
    
    if (rx_data[3]!==1'b0) begin
      $display("ERR2: Would expect shift register to have shifted once by now");
      $stop();
    end else
      $display("GOOD: 2nd check passed");
    
    repeat (128) @(negedge clk);
    RX = 1;         // LSB of data will be a 1
    repeat(256) @(negedge clk);
    RX = 0;         // toggle every other bit
    repeat(256) @(negedge clk);
    RX = 1;         // toggle every other bit
    repeat(256) @(negedge clk);
    RX = 0;         // toggle every other bit
    repeat(256) @(negedge clk);

    if (rx_data!==4'b0101) begin
      $display("ERR3: Data should be in and 0101.  Waiting for stop bit");
      $stop();
    end else
      $display("GOOD: rx_data as expected 0101");
    
    repeat(120) @(negedge clk);
    //// should be nearing the rdy assertion now ////
    fork
      begin: TIMEOUT
        repeat(20) @(negedge clk);
        $display("ERR4: timed out waiting for rdy");
        $stop();
      end
      begin
        @(posedge rdy);
        disable TIMEOUT;
        $display("GOOD: rdy asserted in expected time window");
      end
    join

    repeat(2) @(negedge clk);
    if (rx_data!==4'b0101) begin
      $display("ERR5: Data should be in and 0101");
      $stop();
    end else
      $display("GOOD: rx_data as expected");

    $display("YAHOO!! all tests passed!");
    
    $stop();
  end
  
  always
    #5 clk = ~clk;
    
endmodule
