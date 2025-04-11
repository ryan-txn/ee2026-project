`timescale 1ns / 1ps

module letter_display #(
    parameter [4:0] LETTERIDEN = 1,     // choose which letter A = 1 up to Z = 26
    parameter [6:0] XSTART = 0,          // X-coord from top left corner
    parameter [6:0] YSTART = 1           // Y-coord from top left corner
    )(
    input wire clk,                    // Clock signal for sequential processing
    input wire [15:0] color,           // 16-bit color input
    input wire [12:0] pixel_index,     // taking in the bit the oled is drawing       
    output reg [15:0] oled_data,       // Pixel color output
    output reg valid                   // to ensure correct oled_data is used; true when correct data is being outputted
    );

    reg [0:6] letters [0:26] [0:6];
    wire [6:0] x;
    wire [6:0] y;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    always @(posedge clk) begin
        valid <= 0;
        
        if (x >= XSTART && x < (XSTART + 7) && y >= YSTART && y < (YSTART + 7)) begin
            valid <= 1;
            
            if (letters[LETTERIDEN][(y - YSTART)][(x - XSTART)] == 1) begin
                oled_data <= color;
            end else 
                oled_data <= 16'h0000;
        end else 
            oled_data <= 16'h0000;
    end

    initial begin
        // A
        letters[1][0] = 7'b0111110;
        letters[1][1] = 7'b0100010;
        letters[1][2] = 7'b0100010;
        letters[1][3] = 7'b0111110;
        letters[1][4] = 7'b0100010;
        letters[1][5] = 7'b0100010;
        letters[1][6] = 7'b0100010;
        
        // B
        letters[2][0] = 7'b0111100;
        letters[2][1] = 7'b0100110;
        letters[2][2] = 7'b0100010;
        letters[2][3] = 7'b0111100;
        letters[2][4] = 7'b0100010;
        letters[2][5] = 7'b0100110;
        letters[2][6] = 7'b0111100;

        // C
        letters[3][0] = 7'b0111110;
        letters[3][1] = 7'b0100000;
        letters[3][2] = 7'b0100000;
        letters[3][3] = 7'b0100000;
        letters[3][4] = 7'b0100000;
        letters[3][5] = 7'b0100000;
        letters[3][6] = 7'b0111110;
        
        // D        
        letters[4][0] = 7'b0111100;
        letters[4][1] = 7'b0100110;
        letters[4][2] = 7'b0100010;
        letters[4][3] = 7'b0100010;
        letters[4][4] = 7'b0100010;
        letters[4][5] = 7'b0100110;
        letters[4][6] = 7'b0111100;

        // E
        letters[5][0] = 7'b0111110;
        letters[5][1] = 7'b0100000;
        letters[5][2] = 7'b0100000;
        letters[5][3] = 7'b0111100;
        letters[5][4] = 7'b0100000;
        letters[5][5] = 7'b0100000;
        letters[5][6] = 7'b0111110;
        
        // F
        letters[6][0] = 7'b0111110;
        letters[6][1] = 7'b0100000;
        letters[6][2] = 7'b0100000;
        letters[6][3] = 7'b0111100;
        letters[6][4] = 7'b0100000;
        letters[6][5] = 7'b0100000;
        letters[6][6] = 7'b0100000;

        // G
        letters[7][0] = 7'b0011110;
        letters[7][1] = 7'b0100000;
        letters[7][2] = 7'b0100000;
        letters[7][3] = 7'b0100110;
        letters[7][4] = 7'b0100010;
        letters[7][5] = 7'b0100010;
        letters[7][6] = 7'b0011110;

        // H
        letters[8][0] = 7'b0100010;
        letters[8][1] = 7'b0100010;
        letters[8][2] = 7'b0100010;
        letters[8][3] = 7'b0111110;
        letters[8][4] = 7'b0100010;
        letters[8][5] = 7'b0100010;
        letters[8][6] = 7'b0100010;

        // I
        letters[9][0] = 7'b0111110;
        letters[9][1] = 7'b0001000;
        letters[9][2] = 7'b0001000;
        letters[9][3] = 7'b0001000;
        letters[9][4] = 7'b0001000;
        letters[9][5] = 7'b0001000;
        letters[9][6] = 7'b0111110;

        // J
        letters[10][0] = 7'b0001110;
        letters[10][1] = 7'b0000100;
        letters[10][2] = 7'b0000100;
        letters[10][3] = 7'b0000100;
        letters[10][4] = 7'b0100100;
        letters[10][5] = 7'b0100100;
        letters[10][6] = 7'b0011000;

        // K
        letters[11][0] = 7'b0100010;
        letters[11][1] = 7'b0100100;
        letters[11][2] = 7'b0101000;
        letters[11][3] = 7'b0110000;
        letters[11][4] = 7'b0101000;
        letters[11][5] = 7'b0100100;
        letters[11][6] = 7'b0100010;

        // L
        letters[12][0] = 7'b0100000;
        letters[12][1] = 7'b0100000;
        letters[12][2] = 7'b0100000;
        letters[12][3] = 7'b0100000;
        letters[12][4] = 7'b0100000;
        letters[12][5] = 7'b0100000;
        letters[12][6] = 7'b0111110;

        // M
        letters[13][0] = 7'b0100010;
        letters[13][1] = 7'b0110110;
        letters[13][2] = 7'b0101010;
        letters[13][3] = 7'b0100010;
        letters[13][4] = 7'b0100010;
        letters[13][5] = 7'b0100010;
        letters[13][6] = 7'b0100010;

        // N
        letters[14][0] = 7'b0100010;
        letters[14][1] = 7'b0110010;
        letters[14][2] = 7'b0101010;
        letters[14][3] = 7'b0100110;
        letters[14][4] = 7'b0100010;
        letters[14][5] = 7'b0100010;
        letters[14][6] = 7'b0100010;

        // O
        letters[15][0] = 7'b0011100;
        letters[15][1] = 7'b0100010;
        letters[15][2] = 7'b0100010;
        letters[15][3] = 7'b0100010;
        letters[15][4] = 7'b0100010;
        letters[15][5] = 7'b0100010;
        letters[15][6] = 7'b0011100;       
        
        // P
        letters[16][0] = 7'b0111100;
        letters[16][1] = 7'b0100010;
        letters[16][2] = 7'b0100010;
        letters[16][3] = 7'b0111100;
        letters[16][4] = 7'b0100000;
        letters[16][5] = 7'b0100000;
        letters[16][6] = 7'b0100000; 
        
        // Q
        letters[17][0] = 7'b0011100;
        letters[17][1] = 7'b0100010;
        letters[17][2] = 7'b0100010;
        letters[17][3] = 7'b0100010;
        letters[17][4] = 7'b0101010;
        letters[17][5] = 7'b0100110;
        letters[17][6] = 7'b0011110;

        // R
        letters[18][0] = 7'b0111100;
        letters[18][1] = 7'b0100010;
        letters[18][2] = 7'b0100010;
        letters[18][3] = 7'b0111100;
        letters[18][4] = 7'b0101000;
        letters[18][5] = 7'b0100100;
        letters[18][6] = 7'b0100010;

        // S
        letters[19][0] = 7'b0011110;
        letters[19][1] = 7'b0100000;
        letters[19][2] = 7'b0100000;
        letters[19][3] = 7'b0011100;
        letters[19][4] = 7'b0000010;
        letters[19][5] = 7'b0000010;
        letters[19][6] = 7'b0111100;

        // T
        letters[20][0] = 7'b0111110;
        letters[20][1] = 7'b0001000;
        letters[20][2] = 7'b0001000;
        letters[20][3] = 7'b0001000;
        letters[20][4] = 7'b0001000;
        letters[20][5] = 7'b0001000;
        letters[20][6] = 7'b0001000;

        // U
        letters[21][0] = 7'b0100010;
        letters[21][1] = 7'b0100010;
        letters[21][2] = 7'b0100010;
        letters[21][3] = 7'b0100010;
        letters[21][4] = 7'b0100010;
        letters[21][5] = 7'b0100010;
        letters[21][6] = 7'b0011100;

        // V
        letters[22][0] = 7'b0100010;
        letters[22][1] = 7'b0100010;
        letters[22][2] = 7'b0100010;
        letters[22][3] = 7'b0100010;
        letters[22][4] = 7'b0100010;
        letters[22][5] = 7'b0010100;
        letters[22][6] = 7'b0001000;        
        
        // W
        letters[23][0] = 7'b0100010;
        letters[23][1] = 7'b0100010;
        letters[23][2] = 7'b0100010;
        letters[23][3] = 7'b0101010;
        letters[23][4] = 7'b0101010;
        letters[23][5] = 7'b0110110;
        letters[23][6] = 7'b0100010;
    
        // X
        letters[24][0] = 7'b0100010;
        letters[24][1] = 7'b0100010;
        letters[24][2] = 7'b0010100;
        letters[24][3] = 7'b0001000;
        letters[24][4] = 7'b0010100;
        letters[24][5] = 7'b0100010;
        letters[24][6] = 7'b0100010;
    
        // Y
        letters[25][0] = 7'b0100010;
        letters[25][1] = 7'b0100010;
        letters[25][2] = 7'b0010100;
        letters[25][3] = 7'b0001000;
        letters[25][4] = 7'b0001000;
        letters[25][5] = 7'b0001000;
        letters[25][6] = 7'b0001000;
    
        // Z
        letters[26][0] = 7'b0111110;
        letters[26][1] = 7'b0000010;
        letters[26][2] = 7'b0000100;
        letters[26][3] = 7'b0001000;
        letters[26][4] = 7'b0010000;
        letters[26][5] = 7'b0100000;
        letters[26][6] = 7'b0111110;        
    end

endmodule
