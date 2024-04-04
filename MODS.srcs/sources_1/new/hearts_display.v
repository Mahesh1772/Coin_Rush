`timescale 1ns / 1ps

module hearts_display(
    input wire clk,                // clock signal for synchronous roms
    input wire [12:0] pixel_index, // combined x/y pixel index
    input wire [1:0] num_hearts,   // input signal of number of hearts to display
    output wire [15:0] color_data, // output signals for rgb color_data
    output reg hearts_on           // output signal asserted when x/y is located within the hearts locations
);

    // Assuming screen width is a power of 2 for simplicity, e.g., 96 pixels
    localparam SCREEN_WIDTH = 96;
    localparam SCREEN_HEIGHT = 64;

    // Calculate x and y from pixel_index
    wire [6:0] x = pixel_index % SCREEN_WIDTH; // Adjusted for actual screen width
    wire [6:0] y = pixel_index / SCREEN_WIDTH; // Adjusted for actual screen height

    // row and column regs to index hearts_rom
    reg [2:0] row; // 3 bits for 8 rows
    reg [1:0] col; // 2 bits for 4 columns

    localparam HEART_HEIGHT = 4;

    // infer hearts rom 
    hearts_rom hearts_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));

    always @* begin
        // defaults
        row = 0;
        col = 0;
        hearts_on = 0;

        // // if vga pixel within heart 1 (left)
    	// if(x >= 48 && x < 52 && y>=4 && y < 8) begin
    	// 	col = x - 48;                     // set col index
    	// 	if(num_hearts > 0)                 // if num_hearts > 0 (1,2,3) left heart is on
    	// 		row = y - HEART_HEIGHT;                  // set full heart
    	// 	else 
    	// 		row = y;                       // else set empty heart
    	// 	if(color_data != 16'hFFFF) // if color_data != sprite background color
    	// 		hearts_on = 1;                 // assert hearts_on signal
    	// end

    	// // if vga pixel within heart 2 (center)
    	// if(x >= 52 && x < 56 && y>=4 && y < 8) begin
    	// 	col = x - 52;                     // set col index
    	// 	if(num_hearts > 1)                 // if num_hearts > 1 (2,3) middle heart is on
    	// 		row = y - HEART_HEIGHT;                  // set full heart
    	// 	else 
    	// 		row = y;                       // else set empty heart
    	// 	if(color_data != 16'hFFFF) // if color_data != sprite background color
    	// 		hearts_on = 1;                 // assert hearts_on signal
    	// end


    	// // if vga pixel within beart 3 (right)
    	// if(x >= 56 && x < 60 && y>=4 && y < 8) begin
    	// 	col = x - 56;                     // set col index
    	// 	if(num_hearts > 2)                 // if num_hearts > 2 (3)right heart is on
    	// 		row = y - HEART_HEIGHT;                  // set full heart
    	// 	else 
    	// 		row = y;                       // else set empty heart
    	// 	if(color_data != 16'hFFFF) // if color_data != sprite background color
    	// 		hearts_on = 1;                 // assert hearts_on signal
    	// end

		// if vga pixel within heart 1 (left)
    if(x >= 33 && x < 37 && y>=4 && y < 8) begin
        col = x - 33; // set col index
        if(num_hearts > 0) // if num_hearts > 0 (1,2,3) left heart is on
            row = y - HEART_HEIGHT; // set full heart
        else
            row = y; // else set empty heart
        if(color_data != 16'hFFFF) // if color_data != sprite background color
            hearts_on = 1; // assert hearts_on signal
    end

    // if vga pixel within heart 2 (center)
    if(x >= 37 && x < 41 && y>=4 && y < 8) begin
        col = x - 37; // set col index
        if(num_hearts > 1) // if num_hearts > 1 (2,3) middle heart is on
            row = y - HEART_HEIGHT; // set full heart
        else
            row = y; // else set empty heart
        if(color_data != 16'hFFFF) // if color_data != sprite background color
            hearts_on = 1; // assert hearts_on signal
    end

    // if vga pixel within heart 3 (right)
    if(x >= 41 && x < 45 && y>=4 && y < 8) begin
        col = x - 41; // set col index
        if(num_hearts > 2) // if num_hearts > 2 (3) right heart is on
            row = y - HEART_HEIGHT; // set full heart
        else
            row = y; // else set empty heart
        if(color_data != 16'hFFFF) // if color_data != sprite background color
            hearts_on = 1; // assert hearts_on signal
    end

    end

endmodule
