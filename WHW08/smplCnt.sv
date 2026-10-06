module smplCnt(clk,inc,clr,smpl_cnt);

  input clk;
  input inc;    // synchronous, assert when new sample accumulated
  input clr;    // synchronous clear
  output reg [1:0] smpl_cnt;    // the actual count of samples
  
  always_ff @(posedge clk)
    if (clr)
      smpl_cnt <= 2'b00;
    else if (inc)
      smpl_cnt <= smpl_cnt + 2'b01;
      
endmodule