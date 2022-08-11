module uart_tx_tb();
    localparam T = 10;
    parameter DBIT=8;
    reg clk, reset;
    reg tx_start, s_tick;
    reg [7:0] din;
    wire tx_done_tick;
    wire tx;
    
    uart_tx  uart_tx_uut
	(
	.din(din), 
	.clk(clk), 
	.reset(reset), 
	.tx_start(tx_start), 
	.s_tick(s_tick), 
	.tx_done_tick(tx_done_tick), 
	.tx(tx)
	);
    always 
      begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
      end
    initial
      begin
	    s_tick = 0;
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
      end
	always
      begin
        repeat(1000)
		  begin
		    #1630 s_tick = 1;
			#10   s_tick = 0;
		  end
      end
	  
	
    initial
      begin
        tx_start = 0;
        #(2*T) tx_start = 1;
        din = $random;	
		#(2*T) tx_start = 0;
		//////////////////////
		#270000 tx_start = 1;
		din = $random;
		#(2*T) tx_start = 0;
		//////////////////////
		#270000 tx_start = 1;
		din = $random;
		#(2*T) tx_start = 0;
      end
    
endmodule