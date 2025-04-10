`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 09:26:22
// Design Name: 
// Module Name: Reset_StaticTraps
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

// Array of loc and dimensions for multiple traps?
module Reset_StaticTrap #(
        parameter ROW_LOC = 0,
        parameter COL_LOC = 0,
        parameter DIMENSIONS = 10,
        // Do not declare these parameters (Use default values)
        parameter LEFT_BOUND = (COL_LOC > DIMENSIONS) ? COL_LOC - DIMENSIONS : 0,
        parameter RIGHT_BOUND = (COL_LOC + DIMENSIONS < 96) ? COL_LOC + DIMENSIONS : 95,
        parameter TOP_BOUND = (ROW_LOC > DIMENSIONS) ? ROW_LOC - DIMENSIONS : 0,
        parameter BOTTOM_BOUND = (ROW_LOC + DIMENSIONS < 64) ? ROW_LOC + DIMENSIONS : 63
    )(
        input CLK,
        (* KEEP = "TRUE" *) input [6:0] xOffset,
        (* KEEP = "TRUE" *) input [5:0] yOffset,
        (* KEEP = "TRUE" *) output reg resetFlag
    );
    
    always @ (posedge CLK) begin

        if (    
            (xOffset >= LEFT_BOUND && xOffset < RIGHT_BOUND) &&
            (yOffset >= TOP_BOUND && yOffset < BOTTOM_BOUND)      
        ) begin
            resetFlag <= 1;
        end
        else begin 
            resetFlag <= 0;
        end
    end
    
endmodule
