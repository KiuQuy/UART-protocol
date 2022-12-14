module uart_tx
  #(
  parameter DBIT = 8,  // data bit
             SB_TICK = 16// ticks for stop bit
  )
  (
  input wire clk, reset,
  input wire tx_start, s_tick,
  input wire [7:0] din,
  output reg tx_done_tick,
  output wire tx
  );
  // symbolic state declaration
  localparam [1:0]
    idle  = 2'b00,
	start = 2'b01,
    data  = 2'b10,
    stop  = 2'b11;
  // signal declaration
  reg [1:0] state_reg, state_next;
  reg [3:0] s_reg, s_next; // s dem den 15
  reg [2:0] n_reg, n_next; // n dem tu 1 den 7 thoi
  reg [7:0] b_reg, b_next;
  reg tx_reg, tx_next;
  // body 
  //fsmd state & data register
  always @(posedge clk, negedge reset, posedge s_tick)
  if(reset)
    begin
	  state_reg <= idle;
	  s_reg     <= 0;
	  n_reg     <= 0;
	  b_reg     <= 0;
	  tx_reg    <= 1'b1;
	end
  else
    begin  
	  state_reg <= state_next;
	  s_reg     <= s_next;
	  n_reg     <= n_next;
	  b_reg     <= b_next;
	  tx_reg    <= tx_next;
	end
	// FSMD next state logic & functional units
	always @ (*)
	begin
	  state_next = state_reg;
	  tx_done_tick = 1'b0;
	  s_next = s_reg;
	  n_next = n_reg;
	  tx_next = tx_reg;
	  b_next = b_reg;
	  case(state_reg)
	    idle:
		  begin
		    tx_next = 1'b1;
			if(tx_start == 1'b1)
			  begin  
			    state_next = start;
				s_next     = 0;
				b_next     = din;
			  end
		  end
		start:
		  begin 
		    tx_next = 1'b0;
			if(s_tick == 1'b1)
			  if(s_reg == 15)
			    begin
				  state_next = data;
				  s_next     = 0;
				  n_next     = 0;
				end
			  else
			    s_next = s_reg + 1;
		  end
		data:
		  begin
		    tx_next = b_reg[0];
			if(s_tick == 1'b1)
			  if(s_reg == 15)
			    begin 
				  s_next = 0;
				  b_next = {1'b0, b_reg[DBIT - 1 : 1]};   // dich phai
				  if(n_reg == (DBIT - 1))
				    begin
				      state_next = stop;
					  n_next = 0;
					  s_next = 0;
					end
				  else  
				    n_next = n_reg + 1;
				end
			  else
			    s_next = s_reg + 1;
		  end
		stop:
		  begin
		    tx_next = 1'b1;
			if(s_tick == 1'b1)
			  if(s_reg == 15)
			    begin
				  state_next = idle;
				  s_next     = 0;
				  n_next     = 0;
				  tx_done_tick = 1'b1;
				end
			  else
			    s_next = s_reg + 1;
		  end
		default:
		  state_next = idle;
		endcase
	end
	//output
	assign tx = tx_reg;
endmodule
				  
				
			