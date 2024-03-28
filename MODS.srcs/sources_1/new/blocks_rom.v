`timescale 1ns / 1ps


//module blocks_rom(
//    input wire clk,
//	input wire [4:0] row,
//	input wire [1:0] col,
//	output reg [15:0] color_data
//    );
    
//    (* rom_style = "block" *)

//	//signal declaration
//	reg [4:0] row_reg;
//	reg [1:0] col_reg;

//	always @(posedge clk)
//		begin
//		row_reg <= row;
//		col_reg <= col;
//		end

//	always @*
//	case ({row_reg, col_reg})
//        //.....
//    7'b0000000: color_data = 16'b1000110001001111;
//    7'b0000001: color_data = 16'b1100010100101011;
//    7'b0000010: color_data = 16'b1011110011101000;
//    7'b0000011: color_data = 16'b0111101100000101;
//    7'b0000100: color_data = 16'b1011110100001100;
//    7'b0000101: color_data = 16'b1101010111001100;
//    7'b0000110: color_data = 16'b1101010111001100;
//    7'b0000111: color_data = 16'b1010110001000110;
//    7'b0001000: color_data = 16'b1011110011001000;
//    7'b0001001: color_data = 16'b1111011010001110;
//    7'b0001010: color_data = 16'b1111011010001110;
//    7'b0001011: color_data = 16'b1011010001100110;
//    7'b0001100: color_data = 16'b0110101011100100;
//    7'b0001101: color_data = 16'b1010110000100101;
//    7'b0001110: color_data = 16'b1010010000000101;
//    7'b0001111: color_data = 16'b0111001100000100;
//    7'b0010000: color_data = 16'b0101101101001111;
//    7'b0010001: color_data = 16'b0100001000101111;
//    7'b0010010: color_data = 16'b0011000110001110;
//    7'b0010011: color_data = 16'b0010000101001010;
//    7'b0010100: color_data = 16'b0101101011110001;
//    7'b0010101: color_data = 16'b0101101010110100;
//    7'b0010110: color_data = 16'b0101101011010100;
//    7'b0010111: color_data = 16'b0011100111001110;
//    7'b0011000: color_data = 16'b0100001000001111;
//    7'b0011001: color_data = 16'b0110001100010110;
//    7'b0011010: color_data = 16'b0110001100010110;
//    7'b0011011: color_data = 16'b0011100111101110;
//    7'b0011100: color_data = 16'b0010100101001010;
//    7'b0011101: color_data = 16'b0011000110001101;
//    7'b0011110: color_data = 16'b0011000110001101;
//    7'b0011111: color_data = 16'b0010100101001010;
//    7'b0100000: color_data = 16'b0000001111100000;
//    7'b0100001: color_data = 16'b0001110100000011;
//    7'b0100010: color_data = 16'b0001110100000011;
//    7'b0100011: color_data = 16'b0000001101100000;
//    7'b0100100: color_data = 16'b0010010110000100;
//    7'b0100101: color_data = 16'b1100111110111010;
//    7'b0100110: color_data = 16'b1100111111011010;
//    7'b0100111: color_data = 16'b0010010010000100;
//    7'b0101000: color_data = 16'b0001010110000010;
//    7'b0101001: color_data = 16'b1011111110111001;
//    7'b0101010: color_data = 16'b1011111111011001;
//    7'b0101011: color_data = 16'b0001010010000001;
//    7'b0101100: color_data = 16'b0001101110000101;
//    7'b0101101: color_data = 16'b0001101111100010;
//    7'b0101110: color_data = 16'b0001110000000010;
//    7'b0101111: color_data = 16'b0001101100000101;
//    7'b0110000: color_data = 16'b0110001101101101;
//    7'b0110001: color_data = 16'b0110101100101010;
//    7'b0110010: color_data = 16'b0111001011100111;
//    7'b0110011: color_data = 16'b0101101000100011;
//    7'b0110100: color_data = 16'b1001010001001100;
//    7'b0110101: color_data = 16'b1000110010010001;
//    7'b0110110: color_data = 16'b1010110111010110;
//    7'b0110111: color_data = 16'b0111101100000101;
//    7'b0111000: color_data = 16'b1100010011100111;
//    7'b0111001: color_data = 16'b1010010011101111;
//    7'b0111010: color_data = 16'b1011110101001110;
//    7'b0111011: color_data = 16'b1010001111100101;
//    7'b0111100: color_data = 16'b0110001010100100;
//    7'b0111101: color_data = 16'b0111001010100011;
//    7'b0111110: color_data = 16'b0111101011100011;
//    7'b0111111: color_data = 16'b0101101001000011;
//    7'b1000000: color_data = 16'b0010000101001011;
//    7'b1000001: color_data = 16'b0011100111001100;
//    7'b1000010: color_data = 16'b0011000111001100;
//    7'b1000011: color_data = 16'b0010000101101011;
//    7'b1000100: color_data = 16'b0011100111001111;
//    7'b1000101: color_data = 16'b1001010011010110;
//    7'b1000110: color_data = 16'b1001010011010110;
//    7'b1000111: color_data = 16'b0011100111001111;
//    7'b1001000: color_data = 16'b0100001000010000;
//    7'b1001001: color_data = 16'b0110001100110010;
//    7'b1001010: color_data = 16'b0110001100110010;
//    7'b1001011: color_data = 16'b0100001000010000;
//    7'b1001100: color_data = 16'b0011000110101011;
//    7'b1001101: color_data = 16'b0100001000001110;
//    7'b1001110: color_data = 16'b0100001000001110;
//    7'b1001111: color_data = 16'b0011000110101011;
//    //.....

//    endcase

//endmodule

module blocks_rom(
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
        4'b0000: color_data = 16'b0000_0011001_00000;
        4'b0001: color_data = 16'b0000_0011001_00000;
        4'b0010: color_data = 16'b0000_0011001_00000;
        4'b0011: color_data = 16'b0000_0011001_00000;
        4'b0100: color_data = 16'b0000_0011001_00000;
        4'b0101: color_data = 16'b0000_0011001_00000;
        4'b0110: color_data = 16'b0000_0011001_00000;
        4'b0111: color_data = 16'b0000_0011001_00000;
        4'b1000: color_data = 16'b01100_010000_00100;
        4'b1001: color_data = 16'b01100_010000_00100;
        4'b1010: color_data = 16'b01100_010000_00100;
        4'b1011: color_data = 16'b01100_010000_00100;
        4'b1100: color_data = 16'b01100_010000_00100;
        4'b1101: color_data = 16'b01100_010000_00100;
        4'b1110: color_data = 16'b01100_010000_00100;
        4'b1111: color_data = 16'b01100_010000_00100;

    endcase

endmodule