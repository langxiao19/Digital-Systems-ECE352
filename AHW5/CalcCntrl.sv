module CalcCntrl (
    input clk,
    input rst_n,
    input act_rdy,
    input [1:0] step,
    output logic clk_en,
    output logic init_step,
    output logic capture
);

    //// Define states of SM ////
    typedef enum reg[1:0] {SLEEP=2'b01, CALC=2'b10} state_t;
  
	/////////////////////////////
	// declare state register //
	///////////////////////////
	state_t nxt_state;
    reg [1:0] state;
    
    //////////////////////////////
	// Instantiate state flops //
	////////////////////////////
	state2_reg iST(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));	
    
    //////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	/*always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		// (OK...nxt_state done for you)     //
		//////////////////////////////////////
		nxt_state = state_t'(state);
        //<...your SM outputs defaulted...>
        clk_en = 0;
	capture = 0;
	init_step = 0;
        case (state)
          //<<Fill in your intellectual property here>>
		SLEEP: begin
			if (act_rdy != 1) begin
				init_step = 1;
			end
			else if (act_rdy == 1) begin
				clk_en = 1;
				nxt_state = CALC;
			end		
		end
		CALC: begin
			if (step != 2'b11) begin
				clk_en = 1;
			end
			if (step == 2'b11) begin
				capture = 1;
				clk_en = 0;
				nxt_state = SLEEP;
			end
		end
        endcase
    end
    
endmodule*/
	always_comb begin
        // Default values
        nxt_state = state_t'(state);  // Stay in current state unless changed
        clk_en = 0;
        init_step = 0;
        capture = 0;

        case (state)
            SLEEP: begin
                clk_en = 0;
                if (!act_rdy) begin
                    init_step = 1;     // init step counter while idle
                end
                else begin
                    nxt_state = CALC; // start calculation
                end
            end

            CALC: begin
                clk_en = 1;
                if (step == 2'b11) begin
                    capture = 1;       // capture result
                    nxt_state = SLEEP;
                end
            end
        endcase
    end

endmodule