`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 20:01:31
// Design Name: 
// Module Name: returnColour
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

// Array of trap locations and colour
module returnColour(
        input clk,
        input [12:0] pixel_index,
        input [6:0] xOffset,
        input [5:0] yOffset,
        input resetFlag,
        input [4:0] taken, // each bit respresent 1 key, if 00100 means key 3 is taken and should not be shown
        output reg [15:0] oled_colour
    );
    
    // instantiate wall flags for each object instance
    wire wall1_flag;
    
    // instantiate trap flags 
    wire trap1_flag;
    wire trap2_flag;
    wire trap3_flag;
    wire trap4_flag;
    wire trapDynamic1_flag;
    wire trapDynamic2_flag;
    
    //instantiate key flags
    wire key1_flag;
    
    //instantiate door flags
    wire door1_flag;
    
    integer count = 0;

        
    always @ (posedge clk) begin // edit and put in separate module
        count <= count + 1;
        if (resetFlag) begin
            count <= 0;
        end
    
        if ( // Paint block/player pixels to colour green
            (pixel_index / 96 < 4 + yOffset && pixel_index / 96 >= yOffset) && 
            (pixel_index % 96 < 4 + xOffset && pixel_index % 96 >= xOffset) &&
            !(
                (count < 50000000 && count > 0) || 
                (count < 150000000 && count > 100000000) ||
                (count < 250000000 && count > 200000000) )
            )
            oled_colour <= 16'h07E0; //green    
        else if (wall1_flag)
            oled_colour <= 16'hFFFF; //white    
        else if (
            trap1_flag || 
            trap2_flag ||
            trap3_flag ||
            trap4_flag 
        )
            oled_colour <= 16'hF800;  //red   
        else if (key1_flag)
            oled_colour <= 16'hF819;  //pink         
        else if (door1_flag == 1)//door open/exist a place to stop
            oled_colour <= 16'hFFFF;  //white becomes a stop point after taking key
        else if (
            trapDynamic1_flag ||
            trapDynamic2_flag
        )
            oled_colour <= 16'hFB00; //orange
        else 
            oled_colour <= 0;   
    end
    
    // Walls shader, instantiate multiple traps (Location is top left of object)
    // Link the flags
    returnColour_Walls #(
        .ROW_LOC(0),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) wall1_Colour (
        clk,
        pixel_index,
        wall1_flag
    );
    
    // Traps shader, instantiate multiple traps (Location is top left of object)
    // Link the flags
    returnColour_StaticTraps #(
        .ROW_LOC(0),
        .COL_LOC(85),
        .DIMENSIONS(4)
    ) trap1_Colour (
        clk,
        pixel_index,
        trap1_flag
    );
    
    returnColour_StaticTraps #(
        .ROW_LOC(53),
        .COL_LOC(85),
        .DIMENSIONS(4)
    ) trap2_Colour (
        clk,
        pixel_index,
        trap2_flag
    );
    
    returnColour_StaticTraps #(
        .ROW_LOC(30),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) trap3_Colour (
        clk,
        pixel_index,
        trap3_flag
    );
    
    returnColour_StaticTraps #(
        .ROW_LOC(53),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) trap4_Colour (
        clk,
        pixel_index,
        trap4_flag
    );
    
    returnColour_DynamicTraps #(
        .ROW_LOC(30),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic1_Colour (
        clk,
        pixel_index,
        trapDynamic1_flag
    );
    
    returnColour_DynamicTraps #(
        .ROW_LOC(30),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic2_Colour (
        clk,
        pixel_index,
        trapDynamic2_flag
    );
    
    returnColour_Key_Door #(
        .ROW_LOC_KEY(0),
        .COL_LOC_KEY(25),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(25),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key1_Colour (
        clk,
        pixel_index,
        taken[0],
        key1_flag,
        door1_flag
    );
    
endmodule
