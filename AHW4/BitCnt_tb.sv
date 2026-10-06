module BitCnt_tb();

  //////////////////////////////////
  // Declare stimulus to bit_cnt //
  ////////////////////////////////
  reg clk,rst_n;    // 50MHz clk, and asynch active low reset
  reg clr;          // synchronous clear of BitCnt
  reg shft;         // enable to bit_cnt (only counts when shift reg shifts)
  
  //////////////////////////////////////
  // Declare signal to monitor count //
  ////////////////////////////////////
  wire [2:0] bit_cnt;        // monitor the 3-bit count
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  BitCnt iDUT(.clk(clk), .rst_n(rst_n), .clr(clr), .shft(shft), .bit_cnt(bit_cnt));
  
  initial begin
    rst_n = 1'b0;
	clk = 1'b0;
	clr = 1'b0;
    shft = 1'b1;
    
	@(negedge clk);
    if (bit_cnt!==3'b000) begin
      $display("ERR1: bit_cnt should be asynch reset to 3'b000");
      $stop();
    end
    
	rst_n = 1;      // deassert reset
    
    @(negedge clk);
    if (bit_cnt!==3'b001) begin
      $display("ERR2: bit_cnt should have incremented to 3'b001");
      $stop();
    end    
    
    clr = 1;            // test synch clear
    shft = 0;           // disable
    @(negedge clk);     // clr is asserted so bit_cnt should be 000
    if (bit_cnt!==3'b000) begin
      $display("ERR3: Since clr is asserted count should be 3'b000");
      $stop();
    end

    clr = 0;                            // Don't clear, but still
    repeat(2) @(negedge clk);           // not enable
    if (bit_cnt!==3'b000) begin         // and shft should be asserted
      $display("ERR4: bit_cnt should be 000 since not enabled");
      $stop();
    end     
    
    shft = 1;                           // enable counting
    repeat(5) @(negedge clk);
    if (bit_cnt!==3'b101) begin         // and shft should be asserted
      $display("ERR5: bit_cnt should be 101");
      $stop();
    end 

	$display("YAHOO! all tests pass, bit_cnt looks good");	
	$stop();
  end
  
  always
    #5 clk = ~ clk;		// keep clock toggling
  
endmodule
  