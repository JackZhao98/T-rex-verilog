module vgaClk(
	      input wire  clk,
	      output wire pix_clk);
   
   reg [15:0] 		  counter;
   reg 			  pix_stb;

   always @(posedge clk)
     {pix_stb, counter} <= counter + 16'h4000;

   assign pix_clk <= pix_stb;

endmodule // end of vgaClk

   
   
