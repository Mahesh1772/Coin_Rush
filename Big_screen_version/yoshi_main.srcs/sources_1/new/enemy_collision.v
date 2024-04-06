module enemy_collision
	(
		input direction,                   					// current direction of mario
		input wire [9:0] mario_x, mario_y, 					// mario x/y
		input wire [9:0] ghost_crazy_x, ghost_crazy_y,      // ghost_crazy x/y
		input wire [9:0] ghost_top_x, ghost_top_y,     		// ghost_top x/y
		input wire [9:0] ghost_bottom_x, ghost_bottom_y,    // ghost_bottom x/y
		output wire collision              					// output signal asserted when ghost and mario collide
    );
	
	// symbolic states for left and right motion
    localparam LEFT = 0;
    localparam RIGHT = 1;
	
	// register for collision state
	reg collide;
	
	always @*
		begin
		
		collide = 0;
		
		// if mario facing left
		if(direction == LEFT)
			begin
			// if mario and ghost_crazy are within each other, assert collide
			if((ghost_crazy_x + 13 > mario_x && ghost_crazy_x < mario_x + 13 && ghost_crazy_y + 13 > mario_y && ghost_crazy_y < mario_y + 13) ||
			   (ghost_crazy_x + 13 > mario_x + 9 && ghost_crazy_x < mario_x + 16 && ghost_crazy_y + 13 > mario_y + 13 && ghost_crazy_y < mario_y + 18))
			  collide = 1;
			  
			// if mario and ghost_top are within each other, assert collide  
			else if((ghost_top_x + 13 > mario_x && ghost_top_x < mario_x + 13 && ghost_top_y + 13 > mario_y && ghost_top_y < mario_y + 13) ||
			        (ghost_top_x + 13 > mario_x + 9 && ghost_top_x < mario_x + 16 && ghost_top_y + 13 > mario_y + 13 && ghost_top_y < mario_y + 18))
			  collide = 1;
			  
			// if mario and ghost_bottom are within each other, assert collide  
			else if((ghost_bottom_x + 13 > mario_x && ghost_bottom_x < mario_x + 13 && ghost_bottom_y + 13 > mario_y && ghost_bottom_y < mario_y + 13) ||
			        (ghost_bottom_x + 13 > mario_x + 9 && ghost_bottom_x < mario_x + 16 && ghost_bottom_y + 13 > mario_y + 13 && ghost_bottom_y < mario_y + 18))
			  collide = 1;
			end
		
		// if mario facing right	
		if(direction == RIGHT)
			begin
			// if mario and ghost_crazy are within each other, assert collide
			if((ghost_crazy_x + 13 > mario_x + 9 && ghost_crazy_x < mario_x + 16 && ghost_crazy_y + 13 > mario_y && ghost_crazy_y < mario_y + 13) ||
			   (ghost_crazy_x + 13 > mario_x && ghost_crazy_x < mario_x + 13 && ghost_crazy_y + 13 > mario_y + 13 && ghost_crazy_y < mario_y + 18))
			  collide = 1;
			
			// if mario and ghost_top are within each other, assert collide
			else if((ghost_top_x + 13 > mario_x + 9 && ghost_top_x < mario_x + 16 && ghost_top_y + 13 > mario_y && ghost_top_y < mario_y + 13) ||
			        (ghost_top_x + 13 > mario_x && ghost_top_x < mario_x + 13 && ghost_top_y + 13 > mario_y + 13 && ghost_top_y < mario_y + 18))
			  collide = 1;
			
			// if mario and ghost_bottom are within each other, assert collide
			else if((ghost_bottom_x + 13 > mario_x + 9 && ghost_bottom_x < mario_x + 16 && ghost_bottom_y + 13 > mario_y && ghost_bottom_y < mario_y + 13) ||
			        (ghost_bottom_x + 13 > mario_x && ghost_bottom_x < mario_x + 13 && ghost_bottom_y + 13 > mario_y + 13 && ghost_bottom_y < mario_y + 18))
			  collide = 1;
			end
		end
	
	// assert output signal
	assign collision = collide;
			
endmodule