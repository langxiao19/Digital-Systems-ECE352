module stg1flops(
  input clk,
  input [2:0] Y,    // Output of RELU
  input [1:0] step, // what step of 3-step process?
  output [2:0] Z0,  // output reg of row Wx0 * X
  output [2:0] Z1,  // output reg of row Wx1 * X
  output [2:0] Z2   // output reg of row Wx2 * X  
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  /////////////////////////////////////////
  logic EN0, EN1, EN2;  

  ///////////////////////////////////////////////////////////
  // Instantiate 9 of d_en_ff to create 3 3-bit registers //
  // Connect as needed. Best done as 3 3-bit vectored   //
  ////////////////////////////////////////////////////////
  // Instantiate the 3 3-bit registers
  d_en_ff flipflop0[2:0] (
    .CLK(clk),
    .D(Y),        
    .CLRN(1'b1),  
    .EN(EN0),     
    .Q(Z0)        
  );
  
  d_en_ff flipflop1[2:0] (
    .CLK(clk),
    .D(Y),
    .CLRN(1'b1),
    .EN(EN1),
    .Q(Z1)
  );
  
  d_en_ff flipflop2[2:0] (
    .CLK(clk),
    .D(Y),
    .CLRN(1'b1),
    .EN(EN2),
    .Q(Z2)
  );

  //////////////////////////////////////////////////////
  // Infer 2:3 decoder using dataflow verilog. Only  //
  // 3 of the 4 possible encodings are used, 2'b11  //
  // should yield 3'b000 (none hot).               //
  //////////////////////////////////////////////////
  assign EN0 = (step == 2'b00);
  assign EN1 = (step == 2'b01);
  assign EN2 = (step == 2'b10);
endmodule
  