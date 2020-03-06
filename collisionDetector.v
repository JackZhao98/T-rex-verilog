module collisionDetector #(parameter GroundY)
   (input wire [10:0] DinoX,
    input wire [8:0] DinoY,
    input wire [6:0] DinoH,
    input wire [7:0] DinoW,
    input wire [10:0] ObsX,
    input wire [6:0] ObsH,
    input wire [7:0] ObsW,
    output wire collided );


   initial begin
       assign collided = 0;
   end
	
	//assign collided = ((DinoX + DinoW >= ObsX) && (DinoX <= ObsX + ObsW))? (DinoY <= ObsH + GroundY):0;
	
   /*  |---- DinoW -----|~~~~~~~~~|
     DinoX~~~~~~~~~~~~~~^        ObsX */
   if (DinoX + DinoW < ObsX) begin
       assign collided = 0;
   end


   /*  ~~~~ ObsW ~~~~~|---------|
   	 ObsX            DinoX      */
   else if (DinoX > ObsX + ObsW) begin
       assign collided = 0;
   end

   // Horizon overlap
   else if ((DinoX + DinoW >= ObsX) || (DinoX <= ObsX + ObsW)) begin
       
       assign collided = (DinoY > ObsH + GroundY)? 0:1;

   end

   else begin
       assign collided = 0;
   end

endmodule