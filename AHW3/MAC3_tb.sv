module MAC3_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  reg [1:0] W0,W1,W2;
  reg [1:0] X0,X1,X2;
  
  /// Declare signal to monitor DUT output ///
  reg [2:0] Y;

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  MAC3 iDUT(.W0(W0),.W1(W1),.W2(W2),.X0(X0),.X1(X1),.X2(X2),.Y(Y));
  
  initial begin
    X0 = 2'b11;     // -1
    X1 = 2'b01;     // +1
    X2 = 2'b01;     // +1
    W0 = 2'b11;     // -1
    W1 = 2'b00;
    W2 = 2'b01;     // +1
    #5;             // give DUT time to compute
    if (Y!==3'b010) begin
      $display("ERR1: first expected result is 1 + 0 + 1 = 2");
      $stop();
    end else $display("GOOD1: first computation looks good");
 
    W0 = 2'b01;     // +1 first product will be -1 now
    #5;             // give DUT time to compute
    
    if (Y!==3'b000) begin
      $display("ERR2: first expected result is -1 + 0 + 1 = 0");
      $stop();
    end else $display("GOOD2: second computation looks good");

    W1 = 2'b11;     // -1
    W2 = 2'b11;     // -1
    #5;             // give DUT time to compute
    if (Y!==3'b101) begin
      $display("ERR3: third expected result is -1 + -1 + -1 = -3");
      $stop();
    end else $display("GOOD3: third computation looks good");    

    $display("YAHOO!! all tests on MAC3 passed");
    $stop();
    
  end
  
endmodule

