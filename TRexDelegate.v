module TRexDelegate #(parameter ratio=1)(
    input wire rst,
    input wire animationClk,
    input wire FrameClk,
    input wire jump,
    input wire duck,
    input wire [1:0] gameState,
    input wire [10:0] GroundY,
    input wire [10:0] vgaX,
    input wire [10:0] vgaY,
    output wire inGrey,
    output wire inWhite);
	
    reg [5:0]	DinoX;
    reg signed [10:0]	DinoY;

    wire [5:0] defaultX;
    assign defaultX = 6'd50;


    wire	Airborne;
    wire	isDuck;
    wire	isDead;

    
    assign onGround = (DinoY >= GroundY);
    assign isDuck = duck;
    assign isDead = (gameState == 2'b01);
    wire	dino_inWhite;
    wire	dino_inGrey;
    wire [3:0]	dinoSEL; 
   /*
      Dino Movement
   */
   reg signed [6:0] V;
   reg isJumping;
   localparam g = 1;
   localparam v_init = 7'd17;
   /* Gravity Module */   
    
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= GroundY;
            isJumping <= 0;
            V <= 0;
        end
        else begin
            case (gameState)
                2'b00:
                    DinoY <= GroundY;
                    
                2'b10: begin
                    if (isJumping) begin
                        V <= V + g;
                        DinoY <= DinoY + V;
                 
                    if (DinoY >= GroundY) begin
                       
                        DinoY <= GroundY;
                        V <= 0;
                        isJumping <= 0;
                    end
                    end
                    else if (jump) begin
                        
                        isJumping <= 1;
                        V <= -v_init;
                        DinoY <= DinoY - v_init;
                    end
                    else
                        DinoY <= GroundY;     
                end
                
                2'b01:
                    DinoY <= DinoY;     
            endcase   
		end
    end

    DinoFSM fsm(
        .rst(rst),
        .animationClk(animationClk),
        .gameState(gameState),
        .Airborne(~onGround),
        .onGround(onGround),
        .isDuck(isDuck),
        .DinoMovementSelect(dinoSEL));
   
    drawDino #(.ratio(ratio))
      dino (
        .rst(rst),
        .ox(DinoX),
        .oy(DinoY),
        .X(vgaX),
        .Y(vgaY),
        .select(dinoSEL),
        .inWhite(dino_inWhite),
        .inGrey(dino_inGrey));

    assign inGrey = dino_inGrey;
    assign inWhite = dino_inWhite;

endmodule
