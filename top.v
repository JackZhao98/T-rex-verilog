module top_vga(
	       input wire 	 clk,
	       input wire 	 btnR, // Reset button
	       output wire 	 Hsync,
	       output wire 	 Vsync,
	       output wire [2:0] vgaRed,
	       output wire [2:0] vgaGreen,
	       output wire [1:0] vgaBlue);

   // Begin of clock divider.
   // Output: pixel_clk ==> 25MHz Clock
   wire 			 pixel_clk;
   vgaClk _vgaClk(.clk(clk), 
		  .pix_clk(pixel_clk));
   // Now pixel_clk is a 25MHz clock, hopefully.
   // End of Clock Divider
   
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

   // T-Rex vertical jump simulator
   // Vert_Velocity = a*t
   wire [31:0] 			 DinoX;
   wire [31:0] 			 DinoY;
   /*
    module Gravity#(parameter g=1)
   (input wire rst,
    input wire [31:0]  GroundY,
    input wire [31:0]  Y,
    output wire	[10:0] Displacement);
    */
   wire [10:0] 			 Y_Displacement;
   Gravity #(.g(1), .InitialVelocity(-20))
       dinoG(.rst(rst),
	     .GroundY(GroundY),
	     .Y(DinoY),
	     .Displacement(Y_Displacement));
   
    
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
   drawDino #(.ratio(1)) 
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
