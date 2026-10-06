module SerialShftReg_tb();


  ////////////////////////////////////////////
  // Declare stimulus to DUT of type logic //
  //////////////////////////////////////////
  logic clk;            // 50MHz clock
  logic rst_n;          // asynch active low reset
  logic RX_raw;         // input stimulus
  logic shft;           // enable to allow shifting
  
  //////////////////////////////////////////////////////
  // Declare signals hooked to DUT to monitor output //
  ////////////////////////////////////////////////////
  wire [3:0] rx_data;   // monitor rx_data output
  wire RX_synch;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  SerialShftReg iDUT(.clk(clk), .rst_n(rst_n), .RX_raw(RX_raw), .shft(shft), 
                     .RX_synch(RX_synch), .rx_data(rx_data));
                     
  initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    shft = 1'b0;
    RX_raw = 1'b0;
    
    /// Check reset conditions after first fall of clk ///
    @(negedge clk);
    if (RX_synch!==1'b1) begin
      $display("ERR1: RX_synch should have been preset to 1'b1");
      $stop();
    end
    if (rx_data!==4'hx) begin
      $display("ERR1: rx_data should be all X's at this point");
      $stop();
    end
    
    rst_n = 1'b1;       // deassert reset
    
    @(negedge clk);     // wait another clk, since shft is still low
                        // the shift reg should still be all X's
    if (rx_data!==4'hx) begin
      $display("ERR2: rx_data should still be all X's at this point");
      $stop();
    end  

    shft = 1'b1;                // enable shifting (shifting in 1 at first, then two 0's)
    repeat(3) @(negedge clk);   // wait for 1+2 clks (1 more for double flops,
                                // 2 for first two bits of shift reg
    if (rx_data!==4'b001x) begin
      $display("ERR3: rx_data should still be 4'b001x at this point");
      $stop();
    end    
                      
    RX_raw = 1'b1;              // switch data in to be 1
    shft = 1'b0;                // disable shift reg from flopping, but
                                // meta-stability flops still running
    repeat(2) @(negedge clk);   // let 1 perculate through meta-stability flops
    if (RX_synch!==1'b1) begin
      $display("ERR4: RX_synch should be 1'b0 by now");
      $stop();
    end
    if (rx_data!==4'b001x) begin
      $display("ERR4: rx_data should still be 4'b001x");
      $stop();
    end

    shft = 1'b1;                // enable shifting again
    repeat(2) @(negedge clk);   // 1's should be shifting into MSB's of shift reg
    if (rx_data!==4'b1100) begin
      $display("ERR5: rx_data should still be 4'b00xx");
      $stop();
    end

    $display("YAHOOO! SerialShftReg appears to be working!");
    $stop();
    
  end
  
  always
    #5 clk = ~clk;

endmodule  
  