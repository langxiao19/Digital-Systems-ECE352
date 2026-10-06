module motionDetect_tb();

  ///////////////////////////////////
  // Declare stimulus of type reg //
  /////////////////////////////////
  reg clk, rst_n;

  
  /////////////////////////////////////////////
  // Declare signals to monitor DUT outputs //
  ///////////////////////////////////////////
  wire [1:0] mv;
  wire vld;

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  motionDetect iDUT(.clk(clk),.rst_n(rst_n),.vld(vld),.mv(mv));
			 
  initial begin
    clk = 0;
	rst_n = 0;			        // assert reset

    @(negedge clk) rst_n = 1;   // deassert reset
	
    //////////////////////////////////////
    // wait for first assertion of vld //
    ////////////////////////////////////
	fork
      begin : timeout1
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout1;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b01) begin
      $display("ERR: First reading should be large motion (i.e. 2'b01)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: first reading as expeced");
      
      
    ////////////////////////////////////
    // wait for 2nd assertion of vld //
    //////////////////////////////////
	fork
      begin : timeout2
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for 2nd assertion of vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout2;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b01) begin
      $display("ERR: 2nd reading should be large motion (i.e. 2'b01)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: 2nd reading as expeced");	
      
    ////////////////////////////////////
    // wait for 3rd assertion of vld //
    //////////////////////////////////
	fork
      begin : timeout3
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for 3rd assertion of vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout3;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b00) begin
      $display("ERR: 3rd reading should be medium motion (i.e. 2'b00)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: 3rd reading as expeced");	

    ////////////////////////////////////
    // wait for 4th assertion of vld //
    //////////////////////////////////
	fork
      begin : timeout4
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for 4th assertion of vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout4;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b00) begin
      $display("ERR: 4th reading should be medium motion (i.e. 2'b00)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: 4th reading as expeced");
      
    ////////////////////////////////////
    // wait for 5th assertion of vld //
    //////////////////////////////////
	fork
      begin : timeout5
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for 5th assertion of vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout5;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b11) begin
      $display("ERR: 5th reading should be low/no motion (i.e. 2'b11)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: 5th reading as expeced");

    ////////////////////////////////////
    // wait for 6th assertion of vld //
    //////////////////////////////////
	fork
      begin : timeout6
        repeat(20) @(posedge clk);
        $display("ERR: timedout waiting for 6th assertion of vld");
        $stop();
      end
      begin
        @(posedge vld);
        disable timeout6;
      end
    join
    /// check that mv[1:0] is as expected ///
	if (mv!==2'b11) begin
      $display("ERR: 5th reading should be low/no motion (i.e. 2'b11)");
      @(posedge clk);       // wait 1 clock then
      $stop();
    end else
      $display("GOOD: 6th reading as expeced");
           
	$display("YAHOO! all tests passed");
	$stop();
	
  end
  
  always
    #5 clk = ~clk;
	
endmodule
			 
			 