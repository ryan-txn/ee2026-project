`timescale 1ns / 1ps

module Game_1 (
    input clk, input clk6p25m, input [12:0] pixel_index, 
    input enable, input [15:0] scan_code,
    output [15:0] oled_data, output level_1_done); 

    // Oled_Display extra
    wire sample_pixel;
    wire sending_pixels;
    wire frame_begin;

    reg reset = 0;

    wire [15:0] oled_colour;
    // push oled_colour output from returnColour to top
    assign oled_data = oled_colour;

    // input direction from buttons
    wire [3:0] mvtDirection;
    // reg for latching on the commands from mvtDirection
    reg [3:0] nextMovement = 4'b1111;

    // Position of box
    reg [6:0] xOffset = 0;
    reg [5:0] yOffset = 0;
    reg [6:0] prevXOffset = 0;
    reg [5:0] prevYOffset = 0;

    // reset keys/doors when trap hit
    reg reset_keys = 0;
    // key taken record
    wire taken;
    // door flags
    wire door1_Flag;

    // wall stop flags
    wire rest1_StopFlag;
    wire rest2_StopFlag;
    wire rest3_StopFlag;
    wire rest4_StopFlag;
    wire rest5_StopFlag;

    
    wire restStop;
    assign restStop = (
        rest1_StopFlag || rest2_StopFlag || 
        rest3_StopFlag || rest4_StopFlag ||
        rest5_StopFlag);
        
    assign level_1_done = door1_Flag;

    // trap reset flags
    wire trap1_ResetFlag;
    wire trap2_ResetFlag;
    wire trap3_ResetFlag;
    wire trap4_ResetFlag;
    wire trapReset;
    
    assign trapReset = (
        trap1_ResetFlag || trap2_ResetFlag ||
        trap3_ResetFlag || trap4_ResetFlag);
        

    // Boundaries
    parameter OOB_top = 0;
    parameter OOB_left = 0;
    parameter OOB_right = 92; //95
    parameter OOB_bottom = 60; //63

    integer count = 0;
    reg first_touch_stops = 1;
    reg reset_done = 0;

    // edit and put in separate module
    always @ (posedge clk6p25m) begin 
        count <= count + 1;
        
        // shld only allow if touching wall
        if (mvtDirection != 4'b0000 && (xOffset == prevXOffset && yOffset == prevYOffset))
            nextMovement <= mvtDirection;
       
        // Reset if quit (go to menu) 
        if (!enable) begin
            reset_done <= 0;
        end else if (enable && !reset_done) begin
            xOffset <= 0;
            yOffset <= 0;
            nextMovement <= 4'b1111;
            reset_keys <= 1;
            reset_done <= 1;
        // Reset if touching traps
        end else if (trapReset) begin
            xOffset <= 0;
            yOffset <= 0;
            nextMovement <= 4'b1111;
            reset_keys <= 1;
        end else if (restStop && first_touch_stops) begin
            if (first_touch_stops) begin
                nextMovement <= 4'b1111; // Arbitrary value to stop movement
                first_touch_stops <= 0;
            end
        // Change movement direction every 100 cycles, 208332 is from calculation
        end else if (count > 208332) begin 
            count <= 0;
            reset_keys <= 0;
            first_touch_stops <= 1;
    
            // Stop if touching rest points
            if (restStop) begin
                nextMovement <= 4'b1111; // Arbitrary value to stop movement
            end

            // Change movement from rest points
            if (xOffset == 60 && yOffset == 0) // Rest point 1 coordinates
                nextMovement <= mvtDirection;
        
            if (xOffset == 80 && yOffset == 30) // Rest point 2 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 60 && yOffset == 56) // Rest point 3 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 80 && yOffset == 56) // Rest point 4 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 0 && yOffset == 0 && door1_Flag) begin // Door1 coordinates
                nextMovement <= 4'b1111;
                reset_keys <= 1;
            end
                
            
            // Change direction
            prevYOffset <= yOffset;
            prevXOffset <= xOffset;
        
            // U L R D (With reference to top right corner of the box as its location coordinate)
            case (nextMovement) 
                4'b0001 : begin // Up
                    yOffset <= (yOffset > OOB_top) ? yOffset - 1 : yOffset;
                    nextMovement <= 4'b0001;
                end
                4'b0010 : begin // Left
                    xOffset <= (xOffset > OOB_left) ? xOffset - 1 : xOffset;
                    nextMovement <= 4'b0010; 
                end
                4'b0100 : begin // Right
                    xOffset <= (xOffset < OOB_right) ? xOffset + 1 : xOffset;
                    nextMovement <= 4'b0100;
                end
                4'b1000 : begin // Down
                    yOffset <= (yOffset < OOB_bottom) ? yOffset + 1 : yOffset;
                    nextMovement <= 4'b1000; 
                end
            endcase
        end else
            reset_keys <= 0;
    end

    // Block/Player shader (Location is top left of object)
    returnColourGame1 shader (
        clk, pixel_index, xOffset, yOffset,
        taken, oled_colour);

    // Block/Player Movement
    MoveWASD move (
        clk, scan_code, mvtDirection);

    // Rest point logic, instantiate multiple rest points (Location is top left of object)
    // Link all wall stop flags
    Stop_Walls #(         
        .ROW_LOC(0),
        .COL_LOC(60),
        .DIMENSIONS(4)
    ) restPoint1 (
        xOffset, yOffset, rest1_StopFlag);
        
    Stop_Walls #(         
        .ROW_LOC(30),
        .COL_LOC(80),
        .DIMENSIONS(4)
    ) restPoint2 (
        xOffset, yOffset, rest2_StopFlag);
        
    Stop_Walls #(         
            .ROW_LOC(56),
            .COL_LOC(60),
            .DIMENSIONS(4)
        ) restPoint3 (
            xOffset, yOffset, rest3_StopFlag);

    Stop_Walls #(         
            .ROW_LOC(56),
            .COL_LOC(80),
            .DIMENSIONS(4)
        ) restPoint4 (
            xOffset, yOffset, rest4_StopFlag);
            
    Stop_Walls #(         
            .ROW_LOC(30),
            .COL_LOC(0),
            .DIMENSIONS(4)
        ) restPoint5 (
            xOffset, yOffset, rest5_StopFlag);

    // Trap reset logic, instantiate multiple traps (Location is top left of object)
    // Link all trap reset flags
    Reset_StaticTrap #(         
        .ROW_LOC(20),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) trap1 (
        clk6p25m, xOffset, yOffset, trap1_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(56),
        .COL_LOC(35),
        .DIMENSIONS(4)
    ) trap2 (
        clk6p25m, xOffset, yOffset, trap2_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(60),
        .COL_LOC(35),
        .DIMENSIONS(4)
    ) trap3 (
        clk6p25m, xOffset, yOffset, trap3_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(0),
        .COL_LOC(90),
        .DIMENSIONS(4)
    ) trap4 (
        clk6p25m, xOffset, yOffset, trap4_ResetFlag);

    // Key / door logic, instantiate multiple keys / doors (Location is top left of object)
    // Link all key / door flags
    Keys_Doors #(
        .ROW_LOC_KEY(60),
        .COL_LOC_KEY(0),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(0),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key_door1 (
        clk6p25m, xOffset, yOffset, 
        reset_keys, taken, door1_Flag);

endmodule