module DinoFSM(
	       /*input wire 	 clk,*/
	       input wire 	 rst,
	       input wire 	 animationClk,
           input wire [1:0] gameState,
	       input wire 	 Airborne,
	       input wire 	 onGround,
	       input wire 	 isDuck,
 	       output wire [3:0] DinoMovementSelect);

   reg [3:0] 			 select;
   
   always @(*) begin
      if (rst) begin
        select <= 4'b0000;
      end
      
      else begin
          case (gameState)
            2'b00: select <= 4'b0011;
            2'b01: select <= 4'b0010;
            2'b10: begin
                if (Airborne) begin
                    select <= 4'b0011;
                end
                
                else if (onGround) begin
                    if (animationClk)
                      select <= (isDuck)? 4'b0101:4'b0001;
                    else
                      select <= (isDuck)? 4'b0000:4'b0100;
                end
            end
            default: select <= 4'b0011;
          endcase
      end
   end // always @ (posedge clk or posedge rst)
   
   assign DinoMovementSelect = select;
   
endmodule // DinoFSM
