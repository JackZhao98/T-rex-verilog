module RGB(
	   input wire [1:0]  color,
	   output wire [2:0] Red,
	   output wire [2:0] Green,
	   output wire [1:0] Blue);
   
   // Color table
   // 00 - White
   // 01 - Grey?
   // 11 - Black
   
   reg [7:0] 		     rgb;

   always @(*) begin
      case (color)
	2'b00: rgb <= 8'b11111111;
	2'b01: rgb <= 8'b01010101;
	2'b11: rgb <= 8'b00000000;
      endcase // case (colorSel)
   end

   assign Red = rgb[7:5];
   assign Green = rgb[4:2];
   assign Blue = rgb[1:0];

endmodule // RGB

