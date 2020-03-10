# TRex with FPGA in Verilog
## Game Management Modules

### TRex_top
This is the top module of the entire project. The module takes raw inputs from the Nexys3 FPGA board including four buttons and generates proper output signals to VGA and some led indicators. <br>

```verilog
module TRexTop(
    input wire          clk,
    input wire          btnR, // Reset button
    input wire          duckButton,
    input wire          jumpButton,
    output wire         Hsync,
    output wire         Vsync,
    output reg [2:0]    vgaRed,
    output reg [2:0]    vgaGreen,
    output reg [1:0]    vgaBlue,
    output wire         led,
    output wire         run,
    output wire         dead);
```


## Graphic Modules
### VGA
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

### vgaClk (Clock divider, generate a 25MHz clock rate for pixel update)
 - Input: clk (100MHz Master Clock)
 - Output: pix_clk (25MHz clock signal)

### Multi-functional Clock Divider
- Input: clk (100MHz Master Clock)
This module takes a parameter in order to output different clock frequencies. 
```verilog
module ClockDivider#(parameter velocity = 1)
```
The parameter `velocity` represents the clock pulse freqency in Hertz, i.e. "how many pulses in one second"

## Helper program

### Automatic graphing script
[![TRex Default]
(https://miro.medium.com/max/600/0*9U_PkckAUtKGrb_R.png)]


