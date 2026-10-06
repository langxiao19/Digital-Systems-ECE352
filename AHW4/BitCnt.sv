//////////////////////////////////////////////////////////
// BitCnt.sv:  This design implements an 3-bit counter //
// used to determine when serial reception complete.  //
//                                                   //
// Student 1 Name: << Enter your name here >>       //
// Student 2 Name: << Enter name if applicable >>  //
////////////////////////////////////////////////////
module BitCnt(
  input clk,			// 50MHz
  input rst_n,			// asynch active low reset
  input clr,			// pre-loads with 5'b01111 (15)
  input shft,           // enables the count every shift of shift reg
  output [2:0] bit_cnt  // when count hits zero shift register shifts
);

  /////////////////////////////////////////////
  // Declare any needed internal signals.   //
  // HINT: nxt_cnt which is a 3-bit vector //
  //////////////////////////////////////////
  logic [2:0] cnt;   
  /////////////////////////////////////////////////////////
  // Use dataflow statement to infer nxt_cnt as 3'b000  //
  // if clr is asserted, else if shft is asserted it   //
  // should be cnt + 3'b001, otherwise it should hold //
  // current value of bit_cnt                        //
  ////////////////////////////////////////////////////
  always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    cnt <= 3'b000;           
  else if (clr)
    cnt <= 3'b000;             
  else if (shft)
    cnt <= cnt + 3'b001;     
  
  end
  
  ////////////////////////////////////////////////////////////////
  // Instantiate 3 d_ff as a vector to implement the counter   //
  // Should be reset to 000 with rst_n.  Tie PRN inactive. It //
  // takes on value of nxt_cnt on + clk if not being reset.  //
  ////////////////////////////////////////////////////////////
  assign bit_cnt = cnt;

endmodule
  