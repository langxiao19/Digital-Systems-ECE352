module mult3x2_tb();

  reg [2:0] Z;      // stimulus
  reg [1:0] U;      // stimulus
  wire [2:0] prod;  // monitor DUT output

  //////////////////////
  // Instantiate DUT //
  ////////////////////
  mult3x2 iDUT(.Z(Z),.U(U),.prod(prod));
  
  initial begin
    U = 2'b11;      // -1
    Z = 3'b101;     // -3
    #5;
    if (prod!==3'b011) begin
      $display("ERROR: -1 * -3 should be 3");
      $stop;
    end
    
    U = 2'b11;      // -1
    Z = 3'b010;     // 2
    #5;
    if (prod!==3'b110) begin
      $display("ERROR: -1 * 2 should be 2");
      $stop;
    end   
 
    U = 2'b00;      // 0
    Z = 3'b011;     // 3
    #5;
    if (prod!==3'b000) begin
      $display("ERROR: 0 * 3 should be 0");
      $stop;
    end 
    
    $display("Getting there!");
    
    U = 2'b01;      // 1
    Z = 3'b011;     // 3
    #5;
    if (prod!==3'b011) begin
      $display("ERROR: 1 * 3 should be 3");
      $stop;
    end   
   
    U = 2'b01;      // 1
    Z = 3'b111;     // -1
    #5;
    if (prod!==3'b111) begin
      $display("ERROR: 1 * -1 should be -1");
      $stop;
    end
    
    $display("YAHOO!! test passed for mult3x2!");
    $stop();
     
  end
  
endmodule
