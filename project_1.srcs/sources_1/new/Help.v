`timescale 1ns / 1ps


module Help(
    input wire clk6p25m,
    input wire [12:0] pixel_index,
    input wire [7:0] scan_code, //change to input for keyboard
    output reg [15:0] oled_data,
    output reg back
    );
    
    wire [15:0] page0_oled_data, page1_oled_data;
    
    always @(posedge clk6p25m) begin 
        if (scan_code == 8'h15)
            back = 1;
        else 
            back = 0;
    end

    reg page = 0;
    
    always @(posedge clk6p25m) begin 
        if (scan_code == 8'h22) // change to X
            page <= 0; 
        else if (scan_code == 8'h21) //change to C
            page <= 1;
    end 
        
    always @ (posedge clk6p25m) begin // edit and put in separate module 
        if (page == 0)
            oled_data <= page0_oled_data;
        else if (page == 1)
            oled_data <= page1_oled_data;
    end
    
    Help1 h1(clk6p25m, pixel_index, page0_oled_data);
    Help2 h2(clk6p25m, pixel_index, page1_oled_data);
    
    
endmodule
