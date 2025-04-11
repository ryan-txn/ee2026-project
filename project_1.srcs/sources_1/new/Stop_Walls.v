`timescale 1ns / 1ps

module Stop_Walls #(
    parameter ROW_LOC = 0,
    parameter COL_LOC = 0,
    parameter DIMENSIONS = 10//,
    )(
    (* KEEP = "TRUE" *) input [6:0] xOffset,
    (* KEEP = "TRUE" *) input [5:0] yOffset,
    (* KEEP = "TRUE" *) output stopFlag);
     
    assign stopFlag = (xOffset == COL_LOC && yOffset == ROW_LOC);
    
endmodule
