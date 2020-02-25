# Untitled
## Modules

#### VGA
 -  Input: clk (100MHz Master Clock) <br>
	   pixel_clk (25MHz pixel clock) <br>
	   rst (reset) <br>

 - Output: Hsync (Horizontal Sync Signal) <br>
           Vsync (Vertical Sync Signal) <br>
	   blanking (cursor within blank area) <br>
	   active (cursor within active area) <br>
	   screened (One tick pulse at the end of a frame) <br>
	   animate (One tick pulse at the very last of active pixel) <br>
	   [9:0]x (Current X coordinate) <br>
	   [8:0]y (Current Y coordinate) <br>

#### RGB (Color selector, 相当于Stop Watch Proj的BCD -->seg decoder) 
 - Input: [1:0]color (Color select, 00 - White, 01 - Grey, 11 - Black) <br>
 - Output: [2:0]Red, [2:0]Green, [1:0]Blue (Output should directly go to VGA port) <br>

#### vgaClk (Clock divider, generate a 25MHz clock rate for pixel update)
 - Input: clk (100MHz Master Clock)
 - Output: pix_clk (25MHz clock signal)

  
