module top_vga(
	       input wire 	 clk,
	       input wire 	 btnR, // Reset button
	       output wire 	 Hsync,
	       output wire 	 Vsync,
	       output wire [2:0] vgaRed,
	       output wire [2:0] vgaGreen,
	       output wire [1:0] vgaBlue);

   localparam ratio = 1;
   
   // Begin of clock divider.
   // Output: pixel_clk ==> 25MHz Clock
   wire 			 pixel_clk;
   vgaClk _vgaClk(.clk(clk), 
		  .pix_clk(pixel_clk));
   // Now pixel_clk is a 25MHz clock, hopefully.
   // End of Clock Divider
   wire 			 animateClock;
   ClockDivider #(.velocity(2))
      animateClk (.clk(clk),
		  .speed(animateClock));

   wire 			 ObstacleClock;
   ClockDivider #(.velocity(100))
      ObstacleClk (.clk(clk),
		   .speed(ObstacleClock));
   
   
   // Begin of Debouncer Module
   // Generate: rst
   wire 			 rst;
 
   debouncer resetButton (.button_in(btnR),
			  .clk(clk),
			  .button_out(rst));

   wire 			 jump;
   debouncer jumpButton (.button_in(/* Assign button */),
			 .clk(clk),
			 .button_out(jump));

   wire 			 duck;
   debouncer duckButton(.button_in(/* Assign button */),
			.clk(clk),
			.button_out(duck));
   // End of debouncer
   
   // Some Constant
   localparam ScreenH = 480;
   localparam ScreenW = 640;

   // Draw horizon
   wire [3:0] 			 horizonSEL;
   assign horizonSEL = 4'b0000;
   
   wire [31:0] 			 GroundY;
   assign GroundY = ScreenH - ScreenH >> 2;

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
   wire [31:0] 			 Num1_x;
   wire [31:0] 			 Num1_y;
   wire [31:0]                   Num2_x;
   wire	[31:0]                   Num2_y;
   wire [31:0]                   Num3_x;
   wire	[31:0]                   Num3_y;
   wire [31:0]                   Num4_x;
   wire	[31:0]                   Num4_y;
   
   wire [10:0] 			 Num_H;
   wire [10:0] 			 Num_W;

   assign Num_W = 20;
   assign Num_H = 21;

   wire 			 Num1_inGrey;
   wire	                         Num2_inGrey;
   wire	                         Num3_inGrey;
   wire	                         Num4_inGrey;
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

   reg [3:0] 			 Num1_SEL;
   reg [3:0]                     Num2_SEL;
   reg [3:0]                     Num3_SEL;
   reg [3:0]                     Num4_SEL;
   
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
   
   
   // Begin of VGA module
   wire [31:0] 			 x;
   wire [31:0] 			 y;
   wire 			 active;
   
   
    vga640x480 vga(
        .dclk(pixel_clk),
        .clr(rst),
        .hsync(Hsync),
        .vsync(Vsync),
        .X(x),
        .Y(y));
        
   /*VGA vga(.clk(clk),
	   .pixel_clk(pixel_clk),
	   .rst(rst),
	   .Hsync(Hsync),
	   .Vsync(Vsync),
	   .active(active),
	   .x(x),
	   .y(y));
       */
   // End of VGA module

   // SRAM buffer
   localparam DISPLAY_WIDTH = 640;
   localparam DISPLAY_HEIGHT = 480;
   
   wire inWhite;
   wire inWhite_dino;
   wire inGrey_dino;
   wire [11:0] dinoW;
   wire [6:0] dinoH;
   wire inHitDino;
   
   wire [3:0]SEL;
   assign SEL = 4'b1010;
   wire [31:0] OX;
   wire [31:0] OY;
   assign OX = 31'd100;
   assign OY = 31'd300;
   drawDino #(.ratio(ratio)) 
    dino1 ( 
        .ox(OX), 
        .oy(OY), 
        .X(x), 
        .Y(y), 
        .select(SEL),
        .inWhite(inWhite_dino), 
        .inGrey(inGrey_dino));
        
   
    
   //$display("in White is %h\n", inWhite_dino);
   wire isBackGround;
   assign isBackGround = x < 640 && x >= 0 && y >= 0 && y < 479;
  
   reg [7:0] color;
   always @(posedge clk) begin
        if (inWhite_dino)
            color <= 10101010;
        else if (inGrey_dino)
            color <= 8'b00100101;
        else if (isBackGround)
            color <= 8'b11111111;
//        if (inWhite_dino)
//            color <= 8'b111_111_11;
//        else if (inGrey_dino)
//            color <= 8'b01110000;
//        else
//            color <= 8'b111_111_11;
   end
   
   assign vgaRed = color[7:5];
   assign vgaGreen = color[4:2];
   assign vgaBlue = color[1:0];
      
endmodule // top_vga
