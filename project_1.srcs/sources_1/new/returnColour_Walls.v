`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 21:07:44
// Design Name: 
// Module Name: returnColour_Walls
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module returnColour_Walls #(
        parameter ROW_LOC = 0,
        parameter COL_LOC = 0,
        parameter DIMENSIONS = 10
    )(
        input clk,
        input [12:0] pixel_index,
        output reg wallFlag
    );
    
    always @ (posedge clk) begin
        if ( // Paint pixels to colour red
            (pixel_index / 96 < ROW_LOC + DIMENSIONS && pixel_index / 96 >= ROW_LOC) && 
            (pixel_index % 96 < COL_LOC + DIMENSIONS && pixel_index % 96 >= COL_LOC)
        ) begin
            wallFlag = 1;
        end
        else begin
            wallFlag = 0;
        end
    end
    
endmodule
