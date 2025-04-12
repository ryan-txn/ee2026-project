`timescale 1ns / 1ps

// Array of trap locations and colour
module returnColourGame1 (
    input clk, input [12:0] pixel_index,
    input [6:0] xOffset, input [5:0] yOffset,
    input taken, output reg [15:0] oled_colour);
    
    // instantiate wall flags for each object instance
    wire rest1_flag;
    wire rest2_flag;
    wire rest3_flag;
    wire rest4_flag;
    wire rest5_flag;

    
    // instantiate trap flags 
    wire trap1_flag;
    wire trap2_flag;
    wire trap3_flag;
    wire trap4_flag;
    
    //instantiate key flags
    wire key1_flag;
    
    //instantiate door flags
    wire door1_flag;
    
    integer count = 0;

    // edit and put in separate module   
    always @ (posedge clk) begin 
        if ( // Paint player block to colour green
            (pixel_index / 96 < 4 + yOffset && pixel_index / 96 >= yOffset) && 
            (pixel_index % 96 < 4 + xOffset && pixel_index % 96 >= xOffset))
            // green
            oled_colour <= 16'h07E0;     
        else if (rest1_flag || rest2_flag || rest3_flag || rest4_flag || rest5_flag)
            // white
            oled_colour <= 16'hFFFF;     
        else if (trap1_flag || trap2_flag || trap3_flag || trap4_flag)
            // red
            oled_colour <= 16'hF800;     
        else if (key1_flag)
            // pink
            oled_colour <= 16'hF819; 
        // last door open (game completed)
        else if (door1_flag == 1)
            // yellow
            oled_colour <= 16'hFFE0;
        else
            // black 
            oled_colour <= 0;   
    end
    
    // Rest points shader, instantiate multiple rest points (Location is top left of object)
    // Link the flags
    returnColour_Walls #(
        .ROW_LOC(0),
        .COL_LOC(60),
        .DIMENSIONS(4)
    ) rest1_Colour (
        clk, pixel_index, rest1_flag);
    
    returnColour_Walls #(
        .ROW_LOC(30),
        .COL_LOC(80),
        .DIMENSIONS(4)
    ) rest2_Colour (
        clk, pixel_index, rest2_flag);

    returnColour_Walls #(
        .ROW_LOC(56),
        .COL_LOC(60),
        .DIMENSIONS(4)
    ) rest3_Colour (
        clk, pixel_index, rest3_flag);    

    returnColour_Walls #(
        .ROW_LOC(56),
        .COL_LOC(80),
        .DIMENSIONS(4)
    ) rest4_Colour (
        clk, pixel_index, rest4_flag);
        
    returnColour_Walls #(
            .ROW_LOC(30),
            .COL_LOC(0),
            .DIMENSIONS(4)
        ) rest5_Colour (
            clk, pixel_index, rest5_flag);
    
    // Traps shader, instantiate multiple traps (Location is top left of object)
    // Link the flags
    returnColour_StaticTraps #(
        .ROW_LOC(26),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) trap1_Colour (
        clk, pixel_index, trap1_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(56),
        .COL_LOC(35),
        .DIMENSIONS(4)
    ) trap2_Colour (
        clk, pixel_index, trap2_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(60),
        .COL_LOC(35),
        .DIMENSIONS(4)
    ) trap3_Colour (
        clk, pixel_index, trap3_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(0),
        .COL_LOC(90),
        .DIMENSIONS(4)
    ) trap4_Colour (
        clk, pixel_index, trap4_flag);
    
    // Keys / doors shader, instantiate multiple keys / doors (Location is top left of object)
    // Link the flags
    returnColour_Key_Door #(
        .ROW_LOC_KEY(60),
        .COL_LOC_KEY(0),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(0),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key1_Colour (
        clk, pixel_index, taken, key1_flag, door1_flag);
    
endmodule

// Array of trap locations and colour
module returnColourGame2 (
    input clk, input [12:0] pixel_index,
    input [6:0] xOffset, input [5:0] yOffset,
    input [1:0] collided_flag, input [3:0] taken, // each bit respresent 1 key (if 00100 -> means key 3 is taken and should not be shown)
    output reg [15:0] oled_colour);
    
    // instantiate wall flags for each object instance
    wire rest1_flag;
    wire rest2_flag;
    
    // instantiate trap flags 
    wire trap1_flag;
    wire trap2_flag;
    wire trap3_flag;
    wire trap4_flag;
    wire trapDynamic1_flag;
    wire trapDynamic2_flag;
    wire trapDynamic3_flag;
    
    //instantiate key flags
    wire key1_flag;
    wire key2_flag;
    wire key3_flag;
    wire key4_flag;
    
    //instantiate door flags
    wire door1_flag;
    wire door2_flag;
    wire door3_flag;
    wire door4_flag;
    
    wire destroyed1_flag;
    wire destroyed2_flag;
    
    integer count = 0;

    // edit and put in separate module   
    always @ (posedge clk) begin 
        if ( // Paint player block to colour green
            (pixel_index / 96 < 4 + yOffset && pixel_index / 96 >= yOffset) && 
            (pixel_index % 96 < 4 + xOffset && pixel_index % 96 >= xOffset))
            // green
            oled_colour <= 16'h07E0;     
        else if (rest1_flag || rest2_flag)
            // white
            oled_colour <= 16'hFFFF;     
        else if (trap1_flag || trap2_flag || trap3_flag || trap4_flag ||
            trapDynamic1_flag || trapDynamic2_flag || trapDynamic3_flag)
            // red
            oled_colour <= 16'hF800;     
        else if (key1_flag || key2_flag || key3_flag || key4_flag)
            // pink
            oled_colour <= 16'hF819; 
        // door open (exist a place to stop)
        else if (door1_flag == 1 || door2_flag == 1 || door3_flag == 1)
            // white (becomes a stop point after taking key)
            oled_colour <= 16'hFFFF;  
        // last door open (game completed)
        else if (door4_flag == 1)
            // yellow
            oled_colour <= 16'hFFE0;
        else if (destroyed1_flag == 1 || destroyed2_flag == 1)
            // blue 
            oled_colour <= 16'h001F;
        else
            // black 
            oled_colour <= 0;   
    end
    
    // Rest points shader, instantiate multiple rest points (Location is top left of object)
    // Link the flags
    returnColour_Walls #(
        .ROW_LOC(0),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) rest1_Colour (
        clk, pixel_index, rest1_flag);
    
    returnColour_Walls #(
        .ROW_LOC(47),
        .COL_LOC(55),
        .DIMENSIONS(4)
    ) rest2_Colour (
        clk, pixel_index, rest2_flag);
    
    // Traps shader, instantiate multiple traps (Location is top left of object)
    // Link the flags
    returnColour_StaticTraps #(
        .ROW_LOC(0),
        .COL_LOC(85),
        .DIMENSIONS(4)
    ) trap1_Colour (
        clk, pixel_index, trap1_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(54),
        .COL_LOC(92),
        .DIMENSIONS(4)
    ) trap2_Colour (
        clk, pixel_index, trap2_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(30),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) trap3_Colour (
        clk, pixel_index, trap3_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(54),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) trap4_Colour (
        clk, pixel_index, trap4_flag);
    
    
    returnColour_DynamicTraps #(
        .ROW_LOC(30),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic1_Colour (
        clk, pixel_index, trapDynamic1_flag);
    
    returnColour_DynamicTraps #(
        .ROW_LOC(40),
        .COL_LOC(20),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic2_Colour (
        clk, pixel_index, trapDynamic2_flag);
        
    returnColour_DynamicTraps #(         
        .ROW_LOC(40),
        .COL_LOC(65),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic3_Colour (
        clk, pixel_index, trapDynamic3_flag);
    
    // Keys / doors shader, instantiate multiple keys / doors (Location is top left of object)
    // Link the flags
    returnColour_Key_Door #(
        .ROW_LOC_KEY(0),
        .COL_LOC_KEY(25),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(20),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key1_Colour (
        clk, pixel_index, taken[0], key1_flag, door1_flag);
    
    returnColour_Key_Door #(
        .ROW_LOC_KEY(0),
        .COL_LOC_KEY(92),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(47),
        .COL_LOC_DOOR(92),
        .DIMENSIONS_DOOR(4)
    ) key2_Colour (
        clk, pixel_index, taken[1], key2_flag, door2_flag);
        
    returnColour_Key_Door #(
        .ROW_LOC_KEY(59),
        .COL_LOC_KEY(0),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(59),
        .COL_LOC_DOOR(73),
        .DIMENSIONS_DOOR(4)
    ) key3_Colour (
        clk, pixel_index, taken[2], key3_flag, door3_flag);
        
    returnColour_Key_Door #(
        .ROW_LOC_KEY(14),
        .COL_LOC_KEY(73),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(0),
        .COL_LOC_DOOR(0),
        .DIMENSIONS_DOOR(4)
    ) key4_Colour (
        clk, pixel_index, taken[3], key4_flag, door4_flag);
    
    // Destroyable blocks shader, instantiate multiple blocks (Location is top left of object)
    // Link the flags   
    returnColour_Destroyable #(
        .ROW_LOC(30),
        .COL_LOC(92),
        .DIMENSIONS(4)
    ) destroyableBlock1_Colour (
        clk, pixel_index, collided_flag[0], destroyed1_flag);
    
    returnColour_Destroyable #(
        .ROW_LOC(59),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) destroyableBlock2_Colour (
        clk, pixel_index, collided_flag[1], destroyed2_flag);
    
endmodule

// Array of trap locations and colour
module returnColourGame3 (
    input clk, input [12:0] pixel_index,
    input [6:0] xOffset, input [5:0] yOffset,
    input [2:0] taken, // each bit respresent 1 key (if 00100 -> means key 3 is taken and should not be shown)
    output reg [15:0] oled_colour);
    
    // instantiate wall flags for each object instance
    wire rest1_flag;
    wire rest2_flag;
    wire rest3_flag;
    wire rest4_flag;
    wire rest5_flag;
    wire rest6_flag;

    
    // instantiate trap flags 
    wire trap1_flag;
    wire trap2_flag;
    wire trap3_flag;
    wire trap4_flag;
    wire trap5_flag;
    wire trapDynamic1_flag;
    wire trapDynamic2_flag;
    wire trapDynamic3_flag;
    wire trapDynamic4_flag;
    
    //instantiate key flags
    wire key1_flag;
    wire key2_flag;
    wire key3_flag;
    
    //instantiate door flags
    wire door1_flag;
    wire door2_flag;
    wire door3_flag;
    
    integer count = 0;

    // edit and put in separate module   
    always @ (posedge clk) begin 
        if ( // Paint player block to colour green
            (pixel_index / 96 < 4 + yOffset && pixel_index / 96 >= yOffset) && 
            (pixel_index % 96 < 4 + xOffset && pixel_index % 96 >= xOffset))
            // green
            oled_colour <= 16'h07E0;     
        else if (rest1_flag || rest2_flag || rest3_flag || rest4_flag || rest5_flag || rest6_flag)
            // white
            oled_colour <= 16'hFFFF;     
        else if (trap1_flag || trap2_flag || trap3_flag || trap4_flag || trap5_flag ||
            trapDynamic1_flag || trapDynamic2_flag || trapDynamic3_flag || trapDynamic4_flag)
            // red
            oled_colour <= 16'hF800;     
        else if (key1_flag || key2_flag || key3_flag)
            // pink
            oled_colour <= 16'hF819; 
        // door open (exist a place to stop)
        else if (door1_flag || door2_flag)
            // white (becomes a stop point after taking key)
            oled_colour <= 16'hFFFF;  
        // last door open (game completed)
        else if (door3_flag == 1)
            // yellow
            oled_colour <= 16'hFFE0;
        else
            // black 
            oled_colour <= 0;   
    end
    
    // Rest points shader, instantiate multiple rest points (Location is top left of object)
    // Link the flags
    returnColour_Walls #(
        .ROW_LOC(60),
        .COL_LOC(0),
        .DIMENSIONS(4)
    ) rest1_Colour (
        clk, pixel_index, rest1_flag);
    
    returnColour_Walls #(
        .ROW_LOC(60),
        .COL_LOC(20),
        .DIMENSIONS(4)
    ) rest2_Colour (
        clk, pixel_index, rest2_flag);

    returnColour_Walls #(
        .ROW_LOC(40),
        .COL_LOC(20),
        .DIMENSIONS(4)
    ) rest3_Colour (
        clk, pixel_index, rest3_flag);

    returnColour_Walls #(
        .ROW_LOC(0),
        .COL_LOC(80),
        .DIMENSIONS(4)
    ) rest4_Colour (
        clk, pixel_index, rest4_flag);

    returnColour_Walls #(
        .ROW_LOC(15),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) rest5_Colour (
        clk, pixel_index, rest5_flag);

    returnColour_Walls #(
        .ROW_LOC(25),
        .COL_LOC(40),
        .DIMENSIONS(4)
    ) rest6_Colour (
        clk, pixel_index, rest6_flag);
    
    // Traps shader, instantiate multiple traps (Location is top left of object)
    // Link the flags
    returnColour_StaticTraps #(
        .ROW_LOC(0),
        .COL_LOC(87),
        .DIMENSIONS(4)
    ) trap1_Colour (
        clk, pixel_index, trap1_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(25),
        .COL_LOC(20),
        .DIMENSIONS(4)
    ) trap2_Colour (
        clk, pixel_index, trap2_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(60),
        .COL_LOC(30),
        .DIMENSIONS(4)
    ) trap3_Colour (
        clk, pixel_index, trap3_flag);
    
    returnColour_StaticTraps #(
        .ROW_LOC(40),
        .COL_LOC(90),
        .DIMENSIONS(4)
    ) trap4_Colour (
        clk, pixel_index, trap4_flag);
        
    returnColour_StaticTraps #(
        .ROW_LOC(60),
        .COL_LOC(90),
        .DIMENSIONS(4)
    ) trap5_Colour (
        clk, pixel_index, trap5_flag);
    
    
    returnColour_DynamicTraps #(
        .ROW_LOC(8),
        .COL_LOC(0),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic1_Colour (
        clk, pixel_index, trapDynamic1_flag);
    
    returnColour_DynamicTraps #(
        .ROW_LOC(21),
        .COL_LOC(15),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic2_Colour (
        clk, pixel_index, trapDynamic2_flag);
        
    returnColour_DynamicTraps #(         
        .ROW_LOC(33),
        .COL_LOC(30),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(0)
    ) trapDynamic3_Colour (
        clk, pixel_index, trapDynamic3_flag);
        
    returnColour_DynamicTraps #(         
        .ROW_LOC(0),
        .COL_LOC(60),
        .DIMENSIONS(4),
        .IS_UP_DIRECTION(1)
    ) trapDynamic4_Colour (
        clk, pixel_index, trapDynamic4_flag);
    
    // Keys / doors shader, instantiate multiple keys / doors (Location is top left of object)
    // Link the flags
    returnColour_Key_Door #(
        .ROW_LOC_KEY(45),
        .COL_LOC_KEY(20),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(25),
        .COL_LOC_DOOR(80),
        .DIMENSIONS_DOOR(4)
    ) key1_Colour (
        clk, pixel_index, taken[0], key1_flag, door1_flag);
    
    returnColour_Key_Door #(
        .ROW_LOC_KEY(15),
        .COL_LOC_KEY(65),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(54),
        .COL_LOC_DOOR(40),
        .DIMENSIONS_DOOR(4)
    ) key2_Colour (
        clk, pixel_index, taken[1], key2_flag, door2_flag);
        
    returnColour_Key_Door #(
        .ROW_LOC_KEY(54),
        .COL_LOC_KEY(90),
        .DIMENSIONS_KEY(4),
        .ROW_LOC_DOOR(0),
        .COL_LOC_DOOR(90),
        .DIMENSIONS_DOOR(4)
    ) key3_Colour (
        clk, pixel_index, taken[2], key3_flag, door3_flag);
    
endmodule
