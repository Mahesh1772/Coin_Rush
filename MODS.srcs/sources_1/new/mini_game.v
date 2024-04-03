`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 23:04:57
// Design Name: 
// Module Name: random_num_generator
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


module mini_game(
    input clk,
    input [15:0] sw,
    output wire [3:0] an,
    output wire [6:0] seg ,
    output reg [2:0] led = 0
    );
    
    reg [3:0] random_num = 0;
    reg [31:0] two_sec_count = 0;
    wire led_blink_0, led_blink_1, led_blink_2;
    wire [2:0] led_blink;
    
    flexible_clock clk_10Hz_unit0 (clk, 4999999, led_blink_0);
    flexible_clock clk_10Hz_unit1 (clk, 4999999, led_blink_1);
    flexible_clock clk_10Hz_unit2 (clk, 4999999, led_blink_2);
    
    assign led_blink = {led_blink_2, led_blink_1, led_blink_0};
    
    reg [15:0] lfsr_seed; // Default seed for LFSR
    reg [15:0] lfsr_state = 16'hC0DE;
    
    always @ (posedge clk) begin
        two_sec_count = two_sec_count + 1;
        if (two_sec_count == 199999999) begin
            lfsr_state = {lfsr_state[14:0], lfsr_state[0] ^ lfsr_state[2] ^ lfsr_state[3] ^ lfsr_state[5]};
            random_num = lfsr_state[3:0] % 10;
            two_sec_count = 0;
        end
    end
    
    seg_display unit (clk, random_num, an, seg);
    
    always @ (posedge clk) begin
        if (random_num == 0 && sw == 10'b00000_00001)
            led = led_blink;
        else if (random_num == 1 && sw == 10'b00000_00010)
            led = led_blink;
        else if (random_num == 2 && sw == 10'b00000_00100)
            led = led_blink;
        else if (random_num == 3 && sw == 10'b00000_01000)
            led = led_blink;
        else if (random_num == 4 && sw == 10'b00000_10000)
            led = led_blink;
        else if (random_num == 5 && sw == 10'b00001_00000)
            led = led_blink;
        else if (random_num == 6 && sw == 10'b00010_00000)
            led = led_blink;
        else if (random_num == 7 && sw == 10'b00100_00000)
            led = led_blink;
        else if (random_num == 8 && sw == 10'b01000_00000)
            led = led_blink;
        else if (random_num == 9 && sw == 10'b10000_00000)
            led = led_blink;
        else
            led = 0;
    end

endmodule
