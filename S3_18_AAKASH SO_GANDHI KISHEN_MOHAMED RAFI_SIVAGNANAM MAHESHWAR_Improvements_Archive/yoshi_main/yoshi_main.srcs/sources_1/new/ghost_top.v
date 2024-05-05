module ghost_top
    (
        input wire clk, reset,
        input wire [9:0] mario_x, mario_y,          // current pizel location of mario
	    input wire [9:0] x, y,                      // current pixel coordinates from vga_sync circuit
	    input wire [25:0] speed_offset,             // score dependent value that increases ghost's speed
	    output wire [9:0] ghost_top_x, ghost_top_y, // output vector for ghost_top's x/y position
        output ghost_top_on,                        // on signal: vga pixel within sprite location
	    output wire [11:0] rgb_out                  // output rgb signal for current pixel
    );
   
    // constant declarations
    // max pixel coordinates for VGA display area
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
   
    // tile width
    localparam T_W = 16;
   
    /////////////////////////////////////////////////////////////////////////////////////
    /*                           sprite location registers                             */  
    /////////////////////////////////////////////////////////////////////////////////////
    // mario sprite location regs, pixel location for top left corner
    reg [9:0] sprite_x_reg, sprite_y_reg;
    reg [9:0] sprite_x_next, sprite_y_next;
   
    // infer registers for sprite location
    always @(posedge clk)
	begin
        sprite_x_reg     <= sprite_x_next;
        sprite_y_reg     <= sprite_y_next;
	end

    /////////////////////////////////////////////////////////////////////////////////////
    /*                                direction register                               */  
    /////////////////////////////////////////////////////////////////////////////////////
    // determines if sprite tiles are displayed normally or mirrored in x
   
    // symbolic states for left and right motion
    localparam LEFT = 0;
    localparam RIGHT = 1;
   
    reg dir_reg, dir_next;
    
    // infer direction register
    always @(posedge clk, posedge reset)
        if (reset)
            dir_reg     <= RIGHT;
        else
            dir_reg     <= dir_next;
    
    // sprite should face direction towards mario
    always @*
        begin
        dir_next = dir_reg;

	if(mario_x < sprite_x_reg)
		dir_next = LEFT;
			
	if(mario_x > sprite_x_reg)  
		dir_next = RIGHT;
        end

    /////////////////////////////////////////////////////////////////////////////////////
    /*                                sprite motion                                    */  
    /////////////////////////////////////////////////////////////////////////////////////
    
    localparam TIME_MAX    =   4600000; 

    reg [25:0] time_reg;   // register to keep track of count time between position updates
    wire [25:0] time_next; 
    reg tick_reg;

    // infer time register
    always @(posedge clk, posedge reset)
	if(reset)
		time_reg <= 0;
	else
		time_reg <= time_next;
	
    // next-state logic, increment until maximum, then reset to 0
    assign time_next = (time_reg < TIME_MAX - speed_offset) ? time_reg + 1 : 0;
			
    // tick signal is asserted when time reg reaches max
    wire tick;
    assign tick = (time_reg == TIME_MAX - speed_offset) ? 1 : 0;
   
    // on positive edge of tick signal, or reset, update ghost location
    always @(posedge tick, posedge reset)
		begin
		//defaults
		sprite_x_next = sprite_x_reg;
		sprite_x_next = sprite_x_reg;
		
		if(reset)
			sprite_x_next = 608;                 // reset to starting x position
			else if(mario_y <= 231)             // if mario is in top portion of screen, ghost_B can chase
			begin
			if(sprite_x_reg > mario_x)       	// if ghost x pos > mario
				sprite_x_next = sprite_x_reg - 1; // move negative x
			else if(sprite_x_reg < mario_x)  	// else if ghost x pos < mario
				sprite_x_next = sprite_x_reg + 1; // move positive x
			end
		else 
			sprite_x_next = sprite_x_reg;         	// else remain the same
			
		if(reset)
			sprite_y_next = 17;            	// reset to starting y position
		else if(mario_y <= 231)        		// if mario is in top portion of screen, ghost_B can chase
			begin
			if(sprite_y_reg > mario_y)       	// if ghost y pos > mario
				sprite_y_next = sprite_y_reg - 1; // move negative y
			else if(sprite_y_reg < mario_y) 		// else if ghost y pos < mario
				sprite_y_next = sprite_y_reg + 1; // move positive y
			end
		else 
			sprite_y_next = sprite_y_reg;         	// else remain the same
		end      
    
    /////////////////////////////////////////////////////////////////////////////////////
    /*                                     ROM indexing                                */  
    /////////////////////////////////////////////////////////////////////////////////////  
    
    // register, next-state logic to oscillate face tile
    reg [25:0] face_tile_reg;
    wire [25:0] face_tile_next;
	
    // rom index offset reg
    wire [5:0] face_type;
	
    // infer face_t register
    always @(posedge clk, posedge reset)
	if(reset)
		face_tile_reg <= 0;
	else 
		face_tile_reg <= face_tile_next;
	
    // increment face_t until max value
    assign face_tile_next = (face_tile_reg < 40000000)? face_tile_reg + 1 : 0;
	
    // assign rom index offset, half time between face tiles
    assign face_type = (face_tile_reg < 20000000 || mario_y > 231)? 0 : 16;
	
    // sprite coordinate addreses, from upper left corner
    // used to index ROM data
    wire [3:0] col;
    wire [4:0] row;
   
    // current pixel coordinate minus current sprite coordinate gives ROM index
    // col index value depends on direction
    assign col = dir_reg == RIGHT ? x - sprite_x_reg : (T_W - 1 - (x - sprite_x_reg)); 
    // row index value depends on offset for which tile to display
    assign row = y + face_type - sprite_y_reg;
   
    // vector for ROM color_data output
    wire [11:0] color_data;
	
    // infer sprite rom
    ghost_normal_rom ghost_normal_unit (.clk, .row(row), .col(col), .color_data(color_data));
   
    // signal asserted when x/y vga pixel values are within sprite in current location
    wire ghost_on;
    assign ghost_on = (x >= sprite_x_reg && x < sprite_x_reg + 16
                       && y >= sprite_y_reg && y < sprite_y_reg + 16)? 1 : 0;
					
    // assert output on signal when vga x/y pixels are within sprite
    // and location rgb value isn't sprite background color
    assign ghost_top_on = ghost_on && rgb_out != 12'hFFF ? 1 : 0;
	
    // route color_data out
    assign rgb_out = color_data;
	
    // route x/y location out
    assign ghost_top_x = sprite_x_reg;
    assign ghost_top_y = sprite_y_reg;
	
endmodule
