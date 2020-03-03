module top_vga(
	       input wire 	 clk,
	       input wire 	 btnR, // Reset button
	       input wire 	 duckButton,
	       input wire 	 jumpButton,
	       output wire 	 Hsync,
	       output wire 	 Vsync,
	       output wire [2:0] vgaRed,
	       output wire [2:0] vgaGreen,
	       output wire [1:0] vgaBlue);

   localparam ratio = 1;
   localparam ScreenH = 480;
   localparam ScreenW = 640;

   wire [31:0] x;       // VGA pixel scan X      
   wire [31:0] y;       // VGA pixel scan Y
   wire [31:0] GroundY; // Horizon Y coordinate

   wire  pixel_clk;     // 25Mhz pixel scan clock rate
   wire  animateClock;  // controls the animation of dino's foot step, and bird wings
   // wire  ObstacleClock; // controls the speed of Ground & Obstacle movement
   wire  ScoreClock;    // Speed of Score coutner (1s = 10 points)
   wire Frame_Clk;

   wire  rst;
   wire  jump;
   wire  duck;

   wire [3:0] dx = 4'd5;
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
   ClockDivider #(.velocity(2))   
      animateClk (.clk(clk),
                  .speed(animateClock));

   // wire 			 ObstacleClock;
   // ClockDivider #(.velocity(100))
   //    ObstacleClk (.clk(clk),
   //                 .speed(ObstacleClock));
   
   ClockDivider #(.velocity(10))  // Period = 0.1s
      ScoreClkv (.clk(clk),
                 .speed(ScoreClock));

   // Begin of Debouncer Module

   // wire       rst;
   Debouncer resetButton (
       .button_in(btnR),
       .clk(clk),
       .button_out(rst));

   // wire       jump;
   Debouncer jumpButton (
       .button_in(jumpButton/* Assign button */),
       .clk(clk),
       .button_out(jump));

   // wire       duck;
   Debouncer duckButton(
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
      
      (10 - restart -)-> 00 -- Jump ----> 01 ------- Collided ---> 10 (Dead)
                                     ^          |
                                     |          |
                                     |_!Collide_|
   */ 
   wire [1:0] gameState;

   GameDelegate gameFSM(
          .clk(clk),
          .rst(rst),
          .gameState(gameState));


 
   // Begin of VGA module
   // Some Constant for VGA module
   // localparam ScreenH = 480;
   // localparam ScreenW = 640;
   // wire [31:0] x;
   // wire [31:0] y;

   VGA vga(.pixel_clock(pixel_clk),
           .rst(rst),
           .Hsync(Hsync),
           .Vsync(Vsync),
           .FPSClk(Frame_Clk),
           .X(x),
           .Y(y));

   // End of VGA

   wire 			 BackGround_inGrey;

   BackGroundDelegate #(.ratio(ratio), .dx(dx))
       BGD (.FrameClk(FrameClk),
            .rst(rst),
            .GroundY(GroundY),
            .vgaX(x),
            .vgaY(y),
            .gameState(gameState),
            .inGrey(BackGround_inGrey));

   /* Horizon movement */
		
   wire ScoreBoard_inGrey;

   ScoreBoardDelegate SBD(.ScoreClock(ScoreClock),
                          .rst(rst),
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
           .GroundY(GroundY),
           .vgaX(x),
           .vgaY(y),
           .DinoHeight(DinoH),
           .DinoWidth(DinoW),
           .inGrey(dino_inGrey),
           .inWhite(dino_inWhite));


   wire obstacle_inWhite;
   wire obstacle_inGrey;

   ObstaclesDelegate #(.ratio(ratio), .dx(dx))
      OD (.clk(clk),
          .FrameClk(Frame_Clk),
          .rst(rst),
          .ObstacleY(GroundY),
          .vgaX(x),
          .vgaY(y),
          .gameState(gameState),
          .inGrey(obstacle_inGrey),
          .inWhite(obstacle_inWhite),
          .Obs1_W(Obs1_W),
          .Obs1_H(Obs1_H),
          .Obs2_W(Obs2_W),
          .Obs2_H(Obs2_H),
          .Obs3_W(Obs3_W),
          .Obs3_H(Obs3_H));

   



   // 关于选择RGB颜色的模块
   // 希望能好用。。

   /* Color Select */
   wire isGrey;
   wire isWhite;
   wire isBackGround;

   assign isGrey = dino_inGrey | Ground_1_inGrey | Ground_2_inGrey | ScoreBoard_inGrey;
   assign isWhite = dino_inWhite | obstacle_inWhite;
   assign inBackGround = (x > 0) && (x <= ScreenW) 
                      && (y > 0) && (y <= ScreenH) 
                      && !inWhite && !inGrey;
   /* Assign Values to color select wires */


   reg [2:0] red;
   reg [2:0] green;
   reg [1:0] blue;
   
   always @(posedge Frame_Clk) begin
     if (isGrey) begin
       red <= 3'b000;
       green <= 3'b000;
       blue <= 2'b00;
     end

     else if (isWhite) begin
       red <= 3'b111;
       green <= 3'b111;
       blue <= 2'b11;
     end

     else if (isBackGround) begin
       red <= 3'b111;
       green <= 3'b111;
       blue <= 2'b11;
     end
   end

   assign vgaRed = red;
   assign vgaGreen = green;
   assign vgaBlue = blue;
      
endmodule // top_vga
