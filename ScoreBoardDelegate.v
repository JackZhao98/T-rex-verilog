module ScoreBoardDelegate (
	input wire ScoreClock,
	input wire rst,
	input wire [31:0] vgaX,
	input wire [31:0] vgaY,
	output wire inGrey);


   localparam ScreenH = 480;
   localparam ScreenW = 640;


   wire [31:0] x;
   wire [31:0] y;
   assign x = vgaX;
   assign y = vgaY;

   wire [31:0]       Num1_x;
   wire [31:0]       Num1_y;
   wire [31:0]       Num2_x;
   wire [31:0]       Num2_y;
   wire [31:0]       Num3_x;
   wire [31:0]       Num3_y;
   wire [31:0]       Num4_x;
   wire [31:0]       Num4_y;
   
   wire [10:0]       Num_H;
   wire [10:0]       Num_W;
   assign Num_W = 20;
   assign Num_H = 21;

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

   		if (Num4_SEL == 4'd9) begin
   			if (Num3_SEL == 4'd9) begin
   				if (Num2_SEL == 4'd9) begin
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

   end

   drawNumber #(.ratio(ratio))
      Num1 (.rst(rst),
            .ox(Num1_x),
            .oy(Num1_y)),
            .X(x),
            .Y(y),
            .select(Num1_SEL),
            .inGrey(Num1_inGrey));

   drawNumber #(.ratio(ratio))
      Num2 (.rst(rst),
            .ox(Num2_x),
            .oy(Num2_y),
            .X(x),
            .Y(y),
            .select(Num2_SEL),
            .inGrey(Num2_inGrey));

   drawNumber #(.ratio(ratio))
      Num3 (.rst(rst),
            .ox(Num3_x),
            .oy(Num3_y),
            .X(x),
            .Y(y),
            .select(Num3_SEL),
            .inGrey(Num3_inGrey));

   drawNumber #(.ratio(ratio))
      Num4 (.rst(rst),
            .ox(Num4_x),
            .oy(Num4_y),
            .X(x),
            .Y(y),
            .select(Num4_SEL),
            .inGrey(Num4_inGrey));


    assign inGrey = Num1_inGrey | Num2_inGrey | Num3_inGrey | Num4_inGrey;

endmodule


