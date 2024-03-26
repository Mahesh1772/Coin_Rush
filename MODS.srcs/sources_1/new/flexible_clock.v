`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2024 22:02:08
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock(
    input clk,
    input [31:0]m,
    output reg slow_clk = 0
    );
    
    reg [31:0] count = 0;
    
    always @ (posedge clk) begin
        count <= (count == m) ? 0 : count + 1;
        slow_clk <= (count == 0) ? ~slow_clk : slow_clk;
    end 
    
endmodule
