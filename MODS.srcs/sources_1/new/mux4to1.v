`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 18:15:30
// Design Name: 
// Module Name: mux4to1
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


module mux4to1(
    input [3:0] A, B,
    input [1:0] C, 
    input [3:0] D,
    input [1:0] SS,
    output reg [3:0] Y
    );
    
    always @ (A or B or C or D or SS) begin
        case (SS)
            2'b00 : Y = A;
            2'b01 : Y = B;
            2'b10 : Y = C;
            2'b11 : Y = D;
        endcase
    end
endmodule
