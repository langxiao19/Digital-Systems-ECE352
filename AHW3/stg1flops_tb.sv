module stg1flops_tb();

  //////////////////////////////
  // Declare stimulus to DUT //
  ////////////////////////////
  reg [1:0] step;
  reg [2:0] Y;
  reg clk;
  
  ///////////////////////////////////////
  // Declare signals to check outputs //
  /////////////////////////////////////
  wire [2:0] Z0,Z1,Z2;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  stg1flops iDUT(.clk(clk),.Y(Y),.step(step),.Z0(Z0),.Z1(Z1),.Z2(Z2));
  
  initial begin
    clk = 0;
    Y = 3'b001;
    step = 2'b00;
    
    @(negedge clk);
    if (Z0!==3'b001) begin
      $display("ERR: Z0 should have been updated to 001");
      $stop();
    end
    if ((Z1!==3'bxxx) || (Z2!==3'bxxx)) begin
      $display("ERR: Both Z1 & Z2 should still be unknown");
      $stop();
    end
    
    step = 2'b01;
    Y = 2'b010;
    @(negedge clk);
    if (Z1!==3'b010) begin
      $display("ERR2: Z1 should have been updated to 010");
      $stop();
    end
    if (Z0!==3'b001) begin
      $display("ERR2: Z0 should not have changed");
      $stop();
    end
    if (Z2!==3'bxxx) begin
      $display("ERR2: Z2 should still be unknown");
      $stop();
    end   
    
    step = 2'b10;
    Y = 3'b100;
    @(negedge clk);
    if (Z2!==3'b100) begin
      $display("ERR3: Z2 should have been updated to 100");
      $stop();
    end
    if (Z0!==3'b001) begin
      $display("ERR3: Z0 should not have changed");
      $stop();
    end
    if (Z1!==3'b010) begin
      $display("ERR3: Z1 should not have changed");
      $stop();
    end   

    step = 2'b11;
    Y = 3'b111;
    @(negedge clk);
    if (Z2!==3'b100) begin
      $display("ERR4: Z2 should not have changed");
      $stop();
    end
    if (Z0!==3'b001) begin
      $display("ERR4: Z0 should not have changed");
      $stop();
    end
    if (Z1!==3'b010) begin
      $display("ERR4: Z1 should not have changed");
      $stop();
    end 

    $display("YAHOO!!! all tests passed on stg1flops!");
    $stop();    
      
  end
  
  always
    #5 clk = ~clk;      // keep clock going
endmodule
