////////////////////////////////////////////////////////////////
// BaudCnt.sv:  This design implements an 8-bit down counter //
// that is preloaded at 0x7F to be used as a baud counter.  //
//                                                         //
// Student 1 Name: << Enter you name here >>              //
// Student 2 Name: << Enter name if applicable >>        //
//////////////////////////////////////////////////////////
module BaudCnt(
  input clk,      // 50MHz
  input rst_n,      // asynch active low reset
  input load,     // pre-loads with 5'b01111 (15)
  output shft       // when count hits zero shift register shifts
);

  ///////////////////////////////////////////
  // Declare any needed internal signals. //
  /////////////////////////////////////////
 
  logic [7:0] cnt, nxt_cnt;
  ///////////////////////////////////////////////////////
  // Use dataflow statement to infer nxt_cnt as 7'h7F //
  // if load is asserted, otherwise cnt - 8'h01      //
  ////////////////////////////////////////////////////
  assign nxt_cnt = load ? 8'h7F : (cnt - 8'h01);
 
  //////////////////////////////////////////////////////////////
  // Instantiate 8 d_ff as a vector to implement the counter //
  // Should be preset to FF with rst_n.  Tie CLRN inactive. //
  ///////////////////////////////////////////////////////////
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      cnt <= 8'hFF;      
    else
      cnt <= nxt_cnt;  
  end
         
  //////////////////////////////////////////////////////
  // Using dataflow assert shft when count hits zero //
  ////////////////////////////////////////////////////
  assign shft = (cnt == 8'h00);  // Assert when counter hits zero

 
endmodule