module score_display
	(	
		// Input signals
		input wire clk,           // Clock signal
		input wire reset,         // Reset signal for synchronous ROMs and registers
		input wire score_updated, // Signal asserted when the score is updated
		input wire [13:0] score,  // Current score value
		input wire mini_game_new_score,
        input wire [13:0] mini_game_score,         // output score register value
		input wire [9:0] x,       // VGA x pixel location
		input wire [9:0] y,       // VGA y pixel location
		// Output signal
		output reg show_score // Signal asserted when the x/y coordinates are within the score location on the display
        );	
	
	// Declare wires to route Binary Coded Decimal (BCD) values from the binary to BCD conversion circuit
	wire [3:0] bcd3, bcd2, bcd1, bcd0;
	
	// instantiate binary to bcd conversion circuit
	//binary2bcd bcd_unit (.clk(clk), .reset(reset), .start(score_updated), .in(score), .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
	binary2bcd bcd_unit (.clk(clk), .reset(reset), .start(score_updated + mini_game_new_score), .in(score + mini_game_score), .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
        
	// seven-segment output decoding circuit
	
	// Register to route either units or tenths value to the decoding circuit
	reg [3:0] decode_reg; // Current value to be decoded
	reg [3:0] decode_next; // Next value to be decoded
	
	// Infer the decode value register
	always @(posedge clk, posedge reset)
		if(reset)
			decode_reg <= 0; // Reset the decode register to 0
		else 
			decode_reg <= decode_next; // Update the decode register with the next value to be decoded
	
	// seven-segment multiplexing circuit running at a frequency of 381 Hz
	reg [16:0] m_count_reg; // Register to store the current count value for multiplexing
	
	// Infer the multiplexing counter register and next-state logic
	always @(posedge clk, posedge reset)
		if(reset)
			m_count_reg <= 0; // Reset the multiplexing counter register to 0
		else
			m_count_reg <= m_count_reg + 1; // Increment the multiplexing counter register
	
	// Multiplex two digits using the most significant bit (MSB) of m_count_reg 
	always @*
		if (m_count_reg[16:15] == 0) begin
			decode_next = bcd0; 
		end else if (m_count_reg[16:15] == 1) begin
			decode_next = bcd1; 
		end else if (m_count_reg[16:15] == 2) begin
			decode_next = bcd2;
		end else if (m_count_reg[16:15] == 3) begin
			decode_next = bcd3; 
		end
	
	// *** On-Screen Score Display ***

	// Registers to index the numbers_rom
	reg [7:0] row; // Row index for numbers_rom
	reg [3:0] col; // Column index for numbers_rom

	// Output from numbers_rom
	wire color_data; // Color data for the corresponding pixel

	// Instantiate numbers_rom module to display numbers on screen
	numbers_rom numbers_rom_unit(.clk(clk), .row(row), .col(col), .color_data(color_data));

	// Display 4 digits on the screen
	always @* 
		begin
		// Default values
		show_score = 0; 
		row = 0; 
		col = 0; 

		// Check if the current VGA pixel is within the bcd3 location on the screen
		if(x >= 336 && x < 352 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd3 * 16); // Offset the row index by the scaled bcd3 value
			if(color_data == 12'b000000000000)      // If the color data is all zeros, assert the show_score output
				show_score = 1;
			end
		
		// Check if the current VGA pixel is within the bcd2 location on the screen
		if(x >= 352 && x < 368 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd2 * 16); // Offset the row index by the scaled bcd2 value
			if(color_data == 12'b000000000000)      // If the color data is all zeros, assert the show_score output
				show_score = 1;
			end
		
		// Check if the current VGA pixel is within the bcd1 location on the screen
		if(x >= 368 && x < 384 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd1 * 16); // Offset the row index by the scaled bcd1 value
			if(color_data == 12'b000000000000)      // If the color data is all zeros, assert the show_score output
				show_score = 1;
			end
		
		// Check if the current VGA pixel is within the bcd0 location on the screen
		if(x >= 384 && x < 400 && y >= 16 && y < 32)
			begin
			col = x - 336;
			row = y - 16 + (bcd0 * 16); // Offset the row index by the scaled bcd0 value
			if(color_data == 12'b000000000000)      // If the color data is all zeros, assert the show_score output
				show_score = 1;
			end
		end
		
endmodule
