`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 18:16:21
// Design Name: 
// Module Name: my_counter
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


module my_counter(
    input clk,
    output [1:0] Q
    );
    
    reg [1:0] temp = 0;
    always @ (posedge clk) begin
        temp = temp + 1;
    end
    assign Q = temp;
endmodule
