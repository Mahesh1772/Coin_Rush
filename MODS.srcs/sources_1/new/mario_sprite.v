`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 02:20:03
// Design Name: 
// Module Name: mario_sprite
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mario_sprite(
    input btnL,
    input btnU,
    input btnR,
    input wire clk,                    // input clock signal for synchronous ROMs
    input wire [12:0] pixel_index,     // 13-bit wire containing all pixel indices
    output reg [15:0] oled_data,         // output rgb signal for current pixel (565 RGB format)
    output reg mario_on
    );
    
    parameter IDLE = 3'b000;
    parameter WALKING = 3'b001;
    parameter JUMPING = 3'b011;
    
    wire clk_25M;
    
    reg [1:0] current_state = IDLE;
    reg [1:0] next_state = IDLE;
    reg [6:0] char_x = 7'd48; // Start at the middle of the screen (assuming 96-wide screen)
    reg [5:0] char_y = 6'd19; // Character's vertical start position (assuming 64-height screen)
    reg pressU = 0; // press up switch
    reg [31:0] delayL = 32'd0; // left 
    reg [31:0] delayR = 32'd0; // right
    reg [31:0] delayJL = 32'd0; // jump left
    reg [31:0] delayJR = 32'd0; // jump right
    reg [31:0] delayBJU = 32'd0; // block jump up
    reg JR = 0; // jump right switch
    reg JL = 0; // jump left switch
    reg pressR = 0;
    reg pressL = 0;
    reg [31:0] delayJU = 32'd0; // jump up
    reg [31:0] delayCD = 32'd0; // come down
    
    reg [6:0] dy;                           // reg to determine displacement for row signal, changing torso tiles
    
        // Assuming screen width is a power of 2 for simplicity, e.g., 128 pixels
localparam SCREEN_WIDTH = 96;
localparam SCREEN_HEIGHT = 64;

// Calculate x and y from pixel_index
wire [6:0] x = pixel_index % SCREEN_WIDTH; // Adjusted for actual screen width
wire [6:0] y = pixel_index / SCREEN_WIDTH; // Adjusted for actual screen width

// Registers to index ROM
reg [4:0] row;
reg [1:0] col;

// Output vectors from walls and blocks ROMs (16-bit color data)
wire [15:0] mario_color_data;

yoshi_rom yoshi_rom_unit (.clk(clk), .row(row), .col(col), .color_data(mario_color_data));

// Adjusted offset for 4x4 blocks
localparam offset = 4;
    
    
    flexible_clock clk_25m_module (clk, 1, clk_25M);
    
    always @(posedge clk_25M) begin
    
    // Defaults
            mario_on <= 0;
            row <= 0;
            col <= 0;
            oled_data <= 16'h0000;
    
        if( btnU)
         begin
          pressU <= 1;
          end
          
      if(btnR && current_state == JUMPING)
       begin
        pressR <= 1;
       end 
       
      if(btnL && current_state == JUMPING)
       begin
        pressL <= 1;
       end  
        
        
        if (btnL && char_x > 0 && pressU == 0) begin // if nv press up and walk left
           next_state <= WALKING;
            if( delayL < 32'd1250000)
             begin
              delayL <= delayL + 1;
             end
            else begin 
            
              if(char_x + 5 == 75 && char_y == 7) // walk left and fall off platform B
               begin
                 char_y <= 19;
               end 
               
              if(char_x + 5 == 15  && char_y == 19) // walk left and fall off platform C
               begin
                char_y <= 31;
               end
                  
             char_x <= char_x - 1; // move left 1 pixel
             delayL <= 32'd0;
             end
        end
        
        else if (btnR && char_x < 95 && pressU == 0)
        begin 
            next_state <= WALKING;
            if( delayR < 32'd1250000)
                  begin
                      delayR <= delayR + 1;
                  end
                    else begin  
                    
                    
          if(char_x == 20 && char_y == 7) // walk right and fall off top platform A
           begin
               char_y <= 19;
           end               
                    
            if(char_x == 80 && char_y == 19) // walk right and fall off platform C
               begin
                   char_y <= 31;
               end        
                     char_x <= char_x + 1;
                     delayR <= 32'd0;
                     end
        end
       
        
        // Simple jump logic
        else if (pressU > 0 && current_state != JUMPING) begin 
                if(delayJU < 32'd1250000) begin
                    delayJU <= delayJU + 1;   
                end 
                else begin 
                
                    if ( ( char_x + 5 >= 16 && char_x <= 19 && char_y - 15 <= 4 && char_y - 15 >= 0) || ( char_x + 5 >= 76 && char_x <= 79 && char_y - 15 <= 4 && char_y - 15 >= 0))  // bounce logic(AC | BC)
                                   begin
                                          char_y <= 6'd16;
                                         if( delayBJU < 32'd1250000)
                                           begin
                                             delayBJU <= delayBJU + 1;
                                           end
                                         else begin    
                                             char_y <= 6'd31;
                                              next_state <= IDLE;
                                              pressU <= 0;
                                              delayJU <= 32'd0;
                                              delayBJU <= 32'd0;
                                              end
                                                                                                                
                                    end                 

                 else
                 
                  begin
                    char_y <= char_y - 15; 
                    delayJU <= 32'd0;
                    next_state <= JUMPING;
                    pressU <= 0;
                  end  
                end      
        end 
    
        // Apply state transitions and reset jump
        if (current_state == JUMPING ) begin
          if(delayCD < 32'd12500000)
           begin
                    delayCD <= delayCD + 1;
                  if(pressR > 0)
                   begin
                    JR <= 1;
                    end
                  else if (pressL > 0)
                   begin
                    JL <= 1;
                   end                    
          end 
          
        else 
        
                 begin 
                 
        if(JR) 
                begin        
                   char_x <= char_x + 5;
                   JR <= 0; 
                   pressR <= 0;
                   pressU <= 0;
                   
                   if( char_x + 5 >= 75 && char_y == 4) // jump right to platform B
                    begin 
                    char_y <= 7;
                    next_state <= IDLE;
                    delayCD <= 32'd0;
                    end
                    
                    if( char_x + 5 >= 75 && char_y == 16 ) // jump right to platform C from E
                     begin 
                          char_y <= 19;
                          next_state <= IDLE;
                          delayCD <= 32'd0;
                    end

                end 
                   
        else if (JL)
                begin
                    char_x <= char_x - 5;
                    JL <= 0;
                    pressL <= 0;
                    pressU <= 0;
                    
                    if( char_x < 22 && char_y == 4 ) // jump left to platform A from C
                         begin 
                           char_y <= 7;
                           next_state <= IDLE;
                            delayCD <= 32'd0;
                         end
                    
                    if( char_x < 81 && char_y == 16 ) // jump left to platform D from C
                           begin 
                                 char_y <= 19;
                                 next_state <= IDLE;
                                 delayCD <= 32'd0;
                          end

                end 
                 
        else 
                                
                 begin
                    char_y <= char_y + 15; // Drop down
                    next_state <= IDLE;
                    pressU <= 0;
                    delayCD <= 32'd0;
                 end   
                    
               
        end
    
        end
 
        current_state <= next_state;
    end
    
    
    // Drawing Character
    always @(*) begin
//        /*if(x >= char_x && x < char_x + 5 && y >= char_y && y < char_y + 5)
//            oled_data <= 16'hF800; // Red for character
//        else
//            oled_data <= 16'h0000; // Off for background */
//            // Default to background
//                oled_data = 16'h0000; // Off

//    if (x >= 4 && x <= 19 && y >= 12 && y <= 15) begin
//                    oled_data = 16'h07E0; // A
//                end
                
//                if( x >= 76 && x <= 96 && y >= 12 && y <= 15 ) begin
//                  oled_data = 16'h07E0; // B
//                  end
                  
//                if( x >= 16 && x <= 79 && y >= 24 && y <= 27 ) begin
//                                oled_data = 16'h07E0; // C
//                                end
                                
//                 if( x >= 76 && x <= 91 && y >= 36 && y <= 39 ) begin
//                                              oled_data = 16'h07E0; // D
//                                              end
                                              
//                if( x >= 4 && x <= 19 && y >= 36 && y <= 39 ) begin
//                                                            oled_data = 16'h07E0; // E
//                                                            end
                                                            
//                if( x >= 16 && x <= 79 && y >= 48 && y <= 51 ) begin
//                                            oled_data = 16'h07E0; // F
//                                                       end
                                                         
//               if( x >= 0 && x <= 96 && y >= 60 && y <= 64 ) begin
//                    oled_data = 16'h07E0; // F
//                                end
                                                                          
                
//                // Overlay character on top of the platform (or background)
//                if(x >= char_x && x < char_x + 5 && y >= char_y && y < char_y + 5) begin
//                    oled_data = 16'hF800; // Red for character
//                end

       // Platform 'C' at (4, 24)
                   if(y >= char_y && y < char_y + 8 && x >= char_x && x < char_x + 8)
                   begin
                       row <= (y - char_y) + offset;
                       col <= (x - char_x);
                       if(mario_color_data != 16'h0000)
                       begin
                           mario_on <= 1;
                           oled_data <= mario_color_data;
                       end
                   end

    end
    
     
    
    endmodule