`timescale 1ns / 1ps

module returnColour_Key_Door #(
    parameter ROW_LOC_KEY = 0,
    parameter COL_LOC_KEY = 0,
    parameter DIMENSIONS_KEY = 10,
    parameter ROW_LOC_DOOR = 0,
    parameter COL_LOC_DOOR = 0,
    parameter DIMENSIONS_DOOR = 10
    )(
    input clk, input [12:0] pixel_index, input taken,
    output reg keyFlag, output reg doorFlag);
    
    always @ (posedge clk) begin
        if (
            (pixel_index / 96 < ROW_LOC_KEY + DIMENSIONS_KEY && pixel_index / 96 >= ROW_LOC_KEY) && 
            (pixel_index % 96 < COL_LOC_KEY + DIMENSIONS_KEY && pixel_index % 96 >= COL_LOC_KEY) &&
            (~taken)) begin
            keyFlag <= 1;
        end else begin
            keyFlag <= 0;
        end
        
        if (
            (pixel_index / 96 < ROW_LOC_DOOR + DIMENSIONS_DOOR && pixel_index / 96 >= ROW_LOC_DOOR) && 
            (pixel_index % 96 < COL_LOC_DOOR + DIMENSIONS_DOOR && pixel_index % 96 >= COL_LOC_DOOR) &&
            (taken)) begin
            doorFlag <= 1;
        end else begin
            doorFlag <= 0;
        end        
    end
    
endmodule
