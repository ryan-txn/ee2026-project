`timescale 1ns / 1ps

module Keys_Doors #(
    parameter ROW_LOC_KEY = 0,
    parameter COL_LOC_KEY = 0,
    parameter DIMENSIONS_KEY = 10,
    parameter ROW_LOC_DOOR = 0,
    parameter COL_LOC_DOOR = 0,
    parameter DIMENSIONS_DOOR = 10,        
    // Do not declare these parameters (Use default values)
    parameter LEFT_BOUND = (COL_LOC_KEY > DIMENSIONS_KEY) ? COL_LOC_KEY - DIMENSIONS_KEY : 0,
    parameter RIGHT_BOUND = (COL_LOC_KEY + DIMENSIONS_KEY < 96) ? COL_LOC_KEY + DIMENSIONS_KEY : 95,
    parameter TOP_BOUND = (ROW_LOC_KEY > DIMENSIONS_KEY) ? ROW_LOC_KEY - DIMENSIONS_KEY : 0,
    parameter BOTTOM_BOUND = (ROW_LOC_KEY + DIMENSIONS_KEY < 64) ? ROW_LOC_KEY + DIMENSIONS_KEY : 63
    )(
    input CLK,
    (* KEEP = "TRUE" *) input [6:0] xOffset,
    (* KEEP = "TRUE" *) input [5:0] yOffset,
    (* KEEP = "TRUE" *) input reset,
    (* KEEP = "TRUE" *) output reg takenFlag = 0,
    (* KEEP = "TRUE" *) output reg doorFlag);
    
    always @ (posedge CLK) begin
        if (    
            (xOffset >= LEFT_BOUND && xOffset < RIGHT_BOUND) &&
            (yOffset >= TOP_BOUND && yOffset < BOTTOM_BOUND)) begin
            takenFlag <= 1;
        end else if (reset) 
            takenFlag <= 0;
        
        if (    
            xOffset == COL_LOC_DOOR && yOffset == ROW_LOC_DOOR && takenFlag) begin
            doorFlag <= 1;
        end else begin 
            doorFlag <= 0;
        end
    end
    
endmodule

