module VGA(
	   input wire 	     clk,
	   input wire 	     pixel_clk,
	   input wire 	     rst,
	   output wire 	     Hsync,
	   output wire 	     VSync,
	   output wire 	     blanking,
	   output wire 	     active,
	   output wire 	     screened,
	   output wire 	     animate,
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
    * ********************/
   localparam H_Front_Porch = 16;
   localparam H_Sync_Pulse = 96;
   localparam H_Back_Porch = 48;
   localparam V_Front_Porch = 10;
   localparam V_Sync_Pulse = 2;
   localparam V_Back_Porch = 33;

   
   localparam HS_START = H_Front_Porch;
   localparam HS_END = H_Front_Porch + H_Sync_Pulse;
   localparam HA_START = H_Front_Porch + H_Sync_Pulse + H_Back_Porch;
   // |--16--|-------96-------|----48----|ACTIVE AREA|
   
   localparam VS_START = RES_H + V_Front_Porch;
   localparam VS_END = RES_H + V_Front_Porch + V_Sync_Pulse;
   localparam VA_END = RES_H;
   
   localparam LINE = H_Front_Porch + H_Sync_Pulse + H_Back_Porch + RES_W;   // 800
   localparam SCREEN = RES_H + V_Front_Porch + V_Sync_Pulse + V_Back_Porch; // 525
   
   reg [9:0] 	       h_count;
   reg [9:0] 	       v_count;
   
   // generate sync signals (1 control active)
   assign Hsync = ((h_count >= HS_START) & (h_count <= HS_END));
   assign Vsync = ((v_count >= VS_START) & (v_count < VS_END));

   // Keep x and y in-bound within active region (640*480)
   // When counter is in blank area, keep x = 0, y = 479;
   assign x = (h_count < HA_START)? 0 : (h_count - HA_START);
   assign y = (v_count >= VA_END)? (RES_H - 1) : v_count;

   // Blanking signal
   assign blanking = ((h_count < HA_START) | (v_count >= VA_END));

   // Active signal
   assign active = ~blanking;

   // Screened: high for one tick at the end of screen (one frame)
   assign screened = ((h_count == LINE) & (v_count == SCREEN - 1));

   // Active: high for one tick at tha last active pixel
   assign animate = ((h_count == LINE) & (v_counter == VA_END - 1));

   always @(posedge clk) begin
      if (rst) begin
	 h_count <= 0;
	 v_count <= 0;
      end

      if (pixel_clk) begin
	 if (h_count == LINE) begin
	    h_count <= 0;
	    v_count <= v_count + 1;
	 end
	 else
	   h_count <= h_count + 1;

	 if (v_count == SCREEN)
	   v_count <= 0;
      end // if (pixel_clk)

   end // always @ (posedge clk)

endmodule // VGA

// Reference: https://timetoexplore.net/blog/arty-fpga-vga-verilog-01
