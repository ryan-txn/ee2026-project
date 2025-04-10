`timescale 1ns / 1ps

module returnColour_StaticTraps #(
    parameter ROW_LOC = 0,
    parameter COL_LOC = 0,
    parameter DIMENSIONS = 10
    )(
    input clk, input [12:0] pixel_index,
    output reg trapFlag);

    always @ (posedge clk) begin
        if ( // Paint pixels to colour red
            (pixel_index / 96 < ROW_LOC + DIMENSIONS && pixel_index / 96 >= ROW_LOC) && 
            (pixel_index % 96 < COL_LOC + DIMENSIONS && pixel_index % 96 >= COL_LOC)) begin
            trapFlag = 1;
        end else begin
            trapFlag = 0;
        end
    end
        
endmodule
