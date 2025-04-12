`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 17:16:04
// Design Name: 
// Module Name: GameWonScreen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GameWonScreen(
    input clk, input clk6p25m, input [12:0] pixel_index, input [15:0] scan_code,
    output reg [15:0] oled_data);

    // Derive row and col from pixel_index
    //  - row: [0..63]
    //  - col: [0..95]
    wire [6:0] row = pixel_index / 96;
    wire [6:0] col = pixel_index % 96;

    // Example 5-6-5 colors
    parameter [15:0] LIGHT_BLUE = 16'b01100_111000_11111; // R=12, G=56, B=31
    parameter [15:0] GOLD       = 16'b11110_111100_00000; // R=30, G=60, B=0

    always @(*) begin
        // Default is sky (light blue)
        oled_data = LIGHT_BLUE;

        // TROPHY REGIONS
        
        // 1) Bowl Top
        if ((row >= 10 && row < 24) && (col >= 34 && col < 62)) begin
            oled_data = GOLD;
        end
        else if ((row >= 24 && row < 30) && (col >= 38 && col < 58)) begin
            oled_data = GOLD;
        end
        else if ((row >= 30 && row < 40) && (col >= 43 && col < 53)) begin
            oled_data = GOLD;
        end
        // 4) Base
        else if ((row >= 40 && row < 47) && (col >= 38 && col < 58)) begin
            oled_data = GOLD;
        end
    end

endmodule