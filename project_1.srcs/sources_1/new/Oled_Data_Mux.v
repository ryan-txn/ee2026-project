`timescale 1ns / 1ps

module Oled_Data_Mux (
    input clk, input [1:0] selection, 
    input [15:0] oled_data_game, input [15:0] oled_data_help, input [15:0] oled_data_menu,
    output reg enable, output reg [15:0] oled_data);
    
    always @ (posedge clk) begin
        if (selection == 1) begin
            enable <= 1'b1;
            oled_data <= oled_data_game;
        end else if (selection == 2) begin
            enable <= 1'b0;
            oled_data <= oled_data_help;
        end else begin
            enable <= 1'b0;
            oled_data <= oled_data_menu;
        end
    end

endmodule
