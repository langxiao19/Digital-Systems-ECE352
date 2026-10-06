module stepCnt(
  input clk,
  input init,
  output [1:0] step
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic[1:0] nxt_step;
  
  //////////////////////////////////////////////////////////////////
  // Instantiate two copies of d_ff (have no asynch reset/preset //
  ////////////////////////////////////////////////////////////////
  d_ff d0(.clk(clk), .D(nxt_step[0]), .CLRN(1'b1), .PRN(1'b1), .Q(step[0]));
  d_ff d1(.clk(clk), .D(nxt_step[1]), .CLRN(1'b1), .PRN(1'b1), .Q(step[1]));
 
  //////////////////////////////////////////////
  // Infer nxt_step using dataflow statement //
  ////////////////////////////////////////////
  assign nxt_step = (init) ? 2'b11 : step + 1;
  
endmodule