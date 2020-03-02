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




   // Begin of clock divider.

   // Output: pixel_clk ==> 25MHz Clock
   // wire 			 pixel_clk;
   vgaClk _vgaClk(.clk(clk), 
		              .pix_clk(pixel_clk));
   // Now pixel_clk is a 25MHz clock, hopefully.
   // End of Clock Divider


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

   VGA vga(
           .pixel_clock(pixel_clk),
           .rst(rst),
           .Hsync(Hsync),
           .Vsync(Vsync),
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
		
   
   // Numbers (Score board)
   wire [31:0]       Num1_x;
   wire [31:0] 	     Num1_y;
   wire [31:0]       Num2_x;
   wire	[31:0]       Num2_y;
   wire [31:0]       Num3_x;
   wire	[31:0]       Num3_y;
   wire [31:0]       Num4_x;
   wire	[31:0]       Num4_y;
   
   wire [10:0] 	     Num_H;
   wire [10:0] 	     Num_W;

   assign Num_W = 20;
   assign Num_H = 21;

   wire        Num1_inGrey;
   wire	       Num2_inGrey;
   wire	       Num3_inGrey;
   wire	       Num4_inGrey;
   /* Assign Number Position */
   localparam num_top_right_x = ScreenW - 30 - Num_W;
   localparam num_top_y = 30;
   localparam num_gap = 10;
   
   assign Num4_x = num_top_right_x;
   assign Num3_x = Num4_x - Num_W - num_gap;
   assign Num2_x = Num3_x - Num_W - num_gap;
   assign Num1_x = Num2_x - Num_W - num_gap;
   assign Num4_y = num_top_y;
   assign Num3_y = Num4_y;
   assign Num2_y = Num3_y;
   assign Num1_y = Num2_y;

   reg [3:0]       Num1_SEL;
   reg [3:0]       Num2_SEL;
   reg [3:0]       Num3_SEL;
   reg [3:0]       Num4_SEL;
   
   /* Number SEL module here */

   drawNumber #(.ratio(ratio))
      Num1 (.rst(rst),
	    .ox(Num1_x),
	    .oy(Num1_y)),
	    .X(x),
	    .Y(y),
	    .select(Num1_SEL),
	    .inGrey(Num1_inGrey));

   drawNumber #(.ratio(ratio))
      Num2 (.rst(rst),
            .ox(Num2_x),
            .oy(Num2_y),
            .X(x),
            .Y(y),
            .select(Num2_SEL),
            .inGrey(Num2_inGrey));

   drawNumber #(.ratio(ratio))
      Num3 (.rst(rst),
            .ox(Num3_x),
            .oy(Num3_y),
            .X(x),
            .Y(y),
            .select(Num3_SEL),
            .inGrey(Num3_inGrey));

   drawNumber #(.ratio(ratio))
      Num4 (.rst(rst),
            .ox(Num4_x),
            .oy(Num4_y),
            .X(x),
            .Y(y),
            .select(Num4_SEL),
            .inGrey(Num4_inGrey));
   
// T-Rex vertical jump simulator   

   // Vert_Velocity = a*t
   reg [31:0] 			 DinoX;
   reg [31:0] 			 DinoY;
   wire [10:0] 			 DinoH;
   wire [10:0] 			 DinoW;

   wire 			 Airborne;
   wire 			 onGround;
   wire 			 isDuck;
   wire 			 isDead;

   assign Airborne = (DinoY < GroundY)? 1:0;
   assign onGround = (DinoY == GroundY)? 1:0;
   assign isDuck = duck;
   /* assign isDead */
   /* 
    
      Dino Art
   */
   wire 			 dino_inWhite;
   wire 			 dino_inGrey;
   wire [3:0] 			 dinoSEL;
   
   drawDino #(.ratio(ratio))
     dino (
       .rst(rst),
       .ox(DinoX),
       .oy(DinoY),
       .X(x),
       .Y(y),
       .select(dinoSEL),
       .objectWidth(dinoW),
       .objectHeight(dinoH),
       .inWhite(dino_inWhite),
       .inGrey(dino_inGrey));
   
   /*
      Dino Movement
   */
   wire [10:0] 			 Y_Displacement;
   wire [10:0] 			 V0;
   
   assign V0 = (jump || Airborne)? -20:0;
      
   Gravity #(.g(1), .InitialVelocity(V0))
       dinoG(.rst(rst),
	     .GroundY(GroundY - DinoH),
	     .Y(DinoY),
	     .Displacement(Y_Displacement));

   always @(*) begin
      if (rst) begin
	       DinoY <= GroundY;
      end
      else
	       DinoY <= DinoY + Y_Displacement; 
   end
   



   /* Color Select */
   wire isGrey;
   wire isWhite;
   wire isBackGround;

   /* Assign Values to color select wires */


   reg [2:0] red;
   reg [2:0] green;
   reg [1:0] blue;
   /* always */
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
       red <= 3'b100;
       green <= 3'b100;
       blue <= 2'b10;
     end
   end

   assign vgaRed = red;
   assign vgaGreen = green;
   assign vgaBlue = blue;
      
endmodule // top_vga
