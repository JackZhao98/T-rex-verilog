module ObstaclesDelegate #(parameter ratio = 1, dx = 5)
        (input wire clk,
         input wire FrameClk,
         input wire rst,
         input wire [31:0] ObstacleY,
         input wire [31:0] vgaX,
         input wire [31:0] vgaY,
         input wire [1:0] gameState,
         output wire inGrey,
         output wire inWhite,
         output wire [11:0] Obs1_W,
         output wire [11:0] Obs1_H,
         output wire [11:0] Obs2_W,
         output wire [11:0] Obs2_H,
         output wire [11:0] Obs3_W,
         output wire [11:0] Obs3_H);

    localparam ScreenW = 640;
    localparam initOffset = 640;

    wire Obs1_inGrey;
    wire Obs2_inGrey;
    wire Obs3_inGrey;

    wire Obs1_inWhite;
    wire Obs2_inWhite;
    wire Obs3_inWhite;

    reg [3:0] Obstacle1_SEL;    
    reg [3:0] Obstacle2_SEL;
    reg [3:0] Obstacle3_SEL;

    wire X1_Released;	/* These are random pulses */
    wire X2_Released;	/* which generates a random */
    wire X3_Released;	/* tick in order */

    wire [31:0] X_1;
    wire [31:0] X_2;
    wire [31:0] X_3;

    wire [11:0] Obs1_W;
    wire [11:0] Obs2_W;
    wire [11:0] Obs3_W;

    wire [11:0] Obs1_H;
    wire [11:0] Obs2_H;
    wire [11:0] Obs3_H;

    wire X1_inRange;
    wire X2_inRange;
    wire X3_inRange;

    assign X1_inRange = ((X_1 + Obs1_W) > 0 && X_1 <= ScreenW);
    assign X2_inRange = ((X_2 + Obs2_W) > 0 && X_2 <= ScreenW);
    assign X3_inRange = ((X_3 + Obs3_W) > 0 && X_3 <= ScreenW);

    

    ClockDivider #(.velocity(1))
    	tempX1 (.clk(clk),
    			.speed(X1_Released));


    /* Generate and move Obs */
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            X_1 <= ScreenW + initOffset;
            X_2 <= ScreenW + initOffset;
            X_3 <= ScreenW + initOffset;
        end
        else begin
            if (X1_inRange || X1_Released) begin
                X_1 <= X_1 - dx;
            end
            else begin
                X_1 <= ScreenW;    
            end

        end
            
    end

    drawObstacle obs1 (
        .rst(rst),
        .ox(X_1),
        .oy(ObstacleY),
        .x(vgaX),
        .y(vgaY),
        .select(Obstacle1_SEL),
        .objectWidth(Obs1_W),
        .objectHeight(Obs1_H),
        .inWhite(Obs1_inWhite),
        .inGrey(Obs1_inGrey));
    
    drawObstacle obs2 (
        .rst(rst),
        .ox(X_2),
        .oy(ObstacleY),
        .x(vgaX),
        .y(vgaY),
        .select(Obstacle2_SEL),
        .objectWidth(Obs2_W),
        .objectHeight(Obs2_H),
        .inWhite(Obs2_inWhite),
        .inGrey(Obs2_inGrey));

    drawObstacle obs3 (
        .rst(rst),
        .ox(X_3),
        .oy(ObstacleY),
        .x(vgaX),
        .y(vgaY),
        .select(Obstacle3_SEL),
        .objectWidth(Obs3_W),
        .objectHeight(Obs3_H),
        .inWhite(Obs3_inWhite),
        .inGrey(Obs3_inGrey));


    assign inGrey = Obs1_inGrey | Obs2_inGrey | Obs3_inGrey;
    assign inWhite = Obs1_inWhite | Obs2_inWhite | Obs3_inWhite;

endmodule