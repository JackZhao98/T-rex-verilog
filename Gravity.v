
module Gravity#(parameter g=1, InitialSpeed=-20)
   (input wire rst,
    input wire [31:0]  GroundY,
    input wire [31:0]  Y,
    output wire [10:0] Displacement);
   
   wire [10:0] 	       Time;
   assign Time = (Y - GroundY) / g;

   reg [10:0] 	       instVelocity;
   always @(*) begin
      if (rst)
	instVelocity <= 11'b0;
      else
	instVelocity <= instVelocity + Time * g;
   end
   
   assign Displacement = instantVelocity * Time;

endmodule // Gravity
