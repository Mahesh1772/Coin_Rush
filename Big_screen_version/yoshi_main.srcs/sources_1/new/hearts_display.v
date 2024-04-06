module hearts_display
	(	
	    input wire clk,                    // clock signal for synchronous roms
	    input wire [9:0] x, y,             // vga x/y signals
	    input wire [1:0] hearts_number,    // input signal of number of hearts to display
	    output wire [11:0] hearts_rgb_out, // output signals for rgb hearts_rgb_out
	    output reg show_hearts             // output signal asserted when x/y is located within the hearts locations
        );	
	
	// row and column regs to index hearts_rom
	reg [4:0] row;
	reg [3:0] col;
	
	// infer hearts rom 
	hearts_rom hearts_rom_unit(.clk(clk), .row(row), .col(col), .color_data(hearts_rgb_out));
	
	// Set the row and column indexes for the hearts_rom based on the x/y coordinates.
	// Assert the show_hearts signal when the hearts_rgb_out from the rom is not equal to the sprite background color.
	always @* 
		begin
		//Set row and column indexes to 0, and don't show hearts by default
		row = 0;
		col = 0;
		show_hearts = 0;
		
		// Check if the VGA pixel is within the boundaries of heart 1 (left)
		if(x >= 240 && x < 256 && y >= 16 && y < 32)
			begin
			col = x - 240;                     // set col index
			if(hearts_number > 0)                 // if hearts_number > 0 (1,2,3) left heart is on
				row = y - 16;                  // set full heart
			else 
				row = y;                       // else set empty heart
			if(hearts_rgb_out != 12'b011011011110) // if hearts_rgb_out != sprite background color
				show_hearts = 1;                 // assert show_hearts signal
			end
		
		// Check if the VGA pixel is within the boundaries of heart 2 (middle)
		if(x >= 256 && x < 272 && y >= 16 && y < 32)
			begin
			col = x - 256;                     // set col index
			if(hearts_number > 1)                 // if hearts_number > 1 (2,3) middle heart is on
				row = y - 16;                  // set full heart
			else 
				row = y;                       // else set empty heart
			if(hearts_rgb_out != 12'b011011011110) // if hearts_rgb_out != sprite background color
				show_hearts = 1;                 // assert show_hearts signal
			end
		
		
		// Check if the VGA pixel is within the boundaries of heart 3 (right)
		if(x >= 272 && x < 288 && y >= 16 && y < 32)
			begin
			col = x - 272;                     // set column index for the right heart
			if(hearts_number > 2)                 // if hearts_number is greater than 2 (3), the right heart is full
				row = y - 16;                  // set row index for the full heart
			else 
				row = y;                       // else set row index for the empty heart
			if(hearts_rgb_out != 12'b011011011110) // if hearts_rgb_out is not equal to the sprite background color
				show_hearts = 1;                 // assert the show_hearts signal
			end
		end
endmodule
