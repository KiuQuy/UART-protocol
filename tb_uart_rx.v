module uart_rx_tb();
    localparam T = 10;
    parameter DBIT = 8;
    reg clk, reset;
    reg s_tick;
    wire [7:0] dout;
    wire rx_done_tick;
    reg rx;
    
    uart_rx  uart_rx_uut
	(
	.clk(clk),
	.reset(reset),
	.s_tick(s_tick),
	.dout(dout),
	.rx_done_tick(rx_done_tick),
	.rx(rx)
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
        repeat(100)
		  begin
		    // idle 
		    rx = 1'b1;
			// start bit
	        #26080 rx = 1'b0;
			// data bit
		    #26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			#26080 rx = $random;
			// stop bit
			#26080 rx = 1'b1;
		  end
		
      end
    
endmodule