module SerialRX(
  input clk,                // 50MHz clk
  input rst_n,              // active low asynch reset
  input RX,                 // raw asynch Serial input
  output [3:0] rx_data,     // received data
  output logic rdy          // high for 1 clk when data becomes ready
);
    //// Define states of SM ////
    typedef enum reg[2:0] {IDLE=3'b001, RCV=3'b010, STP=3'b100} state_t;
  
	/////////////////////////////
	// declare state register //
	///////////////////////////
	state_t nxt_state;
    
    /////////////////////////////////////////////////////////
    // Declare any needed internal signals and SM outputs //
    ///////////////////////////////////////////////////////
    logic RX_synch;     // synchronized RX from SerialShftReg
    logic baud_time;    // from baud counter time to shift
    logic shft;         // actually shift (SM qualified version of baud_time)
    logic load;
    logic [2:0] bit_cnt;
    logic [2:0] state;
	
    //////////////////////////////
	// Instantiate state flops //
	////////////////////////////
	state3_reg iST(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));								 

	//////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	always_comb begin
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		// (OK...nxt_state done for you)     //
		//////////////////////////////////////
		nxt_state = state_t'(state);
		load = 0;
        	shft = 0;
        		rdy  = 0;

          case (state)
            
            IDLE: begin
                if (RX_synch == 0) begin // detect falling edge start bit
                    load = 1;           // load baud counter (to count 128 cycles)
                    nxt_state = RCV;
                end
            end

            RCV: begin
                if (baud_time) begin    // at middle of each bit
                    shft = 1;          // shift RX into shift reg
                    if (bit_cnt == 3'd4) begin
                        nxt_state = STP;
                    end
                end
            end

            STP: begin
                if (baud_time) begin    // middle of stop bit
                    rdy = 1;            // data is valid!
                    nxt_state = IDLE;
                end
            end

            default: begin
                nxt_state = IDLE;
            end
        endcase
    end
    

    ////////////////////////////////////////
    // Instantiate serial shift register //
    //////////////////////////////////////
    SerialShftReg iSHFT_REG(.clk(clk), .rst_n(rst_n), .RX_raw(RX), .shft(shft), 
                       .RX_synch(RX_synch), .rx_data(rx_data));
                       
    ///////////////////////////////
    // Instantiate Baud Counter //
    /////////////////////////////
    BaudCnt iBAUD(.clk(clk), .rst_n(rst_n), .load(load), .shft(baud_time));
    
    //////////////////////////////
    // Instantiate Bit Counter //
    ////////////////////////////
    BitCnt iBIT_CNT(.clk(clk), .rst_n(rst_n), .clr(load), .shft(shft), .bit_cnt(bit_cnt));    
    
endmodule
      