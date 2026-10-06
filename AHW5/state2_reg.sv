////////////////////////////////////////////////////////////
// state3_reg.sv:  This design implements state register //
//                                                      //
// Student 1 Name: Langlang Xiao           //
// Student 2 Name: Arnav Sawant     //
///////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
// Forms a 3-bit state register that will be one hot. //
// Meaning it needs to aynchronously reset to 3'b001 //
//////////////////////////////////////////////////////
module state2_reg(
  input clk,				// clock
  input rst_n,				// asynchronous active low system reset
  input [1:0] nxt_state,	// forms next state (i.e. goes to D input of FFs)
  output [1:0] state		// output (current state)
);
  
  ////////////////////////////////////////////////////
  // Declare any needed internal signals.  Due to  //
  // all bits except LSB needed to reset, and the //
  // LSB needing to preset you will need to form //
  // two 3-bit vectors to hook to CLRN and PRN  //
  ///////////////////////////////////////////////
  logic [1:0] reset, preset;
  
  ///////////////////////////////////////////////////////////
  // The two 3-bit vectors for CLRN & PRN are formed with //
  // vector concatenation of a mix of rst_n and 1'b1     //
  ////////////////////////////////////////////////////////
  assign reset = {rst_n,rst_n, 1'b1};
  assign preset = {2'b11, rst_n};
  ////////////////////////////////////////////////////////
  // instantiate 3 d_ff as a vector to implement state //
  //////////////////////////////////////////////////////
  
  d_ff ff0(.clk(clk), .D(nxt_state[0]), .CLRN(reset[0]), .PRN(preset[0]), .Q(state[0]));
  d_ff ff1(.clk(clk), .D(nxt_state[1]), .CLRN(reset[1]), .PRN(preset[1]), .Q(state[1]));
  //d_ff ff2(.clk(clk), .D(nxt_state[2]), .CLRN(reset[2]), .PRN(preset[2]), .Q(state[2]));

  
endmodule