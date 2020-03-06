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

    
    assign onGround = (DinoY >= 300)? 1:0;
    assign Airborne = ~onGround;
    assign isDuck = duck;

    wire	dino_inWhite;
    wire	dino_inGrey;
    wire [3:0]	dinoSEL;
    localparam g = 4 ;
	 
   /*
      Dino Movement
   */
   reg [10:0] V;
	reg jumping;
	
	initial begin
	    DinoX = defaultX;
		 DinoY = 300;
		 V = 11'b0;
	end	
	
   /* Gravity Module */
    always @(posedge FrameClk) begin
        if (jump && onGround) begin
			   jumping <= 1;
				V <= -11'd20;
		  end
		  else if (jumping) begin
				if (onGround && V > 0)
					jumping <= 1'b0;
				else begin
					V <= V + g;
				end
		  end
		  else
		      V <= 11'b0;
    end
    
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            DinoX <= defaultX;
            DinoY <= GroundY;
				jumping <= 0;
        end
        else if(jumping) begin
				if (V & 11'h400 == 1)
					DinoY <= DinoY - ((~V) + 1);
				else
					DinoY <= DinoY + V;
			end
			else
				DinoY <= GroundY;
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
