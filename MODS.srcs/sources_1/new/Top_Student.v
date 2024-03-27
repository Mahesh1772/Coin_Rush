`timescale 1ns / 1ps



module Top_Student (
// Control
    input clk,
    // LEDs, Switches, Buttons
    //input btnC, btnU, btnL, btnR, btnD, input [15:0] sw, output [15:0] led,
    // 7 Segment Display
    //output [6:0] seg, output dp, output [3:0] an,
    // OLED PMOD
    output [7:0] JC
    //inout mouse_ps2_clk, mouse_ps2_data
);

    wire [7:0] Jx;
    assign JC[7:0] = Jx;
    // Outputs
    wire [12:0] oled_pixel_index;
    wire [15:0] oled_pixel_data;
    wire clk_25mhz, clk_12_5mhz, clk_6_25mhz, slow_clk;
    
    flexible_clock clk1 (.clk(clk), .slow_clk(clk_6_25mhz), .m(7));
    
    // Additional wire for ROM output
    wire [15:0] rom_pixel_data;
    
    // Instantiate the eggs_rom module
    background_ghost_rom my_rom (
        .clk(clk), // Connect to the system clock
        .row(oled_pixel_index[12:6]), // Map the higher bits to the row
        .col(oled_pixel_index[5:0]),  // Map the lower bits to the column
        .color_data(rom_pixel_data)    // Connect the ROM output to the wire
    );
    
    // Connect the ROM output to the OLED display input
    assign oled_pixel_data = rom_pixel_data;

            
 Oled_Display display(
       .clk(clk_6_25mhz), .reset(0), 
       .frame_begin(), .sending_pixels(), .sample_pixel(), .pixel_index(oled_pixel_index), .pixel_data(oled_pixel_data), 
       .cs(Jx[0]), .sdin(Jx[1]), .sclk(Jx[3]), .d_cn(Jx[4]), .resn(Jx[5]), .vccen(Jx[6]), .pmoden(Jx[7])); //to SPI
   

endmodule