`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 21:23:20
// Design Name: 
// Module Name: Stop_Walls
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


module Stop_Walls #(
        parameter ROW_LOC = 0,
        parameter COL_LOC = 0,
        parameter DIMENSIONS = 10//,
        // Do not declare these parameters (Use default values)
/*        parameter LEFT_BOUND = (COL_LOC > DIMENSIONS) ? COL_LOC - DIMENSIONS : 0,
        parameter RIGHT_BOUND = (COL_LOC + DIMENSIONS < 96) ? COL_LOC + DIMENSIONS : 95,
        parameter TOP_BOUND = (ROW_LOC > DIMENSIONS) ? ROW_LOC - DIMENSIONS : 0,
        parameter BOTTOM_BOUND = (ROW_LOC + DIMENSIONS < 64) ? ROW_LOC + DIMENSIONS : 63*/
    )(
        input CLK,
        (* KEEP = "TRUE" *) input [6:0] xOffset,
        (* KEEP = "TRUE" *) input [5:0] yOffset,
        (* KEEP = "TRUE" *) output stopFlag
    );
     
    assign stopFlag = (xOffset == COL_LOC && yOffset == ROW_LOC);
    
endmodule
