module uart
// Default setting
  #(
  parameter DBIT = 8,     // data bit
            SB_TICK = 16  // ticks for stop bit
  )
// Input, output**************************
  (
  input clk, reset,
  // receiver port
  input rx, rd,
  output [DBIT - 1 : 0] r_data,
  output empty,
  
  // transmitter port
  input [DBIT - 1 : 0] w_data,
  input wr,     
  output tx,
  output full
  );
  
// signal declaration***************************
   // baud rate
   wire tick;
   // transmitter side
   wire tx_done_tick;
   wire wr_uart, tx_full;
   // receiver side
   wire [DBIT - 1 : 0] dout, data;
   wire [DBIT - 1 : 0] rx_done_tick;
   wire rd_uart, rx_empty;
   
  // baud rate
  baud_rate_generator baud_rate_generator_uut
  (
  .clk(clk),
  .reset(reset),
  .s_tick(tick)
  );
  // receiver
  uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) receiver
  (
  .clk(clk),
  .reset(reset),
  .rx(rx),
  .s_tick(tick),
  .rx_done_tick(rx_done_tick),
  .dout(dout)                                // port nay loi
  );
  FIFO_buffer rx_fifo
  (
  .clk(clk),    //
  .reset(reset),  //
  .w_data(dout),  //
  .rd(rd_uart),   
  .wr(rx_done_tick),
  .r_data(data),    //output
  .full(full),              //output
  .empty(rx_empty)    // output
  );
  // transmitter
  uart_tx  #(.DBIT(DBIT), .SB_TICK(SB_TICK)) transmitter
  (
  .clk(clk),
  .reset(reset),
  .tx_start(~empty),
  .s_tick(tick),
  .din(r_data),
  .tx_done_tick(tx_done_tick),
  .tx(tx)
  );
  FIFO_buffer tx_fifo
  (
  .clk(clk),  //
  .reset(reset),   //
  .w_data(w_data),
  .rd(tx_done_tick),   //
  .wr(wr_uart),
  .r_data(r_data),
  .full(tx_full),   //
  .empty(empty)  //
  );
  
endmodule