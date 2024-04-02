`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 18:14:54
// Design Name: 
// Module Name: binary_to_BCD
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


module binary_to_BCD(
    input [7:0] A,
    output [3:0] ones, tens,
    output [1:0] hundreds
    );
    
    wire [3:0] c1, c2, c3, c4, c5, c6, c7;
    wire [3:4] d1, d2, d3, d4, d5, d6, d7;
    
    assign d1 = {1'b0, A[7:5]};
    assign d2 = {c1[2:0], A[4]};
    assign d3 = {c2[2:0], A[3]};
    assign d4 = {c3[2:0], A[2]};
    assign d5 = {c4[2:0], A[1]};
    assign d6 = {1'b0, c1[3], c2[3], c3[3]};
    assign d7 = {c6[2:0], c4[3]};
    
    shift_add3_algorithm u1 (d1, c1);
    shift_add3_algorithm u2 (d2, c2);
    shift_add3_algorithm u3 (d3, c3);
    shift_add3_algorithm u4 (d4, c4);
    shift_add3_algorithm u5 (d5, c5);
    shift_add3_algorithm u6 (d6, c6);
    shift_add3_algorithm u7 (d7, c7);
    
    assign ones = {c5[2:0], A[0]};
    assign tens = {c5[3], c7[2:0]};
    assign hundreds = {c7[3], c6[3]};
endmodule
