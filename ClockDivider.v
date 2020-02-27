`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:24:24 02/25/2020 
// Design Name: 
// Module Name:    ClockDivider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ClockDivider#(parameter velocity = 1)
    (input wire clk,
     output wire speed);
    
    reg [31:0] counter;
    reg clock;
    localparam threashold = 1000000 / velocity;
    
    initial begin
        counter <= 0;
        clock <= 0;
    end
    
    always @(posedge clk) begin
        if (counter == threashold - 1) begin
            counter <= 0;
            clock <= ~clock;
        end
        else begin
            counter <= counter + 1;
            clock <= clock;
        end
    end
    
    assign speed = clock;
endmodule
