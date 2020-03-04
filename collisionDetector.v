module collisionDetector #(parameter GroundY)
   (input wire [10:0] DinoX,
    input wire [8:0] DinoY,
    input wire [6:0] DinoH,
    input wire [6:0] DinoW,
    input wire [9:0] ObsX,
    input wire [6:0] ObsH,
    input wire [7:0] ObsW);
