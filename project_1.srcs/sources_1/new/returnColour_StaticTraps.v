`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 10:26:15
// Design Name: 
// Module Name: returnColour_StaticTraps
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


module returnColour_StaticTraps #(
        parameter ROW_LOC = 0,
        parameter COL_LOC = 0,
        parameter DIMENSIONS = 10
    )(
        input clk,
        input [12:0] pixel_index,
        output reg trapFlag
    );

    always @ (posedge clk) begin
        if ( // Paint pixels to colour red
            (pixel_index / 96 < ROW_LOC + DIMENSIONS && pixel_index / 96 >= ROW_LOC) && 
            (pixel_index % 96 < COL_LOC + DIMENSIONS && pixel_index % 96 >= COL_LOC)
        ) begin
            trapFlag = 1;
        end
        else begin
            trapFlag = 0;
        end
    end
        
endmodule
