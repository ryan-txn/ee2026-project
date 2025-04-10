`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2025 12:49:19
// Design Name: 
// Module Name: Reset_DynamicTraps
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
// 5s / 6.25MHz = 800000 ticks
// 1100_0011_0101_0000_0000
// C_3500
module Reset_DynamicTrap #(
        parameter ROW_LOC = 0,
        parameter COL_LOC = 0,
        parameter DIMENSIONS = 4,
        parameter IS_UP_DIRECTION = 1,
        // Do not declare these parameters (Use default values), unless the trap's movement depends on different things
        parameter LEFT_BOUND = (COL_LOC > DIMENSIONS) ? COL_LOC - DIMENSIONS : 0,
        parameter RIGHT_BOUND = (COL_LOC + DIMENSIONS < 96) ? COL_LOC + DIMENSIONS : 95,
        parameter TOP_BOUND = (ROW_LOC > DIMENSIONS) ? ROW_LOC - DIMENSIONS : 0,
        parameter BOTTOM_BOUND = (ROW_LOC + DIMENSIONS < 64) ? ROW_LOC + DIMENSIONS : 63,
        parameter TRAP_MOVEMENT_BOUND1 = 0,
        parameter TRAP_MOVEMENT_BOUND2 = (IS_UP_DIRECTION) ? 63 : 95
    )(
        input CLK,
        (* KEEP = "TRUE" *) input [6:0] xOffset,
        (* KEEP = "TRUE" *) input [5:0] yOffset,
        (* KEEP = "TRUE" *) output reg resetFlag
    );
    

    
    integer count;
    reg [6:0] trapOffset; // Changes ROW_LOC and COL_LOC
    reg trapMovement; // Direction of trap's movement, 1 is down/right, 0 is up/left
     
    initial begin
        count <= 0;
        trapOffset <= (IS_UP_DIRECTION) ? ROW_LOC : COL_LOC;
        trapMovement <= 1;
    end
    
    wire isInTrap;
    
    assign isInTrap = ( // Rollover?
        (IS_UP_DIRECTION) ? (
            (xOffset >= LEFT_BOUND && xOffset < RIGHT_BOUND) &&
            (yOffset >= trapOffset && yOffset < trapOffset + DIMENSIONS)
        ) : (
            (xOffset >= trapOffset && xOffset < trapOffset + DIMENSIONS) &&
            (yOffset >= TOP_BOUND && yOffset < BOTTOM_BOUND)
        )
    );
    
    always @ (posedge CLK) begin
        count <= count + 1;
        
        if (trapOffset == TRAP_MOVEMENT_BOUND2 - DIMENSIONS)
            trapMovement <= 0;
        else if (trapOffset == TRAP_MOVEMENT_BOUND1)
            trapMovement <= 1;
            
        // Move trap location //208332
        if (count > 3333333) begin
            count <= 0;
            trapOffset <= (trapMovement) ? (trapOffset + 1) : (trapOffset - 1);
        end 
        
        // Reset player
        if (    
            isInTrap    
        ) begin
            resetFlag <= 1;
        end
        else begin 
            resetFlag <= 0;
        end
    end
    
endmodule