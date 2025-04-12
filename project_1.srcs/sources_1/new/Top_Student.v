`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: LEE SEUNG-YOON
//  STUDENT B NAME: KAM SHENG JIE
//  STUDENT C NAME: RYAN TAN
//  STUDENT D NAME: LEE MING KAI JOSHUA
//
//////////////////////////////////////////////////////////////////////////////////

// WASD for game controls
// X to move up in menu, C to move down in menu
// E to select option in menu, Q to exit to menu

module Top_Student (
    input clk, input PS2Clk, input PS2Data,
    output frame_begin, output sending_pixels, output sample_pixel,
    output [7:0] JC);
    
    reg reset = 1'b0;            
    
    wire clk6p25m;
    Clock_Divider #(16) clk_divide_6p25m (clk, clk6p25m);
    
    // clock for the PS2 emulator
    reg clk_50MHz = 0;
    
    always @ (posedge clk) begin
        clk_50MHz <= ~clk_50MHz;
    end
    
    // for PS2 emulator
    wire [15:0] scan_code;
    
    PS2_Receiver receiver (
        clk_50MHz, PS2Clk, PS2Data, scan_code);
    
    wire [12:0] pixel_index; // get which bit is writing from this
    wire [15:0] oled_data; // pass colour bit to this
    wire game_enable;
    wire [1:0] game_state;
    
    // variables for menu screen
    wire [1:0] selection;
    wire [15:0] oled_data_menu; // oled_data when menu is active
    
    wire level_1_done;
    wire level_2_done;



    menu menu (
        clk6p25m, pixel_index, scan_code[7:0], oled_data_menu, selection);
        
    //variable for help screen
    wire [15:0] oled_data_help;
    wire back_menu;
        
    Help help ( 
        clk6p25m, pixel_index, scan_code[7:0], oled_data_help, back_menu);
    
    // variables for game
    wire [15:0] oled_data_game1;
    wire [15:0] oled_data_game2;
    wire [15:0] oled_data_game3;
    
    // triggered after start is selected on menu
    Game_1 game1 (clk, clk6p25m, pixel_index, game_enable, scan_code, oled_data_game1, level_1_done);
    Game_2 game2 (clk, clk6p25m, pixel_index, game_enable, scan_code, oled_data_game2, level_2_done);
    Game_3 game3 (clk, clk6p25m, pixel_index, game_enable, scan_code, oled_data_game3);
            
    Oled_Data_Mux oled_data_mux (
        clk, selection, level_1_done, level_2_done, oled_data_game1, oled_data_game2, oled_data_game3, 
        oled_data_help, oled_data_menu, game_enable, oled_data);
        
    Oled_Display oled_display (
        clk6p25m, reset, frame_begin, sending_pixels, sample_pixel, pixel_index, 
        oled_data, JC[0], JC[1], JC[3], JC[4], JC[5], JC[6], JC[7]);

endmodule
