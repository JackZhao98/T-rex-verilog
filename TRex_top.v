module TRexTop(
	       input wire 	clk,
	       input wire 	btnR, // Reset button
	       input wire 	duckButton,
	       input wire 	jumpButton,
	       output wire 	Hsync,
	       output wire 	Vsync,
	       output reg [2:0] vgaRed,
	       output reg [2:0] vgaGreen,
	       output reg [1:0] vgaBlue,
               output wire 	led,
               output wire 	run,
               output wire 	dead);

   localparam ratio = 1;
   localparam ScreenH = 480;
   localparam ScreenW = 640;

   wire [9:0] x;       // VGA pixel scan X      
   wire [8:0] y;       // VGA pixel scan Y
   wire [8:0] GroundY; // Horizon Y coordinate

   wire [10:0] dinoX;
   wire [8:0] dinoY;
   wire [6:0] DinoH;
   wire [7:0] DinoW;

   wire [10:0] ObsX;
   wire [8:0]  ObsY;
   wire [6:0]  ObsH;
   wire [7:0]  ObsW;
   
   wire  pixel_clk;     // 25Mhz pixel scan clock rate
   wire  animateClock;  // controls the animation of dino's foot step, and bird wings
   wire  ScoreClock;    // Speed of Score coutner (1s = 10 points)
   wire  Frame_Clk;     // 60 FPS
	 wire  moveClk;

   wire  rst;
   wire  jump;
   wire  duck;

   localparam dx = 5'd30;
   // Initial assignments
   assign GroundY = ScreenH - (ScreenH >> 2);   // Ground Y coordinate assignment
   // 640 - 160 = 480 --> Bottom 25 %


   // Begin of clock divider.
   // Output: pixel_clk ==> 25MHz Clock
   // wire 			 pixel_clk;
   vgaClk _vgaClk(.clk(clk), 
                  .pix_clk(pixel_clk));
   // Now pixel_clk is a 25MHz clock, hopefully.

   // wire 			 animateClock;
   ClockDivider #(.velocity(4))   
      animateClk (.clk(clk),
                  .speed(animateClock));
   
   ClockDivider #(.velocity(10))  // Period = 0.1s
      ScoreClkv (.clk(clk),
                 .speed(ScoreClock));
   
   ClockDivider #(.velocity(50))  // Period = 0.1s
      FPSClk (.clk(clk),
                 .speed(Frame_Clk));
					  
	ClockDivider #(.velocity(400))
		MoveClk (.clk(clk),
				   .speed(moveClk));
	
   // Begin of Debouncer Module

   // wire       rst;
   Debouncer resetButton (
       .button_in(btnR),
       .clk(clk),
       .button_out(rst));

   // wire       jump;
   Debouncer jumpBtn (
       .button_in(jumpButton/* Assign button */),
       .clk(clk),
       .button_out(jump));

   // wire       duck;
   Debouncer duckBtn(
       .button_in(duckButton/* Assign button */),
       .clk(clk),
       .button_out(duck));

   // End of debouncer
   


   /* Main Game Control Unit */

   /* Game Delegate is a FSM
      00 - Initial state:
           The game is frozen, everything is at there 
           initial positon:
           Obstacles X = ScreenW + someOffset
           DinoX = defaultDinoX
           DinoY = GroundY
      01 - Gaming State:
           The game starts. Triggered by the 'initial jump'
      10 - Dead State:
           The game is frozen, dead dino and game over msg displayed.
      
      (01 - restart -)-> 00 -- Jump ----> 10 ------- Collided ---> 01 (Dead)
                                     ^          |
                                     |          |
                                     |_!Collide_|
   */ 
   wire [1:0] gameState;	// wire[1] is run;

   GameDelegate gameFSM(
          .clk(clk),
          .rst(rst),
          .jump(jump),
          .collided(collided),
          .state(gameState));

   // Begin of VGA module

   VGA vga(.pixel_clock(pixel_clk),
           .rst(rst),
           .Hsync(Hsync),
           .Vsync(Vsync),
           .X(x),
           .Y(y));

   // End of VGA

   wire 			 BackGround_inGrey;

   BackGroundDelegate #(.ratio(ratio), .dx(dx))
       BGD (.moveClk(moveClk),
            .rst(rst),
            .GroundY(GroundY),
            .vgaX(x),
            .vgaY(y),
            .gameState(gameState),
            .inGrey(BackGround_inGrey));

   /* Horizon movement */
		
   wire ScoreBoard_inGrey;

   ScoreBoardDelegate SBD(.ScoreClock(ScoreClock & gameState[1]),
                          .rst(rst),
                          .gameState(gameState),
                          .vgaX(x),
                          .vgaY(y),
                          .inGrey(ScoreBoard_inGrey));

      
   wire        dino_inWhite;
   wire        dino_inGrey;
   
   TRexDelegate #(.ratio(ratio))
      TRD (.rst(rst),
           .animationClk(animateClock),
           .FrameClk(Frame_Clk),
           .jump(jump),
           .duck(duck),
           .gameState(gameState),
           .GroundY(GroundY),
           .vgaX(x),
           .vgaY(y),
           .inGrey(dino_inGrey),
           .inWhite(dino_inWhite));


   wire obstacle_inWhite;
   wire obstacle_inGrey;
   
   ObstaclesDelegate #(.ratio(ratio), .dx(dx))
      OD (.clk(clk),
          .moveClk(moveClk & gameState[1]),
          .rst(rst),
          .ObstacleY(GroundY),
          .vgaX(x),
          .vgaY(y),
          .gameState(gameState),
          .inGrey(obstacle_inGrey),
          .inWhite(obstacle_inWhite));
			 
   /* Color Select */
   wire isGrey;
   wire isWhite;
   wire isBackGround;
   
   assign isGrey = dino_inGrey | BackGround_inGrey | ScoreBoard_inGrey | obstacle_inGrey;
   assign isWhite = dino_inWhite | obstacle_inWhite;
   assign isBackGround = (x > 0) && (x <= ScreenW) && (y > 0) && (y <= ScreenH) && !isGrey;

   /* Assign Values to color select wires */
   always @(posedge pixel_clk) begin
     if (isWhite) begin
       vgaRed <= 3'b111;
       vgaGreen <= 3'b111;
       vgaBlue <= 2'b11;
     end

     else if (isGrey) begin
       vgaRed <= 3'b000;
       vgaGreen <= 3'b000;
       vgaBlue <= 2'b00;
     end

     else if (isBackGround) begin
       vgaRed <= 3'b111;
       vgaGreen <= 3'b111;
       vgaBlue <= 2'b11;
       end
     else   // defualt 
     begin
       vgaRed <= 3'b000;
       vgaGreen <= 3'b000;
       vgaBlue <= 2'b00;
     end
   end

   assign led = collided;
   assign run = gameState[1];
   assign dead = gameState[0];

   assign collided = obstacle_inGrey & dino_inGrey;
   
endmodule // top_vga
