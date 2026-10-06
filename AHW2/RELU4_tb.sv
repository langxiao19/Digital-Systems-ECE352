module RELU4_tb();

  reg [3:0] Y;          // stiumulus to DUT
  wire [3:0] Yrect;     // output from DUT to monitor
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  RELU4 iDUT(.Y(Y),.Yrect(Yrect));
  
  initial begin
    Y = 4'b0000;
    #5;
    if (Yrect!==4'b0000) begin
      $display("ERROR: RELU of 0000 should be 0000");
      $stop();
    end

    Y = 4'b0101;
    #5;
    if (Yrect!==4'b0101) begin
      $display("ERROR: RELU of 0101 should be 0101");
      $stop();
    end
    
    $display("Almost too easy right?");
    
    Y = 4'b1001;
    #5;
    if (Yrect!==4'b0000) begin
      $display("ERROR: RELU of 1001 should be 0000");
      $stop();
    end

    Y = 4'b1111;
    #5;
    if (Yrect!==4'b0000) begin
      $display("ERROR: RELU of 1111 should be 0000");
      $stop();
    end

    Y = 4'b0001;
    #5;
    if (Yrect!==4'b0001) begin
      $display("ERROR: RELU of 0001 should be 0001");
      $stop();
    end
    
    $display("Yahoo! all tests passed for RELU4");
    $stop();
    
  end
  
endmodule