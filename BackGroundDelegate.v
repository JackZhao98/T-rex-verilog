module BackGoundDelegate #(parameter ratio = 1, dx = 30)
        (input wire FrameClk,
         input wire rst,
         input wire [31:0] GroundY,
         input wire [31:0] vgaX,
         input wire [31:0] vgaY,
         input wire [1:0]  gameState,
         output wire inGrey,
         output wire inWhite);

    localparam groundDisplayOffset = 20;
    // Draw horizon (Module: BackGround)
    wire [3:0]        horizonSEL;   // Multiplexor
    assign horizonSEL = 4'b0000;    // 选择画地面

    reg [31:0]        Ground_1_X;
    reg [31:0]        Ground_2_X;
    reg [11:0]        GroundH;
    reg [11:0]        GroundW;

    wire    Ground_1_inGrey;
    wire    Ground_2_inGrey;


    /* Move Ground 1 & 2 */
    always @(posedge FrameClk or posedge rst) begin

        if (rst) begin
            Ground_1_X <= 0;
            Ground_2_X <= GroundW;
        end

        else if (Ground_1_X + GroundX == 0) begin
            Ground_1_inGrey <= GroundW;
        end

        else if (Ground_2_X + GroundX == 0) begin
            Ground_2_inGrey <= GroundW;
        end

        else begin
            Ground_1_X <= Ground_1_X - dx;
            Ground_2_X <= Ground_2_X - dx;
        end

    end

    drawBackGround #(.ratio(ratio))
      horizon1 (.rst(rst),
                .ox(Ground_1_X),
                .oy(GroundY - groundDisplayOffset),
                .X(x),
                .Y(y),
                .select(horizonSEL),
                .objectWidth(GroundW),
                .objectHeight(GroundH),
                .inGrey(Ground_1_inGrey));

    drawBackGround #(.ratio(ratio))
      horizon2 (.rst(rst),
                .ox(Ground_2_X),
                .oy(GroundY - groundDisplayOffset),
                .X(x),
                .Y(y),
                .select(horizonSEL),
                .objectWidth(GroundW),
                .objectHeight(GroundH),
                .inGrey(Ground_2_inGrey));

    assign inGrey = Ground_1_inGrey | Ground_2_inGrey;

endmodule
