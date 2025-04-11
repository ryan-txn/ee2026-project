`timescale 1ns / 1ps

module arrow #(
    parameter [6:0] start_x = 0,       // X-coordinate of top-left corner
    parameter [6:0] start_y = 0        // Y-coordinate of top-left corner
    )(
    input wire clk,                    // Clock signal for sequential processing
    input wire [15:0] color,           // 16-bit color input
    input wire [12:0] pixel_index,     // taking in the bit the oled is drawing       
    output reg [15:0] oled_data,       // Pixel color output
    output reg valid                   // to ensure correct oled_data is used; true when correct data is being outputted
    );

    reg [0:6] letters [0:6];
    wire [6:0] x;
    wire [6:0] y;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    always @(posedge clk) begin
        valid <= 0;
        
        if (x >= start_x && x < (start_x + 7) && y >= start_y && y < (start_y + 7)) begin
            valid <= 1;
            
            if (letters[(y - start_y)][(x - start_x)] == 1) begin
                oled_data <= color;
            end else 
                oled_data <= 16'h0000;
        end else 
            oled_data <= 16'h0000;
    end

    initial begin
        // A
        letters[0] = 7'b0100000;
        letters[1] = 7'b0111000;
        letters[2] = 7'b0111100;
        letters[3] = 7'b0111110;
        letters[4] = 7'b0111100;
        letters[5] = 7'b0111000;
        letters[6] = 7'b0100000;
    end
    
endmodule
