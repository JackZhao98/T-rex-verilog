module TRexDelegate #(parameter ratio=1)(
    input wire rst,
    input wire animationClk,
    input wire jump,
    input wire duck,
    input wire [31:0] GroundY,
    input wire [31:0] vgaX,
    input wire [31:0] vgaY,
    output wire [10:0] DinoHeight,
    output wire [10;0] DinoWidth,
    output wire inGrey,
    output wire inWhite);
	

    reg [31:0]	DinoX;
    reg [31:0]	DinoY;
    wire [10:0]	DinoH;
    wire [10:0]	DinoW;

    wire [31:0] defaultX;
    wire [31:0] defaultY;
    assign defaultX = 32'd100;
    assign defaultY = GroundY;

    wire	Airborne;
    wire	onGround;
    wire	isDuck;
    wire	isDead;

    assign Airborne = (DinoY < GroundY)? 1:0;
    assign onGround = (DinoY >= GroundY)? 1:0;
    assign isDuck = duck;

    wire	dino_inWhite;
    wire	dino_inGrey;
    wire [3:0]	dinoSEL;


   /*
      Dino Movement
   */
   wire [10:0] 			 Y_Displacement;
   wire [10:0] 			 V0;
   
   /* Gravity Module */
   /*Gravity #(.g(1), .InitialVelocity(V0))
       dinoG(.rst(rst),
	     .GroundY(GroundY),
	     .Y(DinoY),
	     .Displacement(Y_Displacement));*/

    always @(*) begin
    	if (rst) begin
    		DinoX <= defaultX;
    		DinoY <= defaultY;
    	end
    	else begin
    		DinoY <= DinoY + Y_Displacement; 
	        DinoX <= defaultX;
    	end
	       
    end

    DinoFSM fsm(
        .rst(rst),
        .animationClk(animationClk),
        .Airborne(Airborne),
        .onGround(onGround),
        .isDuck(isDuck),
        .isDead(isDead),
        .DinoMovementSelect(dinoSEL));
   
    drawDino #(.ratio(ratio))
      dino (
        .rst(rst),
        .ox(DinoX),
        .oy(DinoY),
        .X(vgaX),
        .Y(vgaY),
        .select(dinoSEL),
        .objectWidth(dinoW),
        .objectHeight(dinoH),
        .inWhite(dino_inWhite),
        .inGrey(dino_inGrey));

    assign inGrey = dino_inGrey;
    assign inWhite = dino_inWhite;
    assign DinoWidth = DinoW;
    assign DinoHeight = DinoH;

endmodule






