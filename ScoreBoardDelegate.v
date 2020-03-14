module ScoreBoardDelegate #(parameter ratio=1)(
	input wire ScoreClock,
	input wire rst,
    input wire [1:0] gameState,
	input wire [10:0] vgaX,
	input wire [8:0] vgaY,
	output wire inGrey);

   localparam ScreenH = 9'd480;

   localparam ScreenW = 10'd640;



   wire [10:0]       Num1_x;
   wire [8:0]       Num1_y;
   wire [10:0]       Num2_x;
   wire [8:0]       Num2_y;
   wire [10:0]       Num3_x;
   wire [8:0]       Num3_y;
   wire [10:0]       Num4_x;
   wire [8:0]       Num4_y;
   
   localparam Num_W = 20;
   localparam Num_H = 21;

   wire        Num1_inGrey;
   wire        Num2_inGrey;
   wire        Num3_inGrey;
   wire        Num4_inGrey;

   /* Assign Number Position */
   localparam num_top_right_x = ScreenW - 30 - Num_W;
   localparam num_top_y = 30 + Num_H;
   localparam num_gap = 10;

   assign Num4_x = num_top_right_x;
   assign Num3_x = Num4_x - Num_W - num_gap;
   assign Num2_x = Num3_x - Num_W - num_gap;
   assign Num1_x = Num2_x - Num_W - num_gap;
   assign Num4_y = num_top_y;
   assign Num3_y = Num4_y;
   assign Num2_y = Num3_y;
   assign Num1_y = Num2_y;

   reg [3:0]       Num1_SEL;
   reg [3:0]       Num2_SEL;
   reg [3:0]       Num3_SEL;
   reg [3:0]       Num4_SEL;

   always @(posedge ScoreClock or posedge rst) begin
   	if (rst) begin
   		Num1_SEL <= 4'b0;
   		Num2_SEL <= 4'b0;
   		Num3_SEL <= 4'b0;
   		Num4_SEL <= 4'b0;
   	end

    else begin
        case (gameState)
        2'b00: begin
            Num1_SEL <= 4'b0;
            Num2_SEL <= 4'b0;
            Num3_SEL <= 4'b0;
            Num4_SEL <= 4'b0;
          end
        2'b10: begin
            if (Num4_SEL == 4'd9) begin
                Num4_SEL <= 0;
                if (Num3_SEL == 4'd9) begin
                    Num3_SEL <= 0;
                    if (Num2_SEL == 4'd9) begin
                        Num2_SEL <= 0;
                        if (Num1_SEL == 4'd9) begin
                             Num1_SEL <= 4'b0;
                             Num2_SEL <= 4'b0;
                             Num3_SEL <= 4'b0;
                             Num4_SEL <= 4'b0;
                        end

                        else begin
                            Num1_SEL <= Num1_SEL + 1;
                        end
                    end
                    else begin
                        Num2_SEL <= Num2_SEL + 1;
                    end
                end
                else begin
                    Num3_SEL <= Num3_SEL + 1;
                end           
            end  // end if(Num4_SEL == 4'd9)
            
            else // Num4_SEL < 9, no carry
                Num4_SEL <= Num4_SEL + 1;
          end
          
          
          2'b01: begin
            Num1_SEL <= Num1_SEL;
            Num2_SEL <= Num2_SEL;
            Num3_SEL <= Num3_SEL;
            Num4_SEL <= Num4_SEL;
          end
          default: begin
           Num1_SEL <= 4'b0;
            Num2_SEL <= 4'b0;
            Num3_SEL <= 4'b0;
            Num4_SEL <= 4'b0;
          end
        endcase
   	end

   end

   drawNumber #(.ratio(ratio))
      Num1 (.rst(rst),
            .ox(Num1_x),
            .oy(Num1_y),
            .X(vgaX),
            .Y(vgaY),
            .select(Num1_SEL),
            .inGrey(Num1_inGrey));

   drawNumber #(.ratio(ratio))
      Num2 (.rst(rst),
            .ox(Num2_x),
            .oy(Num2_y),
            .X(vgaX),
            .Y(vgaY),
            .select(Num2_SEL),
            .inGrey(Num2_inGrey));

   drawNumber #(.ratio(ratio))
      Num3 (.rst(rst),
            .ox(Num3_x),
            .oy(Num3_y),
            .X(vgaX),
            .Y(vgaY),
            .select(Num3_SEL),
            .inGrey(Num3_inGrey));

   drawNumber #(.ratio(ratio))
      Num4 (.rst(rst),
            .ox(Num4_x),
            .oy(Num4_y),
            .X(vgaX),
            .Y(vgaY),
            .select(Num4_SEL),
            .inGrey(Num4_inGrey));


    assign inGrey = Num1_inGrey | Num2_inGrey | Num3_inGrey | Num4_inGrey;

endmodule


