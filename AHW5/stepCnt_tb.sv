module stepCnt_tb();

  //////////////////////////////////
  // Declare stimulus to bit_cnt //
  ////////////////////////////////
  reg clk;          // 50MHz clk
  reg init;         // synchronous initialization of StepCnt
  
  //////////////////////////////////////
  // Declare signal to monitor count //
  ////////////////////////////////////
  wire [1:0] step_mon;        // monitor the 3-bit count
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  stepCnt iDUT(.clk(clk), .init(init), .step(step_mon));
  
  initial begin
	clk = 1'b0;
	init = 1'b0;
    
	@(negedge clk);
    if (step_mon!==2'bxx) begin
      $display("ERR1: step should be unknown (2'bxx) at this time");
      $stop();
    end
    
	init = 1;      // init to 2'b11
    
    @(negedge clk);
    if (step_mon!==2'b11) begin
      $display("ERR2: step should be 2'b11 at this time");
      $stop();
    end    
    
    init = 0;
    
    @(negedge clk);     // init deasserted, should inc and roll over next
    if (step_mon!==2'b00) begin
      $display("ERR3: step should have rolled from 2'b11 to 2'b00 now");
      $stop();
    end

    repeat(2) @(negedge clk);           // two clks later
    if (step_mon!==2'b10) begin         // step should be 2
      $display("ERR4: step should be 2'b10 at this time");
      $stop();
    end     

	$display("YAHOO! all tests pass, bit_cnt looks good");	
	$stop();
  end
  
  always
    #5 clk = ~ clk;		// keep clock toggling
  
endmodule
  