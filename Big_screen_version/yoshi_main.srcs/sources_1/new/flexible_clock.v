`timescale 1ns / 1ps

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

