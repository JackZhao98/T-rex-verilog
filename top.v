module top_vga(
	       input wire 	 clk,
	       input wire 	 btnR, // Reset button
	       output wire 	 Hsync,
	       output wire 	 Vsync,
	       output wire [2:0] vgaRed,
	       output wire [2:0] vgaGreen,
	       output wire [2:1] vgaBlue);

   // Begin of clock divider.
   // Output: pixel_clk ==> 25MHz Clock
   wire 			 pixel_clk;
   
   vgaClk _vgaClk(.clk(clk), .pix_clk(pixel_clk));
   // Now pixel_clk is a 25MHz clock, hopefully.
   // End of Clock Divider

   

   
   
