//`timescale 1ns / 1ps

module baudrate_generator_test();
  localparam T = 10;
  localparam N = 8;
  reg clk, reset;
  wire s_tick;
  baud_rate_generator #(.M(163), .N(8)) DUT
  (
  .clk(clk), 
  .reset(reset), 
  .s_tick(s_tick)
  );
          	
  initial
   begin
     clk = 1'b1;
     reset = 1'b1;
     #(T/2);
     reset = 1'b0;
   end
          
   initial
     begin
       forever #(T/2) clk = ~clk;    
     end
endmodule