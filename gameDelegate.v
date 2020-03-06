module GameDelegate(
		    input wire clk,
		    input wire rst,
			input wire jump,
			input wire collided,
		    output reg [1:0] state);

  localparam InitState = 2'b00;
  localparam InGameState = 2'b10;
  localparam DeadState = 2'b01;
  
  always @(posedge clk) begin  
		case (state)
		InitState: begin
			if (jump)
				state = InGameState;
			else
				state = InitState;
		end
		
		InGameState: begin
			if (collided)
				state = DeadState;
			else
				state = InGameState;
		end
		
		DeadState: begin
			if (jump)
				state = InitState;
			else
				state = DeadState;
		end
		default:
			state = InitState;
		endcase
  end

endmodule // gameDelegate
