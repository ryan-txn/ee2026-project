`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk, input [15:0] sw,
    input btnC, input btnU, input btnD, input btnL, input btnR,
    output [15:0] led, 
    output [6:0] seg, output dp, output [3:0] an,
    output frame_begin, output sending_pixels, output sample_pixel,
    output [7:0] JC);
    
    reg reset = 1'b0;            
    
    wire clk6p25m;
    Clock_Divider #(16) clk_divide_6p25m (clk, clk6p25m);
    
    wire [12:0] pixel_index; //get which bit is writing from this
    wire [15:0] oled_data; //pass colour bit to this
    wire [1:0] enable;
    
    //variables for menu screen
    wire [1:0] option;
    wire [15:0] oled_data_menu; //oled_data when menu is active

    menu m(clk6p25m, pixel_index, btnU, btnC, btnD, !enable, oled_data_menu, option);
    
    //variable for help screen
    wire [15:0] oled_data_help;
    wire enable_help_screen;
    wire back_menu;
    
    Help h(clk6p25m, pixel_index, btnL, enable[1], oled_data_help, back_menu);
    
    //variables for game
    wire [15:0] oled_data_game;
    
    //triggered after start is selectd on menu
    Game g(clk, pixel_index, btnU, btnL, btnR, btnD, oled_data_game);
    
    reg [1:0]selection;
    //enable set to 00 when menu, set to 01 when game start, set to 10 when help_menu
    Oled_Data_Mux oled_data_mux(clk, selection, oled_data_game, oled_data_help, oled_data_menu, enable, oled_data);
        
        
    Oled_Display oled_display (
    clk6p25m, reset, frame_begin, sending_pixels, sample_pixel, pixel_index, 
    oled_data, JC[0], JC[1], JC[3], JC[4], JC[5], JC[6], JC[7]);
    
    always @(posedge clk6p25m) begin
        if (back_menu) begin
            selection <= 0;
        end else if (selection == 2'b00 && btnC)
            selection <= option;
    end
endmodule