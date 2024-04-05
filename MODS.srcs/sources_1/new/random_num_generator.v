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


module random_number_generator(
    input clk,
    input [15:0] sw,
    output [3:0] an,
    output [6:0] seg,
    output reg led = 0
    );
    
    reg [3:0] random_num = 0;
    reg [31:0] gen_interval_count = 0;
    wire [3:0] an_wire;
    wire [6:0] seg_wire;
    
    reg [15:0] lfsr_state = 16'b1010_0101_1010_0101;  // seed
     
    always @ (posedge clk) begin
        gen_interval_count = gen_interval_count + 1;
        if (gen_interval_count == 199999999) begin
            lfsr_state = {lfsr_state[14:0], lfsr_state[0] ^ lfsr_state[2] ^ lfsr_state[3] ^ lfsr_state[5]};
            random_num = lfsr_state[3:0];
            gen_interval_count = 0;
        end
    end
    
    seg_display unit (clk, random_num, an_wire, seg_wire);
    assign an = an_wire;
    assign seg = seg_wire;
    
    always @ (posedge clk) begin
        if (random_num == 0 && sw == 10'b00000_00001)
            led <= 1;
        else if (random_num == 1 && sw == 10'b00000_00010)
            led <= 1;
        else if (random_num == 2 && sw == 10'b00000_00100)
            led <= 1;
        else if (random_num == 3 && sw == 10'b00000_01000)
            led <= 1;
        else if (random_num == 4 && sw == 10'b00000_10000)
            led <= 1;
        else if (random_num == 5 && sw == 10'b00001_00000)
            led <= 1;
        else if (random_num == 6 && sw == 10'b00010_00000)
            led <= 1;
        else if (random_num == 7 && sw == 10'b00100_00000)
            led <= 1;
        else if (random_num == 8 && sw == 10'b01000_00000)
            led <= 1;
        else if (random_num == 9 && sw == 10'b10000_00000)
            led <= 1;
        else if (random_num == 10 && sw == 16'b000001_00000_00000)
            led <= 1;
        else if (random_num == 11 && sw == 16'b000010_00000_00000)
            led <= 1;
        else if (random_num == 12 && sw == 16'b000100_00000_00000)
            led <= 1;
        else if (random_num == 13 && sw == 16'b001000_00000_00000)
            led <= 1;
        else if (random_num == 14 && sw == 16'b010000_00000_00000)
            led <= 1;
        else if (random_num == 15 && sw == 16'b100000_00000_00000)
            led <= 1;
        else
            led <= 0;
    end

endmodule

