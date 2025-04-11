`timescale 1ns / 1ps

module Oled_Data_Mux (
    input clk, input [1:0] selection, 
    input [15:0] start_data, input [15:0] help_data, input [15:0] menu_data,
    output reg enable, output reg [15:0] oled_data);
    
    always @ (posedge clk) begin
        if (selection == 1) begin
            enable <= 2'b01;
            oled_data <= start_data;
        end else if (selection == 2) begin
            enable <= 2'b10;
            oled_data <= help_data;
        end else begin
            enable <= 0;
            oled_data <= menu_data;
        end
    end

endmodule
