/*
frame = start bit + data bit + stop bit
Testbench nay kiem tra 
  1. mot data -> transmitter cua uart -> frame
  2. frame -> receiver cua uart -> data
  
Luu y voi ben transmitter co con tro wr co the on/off
 tuong tu voi ben receiver co con tro rd co the on/ off
 Va khi chay testbench thi khoi tai cho no bang 1
*/

module tb_uart;
  localparam DBIT = 8;
  // all
  reg clk, reset;
  // receiver port
  reg rx, rd;
  wire [DBIT - 1 : 0] r_data;
  wire empty;
  
  // transmitter port
  reg [DBIT - 1 : 0] w_data;
  reg wr;
  wire tx;
  wire full;
  uart uut
  (
  // all
  .clk(clk),   //
  .reset(reset),   //
  // transmitter
  .w_data(w_data),    //
  .wr(wr),   //
  .tx(tx),
  .full(full),
  //receiver
  .r_data(r_data),    
  .empty(empty),  //
  .rd(rd),      //
  .rx(tx)  //
  );
  
  
  
  initial 
    begin
	  clk = 0;
	  forever #5 clk = ~clk;
	end
  initial
    begin
	wr = 1;
	rd = 1;
	reset = 1;
	#5 reset = 0;
	end
	
	
// DATA bit
  always #300000 w_data = $random;
endmodule