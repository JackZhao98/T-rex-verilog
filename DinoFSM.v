module DinoFSM(
	       /*input wire 	 clk,*/
	       input wire 	 rst,
	       input wire 	 animationClk,
	       input wire 	 Airborne,
	       input wire 	 onGround,
	       input wire 	 isDuck,
	       input wire 	 isDead,
	       /*input wire 	 isPaused,*/
 	       output wire [3:0] DinoMovementSelect);

   reg [3:0] 			 select;
   
   always @(*) begin
      if (rst) begin
        select <= 4'b0000;
      end

      else if (isDead) begin
        select <= 4'b0010;
      end

      else if (Airborne) begin
        select <= 4'b0011;
      end
      
      /*else if (isPaused) begin
        select <= 4'b0011;
      end*/

      else if (onGround) begin
        if (animationClk)
          select <= (isDuck)? 4'b0101:4'b0001;
        else
	      select <= (isDuck)? 4'b0000:4'b0100;
      end

   end // always @ (posedge clk or posedge rst)
   
   assign DinoMovementSelect = select;
   
endmodule // DinoFSM
