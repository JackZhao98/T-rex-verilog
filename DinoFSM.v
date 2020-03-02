module DinoFSM(
	       input wire   clk,
	       input wire   rst,
	       input wire   animationClk,
	       input wire   Airborne,
	       input wire   onGround,
	       input wire   isDead,
	       input wire   isPaused,
 	       output [3:0] DinoMovementSelect);

   reg [3:0] 		    select;
   
   always @(posedge clk or posedge rst) begin
      if (rst) begin
	 select <= 4'b0000;
      end

      if (isDead) begin
	 select <= 4'b0000;
	 
      if (onGround) begin
	 
	       
