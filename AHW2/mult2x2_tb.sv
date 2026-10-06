module mult2x2_tb();

  reg [1:0] X,W;        // stiumuls to DUT
  wire [1:0] prod;      // output of DUT
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  mult2x2 iDUT(.X(X),.W(W),.prod(prod));
  
  initial begin
    X=2'b11;    // -1
    W=2'b11;    // -1
    #5;
    if (prod!==2'b01) begin
      $display("ERROR: -1 * -1 should yield 1");
      $stop();
    end
    
    X=2'b11;    // -1
    W=2'b00;    // 0
    #5;
    if (prod!==2'b00) begin
      $display("ERROR: -1 * 0 should yield 0");
      $stop();
    end
    
    X=2'b11;    // -1
    W=2'b01;    // 1
    #5;
    if (prod!==2'b11) begin
      $display("ERROR: -1 * 1 should yield -1");
      $stop();
    end
 
    X=2'b00;    // 0
    W=2'b11;    // -1
    #5;
    if (prod!==2'b00) begin
      $display("ERROR: 0 * -1 should yield 0");
      $stop();
    end
    
    X=2'b00;    // 0
    W=2'b00;    // 0
    #5;
    if (prod!==2'b00) begin
      $display("ERROR: 0 * 0 should yield 0");
      $stop();
    end 
    
    $display("Looking good so far");
    
    X=2'b00;    // 0
    W=2'b01;    // 1
    #5;
    if (prod!==2'b00) begin
      $display("ERROR: 0 * 1 should yield 0");
      $stop();
    end 
    
    X=2'b01;    // 1
    W=2'b11;    // -1
    #5;
    if (prod!==2'b11) begin
      $display("ERROR: 1 * -1 should yield -1");
      $stop();
    end     
 
    X=2'b01;    // 1
    W=2'b00;    // 0
    #5;
    if (prod!==2'b00) begin
      $display("ERROR: 1 * 0 should yield 0");
      $stop();
    end 
    
    X=2'b01;    // 1
    W=2'b01;    // 1
    #5;
    if (prod!==2'b01) begin
      $display("ERROR: 1 * 1 should yield 1");
      $stop();
    end 
    
    $display("YAHOO! all tests passed for mult2x2");
    $stop();
  end
  
endmodule