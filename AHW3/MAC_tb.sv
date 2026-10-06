module MAC_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  reg clk;
  reg [1:0] step;       // what step are we on?
  reg [2:0] Z0,Z1,Z2;   // result of first stage math
  reg [1:0] Ux;         // 1 of 3 U-weights
  reg zero;             // synchronous zero of accumulator reg
  

  //// Declare signal to monitor output of DUT ////
  wire [3:0] accum;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  MAC iDUT(.clk(clk),.zero(zero),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2),.Ux(Ux),.accum(accum));
  
  initial begin
    clk = 0;
    step = 2'b00;   // start with Z0 * U[0]
    Z0 = 3'b010;    // +2
    zero = 1'b1;    // zero accum initially
    Ux = 2'b01;     // +1
    
    #1;
    if (accum!==4'hx) begin
      $display("ERR: accum should be unknown at first");
      $stop();
    end
    
    /// accum reg should zero on +edge clk ///
    @(negedge clk);
    if (accum!==4'h0) begin
      $display("ERR2: accum reg should have been zeroed");
      $stop();
    end
    
    zero = 0;   // on next clk it should accumulate 
    @(negedge clk);
    if (accum!==4'h2) begin
      $display("ERR3: accum reg should get Ux * Z0 which should be 2");
      $stop();
    end

    Z1 = 3'b110;    // -2
    Ux = 2'b11;     // -1
    step = 2'b01;
    /// Now the 2 in accum will be added to -1*-2 so result should be 4
    @(negedge clk);
    if (accum!==4'h4) begin
      $display("ERR4: accum reg should get 2 + 2");
      $stop();
    end   
    
    Z2 = 3'b101;    // -3
    Ux = 2'b01;     // +1
    step = 2'b10;
    /// Now 4 in accum will be added to 1*-3 so result should be 1
    @(negedge clk);
    if (accum!==4'h1) begin
      $display("ERR5: accum reg should get 4 + -3");
      $stop();
    end    

    zero = 1;
    step = 2'b11;
    /// since zero asserted accum should be zero next
    @(negedge clk);
    if (accum!==4'h0) begin
      $display("ERR6: accum reg should have zeroed");
      $stop();
    end  

    $display("YAHOO!! all tests on MAC passed!");
    $stop();
    
  end
  
  always
    #5 clk = ~clk;
    
endmodule