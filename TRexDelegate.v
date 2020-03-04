module TRexDelegate #(parameter ratio=1, V_init = -10'd99, g = 4'd1)(
    input wire rst,
    input wire animationClk,
    input wire FrameClk,
    input wire jump,
    input wire duck,
    input wire [10:0] GroundY,
    input wire [10:0] vgaX,
    input wire [10:0] vgaY,
    output wire [10:0] Dino_X,
    output wire [10:0] Dino_Y,
    output wire [9:0] DinoHeight,
    output wire [9:0] DinoWidth,
    output wire inGrey,
    output wire inWhite);
	

    reg [10:0]	DinoX;
    reg [10:0]	DinoY;
    wire [11:0]	DinoH;
    wire [11:0]	DinoW;

    wire [10:0] defaultX;
    wire [10:0] defaultY;
    assign defaultX = 10'd50;
    assign defaultY = GroundY;

    wire	Airborne;
    wire	onGround;
    wire	isDuck;
    wire	isDead;

    assign Airborne = (DinoY < defaultY)? 1:0;
    assign onGround = (DinoY >= defaultY)? 1:0;
    assign isDuck = duck;

    wire	dino_inWhite;
    wire	dino_inGrey;
    wire [3:0]	dinoSEL;


   /*
      Dino Movement
   */
   reg [10:0] 			 local_V;
   
   /* Gravity Module */
    always @(posedge FrameClk) begin
        if (onGround && jump) begin
            local_V <= V_init;
        end
        else if (local_V > 0 && onGround) 
            local_V <= 0;
        else begin
            local_V <= local_V + g;
        end
    end
    
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= defaultY;
        end

        /*else if (jump && onGround) begin
        end*/

        else if (/*local_V > 0 && */Airborne || jump) begin
            DinoY <= DinoY + local_V; 
            DinoX <= defaultX;
        end

        else begin
            DinoX <= defaultX;
            DinoY <= defaultY;
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
