`timescale 1ns / 1ps

module platforms
(
    input wire clk,                    // input clock signal for synchronous ROMs
    input wire video_on,               // input from vga_sync signaling when video signal is on
    input wire [12:0] pixel_index,     // 13-bit wire containing all pixel indices
    output reg [15:0] rgb_out,         // output rgb signal for current pixel (565 RGB format)
    output reg platforms_on            // output signal asserted when pixel is within platform location in display area
);

    // Assuming screen width is a power of 2 for simplicity, e.g., 128 pixels
localparam SCREEN_WIDTH = 96;
localparam SCREEN_HEIGHT = 64;

// Calculate x and y from pixel_index
wire [6:0] x = pixel_index % SCREEN_WIDTH; // Adjusted for actual screen width
wire [6:0] y = pixel_index / SCREEN_WIDTH; // Adjusted for actual screen width

// Registers to index ROM
reg [4:0] row;
reg [2:0] col;

// Output vectors from walls and blocks ROMs (16-bit color data)
wire [15:0] walls_color_data, blocks_color_data;
    
 walls_rom walls_unit (.clk(clk), .row(row[2:0]), .col(col[1:0]), .color_data(walls_color_data));
    
 blocks_rom blocks_unit (.clk(clk), .row(row), .col(col), .color_data(blocks_color_data));

// Adjusted offset for 4x4 blocks
localparam offset = 4;

// Always block to set ROM index regs row/col, rgb_out, and platforms_on, depending on input x/y
always @*
    begin
        // Defaults
        platforms_on <= 0;
        row <= 0;
        col <= 0;
        rgb_out <= 16'h0000;

        if(video_on)
        begin
            // Platform 'A'
            if((y >= 12 && y < 16 && x >= 4 && x < 20))
            begin
                row <= (y - 12) / 4;
                col <= (x - 4) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            
            // Platform 'B' at (28, 12)
            if(y >= 12 && y < 16 && x >= 76 && x < 92)
            begin
                row <= (y - 12) / 4;
                col <= (x - 28) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            
            // Platform 'C' at (4, 24)
            if(y >= 24 && y < 28 && x >= 16 && x < 80)
            begin
                row <= (y - 24) / 4;
                col <= (x - 4) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            
            // Platform 'D' at (28, 24)
            if(y >= 36 && y < 40 && x >= 76 && x < 92)
            begin
                row <= (y - 24) / 4;
                col <= (x - 28) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            
            // Platform 'E' at (4, 36)
            if(y >= 36 && y < 40 && x >= 4 && x < 20)
            begin
                row <= (y - 36) / 4;
                col <= (x - 4) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            
            // Platform 'F' at (28, 48)
            if(y >= 48 && y < 52 && x >= 16 && x < 80)
            begin
                row <= (y - 36) / 4;
                col <= (x - 28) / 4;
                if(blocks_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= blocks_color_data;
                end
            end
            // // Platform 'G' at (4, 40)
            // if(y >= 40 && y < 44 && x >= 16 && x < 80)
            // begin
            //     row <= (y - 40) / 4;
            //     col <= (x - 4) / 4;
            //     if(blocks_color_data != 16'hFFFF)
            //     begin
            //         platforms_on <= 1;
            //         rgb_out <= blocks_color_data;
            //     end
            // end

            // Top row
            if(y < 4)
            begin
                row <= y / 4;
                col <= x / 4;
                if(walls_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= walls_color_data;
                end
            end

            // Bottom row
            if(y >= SCREEN_HEIGHT - 4)
            begin
                row <= (y - (SCREEN_HEIGHT - 4)) / 4;
                col <= x / 4;
                if(walls_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= walls_color_data;
                end
            end

            // Left column
            if(x < 4)
            begin
                row <= y / 4;
                col <= x / 4;
                if(walls_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= walls_color_data;
                end
            end

            // Right column
            if(x >= SCREEN_WIDTH - 4)
            begin
                row <= y / 4;
                col <= (x - (SCREEN_WIDTH - 4)) / 4;
                if(walls_color_data != 16'hFFFF)
                begin
                    platforms_on <= 1;
                    rgb_out <= walls_color_data;            
                end
            end
        end
    end
endmodule
