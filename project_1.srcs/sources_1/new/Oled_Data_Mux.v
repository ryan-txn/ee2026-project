`timescale 1ns / 1ps

module Oled_Data_Mux (
<<<<<<< Updated upstream
    input clk, input [1:0] selection, 
    input [15:0] oled_data_game, input [15:0] oled_data_help, input [15:0] oled_data_menu,
=======
    input clk, input [1:0] selection, input level_done1, input level_done2,
    input [15:0] oled_data_game1, input [15:0] oled_data_game2, input [15:0] oled_data_game3,
    input [15:0] oled_data_help, input [15:0] oled_data_menu,
>>>>>>> Stashed changes
    output reg enable, output reg [15:0] oled_data);
    
    localparam GAME_1 = 2'b00,
           GAME_2 = 2'b01,
           GAME_3 = 2'b10;
           //GAME_WIN = 2'b11;
    
    reg [1:0] game_selector;
    wire level_done;
    
    assign level_done = (game_selector == GAME_1) ? level_done1 :
                        (game_selector == GAME_2) ? level_done2 : 1'b0;
                        //(game_selector == GAME_3) ? level_done3 : 1'b0;
    
    always @ (posedge clk) begin
        if (selection == 1) begin
            enable <= 1'b1;
<<<<<<< Updated upstream
            oled_data <= oled_data_game;
=======
                case (game_selector)
                    GAME_1: begin
                        if (level_done)
                            game_selector <= GAME_2;
                        oled_data <= oled_data_game1;
                    end
                    GAME_2: begin
                        if (level_done)
                            game_selector <= GAME_3;
                        oled_data <= oled_data_game1;
                    end
                    GAME_3: 
                        oled_data = oled_data_game3;
                    //GAME_WIN: oled_data = oled_data_win;
                endcase
>>>>>>> Stashed changes
        end else if (selection == 2) begin
            enable <= 1'b0;
            oled_data <= oled_data_help;
        end else begin
            enable <= 1'b0;
            oled_data <= oled_data_menu;
        end
    end

endmodule
