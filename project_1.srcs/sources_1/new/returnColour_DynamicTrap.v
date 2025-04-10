`timescale 1ns / 1ps

module returnColour_DynamicTraps #(
    parameter ROW_LOC = 0,
    parameter COL_LOC = 0,
    parameter DIMENSIONS = 10, 
    // Don't need to edit these
    parameter IS_UP_DIRECTION = 1,
    parameter TRAP_MOVEMENT_BOUND1 = 0,
    parameter TRAP_MOVEMENT_BOUND2 = (IS_UP_DIRECTION) ? 63 : 95
    )(
    input clk, input [12:0] pixel_index,
    output reg trapFlag);
    
    integer count;
    reg [6:0] trapOffset; // Changes ROW_LOC and COL_LOC
    reg trapMovement; // Direction of trap's movement (1 is down/right, 0 is up/left)
    
    initial begin
        count = 0;
        trapOffset = (IS_UP_DIRECTION) ? ROW_LOC : COL_LOC;
        trapMovement = 1;
    end
    
    wire isInTrap;
    
    assign isInTrap = (
        (IS_UP_DIRECTION) ? (
            (pixel_index / 96 < trapOffset + DIMENSIONS && pixel_index / 96 >= trapOffset) && 
            (pixel_index % 96 < COL_LOC + DIMENSIONS && pixel_index % 96 >= COL_LOC)
        ) : (
            (pixel_index / 96 < ROW_LOC + DIMENSIONS && pixel_index / 96 >= ROW_LOC) && 
            (pixel_index % 96 < trapOffset + DIMENSIONS && pixel_index % 96 >= trapOffset)
        )
    );

    always @ (posedge clk) begin
        count = count + 1;
    
        if (trapOffset == TRAP_MOVEMENT_BOUND2 - DIMENSIONS)
            trapMovement = 0;
        else if (trapOffset == TRAP_MOVEMENT_BOUND1)
            trapMovement = 1;
            
        // Move trap location (208332)
        if (count > 3333333) begin
            count = 0;
            trapOffset = (trapMovement) ? (trapOffset + 1) : (trapOffset - 1);
        end 
    
        if ( // Paint pixels to colour red
            isInTrap) begin
           trapFlag = 1;
        end else begin
           trapFlag = 0;
        end
    end
    
endmodule
