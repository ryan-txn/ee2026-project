`timescale 1ns / 1ps

module Debouncer (
    input clk, input PS2_input,
    output reg debounced_signal);
    
    reg [4:0] count;
    reg PS2_prev = 0;
    
    always @ (posedge clk) begin
        if (PS2_input == PS2_prev) begin
            if (count == 19) begin
                debounced_signal <= PS2_input;
            end else begin
                count <= count + 1'b1;
            end
        end else begin
            count <= 'b0;
            PS2_prev <= PS2_input;
        end
    end

endmodule
