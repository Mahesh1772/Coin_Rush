`timescale 1ns / 1ps

module score_display
	(	
	    input wire clk, reset,   // clock, reset signal inputs for synchronous roms and registers
	    input wire new_score,    // input wire asserted when eggs module increments score
	    input wire [13:0] score, // current score routed in from eggs module
        input wire [12:0] pixel_index, // combined x/y pixel index
	    output reg [7:0] sseg,   // output seven-segment signals
	    output reg [3:0] an,     // output seven-segment digit enable signals
	    output reg score_on      // output asserted when x/y are within score location in display
        );	
	
	// route bcd values out from binary to bcd conversion circuit
	wire [3:0] bcd3, bcd2, bcd1, bcd0;

    // Assuming screen width is a power of 2 for simplicity, e.g., 96 pixels
    localparam SCREEN_WIDTH = 96;
    localparam SCREEN_HEIGHT = 64;
    localparam SCORE_HEIGHT = 8;
    
    // Calculate x and y from pixel_index
    wire [6:0] x = pixel_index % SCREEN_WIDTH; // Adjusted for actual screen width
    wire [6:0] y = pixel_index / SCREEN_WIDTH; // Adjusted for actual screen height
	
	// instantiate binary to bcd conversion circuit
	binary2bcd bcd_unit (.clk(clk), .reset(reset), .start(new_score),
                         .in(score), .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
	
	// *** seven-segment score display ***
	
	// seven-segment output decoding circuit
    	// register to route either units or tenths value to decoding circuit
        reg [3:0] decode_reg, decode_next;
        
        // infer decode value register
        always @(posedge clk, posedge reset)
	    if(reset)
		decode_reg <= 0;
	    else 
		decode_reg <= decode_next;
	
	// decode value_reg to sseg outputs
	always @*
		case(decode_reg)
			0: sseg = 8'b10000001;
			1: sseg = 8'b11001111;
			2: sseg = 8'b10010010;
			3: sseg = 8'b10000110;
			4: sseg = 8'b11001100;
			5: sseg = 8'b10100100;
			6: sseg = 8'b10100000;
			7: sseg = 8'b10001111;
			8: sseg = 8'b10000000;
			9: sseg = 8'b10000100;
			default: sseg = 8'b11111111;
		endcase
	
	// seven-segment multiplexing circuit @ 381 Hz
	reg [16:0] m_count_reg;
	
	// infer multiplexing counter register and next-state logic
	always @(posedge clk, posedge reset)
		if(reset)
			m_count_reg <= 0;
		else
			m_count_reg <= m_count_reg + 1;
	
	// multiplex two digits using MSB of m_count_reg 
	always @*
		case (m_count_reg[16:15])
			0: begin
			   an = 4'b1110;
               decode_next = bcd0;
            end
			1: begin
               	an = 4'b1101;
                decode_next = bcd1;
            end    
                    
            2: begin
                an = 4'b1011;
                decode_next = bcd2;
            end
                    
            3: begin
                an = 4'b0111;
                decode_next = bcd3;
            end 
	    endcase
	
	// *** on screen score display ***
	
	// row and column regs to index numbers_rom
	reg [7:0] row;
	reg [3:0] col;
	
	// output from numbers_rom
	wire color_data;
	
	// infer number bitmap rom
	numbers_rom numbers_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));
	
	// display 4 digits on screen
	always @* 
		begin
		// defaults
		score_on = 0;
		row = 0;
		col = 0;
		
            // if vga pixel within bcd3 location on screen
            if(x >= 50 && x < 58 && y>=4 && y < 12) begin
                col = x - 50; // Start from 50th pixel
                row = y - SCORE_HEIGHT + (bcd3 * SCORE_HEIGHT); // offset row index by scaled bcd3 value
                if(color_data != 16'b0000000000000000) // if bit is 1, assert score_on output
                    score_on = 1;
            end

            // if vga pixel within bcd2 location on screen
            if(x >= 58 && x < 66 && y>=4 && y < 12) begin
                col = x - 58; // Start from 58th pixel
                row = y - SCORE_HEIGHT + (bcd2 * SCORE_HEIGHT); // offset row index by scaled bcd2 value
                if(color_data != 16'b0000000000000000) // if bit is 1, assert score_on output
                    score_on = 1;
            end

            // if vga pixel within bcd1 location on screen
            if(x >= 66 && x < 74 && y>=4 && y < 12) begin
                col = x - 66; // Start from 66th pixel
                row = y - SCORE_HEIGHT + (bcd1 * SCORE_HEIGHT); // offset row index by scaled bcd1 value
                if(color_data != 16'b0000000000000000) // if bit is 1, assert score_on output
                    score_on = 1;
            end

            // if vga pixel within bcd0 location on screen
            if(x >= 74 && x < 82 && y>=4 && y < 12) begin
                col = x - 74; // Start from 74th pixel
                row = y - SCORE_HEIGHT + (bcd0 * SCORE_HEIGHT); // offset row index by scaled bcd0 value
                if(color_data != 16'b0000000000000000) // if bit is 1, assert score_on output
                    score_on = 1;
            end
        end
		
endmodule
