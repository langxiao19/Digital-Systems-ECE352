module BaudCnt_tb();

  reg clk,rst_n;    // 50MHz clk, and asynch active low reset
  reg load;         // pre-loads BaudCnt with 1/2 baud value (0x7F)
  
  wire shft;        // monitor the shift output of BaudCnt
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  BaudCnt iDUT(.clk(clk), .rst_n(rst_n), .load(load), .shft(shft));
  
  initial begin
    rst_n = 1'b0;
	clk = 1'b0;
	load = 1'b1;
    
	@(negedge clk);
    if (iDUT.cnt!==8'hFF) begin
      $display("ERR1: Count inside BaudCnt should be all 1's");
      $stop();
    end
    if (shft!==1'b0) begin
      $display("ERR1: shft should be zero at this time");
      $stop();
    end
    
	rst_n = 1;      // deassert reset
    
    @(negedge clk);
    if (iDUT.cnt!==8'h7F) begin
      $display("ERR2: Since load is asserted count should be 0x7F");
      $stop();
    end    
    
    @(negedge clk);     // load is still asserted so count should still be 0x7F");
    if (iDUT.cnt!==8'h7F) begin
      $display("ERR3: Since load is asserted count should be 0x7F");
      $stop();
    end

    load = 0;                       // Now enable it to cound down
    repeat(127) @(negedge clk);     // after 127 clks it should be at zero
    if (shft!==1'b1) begin         // and shft should be asserted
      $display("ERR4: shft should be asserted at this time");
      $stop();
    end 

    @(negedge clk);                 // wait one clk and
    if (shft!==1'b0) begin         // shft should be back to 0
      $display("ERR5: shft should be back to zero at this time");
      $stop();
    end 

    repeat(255) @(negedge clk);     // in 255 more clks
    if (shft!==1'b1) begin         // and shft should be asserted again
      $display("ERR6: shft should be asserted again at this time");
      $stop();
    end    

	$display("YAHOO! all tests pass, shft_reg looks good");	
	$stop();
  end
  
  always
    #5 clk = ~ clk;		// keep clock toggling
  
endmodule
  