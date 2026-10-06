module motionDetect(clk,rst_n,vld,mv);

  input clk,rst_n;			// clock & asynch active low reset
  output vld;               // asserted for 1 clk when new mv[1:0] is valid
  output [1:0] mv;		    // -1 => low/no motion, 0 => medium motion, 1 => high motion
  
  ///////////////////////////////////////////////////////
  // Following localparams are used as thresholds for //
  // determining low/med/high movement levels.       //
  ////////////////////////////////////////////////////
  localparam THRES1 = 14'h0600;		// if under this, then low/no motion
  localparam THRES2 = 14'h0C00;	    // if over this, then high motion
  
  ///// Declare needed internal signals /////
  wire selAZ;                   // selects AX or AZ into abs unit (from SM)
  wire zeroSrc1;                // selects 0 or accumulator into ALU src1 bus
  wire accum;                   // enable to accum reg (from SM)
  wire inc_smpl;                // increments smplCnt (from SM)
  wire [1:0] smpl_cnt;          // smpl_cnt value from smplCnt (to SM)
  wire rdy;                     // rdy output from model of accel (to SM)
  wire [11:0] abs_in;           // input to ABS (either AX or AZ)
  wire [10:0] abs_out;          // output of ABS (only need 11-bits now)
  wire [13:0] src1,src0;		// source busses into ALU
  wire [13:0] dst;				// output of ALU
  wire [11:0] AX,AZ;            // outputs of accelerometer

  //// Declare accumulator register ////
  reg [13:0] accum_reg;
  

  /// Infer src0 mux between AX and AZ ///
  assign abs_in = (selAZ) ? AZ : AX;
  
  ////////////////////////////////////////////////////////
  // You complete implementation of ABS using dataflow //
  //////////////////////////////////////////////////////
  assign abs_out = abs_in[11] ? (~abs_in + 1'b1) : abs_in;
  
  /// src0 is simply a zero extension of abs_out ///
  assign src0 = {3'b000,abs_out};
  
  /// infer src1 mux between accum & zero ///
  assign src1 = (zeroSrc1) ? 14'h0000 : accum_reg;
  
  /// Infer ALU (which is actually just an adder) ///
  assign dst = src0 + src1;

  /// infer accum register ///
  always_ff @(posedge clk)
    if (accum)
	  accum_reg <= dst;
	  
  /// infer threshold logic that produces mv[1:0] ///
  assign mv = (accum_reg<THRES1) ? 2'b11 :      // -1 is low/no motion
              (accum_reg<THRES2) ? 2'b00 :      // 0 is medium motion
              2'b01;                            // 1 is high motion

  /////////////////////////////////////
  // Instantiate the controlling SM //
  ///////////////////////////////////
  activitySM iSM(.clk(clk),.rst_n(rst_n),.rdy(rdy),.smpl(smpl_cnt),
                 .inc_smpl(inc_smpl),.selAZ(selAZ),.zeroSrc1(zeroSrc1),
                 .accum(accum),.vld(vld));
 
  ///////////////////////////////////////////
  // Instantiate the 2-bit sample counter //
  ///////////////////////////////////////// 
  smplCnt iCNT(.clk(clk),.inc(inc_smpl),.clr(zeroSrc1),.smpl_cnt(smpl_cnt));
  
  /////////////////////////////////////////
  // Instantiate model of accelerometer //
  ///////////////////////////////////////
  accelModel iACC(.clk(clk),.rst_n(rst_n),.rdy(rdy),.AX(AX),.AZ(AZ));  
  
  
endmodule

