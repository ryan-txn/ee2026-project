`timescale 1ns / 1ps

module MoveWASD ( 
    // 0: Up, 1: Left, 2: Right, 3: Down
    input clk, input [15:0] scan_code,
    output reg [3:0] movementDirection);
    
    always @ (posedge clk) begin
        if (scan_code[15:8] == 8'hF0) begin
            movementDirection <= 4'b0000;
        end else begin 
            // W key
            if (scan_code[7:0] == 8'h1D)  begin
                movementDirection <= 4'b0001;
            // A key
            end else if (scan_code[7:0] == 8'h1C) begin
                movementDirection <= 4'b0010;
            // D key
            end else if (scan_code[7:0] == 8'h23) begin
                movementDirection <= 4'b0100;
            // S key
            end else if (scan_code[7:0] == 8'h1B) begin
                movementDirection <= 4'b1000;
            end
        end
    end
      
endmodule
