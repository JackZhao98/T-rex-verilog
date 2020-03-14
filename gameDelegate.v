module GameDelegate(
		    input wire clk,
		    input wire rst,
			input wire jump,
            input wire restart,
			input wire collided,
		    output reg [1:0] state); // what if we use wire ?? 

  localparam InitState = 2'b00;   // init 
  localparam InGameState = 2'b10; // wait for collidie 
  localparam DeadState = 2'b01;  // after collide 
  
  always @(posedge clk) begin
        
		case (state)
		InitState: begin
			if (jump) /// input 
				state <= InGameState;
			else 
				state <= state;
		end
		
		InGameState: begin
			if (collided)
				state <= DeadState;
            else if (rst)
                state <= InitState;
			else
				state <= InGameState;
		end
		
		DeadState: begin
			if (restart || rst)
				state <= InitState;
			else
				state <= DeadState;
		end
		default:
			state <= InitState;
		endcase
  end

endmodule // gameDelegate
