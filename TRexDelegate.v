module TRexDelegate #(parameter ratio=1, V_init = -10'd30, g = 4'd1)(
    input wire rst,
    input wire animationClk,
    input wire FrameClk,
    input wire jump,
    input wire duck,
    input wire [31:0] GroundY,
    input wire [31:0] vgaX,
    input wire [31:0] vgaY,
    output wire [31:0] Dino_X,
    output wire [31:0] Dino_Y,
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
    assign defaultX = 32'd50;
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
   reg [10:0] 			 local_V;


   
   /* Gravity Module */

    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= defaultY;
        end

        if (jump && onGround) begin
            local_V <= V_init;
        end

        else if (local_V > 0 && onGround) begin
            local_V <= 0;
            DinoX <= defaultX;
            DinoY <= defaultY;
        end

        else begin
            local_V <= local_V + g;
            DinoY <= DinoY + local_V; 
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

    assign Dino_X = DinoX;
    assign Dino_Y = DinoY;
    assign inGrey = dino_inGrey;
    assign inWhite = dino_inWhite;
    assign DinoWidth = DinoW;
    assign DinoHeight = DinoH;

endmodule
