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
    input [9:0] sw,
    input sw14,              // Turn off sw14 to stop the mini-game
    output wire [3:0] an,
    output wire [6:0] seg ,
    output reg [13:12] led = 0
    );
    
    reg [3:0] random_num = 0;
    reg [5:0] nums_gen_so_far = 0;
    reg [31:0] gen_interval_count = 0;    
    wire led_blink_0, led_blink_1;
    wire [13:12] led_blink;
    
    reg [3:0] state = 0;
    reg is_continue = 0;
    reg prev_sw14 = 0;
    
    parameter blink_frequency = 24_999_999;    // 2 Hz
    parameter max_no_of_random_nums = 20;
    parameter gen_interval = 299999999;   // Interval between 2 random nums
    parameter gen_range = 9;    // Generate random num from 0 - gen_range
    
    flexible_clock clk_10Hz_unit0 (clk, blink_frequency, led_blink_0);
    flexible_clock clk_10Hz_unit1 (clk, blink_frequency, led_blink_1);
    
    assign led_blink = {led_blink_1, led_blink_0};
    
    reg [15:0] lfsr_seed; // Default seed for LFSR
    reg [15:0] lfsr_state = 16'b1010_0101_1010_0101;
    
    always @ (posedge clk) begin
        if (sw14 && !prev_sw14) begin
            state = 1;
        end
        else if (!sw14) begin
            state = 0;
        end
        
        prev_sw14 = sw14;
        
        if (state == 1) begin
            is_continue = 1;
        end
        else begin
            is_continue = 0;
        end
    end
    
    always @ (posedge clk) begin
        gen_interval_count = gen_interval_count + 1;
        if (gen_interval_count == gen_interval && nums_gen_so_far != max_no_of_random_nums && is_continue) begin       // 5-seconds interval between generation of the next random number
            lfsr_state = {lfsr_state[14:0], lfsr_state[0] ^ lfsr_state[2] ^ lfsr_state[3] ^ lfsr_state[5]};
            random_num = lfsr_state[3:0] % (gen_range + 1);
            nums_gen_so_far = nums_gen_so_far + 1;
            gen_interval_count = 0;      
        end
    end
    
    seg_display unit (clk, is_continue, nums_gen_so_far, random_num, an, seg);
    
    always @ (posedge clk) begin
        if (is_continue && nums_gen_so_far != max_no_of_random_nums) begin
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
            /*else if (random_num == 10 && sw == 12'b01_00000_00000)
                led = led_blink;
            else if (random_num == 11 && sw == 12'b10_00000_00000)
                led = led_blink; */
            else
                led = 0;
        end
        
        else begin
            led = 0;
        end
    end

endmodule
