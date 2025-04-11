`timescale 1ns / 1ps

module Help (
    input wire clk6p25m, input wire [12:0] pixel_index,
    input wire [7:0] scan_code,
    output reg [15:0] oled_data, output reg back);
    
    wire player_flag;
    wire wall_flag;
    wire trap_flag;
    wire trapDynamic_flag;
    wire key_flag;
    wire door_flag;
    
    //Words
    //Player
    wire valid1,valid2,valid3,valid4,valid5,valid6;
    wire [15:0] pixel_data1,pixel_data2,pixel_data3,pixel_data4,pixel_data5,pixel_data6;

    letter_display #(16, 10, 3) P1(clk6p25m, 16'hFFFF, pixel_index, pixel_data1, valid1); 
    letter_display #(12, 17, 3) L1(clk6p25m, 16'hFFFF, pixel_index, pixel_data2, valid2); 
    letter_display #(1, 24, 3) A1(clk6p25m, 16'hFFFF, pixel_index, pixel_data3, valid3); 
    letter_display #(25, 31, 3) Y1(clk6p25m, 16'hFFFF, pixel_index, pixel_data4, valid4); 
    letter_display #(5, 38, 3) E1(clk6p25m, 16'hFFFF, pixel_index, pixel_data5, valid5); 
    letter_display #(18, 45, 3) R1(clk6p25m, 16'hFFFF, pixel_index, pixel_data6, valid6); 
    
    // Stop
    wire valid11,valid12,valid13,valid14;
    wire [15:0] pixel_data11,pixel_data12,pixel_data13,pixel_data14;
    
    letter_display #(19, 10, 13) S1(clk6p25m, 16'hFFFF, pixel_index, pixel_data11, valid11); 
    letter_display #(20, 17, 13) T1(clk6p25m, 16'hFFFF, pixel_index, pixel_data12, valid12); 
    letter_display #(15, 24, 13) O1(clk6p25m, 16'hFFFF, pixel_index, pixel_data13, valid13); 
    letter_display #(16, 31, 13) P2(clk6p25m, 16'hFFFF, pixel_index, pixel_data14, valid14);     
    
    //Trap
    wire valid21,valid22,valid23,valid24;
    wire [15:0] pixel_data21,pixel_data22,pixel_data23,pixel_data24;
    
    letter_display #(20, 10, 23) T2(clk6p25m, 16'hFFFF, pixel_index, pixel_data21, valid21); 
    letter_display #(18, 17, 23) R2(clk6p25m, 16'hFFFF, pixel_index, pixel_data22, valid22); 
    letter_display #(1, 24, 23) A2(clk6p25m, 16'hFFFF, pixel_index, pixel_data23, valid23); 
    letter_display #(16, 31, 23) P3(clk6p25m, 16'hFFFF, pixel_index, pixel_data24, valid24);   
    
    //Key
    wire valid31,valid32,valid33;
    wire [15:0] pixel_data31,pixel_data32,pixel_data33;
    
    letter_display #(11, 10, 33) K1(clk6p25m, 16'hFFFF, pixel_index, pixel_data31, valid31); 
    letter_display #(5, 17, 33) E2(clk6p25m, 16'hFFFF, pixel_index, pixel_data32, valid32); 
    letter_display #(25, 24, 33) Y2(clk6p25m, 16'hFFFF, pixel_index, pixel_data33, valid33); 
 
    reg valid_any = 1'b0;
    reg [15:0] final_pixel_data = 16'h0000;
    
    always @(posedge clk6p25m) begin 
        if (scan_code == 8'h15)
            back = 1;
        else 
            back = 0;
        end
        
    always @ (posedge clk6p25m) begin // edit and put in separate module 
            if (player_flag)
                oled_data = 16'h07E0; //green    
            else if (wall_flag)
                oled_data <= 16'hFFFF; //white    
            else if (trap_flag)
                oled_data <= 16'hF800;  //red   
            else if (key_flag)
                oled_data <= 16'hF819;  //pink         
            else if (trapDynamic_flag)
                oled_data <= 16'hFB00; //orange
            else if (valid_any)
                oled_data <= final_pixel_data;
            else 
                oled_data <= 0;
        end

        
    returnColour_Player_menu #(.ROW_LOC(3), .COL_LOC(3),.DIMENSIONS(6)) player_Colour (clk6p25m, pixel_index, player_flag);    
    returnColour_Walls #(.ROW_LOC(13), .COL_LOC(3),.DIMENSIONS(6)) wall_Colour (clk6p25m, pixel_index, wall_flag);
    returnColour_StaticTraps #(.ROW_LOC(23), .COL_LOC(3), .DIMENSIONS(6)) trap1_Colour (clk6p25m, pixel_index, trap_flag);
    //returnColour_DynamicTraps #(.ROW_LOC(24), .COL_LOC(3), .DIMENSIONS(4), .IS_UP_DIRECTION(0), .TRAP_MOVEMENT_BOUND2(10)) trapDynamic1_Colour (clk6p25m, pixel_index, trapDynamic_flag);
    returnColour_Key_Door #(.ROW_LOC_KEY(33),.COL_LOC_KEY(3),.DIMENSIONS_KEY(6)) key1_Colour (clk6p25m, pixel_index, 0, key_flag, door_flag);


    always @(*) begin
        if (valid1) begin final_pixel_data = pixel_data1; valid_any = 1; end
        else if (valid2) begin final_pixel_data = pixel_data2; valid_any = 1; end
        else if (valid3) begin final_pixel_data = pixel_data3; valid_any = 1; end
        else if (valid4) begin final_pixel_data = pixel_data4; valid_any = 1; end
        else if (valid5) begin final_pixel_data = pixel_data5; valid_any = 1; end
        else if (valid6) begin final_pixel_data = pixel_data6; valid_any = 1; end
        else if (valid11) begin final_pixel_data = pixel_data11; valid_any = 1; end
        else if (valid12) begin final_pixel_data = pixel_data12; valid_any = 1; end
        else if (valid13) begin final_pixel_data = pixel_data13; valid_any = 1; end
        else if (valid14) begin final_pixel_data = pixel_data14; valid_any = 1; end
        else if (valid21) begin final_pixel_data = pixel_data21; valid_any = 1; end
        else if (valid22) begin final_pixel_data = pixel_data22; valid_any = 1; end
        else if (valid23) begin final_pixel_data = pixel_data23; valid_any = 1; end
        else if (valid24) begin final_pixel_data = pixel_data24; valid_any = 1; end
        else if (valid31) begin final_pixel_data = pixel_data31; valid_any = 1; end
        else if (valid32) begin final_pixel_data = pixel_data32; valid_any = 1; end
        else if (valid33) begin final_pixel_data = pixel_data33; valid_any = 1; end
        else begin valid_any = 0; end
    end
    
endmodule
