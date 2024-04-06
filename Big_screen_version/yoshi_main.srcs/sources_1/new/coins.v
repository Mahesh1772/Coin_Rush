module coins
    (
        input wire clk, reset,             // clock / reset signals for synchronous registers
        input wire [9:0] mario_x, mario_y, // location of mario
        input direction,                   // direction of mario
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        input [13:12] mini_game_led,       // Blinking Leds of mini-game
        output coins_on,                   // on signal: vga pixel within sprite location
        output wire [11:0] rgb_out,        // output rgb signal for current pixel
        output wire [13:0] score,          // output score register value
	    output wire new_score              // output signal that is asserted when a new score is calculated
    );
   
    // symbolic states for left and right motion of mario
    localparam LEFT = 0;
    localparam RIGHT = 1;
   
    // register to oscillate through platforms to spawn coin onto (see platform diagram)
    reg [2:0] platform_select_reg;
    wire [2:0] platform_select_next;
	
    // infer platform select register
    always @(posedge clk, posedge reset)
        if(reset)
            platform_select_reg <= 5;
        else
            platform_select_reg <= platform_select_next;
	
	assign  platform_select_next = platform_select_reg + 1;
   
    // location of coin and type registers
    reg [9:0] coin_x_reg, coin_x_next, coin_y_reg, coin_y_next;
    reg [5:0] coin_type_reg, coin_type_next;
   
	// infer coin location and type registers
    always @(posedge clk, posedge reset)
        if(reset)
            begin
            coin_x_reg    <= 296;
            coin_y_reg    <= 364;
            coin_type_reg <= 0;
            end
        else
            begin
            coin_x_reg    <= coin_x_next;
            coin_y_reg    <= coin_y_next;
            coin_type_reg <= coin_type_next;
            end
           
    // platform location registers:
    // when a new coin spawns, the platform_select_reg determines which platform, while the corresponding
    // platform location registers determine where on the platform the new coin will spawn.
    reg[7:0] A_reg; // [ 16, 144]
    reg[9:0] B_reg; // [480, 608]
    reg[9:0] C_reg; // [ 80, 545]
    reg[8:0] D_reg; // [ 16, 240]
    reg[9:0] E_reg; // [384, 608]
    reg[9:0] F_reg; // [112, 513]
    reg[9:0] G_reg; // [ 16, 608]
   
    // infer registers and next-state logic
    always @(posedge clk, posedge reset)
        if(reset)
            begin
            A_reg <=  16;
            B_reg <= 480;
            C_reg <=  80;
            D_reg <=  16;
            E_reg <= 384;
            F_reg <= 296;
            G_reg <=  16;
            end
        else
            begin
            A_reg <= (A_reg <= 144)? A_reg + 1 :  16;
            B_reg <= (B_reg <= 608)? B_reg + 1 : 480;
            C_reg <= (C_reg <= 545)? C_reg + 1 :  80;
            D_reg <= (D_reg <= 240)? D_reg + 1 :  16;
            E_reg <= (E_reg <= 608)? E_reg + 1 : 384;
            F_reg <= (F_reg <= 513)? F_reg + 1 : 112;
            G_reg <= (G_reg <= 608)? G_reg + 1 :  16;
            end
 
    // coin FSM state register
    reg [1:0] state_reg, state_next;
    
	// infer coin state register
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg <= waiting;
        else
            state_reg <= state_next;
			
    // new_score register, signals when a new score is calculated
    reg new_score_reg, new_score_next; 
	
    // infer new_score register
    always @(posedge clk, posedge reset)
    if(reset)
	    new_score_reg <= 0;
    else
            new_score_reg <= new_score_next;
	
    // assign new_score output
    assign new_score = new_score_reg;
   
    // symbolic state representations for coin FSM
    localparam  waiting    = 1'b0, // waiting for mario to get coin
                respawn    = 1'b1; // mario acquired coin, respawn new coin
    
    // coin FSM next-state logic
    always @*
        begin

        state_next = state_reg;
        coin_x_next = coin_x_reg;
        coin_y_next = coin_y_reg;
        coin_type_next = coin_type_reg;
	    new_score_next = 0;
       
        case(state_reg)
           
            waiting: // coin already spawned, waiting to get it
                begin
		// if collides with coin facing LEFT
                if(direction == LEFT && (coin_x_reg + 13 > mario_x && coin_x_reg < mario_x + 13 && coin_y_reg + 13 > mario_y && coin_y_reg < mario_y + 13) ||
                  (coin_x_reg + 13 > mario_x + 9 && coin_x_reg < mario_x + 16 && coin_y_reg + 13 > mario_y + 13 && coin_y_reg < mario_y + 18))
                    begin
		    new_score_next = 1;   // signal new score ready
		    state_next = respawn; // go to respawn state
		    end
                
		// else if collides with coin facing RIGHT
                else if(direction == RIGHT && (coin_x_reg + 13 > mario_x + 9 && coin_x_reg < mario_x + 16 && coin_y_reg + 13 > mario_y && coin_y_reg < mario_y + 13) ||
                       (coin_x_reg + 13 > mario_x && coin_x_reg < mario_x + 13 && coin_y_reg + 13 > mario_y + 13 && coin_y_reg < mario_y + 18))
                    begin
		    new_score_next = 1;   // signal new score ready
		    state_next = respawn; // go to respawn state
		    end
                end

            respawn: // respawn new coin at current platform_select_reg platform,
         	         // and at this platform's location register value
                begin
                if(platform_select_reg == 0) // 'A'
                    begin
                    coin_y_next    = 116;
                    coin_x_next    = A_reg;
                    coin_type_next = A_reg[5:0];
                    end
                else if(platform_select_reg == 1) // 'B'
                    begin
                    coin_y_next    = 116;
                    coin_x_next    = B_reg;
                    coin_type_next = B_reg[5:0];
                    end
                else if(platform_select_reg == 2) // 'C'
                    begin
                    coin_y_next    = 199;
                    coin_x_next    = C_reg;
                    coin_type_next = C_reg[5:0];
                    end
                else if(platform_select_reg == 3) // 'D'
                    begin
                    coin_y_next    = 282;
                    coin_x_next    = D_reg;
                    coin_type_next = D_reg[5:0];
                    end
                else if(platform_select_reg == 4) // 'E'
                    begin
                    coin_y_next    = 282;
                    coin_x_next    = E_reg;
                    coin_type_next = E_reg[5:0];
                    end
                else if(platform_select_reg == 5) // 'F'
                    begin
                    coin_y_next    = 365;
                    coin_x_next    = F_reg;
                    coin_type_next = F_reg[5:0];
                    end
                else // 6, 7 :'G'
                    begin
                    coin_y_next    = 448;
                    coin_x_next    = G_reg;
                    coin_type_next = G_reg[5:0];
                    end
               
                state_next = waiting; // go back to waiting state
                end
        endcase
        end
   
    // assign coin_type_offset depending on cycling coin_type_reg value
    wire [6:0] coin_type_offset;
    assign coin_type_offset = (coin_type_reg <= 29) ? 0 :
                             (coin_type_reg > 29  && coin_type_reg <= 44) ? 16 :
                             (coin_type_reg > 44  && coin_type_reg <= 54) ? 32 :
                             (coin_type_reg > 54  && coin_type_reg <= 62) ? 48 : 64;
    
    // score reg and next-state logic
    reg [13:0] score_reg;
    wire [13:0] score_next;
	
    // infer score register
    always @(posedge clk, posedge reset)
    if(reset)
	    score_reg <= 0;
    else
            score_reg <= score_next;
	
    // score updates on new_score_reg tick depending on coin_type_offset (coin color)
    assign score_next = (reset || new_score_next && score_reg == 9999) ? 0 : 
			new_score_next && coin_type_offset ==  0 ? score_reg +   20: // blue      coin: p = 30/64, score =  10
			new_score_next && coin_type_offset == 16 ? score_reg +   40: // red       coin: p = 15/64, score =  20
			new_score_next && coin_type_offset == 32 ? score_reg +   60: // bronze    coin: p = 10/64, score =  50
			new_score_next && coin_type_offset == 48 ? score_reg +  200: // silver    coin: p = 08/64, score =  100
			new_score_next && coin_type_offset == 64 ? score_reg +  500: // gold      coin: p = 01/64, score =  500
			score_reg;
	
	// mini-game
	reg [13:0] mini_game_score_reg;
    always @ (posedge clk) begin
       if (reset)
           mini_game_score_reg <= 0;
       else if (mini_game_led[13:12] == 2'b11)
           mini_game_score_reg <= mini_game_score_reg + 5; 
    end 
    //
    
    // assign score to output
    assign score = score_reg + mini_game_score_reg;
    //assign score = score_reg;
   
    // sprite coordinate addreses, from upper left corner
    // used to index ROM data
    wire [3:0] col;
    wire [6:0] row;
   
    // current pixel coordinate minus current sprite coordinate gives ROM index
    assign col = x - coin_x_reg;
    // row index value depends on offset for which tile to display
    assign row = y + coin_type_offset - coin_y_reg;
   
    coins_rom coins_rom_unit(.clk(clk), .row(row), .col(col), .color_data(rgb_out));
   
    // signal asserted when x/y vga pixel values are within sprite in current location
    assign coins_on = (x >= coin_x_reg && x < coin_x_reg + 16 && y >= coin_y_reg && y < coin_y_reg + 16)
                     && (rgb_out != 12'hFFF) ? 1 : 0;                    
endmodule
