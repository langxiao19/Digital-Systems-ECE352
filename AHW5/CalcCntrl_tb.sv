module CalcCntrl_tb();

  //////////////////////////////////////////
  // Declare stimulus to DUT as type reg //
  ////////////////////////////////////////
  reg clk,rst_n;
  reg act_rdy;

  /////////////////////////////////////////////
  // Declare signals to monitor DUT outputs //
  ///////////////////////////////////////////
  wire clk_en;
  wire init_step;
  wire capture;
  /// step is provided by 2-bit counter ///
  wire [1:0] step;

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  CalcCntrl iDUT(.clk(clk),.rst_n(rst_n),.act_rdy(act_rdy),.step(step),
                 .clk_en(clk_en),.init_step(init_step),.capture(capture));
                 
  initial begin
    clk = 0;
    rst_n = 0;          // reset to start
    act_rdy = 0;

    @(negedge clk);
    rst_n = 1;
    
    @(posedge clk);
    if (clk_en!==1'b0) begin
      $display("ERR: clk_en should be 0 right out of reset");
      $stop();
    end else
      $display("GOOD: first check passed");
      
    if (init_step!==1'b1) begin
      $display("ERR: OK init_step should be asserted while you are in SLEEP and act_rdy is low");
    end else
      $display("GOOD: second check passed");
      
    if (capture!==1'b0) begin
      $display("ERR: capture should be 0 right out of reset");
      $stop();
    end else
      $display("GOOD: third check passed");
    
    @(posedge clk);
    act_rdy = 1;        // serial activity ready
    #1;
    if (init_step==1'b1) begin
      $display("ERR: init_step should not be asserted as we leave SLEEP");
      $stop();
    end else
      $display("GOOD: fourth check passed");
    
    @(posedge clk);
    act_rdy = 0;
    #1;
    if (clk_en!==1'b1) begin
      $display("ERR: clk should be enabled at this time");
      $stop();
    end else
      $display("GOOD: fifth check passed");    
    
    repeat(3)@(posedge clk);
    #1;
    if (capture!==1'b1) begin
      $display("ERR: capture should be asserted as step==2'b11");
      $stop();
    end else
      $display("GOOD: sixth check passed");
      
    @(posedge clk);
    #1;
    if (clk_en!==1'b0) begin
      $display("ERR: clk_en should be low as we should be in SLEEP now");
      $stop();
    end else
      $display("GOOD: seventh check passed");

    @(posedge clk);
        
    
    $display("YAHOO!!! all tests pass for CalcCntrl!");
    $stop();
  end
  
  ////////////////////////////////////////////////////////////
  // Instantiate 2-bit counter as a helper to provide step //
  //////////////////////////////////////////////////////////
  stepCnt iSTP(.clk(clk),.init(init_step),.step(step));
  
  //// Toggle clock ////
  always
    #5 clk = ~clk;

endmodule