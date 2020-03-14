module ObstaclesDelegate #(parameter ratio = 1, dx = 5)
        (input wire clk,
         input wire moveClk,
         input wire rst,
         input wire [8:0] ObstacleY,
         input wire [9:0] vgaX,
         input wire [8:0] vgaY,
         input wire [1:0] gameState,
         output wire inGrey,
         output wire inWhite,
         output wire [7:0] Obs1_W,
         output wire [6:0] Obs1_H, 
         output reg [10:0] X_1);
 
    localparam ScreenW = 10'd640;
    localparam initOffset = 6'd40;

    wire Obs1_inGrey;
    wire Obs1_inWhite;

    wire [3:0] Obstacle1_SEL;

    wire X1_Released;	/* These are random pulses */
    //wire X2_Released;	/* which generates a random */
    //wire X3_Released;	/* tick in order */

    wire X1_inRange;

    assign X1_inRange = ((X_1 + Obs1_W) > 0 && X_1 <= ScreenW);
    assign Obstacle1_SEL = 4'b0000;
    ClockDivider #(.velocity(1))
    	tempX1 (.clk(clk),
    			.speed(X1_Released));


    /* Generate and move Obs */
    always @(posedge moveClk or posedge rst) begin
        if (rst) begin
            X_1 <= ScreenW + initOffset;
        end
        else begin
            case (gameState)
                2'b00: X_1 <= ScreenW + initOffset;
                2'b10: begin
                    if (X1_inRange || X1_Released) begin
                        X_1 <= X_1 - 1;
                    end
                    else begin
                        X_1 <= ScreenW;    
                    end
                end
                2'b01: X_1 <= X_1;
                default:
                    X_1 <= X_1;
            endcase

        end
            
    end

    
    drawObstacle obs1 (
        .rst(rst),
        .ox(X_1),
        .oy(ObstacleY),
        .X(vgaX),
        .Y(vgaY),
        .select(Obstacle1_SEL),
        .inWhite(Obs1_inWhite),
        .inGrey(Obs1_inGrey));



    assign inGrey = Obs1_inGrey;
    assign inWhite = Obs1_inWhite;

endmodule