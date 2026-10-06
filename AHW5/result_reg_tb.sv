module result_reg_tb();

  /// Declare stimulus to DUT ///
  reg clk;
  reg capture;
  reg [3:0] Yrect;
  
  /// Declare signal to monitor DUT output ///
  wire [3:0] classifier;
  
  /// instantiate DUT ///
  result_reg iDUT(.clk(clk),.capture(capture),.Yrect(Yrect), .classifier(classifier));
  
  initial begin
    clk = 0;
    capture = 0;
    Yrect = 4'h0;
    
    @(posedge clk);
    #1;
    if (classifier!==4'hx) begin
      $display("ERR: result_reg (classifier) should still be uninitialized at this time");
      $stop();
    end else
      $display("GOOD: first test passed");
      
    capture = 1;    // enable result_reg
    
    @(posedge clk);
    #1;
    if (classifier!==4'h0) begin
      $display("ERR: result_reg (classifier) should have flopped 4'h0");
      $stop();
    end else
      $display("GOOD: second test passed");
     
    Yrect = 4'hA;
    
    @(posedge clk);
    #1;
    if (classifier!==4'hA) begin
      $display("ERR: result_reg (classifier) should have flopped 4'hA");
      $stop();
    end else
      $display("GOOD: third test passed");    
    
    Yrect = 4'h5;
    capture = 0;
    
    @(posedge clk);
    #1;
    if (classifier!==4'hA) begin
      $display("ERR: result_reg (classifier) should still hold 4'hA");
      $stop();
    end else
      $display("GOOD: 4th test passed");
      
    capture = 1;

    @(posedge clk);
    #1;
    if (classifier!==4'h5) begin
      $display("ERR: result_reg (classifier) should have flopped 4'h5");
      $stop();
    end else
      $display("GOOD: 5th test passed");    
    
    $display("YAHOO!! all tests passed!");
    $stop();
  end
  
  always
    #5 clk = ~clk;
    
  
endmodule