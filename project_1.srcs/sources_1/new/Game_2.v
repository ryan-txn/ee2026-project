`timescale 1ns / 1ps

module Game_2 (
    input clk, input clk6p25m, input [12:0] pixel_index, 
    input enable, input [15:0] scan_code,
    output [15:0] oled_data, output level_2_done); 

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
    wire [3:0] taken;
    // door flags
    wire door1_Flag;
    wire door2_Flag;
    wire door3_Flag;
    wire door4_Flag;

    // wall stop flags
    wire rest1_StopFlag;
    wire rest2_StopFlag;
    wire restStop;
    
    assign restStop = (
        rest1_StopFlag || rest2_StopFlag || 
        door1_Flag || door2_Flag || 
        door3_Flag || door4_Flag);
    assign level_2_done = door4_Flag;

    // trap reset flags
    wire trap1_ResetFlag;
    wire trap2_ResetFlag;
    wire trap3_ResetFlag;
    wire trap4_ResetFlag;
    wire trapDynamic1_Resetflag;
    wire trapDynamic2_Resetflag;
    wire trapDynamic3_Resetflag;
    wire trapReset;
    
    assign trapReset = (
        trap1_ResetFlag || trap2_ResetFlag ||
        trap3_ResetFlag || trap4_ResetFlag ||
        trapDynamic1_Resetflag || trapDynamic2_Resetflag || 
        trapDynamic3_Resetflag);
        
    // destroyable block flag
    wire [1:0] collided_Flag;

    // Boundaries
    parameter OOB_top = 0;
    parameter OOB_left = 0;
    parameter OOB_right = 92; //95
    parameter OOB_bottom = 59; //63

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
            if (xOffset == 40 && yOffset == 0) // Rest point coordinates
                nextMovement <= mvtDirection;
        
            if (xOffset == 0 && yOffset == 20 && door1_Flag) // Door1 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 92 && yOffset == 47 && door2_Flag) // Door2 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 73 && yOffset == 59 && door3_Flag) // Door3 coordinates
                nextMovement <= mvtDirection;
                
            if (xOffset == 0 && yOffset == 0 && door4_Flag) begin // Door4 coordinates
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
    returnColour shader (
        clk, pixel_index, xOffset + 10, yOffset + 10,
        collided_Flag, taken, oled_colour);

    // Block/Player Movement
    MoveWASD move (
        clk, scan_code, mvtDirection);

    // Rest point logic, instantiate multiple rest points (Location is top left of object)
    // Link all wall stop flags
    Stop_Walls #(         
        .ROW_LOC(0),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) restPoint1 (
        xOffset, yOffset, rest1_StopFlag);
        
    Stop_Walls #(         
        .ROW_LOC(47),
        .COL_LOC(55),
        .DIMENSIONS(4)
    ) restPoint2 (
        xOffset, yOffset, rest2_StopFlag);

    // Trap reset logic, instantiate multiple traps (Location is top left of object)
    // Link all trap reset flags
    Reset_StaticTrap #(         
        .ROW_LOC(0),
        .COL_LOC(85),
        .DIMENSIONS(4)
    ) trap1 (
        clk6p25m, xOffset, yOffset, trap1_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(54),
        .COL_LOC(92),
        .DIMENSIONS(4)
    ) trap2 (
        clk6p25m, xOffset, yOffset, trap2_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(30),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) trap3 (
        clk6p25m, xOffset, yOffset, trap3_ResetFlag);

    Reset_StaticTrap #(         
        .ROW_LOC(54),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) trap4 (
        clk6p25m, xOffset, yOffset, trap4_ResetFlag);


    Reset_DynamicTrap #(         
        .ROW_LOC(30),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic1 (
        clk, xOffset, yOffset, trapDynamic1_Resetflag);

    Reset_DynamicTrap #(         
        .ROW_LOC(40),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic2 (
        clk, xOffset, yOffset, trapDynamic2_Resetflag);
        
    Reset_DynamicTrap #(         
        .ROW_LOC(40),
        .COL_LOC(65),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic3 (
        clk, xOffset, yOffset, trapDynamic3_Resetflag);

    // Key / door logic, instantiate multiple keys / doors (Location is top left of object)
    // Link all key / door flags
    Keys_Doors #(
        .ROW_LOC_KEY(0),
        .COL_LOC_KEY(25),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(20),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key_door1 (
        clk6p25m, xOffset, yOffset, 
        reset_keys, taken[0], door1_Flag);
        
    Keys_Doors #(
        .ROW_LOC_KEY(0),
        .COL_LOC_KEY(92),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(47),
        .COL_LOC_DOOR(92),
        .DIMENSIONS_DOOR(4)
    ) key_door2 (
        clk6p25m, xOffset, yOffset, 
        reset_keys, taken[1], door2_Flag);
        
    Keys_Doors #(
        .ROW_LOC_KEY(59),
        .COL_LOC_KEY(0),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(59),
        .COL_LOC_DOOR(73),
        .DIMENSIONS_DOOR(4)
    ) key_door3 (
        clk6p25m, xOffset, yOffset, 
        reset_keys, taken[2], door3_Flag);
        
    Keys_Doors #(
        .ROW_LOC_KEY(14),
        .COL_LOC_KEY(73),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(0),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key_door4 (
        clk6p25m, xOffset, yOffset, 
        reset_keys, taken[3], door4_Flag);
        
    // Destroyable wall logic, instantiate multiple walls (Location is top left of object)
    // Link all destroyable wall flags
    Destroyable_Block #(
        .ROW_LOC(30),
        .COL_LOC(92),
        .DIMENSIONS(4)
    ) destroyable_block1 (
        clk6p25m, xOffset, yOffset, reset_keys, collided_Flag[0]);
        
    Destroyable_Block #(
        .ROW_LOC(59),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) destroyable_block2 (
        clk6p25m, xOffset, yOffset, reset_keys, collided_Flag[1]);

endmodule