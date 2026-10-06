/////////////////////////////////////////////////////////
// SerialShftReg.sv.  5-bit right shift register with //
// meta-stability flops up front.                    //
//                                                  //
// Student 1 Name: << Enter you name here >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module SerialShftReg(
  input clk,
  input rst_n,
  input RX_raw,
  input shft,
  output logic RX_synch,
  output [3:0] rx_data
);

  //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic RX_meta;  // First synchronization stage

  /////////////////////////////////////////////////////////////
  /// infer two free-running back to back flops on RX       //
  /// to mitigate meta-stability (synch to our clk domain) //
  //////////////////////////////////////////////////////////
 
  always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    RX_meta  <= 1'b1;  // Reset to idle (high)
    RX_synch <= 1'b1;
  end
  else begin
    RX_meta  <= RX_raw;
    RX_synch <= RX_meta;
  end
end

  //////////////////////////////////////////////////////////////////////////////////
  //// Instantiate copies of d_en_ff to form 4-bit right shift register          //
  //// that produces rx_data.  It should shift right when shft is asserted      //
  //// The incoming signal should be the double flopped RX_raw (i.e. RX_synch) //
  //////////////////////////////////////////////////////////////////////////////
  d_en_ff iSHFT_REG[3:0](
    .CLK(clk),
    .D({RX_synch, rx_data[3:1]}),
    .CLRN(1'b1),  // Disable reset (tie CLRN inactive)
    .EN(shft),
    .Q(rx_data)
  );


endmodule