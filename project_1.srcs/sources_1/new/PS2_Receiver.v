`timescale 1ns / 1ps

module PS2_Receiver (
    input clk, input PS2Clk, input PS2Data,
    output reg [15:0] binary);
    
    wire clk_debounced, data_debounced;
    
    reg [7:0] data_curr;
    reg [7:0] data_prev;
    reg [3:0] count;
    reg flag;
    
    Debouncer db_clk (
        clk, PS2Clk, clk_debounced);
        
    Debouncer db_data (
        clk, PS2Data, data_debounced);
    
    always @ (negedge clk_debounced) begin
        case (count)
            0:; //Start bit
            1: data_curr[0] <= data_debounced;
            2: data_curr[1] <= data_debounced;
            3: data_curr[2] <= data_debounced;
            4: data_curr[3] <= data_debounced;
            5: data_curr[4] <= data_debounced;
            6: data_curr[5] <= data_debounced;
            7: data_curr[6] <= data_debounced;
            8: data_curr[7] <= data_debounced;
            9: flag <= 1'b1;
            10: flag <= 1'b0;
        endcase
        
        if(count <= 9) begin
            count <= count + 1;
        end else if (count == 10) begin
            count <= 0;
        end
    end

    reg prev_flag;
    
    always @ (posedge clk) begin
        if (flag == 1'b1 && prev_flag == 1'b0) begin
            binary <= {data_prev, data_curr};
            data_prev <= data_curr;
        end
        
        prev_flag <= flag;
    end
    
endmodule
