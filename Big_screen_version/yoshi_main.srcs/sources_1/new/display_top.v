module display_top
	(
		input wire clk,
		input wire hard_reset,  // clock signal, reset signal from switch
		input wire data,             // input data from nes controller to FPGA
		input wire btnU,
		input wire btnR,
		input wire btnL,
		input wire btnC,
		output wire hsync, vsync,    // outputs VGA signals to VGA port
		output wire [11:0] rgb,      // output rgb signals to VGA DAC
		input [9:0] sw,
		output wire [13:12] led,
        input sw14,
        output [3:0] an,
        output [6:0] seg
	);
	

    wire up = btnU, left = btnL, right = btnR, start = btnC;      // route nes controller outputs to sprite circuit
	localparam idle = 3'b001;                                     // symbolic state constant representing game state idle
	localparam gameover = 3'b100;                                 // symbolic state constant representing game state gameover
	wire [1:0] num_hearts;                                        // route signal conveying number of hearts mario has, and to display
	wire [2:0] game_state;                                        // route current game state from game_state_machine
	wire game_en;                                                 // route signal conveying is game is enabled (playing mode)
	wire game_reset;                                              // route signal to trigger reset in other modules from inside game_state_machine
    wire reset;                                                   // reset signal
	assign reset = hard_reset || game_reset;                      // assert reset when either hard_reset or game_reset are asserted
	wire [9:0] x, y;                                              // location of VGA pixel
	wire video_on, pixel_tick;                                    // route VGA signals
	reg [11:0] rgb_reg, rgb_next;                                 // RGB data register to route out to VGA DAC
	wire [9:0] mario_x, mario_y;                                  // vector to route mario's x/y location
	wire [9:0] ghost_crazy_x, ghost_crazy_y;                      // vector to route ghost_crazy's x/y location
	wire [9:0] ghost_top_x, ghost_top_y;                          // vector to route ghost_top's x/y location
	wire [9:0] ghost_bottom_x, ghost_bottom_y;                    // vector to route ghost_bottom's x/y location
	wire grounded, jumping_up, direction;                         // signals to route status signals for mario
	wire collision;                                               // signal asserted from enemy_collision
	wire [13:0] score;                                            // route score value from eggs to score_display
	wire new_score;                                               // signal asserted for new score, used to start binary to bcd conversion
	wire [13:0] mini_game_score;                                            
    wire mini_game_new_score;
	wire [11:0] mario_rgb, platforms_rgb, ghost_crazy_rgb,        // RGB regs for various sprite units, to route RGB data to VGA circuit
				ghost_bottom_rgb, ghost_top_rgb, bg_rgb,
				coins_rgb, hearts_rgb, game_logo_rgb,
				gameover_rgb;
	wire mario_on, platforms_on, ghost_crazy_on, ghost_bottom_on, // on signals for various sprite units
	    ghost_top_on, coins_on, score_on, hearts_on, game_logo_on,
	    gameover_on;
		 
	wire [25:0] speed_offset; // amount of speed increase is calculated from current game score and routed to ghosts
	assign speed_offset = (({14'b0, score[13:2]} << 12) < 2750000) ? ({14'b0, score[13:2]} << 12) : 2750000;
	
	wire mario_up, mario_left, mario_right;
	assign mario_up = up & game_en;
	assign mario_left = left & game_en;
	assign mario_right = right & game_en;
	
	// game_over signal routed to mario to signal when to display mario ghost
	wire game_over_mario;
	assign game_over_mario = (game_state == gameover) ? 1 : 0;
	
	// mini-game
    wire [3:0] an_wire;
    wire [6:0] seg_wire;
    wire [13:12] mini_game_led_wire;
    
    wire mini_game_reset;
    reg mini_game_start = 0;
    
    wire btnC_debounced;
    debounce debounce_btnC_mini_game (clk, btnC, btnC_debounced);
    
    always @ (posedge clk) begin
        if (btnC_debounced) begin
            mini_game_start = ~mini_game_start;
        end
    end    
    
    assign mini_game_reset = hard_reset | mini_game_start; 
    
    // instantiate mini-game
    mini_game play_mini_game (.clk(clk), .sw(sw), .sw14(sw14), .an(an_wire), .seg(seg_wire), .led(mini_game_led_wire));
    
    mini_game_score mini_game_score_unit (.clk(clk), .reset(reset), .x(x), .y(y), .mini_game_led(mini_game_led_wire), .mini_game_score(mini_game_score), .mini_game_new_score(mini_game_new_score));
	
	// instantiate vga_sync circuit
	vga_sync vsync_unit (.clk(clk), .reset(hard_reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(pixel_tick), .x(x), .y(y));
	
	// instantiate mario sprite circuit
	mario_sprite mario_unit (.clk(clk), .reset(reset), .btnU(mario_up), .btnL(mario_left), .btnR(mario_right), .video_on(video_on), .x(x), .y(y), .grounded(grounded), .game_over_mario(game_over_mario), .collision(collision), .rgb_out(mario_rgb),.mario_on(mario_on), .mario_x(mario_x), .mario_y(mario_y), .jumping_up(jumping_up), .direction(direction));
	
	// instantiate crazy ghost circuit						 
	ghost_crazy ghost_crazy_unit (.clk(clk), .reset(reset), .mario_x(mario_x), .mario_y(mario_y), .x(x), .y(y), .speed_offset(speed_offset), .ghost_crazy_x(ghost_crazy_x), .ghost_crazy_y(ghost_crazy_y), .ghost_crazy_on(ghost_crazy_on), .rgb_out(ghost_crazy_rgb));
	
	// instantiate top ghost circuit
	ghost_top ghost_top_unit (.clk(clk), .reset(reset), .mario_x(mario_x), .mario_y(mario_y), .x(x), .y(y), .speed_offset(speed_offset), .ghost_top_x(ghost_top_x), .ghost_top_y(ghost_top_y), .ghost_top_on(ghost_top_on), .rgb_out(ghost_top_rgb));
	
	// instantiate bottom ghost circuit
	ghost_bottom ghost_bottom_unit (.clk(clk), .reset(reset), .mario_x(mario_x), .mario_y(mario_y), .x(x), .y(y), .speed_offset(speed_offset), .ghost_bottom_x(ghost_bottom_x), .ghost_bottom_y(ghost_bottom_y), .ghost_bottom_on(ghost_bottom_on), .rgb_out(ghost_bottom_rgb));
    
	// instantiate platform sprites circuit
    platforms platforms_unit (.clk(clk), .video_on(video_on), .x(x), .y(y), .rgb_out(platforms_rgb), .platforms_on(platforms_on));
	
	// instantate circuit that determines if mario sprite is on the ground or a platform
	grounded grounded_unit (.clk(clk), .reset(reset), .mario_x(mario_x), .mario_y(mario_y), .jumping_up(jumping_up), .direction(direction), .grounded(grounded));
	
	// instantiate background rom circuit
	background_ghost_rom background_unit (.clk(clk), .row(y[7:0]), .col(x[7:0]), .color_data(bg_rgb));
	
	// instantiate enemy collision detection circuit
	enemy_collision enemy_collision_unit (.direction(direction), .mario_x(mario_x), .mario_y(mario_y), .ghost_crazy_x(ghost_crazy_x), .ghost_crazy_y(ghost_crazy_y), .ghost_top_x(ghost_top_x), .ghost_top_y(ghost_top_y), .ghost_bottom_x(ghost_bottom_x), .ghost_bottom_y(ghost_bottom_y), .collision(collision)); 
	
	// instantiate coins circuit
    coins coins_unit(.clk(clk), .reset(reset), .mario_x(mario_x), .mario_y(mario_y), .direction(direction), .x(x), .y(y), .mini_game_led(mini_game_led_wire),.coins_on(coins_on), .rgb_out(coins_rgb), .score(score), .new_score(new_score));

    // instantiate score display circuit
	score_display score_display_unit (.clk(clk), .reset(reset), .score_updated(new_score), .score(score), .x(x), .y(y), .show_score(score_on), .mini_game_score(mini_game_score), .mini_game_new_score(mini_game_new_score));	   
	
	// instantiate hearts display circuit
	hearts_display hearts_display_unit (.clk(clk), .x(x), .y(y), .hearts_number(num_hearts), .hearts_rgb_out(hearts_rgb), .show_hearts(hearts_on));
	
	// instantate game FSM circuit
	game_state_machine game_FSM (.clk(clk), .hard_reset(hard_reset), .start(start), .collision(collision), .num_hearts(num_hearts), .game_state(game_state), .game_en(game_en), .game_reset(game_reset));
	
	// instantiate start screen logo display circuit
	game_logo_display game_logo_display_unit (.clk(clk), .x(x), .y(y), .rgb_out(game_logo_rgb), .game_logo_on(game_logo_on));
	
	// instantiate gameover display circuit
	gameover_display gameover_display_unit (.clk(clk), .x(x), .y(y), .rgb_out(gameover_rgb), .gameover_on(gameover_on));

	// routes correct RGB data depending on video_on, < >_on signals, and game_state signal
    	always @*
		begin
        	if (~video_on)
				rgb_next = 12'b0; // black

        	else if(score_on)
				rgb_next = 12'hF00;
				
			else if(hearts_on)
				rgb_next = hearts_rgb;

			else if(game_logo_on && game_state == idle)
				rgb_next = game_logo_rgb;

			else if(gameover_on && game_state == gameover)
				rgb_next = gameover_rgb;

        	else if(ghost_crazy_on && game_state != idle)	
				rgb_next = ghost_crazy_rgb;

			else if(ghost_bottom_on && game_state != idle)
				rgb_next = ghost_bottom_rgb;

			else if(ghost_top_on && game_state != idle)
				rgb_next = ghost_top_rgb;

			else if (mario_on && game_state != idle)
				rgb_next = mario_rgb;       

			else if (coins_on && game_en)
				rgb_next = coins_rgb;

			else if(platforms_on)
                	rgb_next = platforms_rgb;
				
            else
            	rgb_next = bg_rgb;			
		end
	
	// rgb buffer register
	always @(posedge clk)
		if (pixel_tick)
			rgb_reg <= rgb_next;		
			
	// output rgb data to VGA DAC
	assign rgb = rgb_reg;
	
	// outputs of mini-game
    assign an = an_wire;
    assign seg = seg_wire;
    assign led = mini_game_led_wire;

endmodule
