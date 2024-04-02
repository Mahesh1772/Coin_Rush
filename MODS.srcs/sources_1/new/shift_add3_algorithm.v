`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 19:30:25
// Design Name: 
// Module Name: shift_add3_algorithm
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


module shift_add3_algorithm(
    input [3:0] in,
    output reg [3:0] out
    );
    
    always @ (in) begin
        case (in)
            4'b0000 : out <= 4'b0000;
            4'b0001 : out <= 4'b0001;
            4'b0010 : out <= 4'b0010;
            4'b0011 : out <= 4'b0011;
            4'b0100 : out <= 4'b0100;
            4'b0101 : out <= 4'b1000;
            4'b0110 : out <= 4'b1001;
            4'b0111 : out <= 4'b1010;
            4'b1000 : out <= 4'b1011;
            4'b1001 : out <= 4'b1100;
            default : out <= 4'b0000;
        endcase
    end
endmodule
