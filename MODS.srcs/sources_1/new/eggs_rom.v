`timescale 1ns / 1ps

module eggs_rom(
    input wire clk,
    input wire [4:0] row,
    input wire [1:0] col,
    output reg [15:0] color_data         // output signal asserted when x/y is located within the hearts locations
   );
   
  (* rom_style = "block" *)
   
  //signal declaration
  reg [2:0] row_reg;
  reg [4:0] col_reg;
  
  always @(posedge clk)
    begin
       row_reg <= row;
       col_reg <= col;
    end
       
    always @*
        case ({row_reg, col_reg})
        //.....
        7'b0000000: color_data = 16'b0100010111011000;
        7'b0000001: color_data = 16'b0101110011001110;
        7'b0000010: color_data = 16'b1000110101010011;
        7'b0000011: color_data = 16'b0100010111011000;
        7'b0000100: color_data = 16'b0110110100010101;
        7'b0000101: color_data = 16'b1000111100110001;
        7'b0000110: color_data = 16'b1001011011010001;
        7'b0000111: color_data = 16'b0100110010110000;
        7'b0001000: color_data = 16'b0111010010110001;
        7'b0001001: color_data = 16'b0101011101101000;
        7'b0001010: color_data = 16'b0110111100101100;
        7'b0001011: color_data = 16'b0101010001001101;
        7'b0001100: color_data = 16'b0011110110010101;
        7'b0001101: color_data = 16'b0111110100010001;
        7'b0001110: color_data = 16'b1000110101110100;
        7'b0001111: color_data = 16'b0100010110010110;
        7'b0010000: color_data = 16'b0101010111011001;
        7'b0010001: color_data = 16'b1000110010010010;
        7'b0010010: color_data = 16'b0111101100101101;
        7'b0010011: color_data = 16'b0101010111011001;
        7'b0010100: color_data = 16'b0110001111110000;
        7'b0010101: color_data = 16'b1110010001110001;
        7'b0010110: color_data = 16'b1110110001010001;
        7'b0010111: color_data = 16'b0111010011110100;
        7'b0011000: color_data = 16'b0111001101001101;
        7'b0011001: color_data = 16'b1110101100101100;
        7'b0011010: color_data = 16'b1111001001001001;
        7'b0011011: color_data = 16'b1000010001010001;
        7'b0011100: color_data = 16'b0101010100010101;
        7'b0011101: color_data = 16'b1001110011010011;
        7'b0011110: color_data = 16'b1001010001110001;
        7'b0011111: color_data = 16'b0101010011110100;
        7'b0100000: color_data = 16'b0100111000011011;
        7'b0100001: color_data = 16'b1000010011010101;
        7'b0100010: color_data = 16'b0110110000010101;
        7'b0100011: color_data = 16'b0100111000011011;
        7'b0100100: color_data = 16'b0101110001010100;
        7'b0100101: color_data = 16'b1100010111011101;
        7'b0100110: color_data = 16'b1100010111011101;
        7'b0100111: color_data = 16'b0111010100010101;
        7'b0101000: color_data = 16'b0110001111110100;
        7'b0101001: color_data = 16'b1011010101111110;
        7'b0101010: color_data = 16'b1010110100011110;
        7'b0101011: color_data = 16'b0111110010010100;
        7'b0101100: color_data = 16'b0100110101011001;
        7'b0101101: color_data = 16'b1000110011110101;
        7'b0101110: color_data = 16'b1000010010110110;
        7'b0101111: color_data = 16'b0100010100111000;
        7'b0110000: color_data = 16'b0101011000011000;
        7'b0110001: color_data = 16'b1001010011110001;
        7'b0110010: color_data = 16'b1001010010101101;
        7'b0110011: color_data = 16'b0101011000011001;
        7'b0110100: color_data = 16'b0111010010010000;
        7'b0110101: color_data = 16'b1111111100010001;
        7'b0110110: color_data = 16'b1111111101010001;
        7'b0110111: color_data = 16'b0111010100010100;
        7'b0111000: color_data = 16'b1000110000101101;
        7'b0111001: color_data = 16'b1111111101101100;
        7'b0111010: color_data = 16'b1111111110001000;
        7'b0111011: color_data = 16'b1001010011010001;
        7'b0111100: color_data = 16'b0110010110010110;
        7'b0111101: color_data = 16'b1010010100110011;
        7'b0111110: color_data = 16'b1001110011110010;
        7'b0111111: color_data = 16'b0101110110010101;
        7'b1000000: color_data = 16'b0100010111111000;
        7'b1000001: color_data = 16'b0111010011110010;
        7'b1000010: color_data = 16'b1001110010001101;
        7'b1000011: color_data = 16'b0101011000011001;
        7'b1000100: color_data = 16'b0101010011001111;
        7'b1000101: color_data = 16'b1001011101010010;
        7'b1000110: color_data = 16'b1111011100110000;
        7'b1000111: color_data = 16'b0111110100110011;
        7'b1001000: color_data = 16'b1000001100101101;
        7'b1001001: color_data = 16'b1100110000101111;
        7'b1001010: color_data = 16'b1001010011110110;
        7'b1001011: color_data = 16'b0111110010010110;
        7'b1001100: color_data = 16'b0100110011010100;
        7'b1001101: color_data = 16'b1010110011010011;
        7'b1001110: color_data = 16'b1001010010110111;
        7'b1001111: color_data = 16'b0100010011110111;
        //.....

        endcase
    
    
endmodule

