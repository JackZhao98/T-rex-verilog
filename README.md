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
### gameFSM
Game management finite state machine. There are totally three states: 
00, 01 and 10 representing the initial state, in game state, dead state respectively. 

```
-> 00 -- Jump ----> 10 ------- Collided ---> 01 (Dead)
               ^          |
               |          |
               |_!Collide_|

```
- Initial state: Objects are rest to their initial position, TRex is reset to the default pattern, and score is cleared to zero.
- In game state: Objects start to move at a specified game speed, score starts to increment. TRex has normal animation (refer to chrome://dino)
- Dead state: Movements are paused, score increment is paused, and TRex is set to dead pattern.

#### Collision detection
Because the VGA module keeps returning a x and y coordinate representing the current pixel the counter is pointing at, I used these two value to determine if current pixel is in TRex pattern and also in obstacle pattern. If current pixel is in both poatterns, then the game knows a collision has happened.

### TRex Delegate
The TRex delegate module controls everything about the TRex. The module has local variable storing the information including dinosaur origin's X and Y coordinates, its width and height. In addition to calling two other modules `dinoFSM` and `drawDino` which are in charge of TRex pattern selection and vga graphic drawing, the module also takes care of TRex's jump movement. By implementing actual acceleration formula in physics.
```
V = V0 + a * dt
dS = S + V * dt
```
we gave a gravitational acceleration of 1 and an initial veocity of -18 to local parameters. Every frame clock, we want the velocity increment by g and TRex Y displacement by V. (dt is 1 as the calculation is done in every clock pulse)
```verilog
if (isJumping) begin
    V <= V + g;
    DinoY <= DinoY + V;
    if (DinoY >= GroundY) begin
        DinoY <= GroundY;
        V <= 0;
        isJumping <= 0;
    end
end
else if (jump) begin
    isJumping <= 1;
    V <= -v_init;
    DinoY <= DinoY - v_init;
end
else
    DinoY <= GroundY;
```
_note*: GroundY is the default Y value of TRex and obstacles_

### Obstacle Delegate
This module manages all cactus obstacles. The original design was to have three cactus randomly generating with a certain distance interval, however, due to the limitation of ports on FPGA board, we moved to one cactus only. Similar to TRexDelegate, this module contains a instantaneous X coordinate of the cactus. The Y is set to GroundY at default because it only moves from right to left. X starts wtih a value of maximum width of screen (640) and decrements by 1 at every `posedge moveClk`. Graphic of the cactus was originally designed to randomly select from six different patterns, but now set to default small cactus at all time.

### Background Delegate
Similar to obstacle module, the module controls the X coordinate of background position and decrements by 1 at every `posedge moveClk`. Using the same clock pulse will make the background moves at the same pace. I divided the 2400 px wide background image to two parts, hence I could seamlessly loop the background over and over.

### Scoreboard Delegate
The scoreboard delegate module has a score counter that increments by 1 at `posedge scoreClk`. Just like seven segment display, the four digits of the score are Binary Coded Decimals and their value are directly used as number pattern selectors by the `drawNumber` module.

## Graphic Modules
### VGA
This module will iterate through all pixels on a 640x480 60FPS display with proper delays. Except for Hsync and Vsync signals, it also outputs the instant pixel coordinates to help other modules.
```verilog
module VGA(
    input wire        clk,
    input wire        pixel_clk,
    input wire        rst,
    output wire       Hsync,
    output wire       Vsync,
    output wire       blanking,
    output wire       active,
    output wire       screened,
    output wire       animate,
    output wire [9:0] x,  // x and y represent the current
    output wire [8:0] y); // pixel within the screen

    localparam RES_H = 480;
    localparam RES_W = 640;
    /**********************
     *                    *
     * 4                  *
     * 8                  *
     * 0                  *
     *        640         *
     * ********************
    localparam H_Front_Porch = 16;
    localparam H_Sync_Pulse = 96;
    localparam H_Back_Porch = 48;
    localparam V_Front_Porch = 10;
    localparam V_Sync_Pulse = 2;
    localparam V_Back_Porch = 33;
```

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

In order to draw some graphics on the screen, we chose the most straight forward way: depict the region of each color. For this specific project, the objects are in solid grey, so that seems easier to "draw".

![TRex Default][default_dino]

However, the actual image is really complicated to express in boolean statements because the pixel-style dinosaur and objects have no smooth edges. So I wrote a python script to read every pixel value in game sprite images and genreate verilog codes that represent each pattern correspondingly. I also updated the script after the first version which is able to read all images from different folders (each folder is a module) and generate the complete verilog module code automatically.

### even further...
Furthermore, I wrote an `auto.sh` shell script to run the python script above recursively under current directory.
```shell
files=$(find . -type d -regex '\./[A-Za-z]*')
for file in $files; do
    baseName=$(echo "$file" | sed 's|[\.\/]||g')
    ./AutoGenerate.py $file > ../draw$baseName.v
    echo $file "has been generated."
done;
```

### Final Preview
The final version may look like this...<br>
![demo][demo_1]

[demo_1] : /assets/demo_1.gif "Preview"
[default_dino] : https://miro.medium.com/max/600/0*9U_PkckAUtKGrb_R.png

