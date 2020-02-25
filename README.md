# T-Rex Game in Verilog
### Chrome://dino
## Modules

VGA
 -  Input: clk (100MHz Master Clock)
	   pixel_clk (25MHz pixel clock)
	   rst (reset)

 - Output: Hsync (Horizontal Sync Signal)
           Vsync (Vertical Sync Signal)
	   blanking (cursor within blank area)
	   active (cursor within active area)
	   screened (One tick pulse at the end of a frame)
	   animate (One tick pulse at the very last of active pixel)
	   [9:0]x (Current X coordinate)
	   [8:0]y (Current Y coordinate)

RGB (Color selector, 相当于Stop Watch Proj的BCD -->seg decoder)
 - Input: [1:0]color (Color select, 00 - White, 01 - Grey, 11 - Black)
 - Output: [2:0]Red, [2:0]Green, [1:0]Blue (Output should directly go to VGA port)

vgaClk (Clock divider, generate a 25MHz clock rate for pixel update)
 - Input: clk (100MHz Master Clock)
 - Output: pix_clk (25MHz clock signal)

  
