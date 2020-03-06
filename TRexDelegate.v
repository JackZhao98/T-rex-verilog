module TRexDelegate #(parameter ratio=1, V_init = -10'd30)(
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
    assign defaultX = 10'd50;

    wire	Airborne;
    wire	onGround;
    wire	isDuck;
    wire	isDead;

    
    assign onGround = (DinoY == GroundY)? 1:0;
    assign Airborne = ~onGround;
    assign isDuck = duck;

    wire	dino_inWhite;
    wire	dino_inGrey;
    wire [3:0]	dinoSEL;
    localparam g = 4 ;


   /*
      Dino Movement
   */
   reg [5:0] h;
   reg [5:0] local_V;
   /* Gravity Module */
    always @(posedge FrameClk) begin
        if (onGround && jump) begin
            local_V <= 32;
        end
        else if (local_V != 0 && onGround) 
            local_V <= 0;
        else begin
            if (onGround)
                local_V <= local_V;
            else
                local_V <= local_V - g;
        end
    end
    
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= GroundY;
        end

        /*else if (jump && onGround) begin
        end*/

        else if (/*local_V > 0 && */Airborne || local_V  != 0) begin
            if (local_V  >= 0) begin
                DinoY <= DinoY - local_V; 
            end
            else
                DinoY <= DinoY + (~local_V+1);
            DinoX <= defaultX;
        end

        else begin
            DinoX <= defaultX;
            DinoY <= GroundY;
        end
           
    end
    /*always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= GroundY;
            V <= 0;
        end
        
        else if (onGround && jump) begin
            //$display("onGround && jump\n");
            V <= -11'd30;
        end
        
        else if (Airborne) begin
            //$display("onGround && jump\n");
            V <= V + g;
        end 
        
        else if (V >= 11'd30) begin
            //$display("onGround && jump\n");
            V <= 0;
        end
        
        else begin
            DinoY <= DinoY + V;
        end
    
    end*/

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
