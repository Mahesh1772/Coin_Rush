`timescale 1ns / 1ps

module mini_game(
    input clk,
    input [9:0] sw,
    input sw14,              // Turn off sw14 to stop the mini-game
    input reset,
    output wire [3:0] an,
    output wire [6:0] seg ,
    output wire [13:0] score,          // output score register value
    output wire new_score,              // output signal that is asserted when a new score is calculated
    output reg [13:12] led = 0
    );
    
    reg [3:0] random_num = 0;
    reg [31:0] gen_interval_count = 0;    
    wire led_blink_0, led_blink_1;
    wire [13:12] led_blink;
  
    parameter blink_frequency = 24_999_999;    // 2 Hz
    //parameter max_no_of_random_nums = 20;
    parameter gen_interval = 199_999_999;   // Interval between 2 random nums
    parameter gen_range = 9;    // Generate random num from 0 - gen_range
    
    flexible_clock clk_10Hz_unit0 (clk, blink_frequency, led_blink_0);
    flexible_clock clk_10Hz_unit1 (clk, blink_frequency, led_blink_1);
    
    assign led_blink = {led_blink_1, led_blink_0};
    
    reg [15:0] lfsr_state = 16'b1010_0101_1010_0101;
    
    reg btnC_prev = 0;  // Previous state of btnC
    reg btnC_rising_edge;  // Rising edge detection for btnC
    
         
    always @ (posedge clk) begin
        gen_interval_count = gen_interval_count + 1;
        if (gen_interval_count == gen_interval) begin       //  interval between generation of the next random number
            lfsr_state = {lfsr_state[14:0], lfsr_state[0] ^ lfsr_state[2] ^ lfsr_state[3] ^ lfsr_state[5]};
            random_num = lfsr_state[3:0] % (gen_range + 1);
            gen_interval_count = 0;
        end
    end
       
    seg_display unit (.clk(clk), .sw14(sw14), .reset(reset), .num(random_num), .an(an), .seg(seg));

    // score reg and next-state logic
    reg [13:0] score_reg;
    reg [13:0] score_next = 0;
    // new_score register, signals when a new score is calculated
    reg new_score_reg, new_score_next;

    assign score = score + score_reg;
    assign new_score = new_score_reg;
	
    // infer score register
    always @(posedge clk, posedge reset)
    if(reset) 
    begin
	    score_reg <= 0;
        new_score_reg <= 0;
    end else
    begin
        score_reg <= score_next;
        new_score_reg <= new_score_next;
    end
    
    always @ (posedge clk) begin
        if (sw14 && !reset) begin
            if (random_num == 0 && sw == 10'b00000_00001) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 1 && sw == 10'b00000_00010) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 2 && sw == 10'b00000_00100) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 3 && sw == 10'b00000_01000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 4 && sw == 10'b00000_10000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 5 && sw == 10'b00001_00000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 6 && sw == 10'b00010_00000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 7 && sw == 10'b00100_00000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 8 && sw == 10'b01000_00000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else if (random_num == 9 && sw == 10'b10000_00000) begin
                led = led_blink;
                new_score_next = 1;
                score_next = score_next + 5;
            end
            else
                led = 0;
        end
        
        else begin
            led = 0;
        end
    end

endmodule
