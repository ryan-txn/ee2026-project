`timescale 1ns / 1ps

module Oled_Data_Mux (
    input clk, input [1:0] selection, input level_done1, input level_done2, input level_done3,
    input [15:0] oled_data_game1, input [15:0] oled_data_game2, input [15:0] oled_data_game3,
    input [15:0] oled_data_win, input [15:0] oled_data_help, input [15:0] oled_data_menu,
    output reg enable, output reg [15:0] oled_data);
    
    localparam GAME_1 = 2'b00,
           GAME_2 = 2'b01,
           GAME_3 = 2'b10,
           GAME_WIN = 2'b11;
    
    reg [1:0] game_selector;
    
    
    always @ (posedge clk) begin
        if (selection == 1) begin
            enable <= 1'b1;
                case (game_selector)
                    GAME_1: begin
                        if (level_done1)
                            game_selector <= GAME_2;
                        oled_data <= oled_data_game1;
                    end
                    GAME_2: begin
                        if (level_done2)
                            game_selector <= GAME_3;
                        oled_data <= oled_data_game2;
                    end
                    GAME_3: begin
                        if (level_done3)
                            game_selector <= GAME_WIN;
                        oled_data = oled_data_game3;
                    end
                    GAME_WIN: begin
                        oled_data = oled_data_win;
                    end
                endcase
        end else if (selection == 2) begin
            enable <= 1'b0;
            oled_data <= oled_data_help;
        end else begin
            enable <= 1'b0;
            oled_data <= oled_data_menu;
        end
    end

endmodule
