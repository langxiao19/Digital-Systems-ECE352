module state2_reg_tb();

  //// declare stimulus as type reg ////
  reg error;
  reg clk;
  reg rst_n;
  
  wire [1:0] nxt_state;
  
  wire [1:0] state;		// hook to state output of DUT
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  state2_reg iDUT(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));
  
  assign nxt_state = {state[0],1'b0};
  
  initial begin
    error = 1'b0;		// innocent till proven guilty
    clk = 1'b0;
	rst_n = 1'b1;
	
	@(negedge clk);
	if (state!==2'bx0) begin
	  $display("ERR: at time = %t state upper bit of state should be uninitialized",$time);
	  error = 1'b1;
	end
	#1 rst_n = 1'b0;
	#1;
	if (state!==2'b01) begin
	  $display("ERR: at time = %t state should be 2'b01",$time);
	  error = 1'b1;
	end
	
	@(negedge clk);
	rst_n = 1'b1;
	if (state!==3'b01) begin
	  $display("ERR: at time = %t state should still be 2'b01",$time);
	  error = 1'b1;
	end	
	
	@(negedge clk);
	if (state!==2'b10) begin
	  $display("ERR: at time = %t state should be 2'b10",$time);
	  error = 1'b1;
	end	

	#1 rst_n = 1'b0;
	#1;
	if (state!==2'b01) begin
	  $display("ERR: at time = %t state should be 2'b01",$time);
	  error = 1'b1;
	end
	
    if (!error)
	  $display("YAHOO! test passed for state2_reg");
	$stop();
  end
  
  always
    #5 clk = ~clk;		// clock start at zero and toggles every 5 time units
  
endmodule