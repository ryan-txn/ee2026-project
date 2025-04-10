`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:42:50
// Design Name: 
// Module Name: MoveWASD
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


module MoveWASD 
    ( 
        // 0:Up 1:Left 2:Right 3:Down
        input btnU,
        input btnL,
        input btnR,
        input btnD,
        output reg [3:0] movementDirection
    );
    
    always @ (btnU, btnL, btnR, btnD) begin
        if (btnU == 1) // will == be a problem
            movementDirection <= 4'b0001;
        else if (btnL == 1) 
            movementDirection <= 4'b0010;
        else if (btnR == 1)
            movementDirection <= 4'b0100;
        else if (btnD == 1)
            movementDirection <= 4'b1000;
        else // follow prev
            movementDirection <= 4'b0000;
    end
    
endmodule
