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
   wire  ObstacleClock; // controls the speed of Ground & Obstacle movement
   wire  ScoreClock;    // Speed of Score coutner (1s = 10 points)

   wire  rst;
   wire  jump;
   wire  duck;

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
   ClockDivider #(.velocity(100))
      ObstacleClk (.clk(clk),
		               .speed(ObstacleClock));
   
   ClockDivider #(.velocity(10))  // Period = 0.1s
      ScoreClkv (.clk(clk),
                 .speed(ScoreClock));

   // Begin of Debouncer Module

   // wire 			 rst;
   debouncer resetButton (.button_in(btnR),
			  .clk(clk),
			  .button_out(rst));


   // wire 			 jump;
   debouncer jumpButton (.button_in(jumpButton/* Assign button */),
			 .clk(clk),
			 .button_out(jump));


   // wire 			 duck;
   debouncer duckButton(.button_in(duckButton/* Assign button */),
			.clk(clk),
			.button_out(duck));

   // End of debouncer
   
   
   // Begin of VGA module
   // Some Constant for VGA module
   // localparam ScreenH = 480;
   // localparam ScreenW = 640;
   // wire [31:0] x;
   // wire [31:0] y;
   wire Frame_Clk;

   VGA vga(
           .pixel_clock(pixel_clk),
           .rst(rst),
           .Hsync(Hsync),
           .Vsync(Vsync),
           .FPSClk(Frame_Clk),
           .X(x),
           .Y(y));

   // End of VGA


   // Draw horizon (Module: BackGround)
   wire [3:0] 			 horizonSEL;   // Multiplexor
   assign horizonSEL = 4'b0000;    // 选择画地面
   
   // wire [31:0] 			 GroundY;

   reg [31:0] 			 Ground_1_X;
   reg [31:0] 			 Ground_2_X;
   reg [11:0] 			 GroundH;
   reg [11:0] 			 GroundW;

   wire 			 Ground_1_inGrey;
   wire 			 Ground_2_inGrey;
   
   drawBackGround #(.ratio(ratio))
      horizon1 (.rst(rst),
                .ox(Ground_1_X),
                .oy(GroundY),
                .X(x),
                .Y(y),
                .select(horizonSEL),
                .objectWidth(GroundW),
                .objectHeight(GroundH),
                .inGrey(Ground_1_inGrey));

   drawBackGround #(.ratio(ratio))
      horizon2 (.rst(rst),
                .ox(Ground_2_X),
                .oy(GroundY),
                .X(x),
                .Y(y),
                .select(horizonSEL),
                .objectWidth(GroundW),
                .objectHeight(GroundH),
                .inGrey(Ground_2_inGrey));

   /* Horizon movement */
		
   wire ScoreBoard_inGrey;

   ScoreBoardDelegate SBD(.ScoreClock(ScoreClock),
                          .rst(rst),
                          .vgaX(x),
                          .vgaY(y),
                          inGrey(ScoreBoard_inGrey));
      
      
      
   wire 			 dino_inWhite;
   wire 			 dino_inGrey;
   
   TRexDelegate #(.ratio(1))
      dino(.rst(rst),
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


   wire [1:0] gameState;
   GameDelegate gameFSM(
          .clk(clk),
          .rst(rst),
          .gameState(gameState));



   // 关于选择RGB颜色的模块
   // 希望能好用。。

   /* Color Select */
   wire isGrey;
   wire isWhite;
   wire isBackGround;

   assign isGrey = dino_inGrey | Ground_1_inGrey | Ground_2_inGrey | ScoreBoard_inGrey;
   assign isWhite = dino_inWhite;
   assign inBackGround = (x > 0) && (x <= ScreenW) 
                      && (y > 0) && (y <= ScreenH) 
                      && !inWhite && !inGrey;
   /* Assign Values to color select wires */


   reg [2:0] red;
   reg [2:0] green;
   reg [1:0] blue;
   
   always @(*) begin
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
