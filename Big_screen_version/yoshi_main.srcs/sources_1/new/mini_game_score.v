`timescale 1ns / 1ps

module mini_game_score(
        input wire clk, reset,             // clock / reset signals for synchronous registers
        input wire [9:0] x, y,             // current pixel coordinates from vga_sync circuit
        input [13:12] mini_game_led,       // Blinking Leds of mini-game
        output wire [13:0] mini_game_score,         // output score register value
	    output wire mini_game_new_score              // output signal that is asserted when a new score is calculated
    );
   

    // coin FSM state register
    reg [1:0] state_reg, state_next;
    
	// infer coin state register
    always @(posedge clk, posedge reset)
        if(reset)
            state_reg <= waiting;
        else
            state_reg <= state_next;
			
    // new_score register, signals when a new score is calculated
    reg new_mini_game_score_reg, new_score_next; 
	
    // infer new_score register
    always @(posedge clk, posedge reset)
    if(reset)
	    new_mini_game_score_reg <= 0;
    else
            new_mini_game_score_reg <= new_score_next;
	
    // assign new_score output
    assign mini_game_new_score = new_mini_game_score_reg;
   
    // symbolic state representations for coin FSM
    localparam  waiting    = 1'b0, // waiting for mario to get coin
                respawn    = 1'b1; // mario acquired coin, respawn new coin
        
    
    // score reg and next-state logic
    reg [13:0] mini_game_score_reg;
    wire [13:0] score_next;
	
    // infer score register
    always @(posedge clk, posedge reset)
    if(reset)
	    mini_game_score_reg <= 0;
    else
            mini_game_score_reg <= score_next;
	
    assign score_next = (reset || new_score_next && mini_game_score_reg == 9999) ? 0 :
                        mini_game_led == 2'b11 ? mini_game_score_reg + 5:
                        mini_game_score_reg;
    //
    
    // assign score to output
    assign mini_game_score =  mini_game_score_reg;
                 
endmodule
