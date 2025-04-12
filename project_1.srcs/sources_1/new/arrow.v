`timescale 1ns / 1ps

module arrow #(
    parameter [1:0] direction = 0,      //0 for right, 1 for up, 2 for left, 3 for down
    parameter [6:0] start_x = 0,          // X-coordinate of top-left corner
    parameter [6:0] start_y = 0          // Y-coordinate of top-left corner
    )(
    input wire clk,                    // Clock signal for sequential processing
    input wire [15:0] color,           // 16-bit color input
    input wire [12:0] pixel_index,     // taking in the bit the oled is drawing       
    output reg [15:0] oled_data,       // Pixel color output
    output reg valid                   // to ensure correct oled_data is used; true when correct data is being outputted
    );

    reg [0:6] arrows [3:0] [0:6];
    wire [6:0] x;
    wire [6:0] y;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    always @(posedge clk) begin
        valid <= 0;
        
        if (x >= start_x && x < (start_x + 7) && y >= start_y && y < (start_y + 7)) begin
            valid <= 1;
            if (arrows[direction][(y - start_y)][(x - start_x)] == 1) begin
                oled_data <= color;
            end else 
                oled_data <= 16'h0000;
        end else 
            oled_data <= 16'h0000;
    end

    initial begin
        // right
        arrows[0][0] = 7'b0100000;
        arrows[0][1] = 7'b0111000;
        arrows[0][2] = 7'b0111100;
        arrows[0][3] = 7'b0111110;
        arrows[0][4] = 7'b0111100;
        arrows[0][5] = 7'b0111000;
        arrows[0][6] = 7'b0100000;
        
        // up
        arrows[1][0] = 7'b0001000;
        arrows[1][1] = 7'b0011100;
        arrows[1][2] = 7'b0111110;
        arrows[1][3] = 7'b0011100;
        arrows[1][4] = 7'b0011100;
        arrows[1][5] = 7'b0011100;
        arrows[1][6] = 7'b0011100;
        
        // left
        arrows[2][0] = 7'b0000010;
        arrows[2][1] = 7'b0001110;
        arrows[2][2] = 7'b0011110;
        arrows[2][3] = 7'b0111110;
        arrows[2][4] = 7'b0011110;
        arrows[2][5] = 7'b0001110;
        arrows[2][6] = 7'b0000010;
        
        // right
        arrows[3][0] = 7'b0011100;
        arrows[3][1] = 7'b0011100;
        arrows[3][2] = 7'b0011100;
        arrows[3][3] = 7'b0011110;
        arrows[3][4] = 7'b0111110;
        arrows[3][5] = 7'b0011100;
        arrows[3][6] = 7'b0001000;
    end
    
endmodule
