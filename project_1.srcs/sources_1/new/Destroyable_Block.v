`timescale 1ns / 1ps

module Destroyable_Block #(
    parameter ROW_LOC = 0,
    parameter COL_LOC = 0,
    parameter DIMENSIONS = 10,
    // Do not declare these parameters (Use default values)
    parameter LEFT_BOUND = (COL_LOC > DIMENSIONS) ? COL_LOC - DIMENSIONS : 0,
    parameter RIGHT_BOUND = (COL_LOC + DIMENSIONS < 96) ? COL_LOC + DIMENSIONS : 95,
    parameter TOP_BOUND = (ROW_LOC > DIMENSIONS) ? ROW_LOC - DIMENSIONS : 0,
    parameter BOTTOM_BOUND = (ROW_LOC + DIMENSIONS < 64) ? ROW_LOC + DIMENSIONS : 63
    ) (
    input CLK, 
    (* KEEP = "TRUE" *) input [6:0] xOffset,
    (* KEEP = "TRUE" *) input [5:0] yOffset,
    (* KEEP = "TRUE" *) input reset,
    (* KEEP = "TRUE" *) output reg collidedFlag);
    
    initial begin
        collidedFlag = 0;
    end
    
    always @ (posedge CLK) begin
        if (((xOffset == (COL_LOC - DIMENSIONS)) && (yOffset >= (ROW_LOC - (DIMENSIONS - 1)) 
                && yOffset <= (ROW_LOC + (DIMENSIONS - 1)))) ||
            ((xOffset == (COL_LOC + DIMENSIONS)) && (yOffset >= (ROW_LOC - (DIMENSIONS - 1)) 
                && yOffset <= (ROW_LOC + (DIMENSIONS - 1)))) ||
            ((xOffset >= (COL_LOC - (DIMENSIONS - 1)) && xOffset <= (COL_LOC + (DIMENSIONS - 1))) 
                && (yOffset == (ROW_LOC - DIMENSIONS))) ||
            ((xOffset >= (COL_LOC - (DIMENSIONS - 1)) && xOffset <= (COL_LOC + (DIMENSIONS - 1)))
                && (yOffset == (ROW_LOC + DIMENSIONS)))) begin
            collidedFlag <= 1;
        end else if (reset)
            collidedFlag <= 0;
    end
    
endmodule
