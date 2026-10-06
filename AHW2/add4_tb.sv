module add4_tb();

  /////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  reg [3:0] A,B;
  
  ///////////////////////////////////////////
  // Declare signal to monitor DUT output //
  /////////////////////////////////////////
  wire [3:0] S;
  
  //////////////////////////////
  // Instantiate DUT //
  ////////////////////
  add4 iDUT(.A(A), .B(B), .S(S));
  
  initial begin
    A = 4'h5;
    B = 4'hA;
    #5;         // give time for DUT to compute
    if (S!==4'hF) begin
      $display("ERR: expected sum is F");
      $stop();
    end else $display("GOOD passed first add");
    
    B = 4'hB;   // will overflow to 0x0
    #5;         // give time for DUT to compute
    if (S!==4'h0) begin
      $display("ERR: expected sum is 0");
      $stop();
    end else $display("GOOD passed second add");   

    B = 4'h5;   // all bits same in each position
    #5;         // give time for DUT to compute
    if (S!==4'hA) begin
      $display("ERR: expected sum is A");
      $stop();
    end else $display("GOOD passed third add");

    $display("YAHOO! passed tests for add4");
    $stop();    
  end
  
endmodule