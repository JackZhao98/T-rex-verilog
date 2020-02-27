module drawDino #(parameter ratio=1),
   (
    input wire 	     animateClk,
    input wire [9:0] ox,
    input wire [8:0] oy,
    input wire [9:0] x,
    input wire [8:0] y,
    input wire [2:0] dinoMode,
    output wire [6:0] HitBoxWidth,
    output wire [6:0] HitBoxHeight,
    output wire      inHitBox,
    output wire      inDino,
    output wire      inFrame);


   localparam defaultWidth = 88;
   localparam defaultHeight = 94;
  
   localparam px = ratio;
   localparam W  = px * defaultWidth + dinoX;
   localparam H  = px * defaultHeight + dinoY;
   
   // 1. Default Dino (000)
   wire 	     inHitBox_default;
   wire 	     inDino_default;
   wire 	     inBlank_default;
   /* insert default dino mapping here */

   assign inHitBox_default = (x > ox) && (x <= W) && (y > oy) && (y <= H);

   assign inBlank_default = 
          ((x > ox) && (x <= ox + px * 44) && (y > oy) && (y <= oy + px *  4))
       || ((x > ox) && (x <= ox + px * 40) && (y > oy) && (y <= oy + px * 30))
       || ((x > ox) && (x <= ox + px *  4) && (y > oy) && (y <= oy + px * 34))
       || ((x > ox + px * 12) && (x <= ox + px * 36) && (y > oy + px * 30) && (y <= oy + px * 34))
       || ((x > ox + px * 12) && (x <= ox + px * 30) && (y > oy + px * 34) && (y <= oy + px * 38))
       || ((x > ox + px * 12) && (x <= ox + px * 24) && (y > oy + px * 38) && (y <= oy + px * 42))  // 左上角空白结束
       || ((x > ox) && (x <= ox + px * 4) && (y > (H - px * 36)) && (y <= H))
       || ((x > ox) && (x <= ox + px * 8) && (y > (H - px * 32)) && (y <= H))
       || ((x > ox) && (x <= ox + px * 12) && (y > (H - px * 28)) && (y <= H))
       || ((x > ox) && (x <= ox + px * 16) && (y > (H - px * 24)) && (y <= H))
       || ((x > ox) && (x <= ox + px * 20) && (y > (H - px * 16)) && (y <= H))  // 左下角空白结束
       || ((x > (W - px * 8)) && (x <= W) && (y > (H - px * 64)) && (y <= H))
       || ((x > (W - px * 16)) && (x <= W) && (y > (H - px * 56)) && (y <= H))
       || ((x > (W - px * 24)) && (x <= W) && (y > (H - px * 40)) && (y <= H))
       || ((x > (W - px * 28)) && (x <= W) && (y > (H - px * 30)) && (y <= H))
       || ((x > (W - px * 32)) && (x <= W) && (y > (H - px * 24)) && (y <= H))
       || ((x > (W - px * 36)) && (x <= W) && (y > (H - px * 16)) && (y <= H - px * 8))
       || ((x > ox + px * 36) && (x <= ox + px * 40) && (y > (H - px * 16)) && (y <= H))
       || ((x > ox + px * 32) && (x <= ox + px * 36) && (y > oy + px * 82) && (y <= oy + px * 86)))
       || ((x > W - px * 4 ) && (x <= W) && (y > oy) && (y <= oy + px * 8));

	 assign inDino_default = 
        ((x > ox + 48 * px) && (x <= ox + 80 * px) && (y > oy +  4 * px) && (y <= oy +  8 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy +  8 * px) && (y <= oy + 10 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 52 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) ||
        ((x > ox + 56 * px) && (x <= ox + 84 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) || //到眼睛结束
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy + 14 * px) && (y <= oy + 26 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 64 * px) && (y > oy + 26 * px) && (y <= oy + 30 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 76 * px) && (y > oy + 30 * px) && (y <= oy + 34 * px)) ||   // 脑袋结束
        ((x > ox + 40 * px) && (x <= ox + 60 * px) && (y > oy + 34 * px) && (y <= oy + 38 * px)) ||
        ((x > ox + 34 * px) && (x <= ox + 60 * px) && (y > oy + 38 * px) && (y <= oy + 42 * px)) || // 脖子结束
        ((x > ox +  4 * px) && (x <= ox +  8 * px) && (y > oy + 34 * px) && (y <= oy + 58 * px)) ||   // 尾巴从左到右1
        ((x > ox +  8 * px) && (x <= ox + 12 * px) && (y > oy + 42 * px) && (y <= oy + 62 * px)) || // 2
        ((x > ox + 12 * px) && (x <= ox + 16 * px) && (y > oy + 46 * px) && (y <= oy + 66 * px)) || // 3
        ((x > ox + 28 * px) && (x <= ox + 68 * px) && (y > oy + 42 * px) && (y <= oy + 46 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 60 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) ||
        ((x > ox + 64 * px) && (x <= ox + 68 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) || // 手部结束
        ((x > ox + 16 * px) && (x <= ox + 60 * px) && (y > oy + 50 * px) && (y <= oy + 60 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 56 * px) && (y > oy + 60 * px) && (y <= oy + 66 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 52 * px) && (y > oy + 66 * px) && (y <= oy + 70 * px)) ||
        ((x > ox + 20 * px) && (x <= ox + 48 * px) && (y > oy + 70 * px) && (y <= oy + 74 * px)) || // 肚子结束 
        // 腿部（动作部分改这块）
        ((x > ox + 24 * px) && (x <= ox + 36 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 32 * px) && (y > oy + 78 * px) && (y <= oy + 82 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 28 * px) && (y > oy + 82 * px) && (y <= oy + 86 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 32 * px) && (y > oy + 86 * px) && (y <= oy + 90 * px)) || //左腿结束
        ((x > ox + 40 * px) && (x <= ox + 48 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 48 * px) && (y > oy + 78 * px) && (y <= oy + 86 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 52 * px) && (y > oy + 86 * px) && (y <= oy + 90 * px));  //右腿结束 

   // End of default



   // 2. Left foot up (001)
   wire 	     inHitBox_left;
   wire 	     inDino_left;
   wire 	     inBlank_left;
   /* insert left foot up dino mapping here */

   assign inHitBox_left = (x > ox) && (x <= W) && (y > oy) && (y <= H);

   assign inBlank_left = 
        ((x > ox) && (x <= ox + px * 44) && (y > oy) && (y <= oy + px *  4)) ||
        ((x > ox) && (x <= ox + px * 40) && (y > oy) && (y <= oy + px * 30)) ||
        ((x > ox) && (x <= ox + px *  4) && (y > oy) && (y <= oy + px * 34)) ||
        ((x > ox + px * 12) && (x <= ox + px * 36) && (y > oy + px * 30) && (y <= oy + px * 34)) ||
        ((x > ox + px * 12) && (x <= ox + px * 30) && (y > oy + px * 34) && (y <= oy + px * 38)) ||
        ((x > ox + px * 12) && (x <= ox + px * 24) && (y > oy + px * 38) && (y <= oy + px * 42)) ||
        // 左上角空白结束
        ((x > ox) && (x <= ox + px * 4) && (y > (H - px * 36)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 8) && (y > (H - px * 32)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 12) && (y > (H - px * 28)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 16) && (y > (H - px * 24)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 20) && (y > (H - px * 16)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 24) && (y > (H - px * 12)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 36) && (y > (H - px * 8)) && (y <= H)) ||
        ((x > ox + px * 36) && (x <= ox + px * 40) && (y > (H - px * 12)) && (y <= H)) ||
        // 左下角空白结束
        (x > (W - px * 8)) && (x <= W) && (y > (H - px * 64)) && (y <= H) ||
        (x > (W - px * 16)) && (x <= W) && (y > (H - px * 56)) && (y <= H) || 
        (x > (W - px * 24)) && (x <= W) && (y > (H - px * 40)) && (y <= H) ||
        (x > (W - px * 28)) && (x <= W) && (y > (H - px * 30)) && (y <= H) ||
        (x > (W - px * 32)) && (x <= W) && (y > (H - px * 24)) && (y <= H) ||
        (x > (W - px * 36)) && (x <= W) && (y > (H - px * 16)) && (y <= H - px * 8) ||
        // 右下角空白结束
        (x > ox + px * 36) && (x <= ox + px * 40) && (y > (H - px * 16)) && (y <= H) ||
        (x > ox + px * 32) && (x <= ox + px * 36) && (y > oy + px * 82) && (y <= oy + px * 86)) ||
        // 正中间下方 空白结束
        (x > W - px * 4 ) && (x <= W) && (y > oy) && (y <= oy + px * 8);
        // 右上角空白结束

   assign inDino_left = 
        ((x > ox + 48 * px) && (x <= ox + 80 * px) && (y > oy +  4 * px) && (y <= oy +  8 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy +  8 * px) && (y <= oy + 10 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 52 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) ||
        ((x > ox + 56 * px) && (x <= ox + 84 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) || //到眼睛结束
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy + 14 * px) && (y <= oy + 26 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 64 * px) && (y > oy + 26 * px) && (y <= oy + 30 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 76 * px) && (y > oy + 30 * px) && (y <= oy + 34 * px)) ||   // 脑袋结束
        ((x > ox + 40 * px) && (x <= ox + 60 * px) && (y > oy + 34 * px) && (y <= oy + 38 * px)) ||
        ((x > ox + 34 * px) && (x <= ox + 60 * px) && (y > oy + 38 * px) && (y <= oy + 42 * px)) || // 脖子结束
        ((x > ox +  4 * px) && (x <= ox +  8 * px) && (y > oy + 34 * px) && (y <= oy + 58 * px)) ||   // 尾巴从左到右1
        ((x > ox +  8 * px) && (x <= ox + 12 * px) && (y > oy + 42 * px) && (y <= oy + 62 * px)) || // 2
        ((x > ox + 12 * px) && (x <= ox + 16 * px) && (y > oy + 46 * px) && (y <= oy + 66 * px)) || // 3
        ((x > ox + 28 * px) && (x <= ox + 68 * px) && (y > oy + 42 * px) && (y <= oy + 46 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 60 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) ||
        ((x > ox + 64 * px) && (x <= ox + 68 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) || // 手部结束
        ((x > ox + 16 * px) && (x <= ox + 60 * px) && (y > oy + 50 * px) && (y <= oy + 60 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 56 * px) && (y > oy + 60 * px) && (y <= oy + 66 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 52 * px) && (y > oy + 66 * px) && (y <= oy + 70 * px)) ||
        ((x > ox + 20 * px) && (x <= ox + 48 * px) && (y > oy + 70 * px) && (y <= oy + 74 * px)) || // 肚子结束 // 腿部（动作部分改这块）
        ((x > ox + 24 * px) && (x <= ox + 32 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px)) ||
        ((x > ox + 28 * px) && (x <= ox + 36 * px) && (y > oy + 78 * px) && (y <= oy + 82 * px)) ||//左腿结束
        ((x > ox + 40 * px) && (x <= ox + 48 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 48 * px) && (y > oy + 78 * px) && (y <= oy + 86 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 52 * px) && (y > oy + 86 * px) && (y <= oy + 90 * px));  //右腿结束


   // 3. Right foot up (010)
   wire 	     inHitBox_right;
   wire 	     inDino_right;
   wire 	     inBlank_right;
   /* insert right foot up dino mapping here */

   assign inHitBox_right = (x > ox) && (x <= W) && (y > oy) && (y <= H);

   assign inBlank_right = 
        ((x > ox) && (x <= ox + px * 44) && (y > oy) && (y <= oy + px *  4)) ||
        ((x > ox) && (x <= ox + px * 40) && (y > oy) && (y <= oy + px * 30)) ||
        ((x > ox) && (x <= ox + px *  4) && (y > oy) && (y <= oy + px * 34)) ||
        ((x > ox + px * 12) && (x <= ox + px * 36) && (y > oy + px * 30) && (y <= oy + px * 34)) ||
        ((x > ox + px * 12) && (x <= ox + px * 30) && (y > oy + px * 34) && (y <= oy + px * 38)) ||
        ((x > ox + px * 12) && (x <= ox + px * 24) && (y > oy + px * 38) && (y <= oy + px * 42)) ||
        // 左上角空白结束
        ((x > ox) && (x <= ox + px * 4) && (y > (H - px * 36)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 8) && (y > (H - px * 32)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 12) && (y > (H - px * 28)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 16) && (y > (H - px * 24)) && (y <= H)) ||
        ((x > ox) && (x <= ox + px * 20) && (y > (H - px * 16)) && (y <= H)) ||
        // 左下角空白结束
        (x > (W - px * 8)) && (x <= W) && (y > (H - px * 64)) && (y <= H) ||
        (x > (W - px * 16)) && (x <= W) && (y > (H - px * 56)) && (y <= H) || 
        (x > (W - px * 24)) && (x <= W) && (y > (H - px * 40)) && (y <= H) ||
        (x > (W - px * 28)) && (x <= W) && (y > (H - px * 30)) && (y <= H) ||
        (x > (W - px * 32)) && (x <= W) && (y > (H - px * 24)) && (y <= (H - px * 20)) ||
        (x > ox + 62 * px) && (x <= W) && (y > oy + 74 * px) && (y <= H) ||
        (x > ox + 58 * px) && (x <= W) && (y > oy + 78 * px) && (y <= H) ||
        // 右下角空白结束
        (x > ox + px * 36) && (x <= ox + px * 40) && (y > (H - px * 16)) && (y <= H) ||
        (x > ox + px * 32) && (x <= ox + px * 36) && (y > oy + px * 82) && (y <= oy + px * 86)) ||
        // 正中间下方 空白结束
        (x > W - px * 4 ) && (x <= W) && (y > oy) && (y <= oy + px * 8)
        // 右上角空白结束

   assign inDino_right = 
        ((x > ox + 48 * px) && (x <= ox + 80 * px) && (y > oy +  4 * px) && (y <= oy +  8 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy +  8 * px) && (y <= oy + 10 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 52 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) ||
        ((x > ox + 56 * px) && (x <= ox + 84 * px) && (y > oy + 10 * px) && (y <= oy + 14 * px)) || //到眼睛结束
        ((x > ox + 44 * px) && (x <= ox + 84 * px) && (y > oy + 14 * px) && (y <= oy + 26 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 64 * px) && (y > oy + 26 * px) && (y <= oy + 30 * px)) ||
        ((x > ox + 44 * px) && (x <= ox + 76 * px) && (y > oy + 30 * px) && (y <= oy + 34 * px)) ||   // 脑袋结束
        ((x > ox + 40 * px) && (x <= ox + 60 * px) && (y > oy + 34 * px) && (y <= oy + 38 * px)) ||
        ((x > ox + 34 * px) && (x <= ox + 60 * px) && (y > oy + 38 * px) && (y <= oy + 42 * px)) || // 脖子结束
        ((x > ox +  4 * px) && (x <= ox +  8 * px) && (y > oy + 34 * px) && (y <= oy + 58 * px)) ||   // 尾巴从左到右1
        ((x > ox +  8 * px) && (x <= ox + 12 * px) && (y > oy + 42 * px) && (y <= oy + 62 * px)) || // 2
        ((x > ox + 12 * px) && (x <= ox + 16 * px) && (y > oy + 46 * px) && (y <= oy + 66 * px)) || // 3
        ((x > ox + 28 * px) && (x <= ox + 68 * px) && (y > oy + 42 * px) && (y <= oy + 46 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 60 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) ||
        ((x > ox + 64 * px) && (x <= ox + 68 * px) && (y > oy + 46 * px) && (y <= oy + 50 * px)) || // 手部结束
        ((x > ox + 16 * px) && (x <= ox + 60 * px) && (y > oy + 50 * px) && (y <= oy + 60 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 56 * px) && (y > oy + 60 * px) && (y <= oy + 66 * px)) ||
        ((x > ox + 16 * px) && (x <= ox + 52 * px) && (y > oy + 66 * px) && (y <= oy + 70 * px)) ||
        ((x > ox + 20 * px) && (x <= ox + 48 * px) && (y > oy + 70 * px) && (y <= oy + 74 * px)) || // 肚子结束 // 腿部（动作部分改这块）
        ((x > ox + 24 * px) && (x <= ox + 36 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 32 * px) && (y > oy + 78 * px) && (y <= oy + 82 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 28 * px) && (y > oy + 82 * px) && (y <= oy + 86 * px)) ||
        ((x > ox + 24 * px) && (x <= ox + 32 * px) && (y > oy + 86 * px) && (y <= oy + 90 * px)) || //左腿结束
        ((x > ox + 44 * px) && (x <= ox + 54 * px) && (y > oy + 74 * px) && (y <= oy + 78 * px));   //右腿结束

   
   // 4. Dead dino (011)
   wire 	     inHitBox_dead;
   wire 	     inDino_dead;
   wire 	     inBlank_dead;
   /* insert dead dino mapping here */


   
   // First bit 1, meaning duck mode -> don't use default W and H
   // 5. Ducking dino left up (101)
   wire 	     inHitBox_duckLeft;
   wire 	     inDino_duckLeft;
   wire 	     inBlank_duckLeft;
   /* insert duck left mapping here */

   // 6. Ducking dino right up (110)
   wire        inHitBox_duckRight;
   wire        inDino_duckRight;
   wire        inBlank_duckRight;
   /* insert duckRight mapping here */
   


  assign inFrame = (inHitBox) & (~inDino) & (~inBlank);

endmodule // End of dino
