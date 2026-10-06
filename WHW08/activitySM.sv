///////////////////////////////////////////////////\\
// activitySM.sv : Control FSM for motion detection \\
//                                                  //
// Student 1 Name: LANGLANG XIAO      //
// Student 2 Name: ARNAV SAWANT //
///////////////////////////////////////////////////
module activitySM(
  input clk, 				// system clock
  input rst_n,				// active low asynch reset
  input rdy,				// ready from accelerometer
  input [1:0] smpl,         // count of num samples already accumulated
  output logic selAZ,	    // select AX or AZ into ABS unit
  output logic zeroSrc1,	// select accum or zero for src1 bus
  output logic inc_smpl,	// increments the smpl counter
  output logic accum,		// enable write to accum_reg
  output logic vld			// asserted for 1 clk when mv[1:0] is valid
);

  ///////////////////////////////////////////////
  // Declare your states...IDLE done for you. //                                                    //
  // Give the states meaningful names.       //
  ////////////////////////////////////////////
  typedef enum reg[3:0] {IDLE=4'b0001, AX_SAMP=4'b0010, CHECK=4'b0100, WAIT=4'b1000} state_t;
  
  ///////////////////////////////////////
  // Declare nxt_state of our state_t //
  /////////////////////////////////////
  state_t nxt_state;
  
  //////////////////////////////////
  // Declare any internal signsl //
  ////////////////////////////////
  logic [3:0] state;
  
  //////////////////////////////
  // Instantiate state flops //
  ////////////////////////////
  state4_reg iST(.clk(clk), .rst_n(rst_n), .nxt_state(nxt_state), .state(state));
  
  //////////////////////////////////////////////
  // State transitions and outputs specified //
  // next as combinational logic with case  //
  ///////////////////////////////////////////		
  always_comb begin
	/////////////////////////////////////////
	// Default all SM outputs & nxt_state //
    // nxt_state is done for you.        //
	//////////////////////////////////////
	nxt_state = state_t'(state);
	selAZ = 1'b0;
    zeroSrc1 = 1'b0;
    accum = 1'b0;
    inc_smpl = 1'b0;
    vld = 1'b0;

    case (state)
      IDLE: begin
        if (rdy) begin
          selAZ = 1'b0;       // select AX
          zeroSrc1 = 1'b1;    // zero into src1
          accum = 1'b1;
          nxt_state = AX_SAMP;
        end
      end

      AX_SAMP: begin
        selAZ = 1'b1;         // select AZ
        zeroSrc1 = 1'b0;      // accum into src1
        accum = 1'b1;
        nxt_state = CHECK;
      end

      CHECK: begin
        if (smpl == 2'b11) begin
          vld = 1'b1;
          nxt_state = IDLE;
        end else begin
          inc_smpl = 1'b1;
          nxt_state = WAIT;
        end
      end

      WAIT: begin
        if (rdy) begin
          selAZ = 1'b0;       // select AX
          zeroSrc1 = 1'b0;    // accum into src1
          accum = 1'b1;
          nxt_state = AX_SAMP;
        end
      end

      default: nxt_state = IDLE;
    endcase
      end
		
endmodule