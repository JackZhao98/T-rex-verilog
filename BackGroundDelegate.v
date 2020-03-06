module BackGroundDelegate #(parameter ratio = 1, dx = -6'd20)
        (input wire moveClk,
         input wire rst,
         input wire [8:0] GroundY,
         input wire [9:0] vgaX,
         input wire [9:0] vgaY,
         input wire [1:0] gameState,
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
    
    localparam GroundW = 12'd1200;
	 
    wire    Ground_1_inGrey;
    wire    Ground_2_inGrey;

    
    /* Move Ground 1 & 2 */
   
    always @(posedge moveClk or posedge rst) begin
        if (rst) begin
            Ground_1_X <= 0;
            Ground_2_X <= GroundW;
        end
        
        else begin
            case (gameState)
                2'b00: begin
                    Ground_1_X <= 0;
                    Ground_2_X <= GroundW;
                end
                2'b10: begin
                    if (Ground_1_X == (~GroundW + 1)) begin
                        Ground_1_X <= GroundW - 1;
                        Ground_2_X <= Ground_2_X - 1;
                    end

                    else if (Ground_2_X == (~GroundW + 1)) begin
                        Ground_2_X <= GroundW - 1;
                        Ground_1_X <= Ground_1_X - 1;
                    end
                        
                    else begin
                        Ground_1_X <= Ground_1_X - 1;
                        Ground_2_X <= Ground_2_X - 1;
                    end
                
                end
                2'b01: begin
                    Ground_1_X <= Ground_1_X;
                    Ground_2_X <= Ground_2_X;
                end
                default: begin
                    Ground_1_X <= 0;
                    Ground_2_X <= GroundW;
                end
            endcase
        end
    end
    
    wire Ground1_grey;
    wire Ground2_grey;
    // Change ox oy to 12 bit here!
    drawBackGround #(.ratio(ratio))
      horizon1 (.rst(rst),
                .ox(Ground_1_X + 1200),
                .oy(GroundY - groundDisplayOffset),
                .X(vgaX + 1200),
                .Y(vgaY),
                .select(horizonSEL1),
                .inGrey(Ground_1_inGrey));

    drawBackGround #(.ratio(ratio))
      horizon2 (.rst(rst),
                .ox(Ground_2_X + 1200),
                .oy(GroundY - groundDisplayOffset),
                .X(vgaX + 1200),
                .Y(vgaY),
                .select(horizonSEL2),
                .inGrey(Ground_2_inGrey));

    assign inGrey = Ground_1_inGrey | Ground_2_inGrey;

endmodule