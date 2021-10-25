// TimingGeneratorModel.v (Timing Generator model)
//   TriggerManager simulation model for EasirocModule XCELIUM simulation
//   original 20200107 H.SATO
//

`timescale  100ps/10ps
`define  PERIOD       16'h0200    // 16bit hexadecimal decimal: 512
`define  MAX_CYCLE    20'h00008
`define  HOLD_RISE    16'h0000    // decimal: 0
`define  HOLD_WIDTH   16'h0002    // decimal: 2
`define  CLEAR_RISE   16'hf000
`define  CLEAR_WIDTH  16'h0002
`define  ACCEPT_RISE  16'h0080
`define  ACCEPT_WIDTH 16'h0002
`define  TSTOP_RISE   16'h0060
`define  TSTOP_WIDTH  16'h0002
module TimingGeneratorModel(
                 input  wire  clk_50M,
                 output wire  DIN,
                 output wire  SYNCIN,
                 output wire  TSTOP,
                 output wire  ACCEPT,
                 output wire  CLEAR,
                 output wire  HOLD
                );

   reg [15:0] cycle_r;
   reg [19:0] cycle_num_r;
   reg        hold_r;
   reg        clear_r;
   reg        accept_r;
   reg        tstop_r;
   reg        syncin_r;
   reg        din_r;
      
   reg        run_r;
   wire       clk;
   event      TG_start;
   event      TG_stop;
   reg[3:0]   mode;
   
   //assign clk = tb_top.u_TopLevel.clk_5MHz;
   //assign clk = tb_top.u_TopLevel.SitcpClk;
   assign clk       = clk_50M;
   assign HOLD      = hold_r;
   assign CLEAR     = clear_r;
   assign ACCEPT    = accept_r;
   assign TSTOP     = tstop_r;
   assign SYNCIN    = syncin_r;
   
   initial begin
      cycle_r = 16'h0000;
      hold_r  = 1'b0;
      clear_r = 1'b0;
      accept_r= 1'b0;
      tstop_r = 1'b0;
      syncin_r= 1'b0;
      din_r   = 1'b0;
      run_r   = 1'b0;
      cycle_num_r = 20'h00000;
      //mode    = 0;
      mode    = 4'h7; // add for test
      -> TG_start; // add for test
   end
    
   always @(TG_start) begin
      @(posedge clk) begin
	 run_r = 1'b1;
	 cycle_r = 16'h0000;
	 cycle_num_r = 20'h00000;
      end
   end
   
   always @(TG_stop) begin
      @(posedge clk) begin
	 run_r = 1'b0;
	 cycle_r = 16'h0000;
	 cycle_num_r = 20'h00000;
      end
   end
  

	always @(posedge clk) begin
    	if(run_r)begin
        	if(cycle_r >= `PERIOD)begin
            	cycle_r <= 16'h0000;
            	cycle_num_r <= cycle_num_r + 1;
         	end
         	else cycle_r <= cycle_r + 16'h0001;

			if(cycle_num_r == `MAX_CYCLE) begin
	    		run_r <= 1'b0;
	    		cycle_r <= 16'h0000;
	    		cycle_num_r <= 20'h00000;
	          //$display("finish in CCC_mode, reached MAX_CYCLE");
            	//$finish;
         	end
      	end
	end

	always @(posedge clk) begin
		// 4bit hexiadeci, 2,3,5,7
    	if(mode == 4'h2 || mode == 4'h3 || mode == 4'h5 || mode == 4'h7)begin
	 		if(run_r)begin
            	if(cycle_r == `HOLD_RISE)begin
               		hold_r <= 1'b1; // 1bit binary 1
            	end
            	else if(cycle_r == `HOLD_RISE + `HOLD_WIDTH)begin
               		hold_r <= 1'b0;
            	end
	 		end
      	end
	end

   	always @(posedge clk) begin
    	if(mode == 4'h4 || mode == 4'h5 || mode == 4'h6 || mode == 4'h7)begin
	 		if(run_r)begin
            	if(cycle_r == `ACCEPT_RISE)begin
               		accept_r <= 1'b1;
            	end
            	else if(cycle_r == `ACCEPT_RISE + `ACCEPT_WIDTH)begin
               		accept_r <= 1'b0;
            	end
	 		end
      	end
	end

   	always @(posedge clk) begin
    	if(mode == 4'h1 || mode == 4'h3 || mode == 4'h6 || mode == 4'h7)begin
	 		if(run_r)begin
            	if(cycle_r == `TSTOP_RISE)begin
               		tstop_r <= 1'b1;
            	end
            	else if(cycle_r == `TSTOP_RISE + `TSTOP_WIDTH)begin
               		tstop_r <= 1'b0;
            	end
	 		end
      	end
	end

	always @(posedge clk) begin
        if(run_r)begin
            if(cycle_r == `CLEAR_RISE)begin
                clear_r <= 1'b1;
            end
            else if(cycle_r == `CLEAR_RISE + `CLEAR_WIDTH)begin
                clear_r <= 1'b0;
            end
        end
    end

endmodule
