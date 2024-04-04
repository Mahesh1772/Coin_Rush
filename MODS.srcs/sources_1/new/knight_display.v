`timescale 1ns / 1ps

module knight_display
(
    input wire clk,                    // input clock signal for synchronous ROMs
    input wire video_on,               // input from vga_sync signaling when video signal is on
    input wire [12:0] pixel_index,     // 13-bit wire containing all pixel indices
    output reg [15:0] rgb_out,         // output rgb signal for current pixel (565 RGB format)
    output reg knight_on            // output signal asserted when pixel is within platform location in display area
);

    // Assuming screen width is a power of 2 for simplicity, e.g., 128 pixels
localparam SCREEN_WIDTH = 96;
localparam SCREEN_HEIGHT = 64;

// Calculate x and y from pixel_index
wire [6:0] x = pixel_index % SCREEN_WIDTH; // Adjusted for actual screen width
wire [6:0] y = pixel_index / SCREEN_WIDTH; // Adjusted for actual screen width

// Registers to index ROM
reg [2:0] row;
reg [4:0] col;

// Output vectors from walls and blocks ROMs (16-bit color data)
wire [15:0] knight_color_data;
    
 knight_rom my_knight (
        .clk(clk),
        .row(row), // Adjust for knight's Y position
        .col(col),   // Adjust for knight's X position
        .color_data(knight_color_data)
    );

// Adjusted offset for 4x4 blocks
localparam offset = 4;

// Always block to set ROM index regs row/col, rgb_out, and platforms_on, depending on input x/y
always @*
    begin
        // Defaults
        knight_on <= 0;
        row <= 0;
        col <= 0;
        rgb_out <= 16'h0000;

        if(video_on)
        begin

            // Platform 'C' at (4, 24)
            if(y >= 18 && y < 24 && x >= 16 && x < 20)
            begin
                row <= (y - 18) + offset;
                col <= (x - 16);
                if(knight_color_data != 16'hFFFF)
                begin
                    knight_on <= 1;
                    rgb_out <= knight_color_data;
                end
            end

        end
    end
endmodule
