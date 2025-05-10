`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 03:44:36 PM
// Design Name: 
// Module Name: Help
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


module Help2(
    input wire clk6p25m,
    input wire [12:0] pixel_index,
    output reg [15:0] oled_data
    );
    
    wire player_flag;
    wire wall_flag;
    wire trap_flag;
    wire trapDynamic_flag;
    wire key_flag;
    wire door_flag;
    
    //Words
    //WASD MOVE
    wire valid1,valid2,valid3,valid4,valid5,valid6,valid7,valid8;
    wire [15:0] pixel_data1,pixel_data2,pixel_data3,pixel_data4,pixel_data5,pixel_data6,pixel_data7,pixel_data8;

    letter_display #(23, 10, 3) W1(clk6p25m, 16'hFFFF, pixel_index, pixel_data1, valid1); 
    letter_display #(1, 17, 3) A1(clk6p25m, 16'hFFFF, pixel_index, pixel_data2, valid2); 
    letter_display #(19, 24, 3) S1(clk6p25m, 16'hFFFF, pixel_index, pixel_data3, valid3); 
    letter_display #(4, 31, 3) D1(clk6p25m, 16'hFFFF, pixel_index, pixel_data4, valid4); 
    
    letter_display #(13, 42, 3) M1(clk6p25m, 16'hFFFF, pixel_index, pixel_data5, valid5); 
    letter_display #(15, 49, 3) O2(clk6p25m, 16'hFFFF, pixel_index, pixel_data6, valid6); 
    letter_display #(21, 56, 3) V1(clk6p25m, 16'hFFFF, pixel_index, pixel_data7, valid7); 
    letter_display #(5, 63, 3) E1(clk6p25m, 16'hFFFF, pixel_index, pixel_data8, valid8); 
    
    //Arrows
    wire arrowup, arrowdown, arrowleft;
    wire x_valid, c_valid, q_valid;
    wire [15:0] arrow_updata, arrow_downdata, arrow_leftdata; //oled data for up/down arrows
    wire [15:0] x_data, c_data, q_data; //oled data for x/c beside arrows
    
    arrow #(1, 88, 0) arrowUp(clk6p25m, 16'hFFFF, pixel_index, arrow_updata, arrowup);
    letter_display #(24, 81, 0) X1(clk6p25m, 16'hFFFF, pixel_index, x_data, x_valid);
    arrow #(.direction(3), .start_x(88), .start_y(56)) arrowDown(clk6p25m, 16'hFFFF, pixel_index, arrow_downdata, arrowdown);
    letter_display #(3, 81, 56) C1(clk6p25m, 16'hFFFF, pixel_index, c_data, c_valid);
    arrow #(2, 0, 56) arrowLeft(clk6p25m, 16'hFFFF, pixel_index, arrow_leftdata, arrowleft);
    letter_display #(17, 7, 56) Q(clk6p25m, 16'hFFFF, pixel_index, q_data, q_valid);   
 
    reg valid_any = 1'b0;
    reg [15:0] final_pixel_data = 16'h0000;
        
    always @ (posedge clk6p25m) begin // edit and put in separate module 
        if (arrowup) 
            oled_data <= arrow_updata;
        else if (x_valid)
            oled_data <= x_data;
        else if (arrowleft)
            oled_data <= arrow_leftdata;
        else if (q_valid)
            oled_data <= q_data;
        else if (valid_any)
            oled_data <= final_pixel_data;
        else
            oled_data <= 0;
    end
     
    always @(*) begin
        if (valid1) begin final_pixel_data = pixel_data1; valid_any = 1; end
        else if (valid2) begin final_pixel_data = pixel_data2; valid_any = 1; end
        else if (valid3) begin final_pixel_data = pixel_data3; valid_any = 1; end
        else if (valid4) begin final_pixel_data = pixel_data4; valid_any = 1; end
        else if (valid5) begin final_pixel_data = pixel_data5; valid_any = 1; end
        else if (valid6) begin final_pixel_data = pixel_data6; valid_any = 1; end
        else if (valid7) begin final_pixel_data = pixel_data7; valid_any = 1; end
        else if (valid8) begin final_pixel_data = pixel_data8; valid_any = 1; end
        else begin valid_any = 0; end
    end
    
endmodule
