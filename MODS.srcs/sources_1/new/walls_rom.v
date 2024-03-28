`timescale 1ns / 1ps

//module walls_rom(
//   input wire clk,
//	input wire [2:0] row,
//	input wire [1:0] col,
//	output reg [15:0] color_data
//    );
    
//    (* rom_style = "block" *)

//	//signal declaration
//	reg [2:0] row_reg;
//	reg [1:0] col_reg;

//	always @(posedge clk)
//		begin
//		row_reg <= row;
//		col_reg <= col;
//		end

//	always @*
//	case ({row_reg, col_reg})
//    //.....
//    5'b00000: color_data = 16'b0110001100101101;
//    5'b00001: color_data = 16'b1001110011010100;
//    5'b00010: color_data = 16'b1000110001010001;
//    5'b00011: color_data = 16'b0101001010101010;
//    5'b00100: color_data = 16'b1000110001110010;
//    5'b00101: color_data = 16'b1011010110010110;
//    5'b00110: color_data = 16'b1001110011010011;
//    5'b00111: color_data = 16'b0101001010001010;
//    5'b01000: color_data = 16'b0111001110001110;
//    5'b01001: color_data = 16'b1001110011010011;
//    5'b01010: color_data = 16'b0110101101101101;
//    5'b01011: color_data = 16'b0100001000101000;
//    5'b01100: color_data = 16'b0011000110100111;
//    5'b01101: color_data = 16'b0011100111100111;
//    5'b01110: color_data = 16'b0011000110100110;
//    5'b01111: color_data = 16'b0010000101100101;
//    5'b10000: color_data = 16'b0101101100001101;
//    5'b10001: color_data = 16'b1000110001010010;
//    5'b10010: color_data = 16'b0111101111110000;
//    5'b10011: color_data = 16'b0100101010001010;
//    5'b10100: color_data = 16'b1001010001110010;
//    5'b10101: color_data = 16'b1011010110110111;
//    5'b10110: color_data = 16'b1001110011110100;
//    5'b10111: color_data = 16'b0101001010101010;
//    5'b11000: color_data = 16'b0110101101101101;
//    5'b11001: color_data = 16'b1001010010110011;
//    5'b11010: color_data = 16'b0110101101001101;
//    5'b11011: color_data = 16'b0100001000101000;
//    5'b11100: color_data = 16'b0011100111100111;
//    5'b11101: color_data = 16'b0100101001001001;
//    5'b11110: color_data = 16'b0100001000001000;
//    5'b11111: color_data = 16'b0010100110000110;
//    //.....
//	endcase
//endmodule

module walls_rom(
   input wire clk,
	input wire [1:0] row,
	input wire [1:0] col,
	output reg [15:0] color_data
    );
    
    (* rom_style = "block" *)

	//signal declaration
	reg [1:0] row_reg;
	reg [1:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end

	always @*
	case ({row_reg, col_reg})
        4'b0000: color_data = 16'b0110101101101110;
        4'b0001: color_data = 16'b1001010010110100;
        4'b0010: color_data = 16'b1000110000110001;
        4'b0011: color_data = 16'b0101001011001011;
        4'b0100: color_data = 16'b1000110001010010;
        4'b0101: color_data = 16'b1010010100110101;
        4'b0110: color_data = 16'b1001010010010010;
        4'b0111: color_data = 16'b0101101011001011;
        4'b1000: color_data = 16'b0111001101101110;
        4'b1001: color_data = 16'b1000110001110010;
        4'b1010: color_data = 16'b0110101101001101;
        4'b1011: color_data = 16'b0100101001001001;
        4'b1100: color_data = 16'b0011101000001000;
        4'b1101: color_data = 16'b0100101001101010;
        4'b1110: color_data = 16'b0100001000101000;
        4'b1111: color_data = 16'b0010100110000110;
	endcase
endmodule
