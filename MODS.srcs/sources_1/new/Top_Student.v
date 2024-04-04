`timescale 1ns / 1ps

module Top_Student (
    input clk,
    output [7:0] JC,
    input BtnU,
//    input BtnD,
    input BtnL,
    input BtnR
//    input BtnC
);

    localparam SCREEN_WIDTH = 96;
    localparam SCREEN_HEIGHT = 64;

    wire [7:0] Jx;
    assign JC[7:0] = Jx;
    wire [12:0] oled_pixel_index;
    wire [15:0] oled_pixel_data;
    wire clk_6_25mhz;
    
    wire game_en;
    wire [2:0] game_state;
    wire game_reset;  
    
    wire collision;     
    
    wire reset;                                                   // reset signal
    assign reset = game_reset;      
    
    wire [6:0] y_x, y_y;                                          // vector to route yoshi's x/y location
    wire [6:0] g_c_x, g_c_y;                                      // vector to route ghost_crazy's x/y location
    wire [6:0] g_t_x, g_t_y;                                      // vector to route ghost_top's x/y location
    wire [6:0] g_b_x, g_b_y; 
    
    // Generate a slower clock for the OLED display
    flexible_clock clk1 (.clk(clk), .slow_clk(clk_6_25mhz), .m(7));
    
    // Additional wires for ROM outputs and platform status
    wire [15:0] background_pixel_data;
    wire [15:0] platform_pixel_data;
    wire [15:0] hearts_pixel_data; // Wire for hearts color data
    // Additional wire for knight ROM outputs
    wire [15:0] yoshi_pixel_data;
    wire yoshi_on; // Signal to indicate when the knight is on
    wire platforms_on;
    wire hearts_on; // Signal to indicate when hearts are on
    wire grounded, jumping_up, direction;     
    
                        // signals to route status signals for yoshi
    localparam idle = 3'b001;                                     // symbolic state constant representing game state idle
    localparam gameover = 3'b100; 
    wire yoshi_up, yoshi_left, yoshi_right;
    assign yoshi_up = BtnU & game_en;
    assign yoshi_left = BtnL & game_en;
    assign yoshi_right = BtnR & game_en;
    
    // game_over signal routed to yoshi to signal when to display yoshi ghost
        wire game_over_yoshi;
        assign game_over_yoshi = (game_state == gameover) ? 1 : 0;
    
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
    
    
//    // Instantiate the platforms module
//        knight_display my_knight (
//            .clk(clk),
//            .video_on(1'b1), // Assuming video is always on for simplicity
//            .pixel_index(oled_pixel_index),
//            .rgb_out(knight_pixel_data),
//            .knight_on(knight_on)
//        );

//    mario_sprite unit1 (
//    .clk(clk), 
//    .btnU(yoshi_up), 
//    .btnL(yoshi_left), 
//    .btnR(yoshi_right), 
//    .pixel_index(oled_pixel_index), 
//    .oled_data(yoshi_pixel_data),
//    .mario_on(yoshi_on)  
//    );

//// instantiate yoshi sprite circuit
	yoshi_sprite yoshi_unit (.clk(clk), .reset(reset), .btnU(yoshi_up),
				 .btnL(yoshi_left), .btnR(yoshi_right), .video_on(1'b1), .pixel_index(oled_pixel_index),
				 .grounded(grounded), .game_over_yoshi(game_over_yoshi), .collision(collision),
				 .rgb_out(yoshi_pixel_data),.yoshi_on(yoshi_on), .y_x(y_x), .y_y(y_y), 
				 .jumping_up(jumping_up), .direction(direction));

    
    // Combine the pixel data from knight, hearts, platforms, and background
    assign oled_pixel_data = yoshi_on ? yoshi_pixel_data :
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