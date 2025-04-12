`timescale 1ns / 1ps

module menu (
    input wire clk6p25m, input wire [12:0] pixel_index, input wire [7:0] scan_code,
    output reg [15:0] oled_data, output reg [1:0] selection);
    
    wire [15:0] pixel_data1, pixel_data2, pixel_data3, pixel_data4, pixel_data5; 
    wire [15:0] pixel_data6, pixel_data7, pixel_data8, pixel_data9;               
    wire valid1, valid2, valid3, valid4, valid5, valid6, valid7, valid8, valid9;
    
    wire [15:0] arrow_data1, arrow_data2;
    wire arrow_valid1, arrow_valid2;
    
    reg [1:0] choose = 1;
    
    
    //START        
    letter_display #(19, 31, 22) S1(clk6p25m, 16'hFFFF, pixel_index, pixel_data1, valid1); 
    letter_display #(20, 38, 22) T1(clk6p25m, 16'hFFFF, pixel_index, pixel_data2, valid2); 
    letter_display #(1, 45, 22) A1(clk6p25m, 16'hFFFF, pixel_index, pixel_data3, valid3);
    letter_display #(18, 52, 22) R1(clk6p25m, 16'hFFFF, pixel_index, pixel_data4, valid4);
    letter_display #(20, 59, 22) T2(clk6p25m, 16'hFFFF, pixel_index, pixel_data5, valid5);   
    
    //HELP
    letter_display #(8, 34, 32) H1(clk6p25m, 16'hFFFF, pixel_index, pixel_data6, valid6); 
    letter_display #(5, 41, 32) E1(clk6p25m, 16'hFFFF, pixel_index, pixel_data7, valid7); 
    letter_display #(12, 48, 32) L1(clk6p25m, 16'hFFFF, pixel_index, pixel_data8, valid8); 
    letter_display #(16, 55, 32) P1(clk6p25m,16'hFFFF, pixel_index, pixel_data9, valid9); 
    
    //ARROW
    arrow #(0, 24, 22) a1(clk6p25m, 16'hFFFF, pixel_index, arrow_data1, arrow_valid1);
    arrow #(0, 27, 32) a2(clk6p25m, 16'hFFFF, pixel_index, arrow_data2, arrow_valid2);  
    
    always @(posedge clk6p25m) begin
        if (scan_code == 8'h24) begin
            selection = choose;
        end else if (scan_code == 8'h15) begin
            selection = 0;
        end
    end 
  
    always @(posedge clk6p25m) begin
        if (scan_code == 8'h22) begin
            choose <= 1;
        end else if (scan_code == 8'h21) begin
            choose <= 2;
        end
               
        if (valid1) begin
            oled_data <= pixel_data1;
        end else if (valid2) begin
            oled_data <= pixel_data2;
        end else if (valid3) begin
            oled_data <= pixel_data3;
        end else if (valid4) begin
            oled_data <= pixel_data4;
        end else if (valid5) begin 
            oled_data <= pixel_data5;
        end else if (valid6) begin
            oled_data <= pixel_data6;
        end else if (valid7) begin
            oled_data <= pixel_data7;
        end else if (valid8) begin
            oled_data <= pixel_data8;
        end else if (valid9) begin
            oled_data <= pixel_data9;    
        end else if (arrow_valid1 && choose == 1) begin
            oled_data <= arrow_data1;
        end else if (arrow_valid2 && choose == 2) begin
            oled_data <= arrow_data2;
        end     
    end
    
endmodule