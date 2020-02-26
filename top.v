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

   // Begin of Debouncer Module
   // Generate: rst
   wire 			 rst;
 
   debouncer button1 (.button_in(btnR),
		      .clk(clk),
		      .button_out(rst));
   
   // End of debouncer

   // Begin of VGA module
   wire [9:0] 			 x;
   wire [8:0] 			 y;
   wire 			 active;

   VGA vga(.clk(clk),
	   .pixel_clk(pixel_clk),
	   .rst(rst),
	   .Hsync(Hsync),
	   .Vsync(Vsync),
	   .active(active),
	   .x(x),
	   .y(y));
   // End of VGA module

   // SRAM buffer
   localparam DISPLAY_WIDTH = 640;
   localparam DISPLAY_HEIGHT = 480;
      
      
endmodule // top_vga
