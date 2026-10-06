module accelModel(
  input clk,rst_n,  // clock and active low asynch reset
  output reg rdy,   // new measurements are ready on AX & AZ
  output reg [11:0] AX, // signed acceleration in X direction
  output reg [11:0] AZ  // signed acceleration in Z direction
);

  //////////////////////////////////////////
  // declare memory holding AX & AZ data //
  ////////////////////////////////////////
  reg [11:0]ACCEL_DATA[0:23][0:1];   // AX is first then AZ
  reg [4:0] indx;
  reg [31:0] temp;
  
  initial begin
    /// First 8 AX/AZ values will be large motion ///
    for(indx=0; indx<8; indx++) begin
      temp = $urandom_range(4095,384);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx][0] = temp[11:0]; // assign AX[indx]
      temp = $urandom_range(4095,384);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx][1] = temp[11:0]; // assign AZ[indx]
    end
    /// Next 8 AX/AZ values will be medium motion ///
    for(indx=0; indx<8; indx++) begin
      temp = $urandom_range(360,192);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx+8][0] = temp[11:0]; // assign AX[indx]
      temp = $urandom_range(360,192);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx+8][1] = temp[11:0]; // assign AZ[indx]
    end    
    /// Last 8 AX/AZ values will be low/no motion ///
    for(indx=0; indx<8; indx++) begin
      temp = $urandom_range(180,0);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx+16][0] = temp[11:0]; // assign AX[indx]
      temp = $urandom_range(180,0);
      if (temp[4]) temp = ~temp;        // make about 50% negative numbers
      ACCEL_DATA[indx+16][1] = temp[11:0]; // assign AZ[indx]
    end       
  end
  
  initial begin
    AX = 12'hxxx;
    AZ = 12'hxxx;
    rdy = 1'b0;
    @(posedge rst_n);

    repeat(2) @(negedge clk);
    indx = 0;
    repeat(24) begin
      @(posedge clk);
      #1;
      AX = ACCEL_DATA[indx][0];
      AZ = ACCEL_DATA[indx][1];
      rdy = 1;
      @(posedge clk);
      #1;
      rdy = 0;
      repeat(2) @(posedge clk);
      indx++;
    end
    
  end
  
endmodule