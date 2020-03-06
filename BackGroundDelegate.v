module BackGroundDelegate #(parameter ratio = 1, dx = -6'd20)
        (input wire clk,
         input wire FrameClk,
         input wire rst,
         input wire [8:0] GroundY,
         input wire [9:0] vgaX,
         input wire [9:0] vgaY,
         input wire [1:0]  gameState,
         output wire inGrey,
         output wire inWhite);

    localparam groundDisplayOffset = 0;
    // Draw horizon (Module: BackGround)
    wire [3:0]        horizonSEL;   // Multiplexor
    assign horizonSEL1 = 4'b0001;    // 选择画地面
    assign horizonSEL2 = 4'b0000;
    reg [11:0]        Ground_1_X;
    reg [11:0]        Ground_2_X;
    wire [5:0]        GroundH;
    
    localparam mask = 12'h800;
    
    localparam GroundW = 12'd1200;

    wire    Ground_1_inGrey;
    wire    Ground_2_inGrey;

    
    /* Move Ground 1 & 2 */
   
    always @(posedge FrameClk or posedge rst) begin
        if (rst) begin
            Ground_1_X <= 0;
            Ground_2_X <= 1200;
        end
        
        else if ((Ground_1_X + 1200)&mask) begin
            $display("Ground_1_X = %d <= -13'd1200", Ground_1_X);
            Ground_1_X <= 1200 + Ground_2_X;
        end

        else if ((Ground_2_X + 1200)&mask) begin
        $display("Ground_2_X = %d <= -13'd1200", Ground_2_X);
            Ground_2_X <= 1200 + Ground_1_X;
        end
            
        else begin
        $display("else");
            Ground_1_X <= Ground_1_X - 20;
            Ground_2_X <= Ground_2_X - 20;
        end
    end
    
    wire Ground1_grey;
    wire Ground2_grey;
    
    drawBackGround #(.ratio(ratio))
      horizon1 (.rst(rst),
                .ox(Ground_1_X),
                .oy(GroundY - groundDisplayOffset),
                .X(vgaX),
                .Y(vgaY),
                .select(horizonSEL1),
                .inGrey(Ground_1_inGrey));

    drawBackGround #(.ratio(ratio))
      horizon2 (.rst(rst),
                .ox(Ground_2_X),
                .oy(GroundY - groundDisplayOffset),
                .X(vgaX),
                .Y(vgaY),
                .select(horizonSEL2),
                .inGrey(Ground_2_inGrey));

    assign inGrey = Ground_1_inGrey | Ground_2_inGrey;

endmodule