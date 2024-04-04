`timescale 1ns / 1ps

module Top_Student (
    input clk,
    output [7:0] JC
);

    localparam SCREEN_WIDTH = 96;
    localparam SCREEN_HEIGHT = 64;

    wire [7:0] Jx;
    assign JC[7:0] = Jx;
    wire [12:0] oled_pixel_index;
    wire [15:0] oled_pixel_data;
    wire clk_6_25mhz;
    
    // Generate a slower clock for the OLED display
    flexible_clock clk1 (.clk(clk), .slow_clk(clk_6_25mhz), .m(7));
    
    // Additional wires for ROM outputs and platform status
    wire [15:0] background_pixel_data;
    wire [15:0] platform_pixel_data;
    wire [15:0] hearts_pixel_data; // Wire for hearts color data

    // Wires for BCD values and score_on signal
    wire [3:0] bcd3, bcd2, bcd1, bcd0;
    wire score_on;

    wire platforms_on;
    wire hearts_on; // Signal to indicate when hearts are on
    
    // Instantiate the binary to BCD conversion module
binary2bcd bcd_unit (
    .clk(clk),
    .reset(0),
    .start(1'b1), // Assuming start signal is always asserted
    .in(14'd1234), // Set the input value to 1234
    .bcd3(bcd3),
    .bcd2(bcd2),
    .bcd1(bcd1),
    .bcd0(bcd0)
);

    // Instantiate the background module
    background my_background (
        .clk(clk),
        .row(oled_pixel_index[12:7]),
        .col(oled_pixel_index[6:0]),
        .color_data(background_pixel_data)
    );
    
    // Instantiate the platforms module
    platforms my_platforms (
        .clk(clk),
        .video_on(1'b1), // Assuming video is always on for simplicity
        .pixel_index(oled_pixel_index),
        .rgb_out(platform_pixel_data),
        .platforms_on(platforms_on)
    );

    // Instantiate the hearts_display module
    hearts_display my_hearts (
        .clk(clk),
        .pixel_index(oled_pixel_index),
        .num_hearts(2),
        .color_data(hearts_pixel_data),
        .hearts_on(hearts_on)
    );

    // Instantiate the score_display module
    score_display my_score (
        .clk(clk),
        .reset(0), // Assume reset is not asserted
        .new_score(1'b1), // Assume new_score is not asserted
    .score({bcd3, bcd2, bcd1, bcd0}), // Connect BCD outputs to score input
        .pixel_index(oled_pixel_index),
        .sseg(), // Ignore sseg and an outputs
        .an(),
        .score_on(score_on)
    );
    
    // Combine the pixel data from background and platforms, and hearts
        assign oled_pixel_data = score_on ? 16'hFFFF :
                            hearts_on ? hearts_pixel_data :
                            platforms_on ? platform_pixel_data :
                            background_pixel_data;
    
    // Instantiate the OLED display module
    Oled_Display display(
        .clk(clk_6_25mhz), .reset(0), 
        .frame_begin(), .sending_pixels(), .sample_pixel(), .pixel_index(oled_pixel_index), .pixel_data(oled_pixel_data), 
        .cs(Jx[0]), .sdin(Jx[1]), .sclk(Jx[3]), .d_cn(Jx[4]), .resn(Jx[5]), .vccen(Jx[6]), .pmoden(Jx[7])
    );

endmodule