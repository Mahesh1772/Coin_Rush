`timescale 1ns / 1ps

module seg_display(
    input clk,
    input sw14,
    input reset,
    input [3:0] num,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    reg [1:0] counter = 0;
    parameter max_no_of_random_nums = 20;
    
    wire clk_10khz;
    flexible_clock clk_10kHz (clk, 4999, clk_10khz); 
    
    always @ (clk_10khz) begin
        if (sw14 && !reset) begin
            an = 4'b1110;
            case (num)
                0: seg = 7'b1000000;
                1: seg = 7'b1111001;
                2: seg = 7'b0100100;
                3: seg = 7'b0110000;
                4: seg = 7'b0011001;
                5: seg = 7'b0010010;
                6: seg = 7'b0000010;
                7: seg = 7'b1111000;
                8: seg = 7'b0000000;
                9: seg = 7'b0011000;             
            endcase
        end
        else begin
            an = 4'b1111;
            seg = 7'b1111111;
        end
        counter <= counter + 1;
    end
endmodule
