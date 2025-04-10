`timescale 1ns / 1ps

module returnColour_Destroyable #(
    parameter ROW_LOC = 0,
    parameter COL_LOC = 0,
    parameter DIMENSIONS = 10
    ) (
    input clk, input [12:0] pixel_index, input collided_flag,
    output reg destroyed_flag);
    
    always @ (posedge clk) begin
        if ((pixel_index / 96 < ROW_LOC + DIMENSIONS && pixel_index / 96 >= ROW_LOC) && 
            (pixel_index % 96 < COL_LOC + DIMENSIONS && pixel_index % 96 >= COL_LOC) && (~collided_flag)) begin
            destroyed_flag <= 1;
        end else
            destroyed_flag <= 0;
    end
    
endmodule
