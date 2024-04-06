module vga_sync

	(
		input wire clk, reset,
		output wire hsync, vsync, video_on, p_tick,
		output wire [9:0] x, y
	);
	
	// constant declarations for VGA sync parameters
	localparam HORIZONTAL_DISPLAY       = 640; 	// horizontal display area
	localparam HORIZONTAL_LEFT_BORDER   =  48; 	// horizontal left border
	localparam HORIZONTAL_RIGHT_BORDER  =  16; 	// horizontal right border
	localparam HORIZONTAL_RETRACE       =  96; 	// horizontal retrace
	localparam HORIZONTAL_MAX           = HORIZONTAL_DISPLAY + HORIZONTAL_LEFT_BORDER + HORIZONTAL_RIGHT_BORDER + HORIZONTAL_RETRACE - 1;
	localparam START_HORIZONTAL_RETRACE = HORIZONTAL_DISPLAY + HORIZONTAL_RIGHT_BORDER;
	localparam END_HORIZONTAL_RETRACE   = HORIZONTAL_DISPLAY + HORIZONTAL_RIGHT_BORDER + HORIZONTAL_RETRACE - 1;
	
	localparam VERTICAL_DISPLAY       = 480; 	// vertical display area
	localparam VERTICAL_TOP_BORDER    =  10; 	// vertical top border
	localparam VERTICAL_BOTTOM_BORDER =  33; 	// vertical bottom border
	localparam VERTICAL_RETRACE       =   2; 	// vertical retrace
	localparam VERTICAL_MAX           = VERTICAL_DISPLAY + VERTICAL_TOP_BORDER + VERTICAL_BOTTOM_BORDER + VERTICAL_RETRACE - 1;
    localparam START_VERTICAL_RETRACE = VERTICAL_DISPLAY + VERTICAL_BOTTOM_BORDER;
	localparam END_VERTICAL_RETRACE   = VERTICAL_DISPLAY + VERTICAL_BOTTOM_BORDER + VERTICAL_RETRACE - 1;
	
	// mod-2 counter to generate 25 MHz pixel tick
	reg [1:0] pixel_reg;
	wire [1:0] pixel_next;
	wire pixel_tick;
	
	always @(posedge clk, posedge reset)
		if(reset)
		  pixel_reg <= 0;
		else
		  pixel_reg <= pixel_next;
	
	assign pixel_next = pixel_reg + 1; // increment pixel_reg 
	
	assign pixel_tick = (pixel_reg == 0); // assert tick 1/4 of the time
	
	// registers to keep track of current pixel location
	reg [9:0] horizontal_count_reg, horizontal_count_next, vertical_count_reg, vertical_count_next;
	
	// register to keep track of vsync and hsync signal states
	reg vsync_reg, hsync_reg;
	wire vsync_next, hsync_next;
 
	// infer registers
	always @(posedge clk, posedge reset)
		if(reset)
			begin
           		vertical_count_reg <= 0;
            		horizontal_count_reg <= 0;
            		vsync_reg   <= 0;
            		hsync_reg   <= 0;
			end
		else
			begin
            		vertical_count_reg <= vertical_count_next;
            		horizontal_count_reg <= horizontal_count_next;
            		vsync_reg   <= vsync_next;
            		hsync_reg   <= hsync_next;
			end
			
	// next-state logic of horizontal vertical sync counters
	always @*
		begin
		horizontal_count_next = pixel_tick ? 
		               horizontal_count_reg == HORIZONTAL_MAX? 0 : horizontal_count_reg + 1
			       : horizontal_count_reg;
		
		vertical_count_next = pixel_tick && horizontal_count_reg == HORIZONTAL_MAX? 
		               (vertical_count_reg == VERTICAL_MAX ? 0 : vertical_count_reg + 1) 
			       : vertical_count_reg;
		end
		
   // hsync and vsync are active low signals
   // hsync signal asserted during horizontal retrace
   assign hsync_next = horizontal_count_reg >= START_HORIZONTAL_RETRACE && horizontal_count_reg <= END_HORIZONTAL_RETRACE;
   
   // vsync signal asserted during vertical retrace
   assign vsync_next = vertical_count_reg >= START_VERTICAL_RETRACE && vertical_count_reg <= END_VERTICAL_RETRACE;

   // video only on when pixels are in both horizontal and vertical display region
   assign video_on = (horizontal_count_reg < HORIZONTAL_DISPLAY) && (vertical_count_reg < VERTICAL_DISPLAY);

   // output signals
   assign hsync  = hsync_reg;
   assign vsync  = vsync_reg;
   assign x      = horizontal_count_reg;
   assign y      = vertical_count_reg;
   assign p_tick = pixel_tick;
endmodule
