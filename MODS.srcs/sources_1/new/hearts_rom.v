`timescale 1ns / 1ps

module hearts_rom(
    input wire clk,
    input wire [2:0] row,
    input wire [1:0] col,
    output reg [15:0] color_data         // output signal asserted when x/y is located within the hearts locations
   );
   
  (* rom_style = "block" *)
   
  //signal declaration
  reg [2:0] row_reg;
  reg [1:0] col_reg;
  
  always @(posedge clk)
    begin
       row_reg <= row;
       col_reg <= col;
    end
       
    always @*
        case ({row_reg, col_reg})
        //.....
            5'b00000: color_data = 16'b0111010111111000;
            5'b00001: color_data = 16'b0111010111111001;
            5'b00010: color_data = 16'b0111010111111001;
            5'b00011: color_data = 16'b0111010111111000;
            5'b00100: color_data = 16'b1001001100101101;
            5'b00101: color_data = 16'b1100100000100000;
            5'b00110: color_data = 16'b1100100000100000;
            5'b00111: color_data = 16'b1001001100101101;
            5'b01000: color_data = 16'b0110111001011010;
            5'b01001: color_data = 16'b1100000100000100;
            5'b01010: color_data = 16'b1100000100000100;
            5'b01011: color_data = 16'b0110111001011010;
            5'b01100: color_data = 16'b0101111011111101;
            5'b01101: color_data = 16'b0110111001111011;
            5'b01110: color_data = 16'b0110111001111011;
            5'b01111: color_data = 16'b0101111011111101;
            5'b10000: color_data = 16'b0110110111011000;
            5'b10001: color_data = 16'b0111011000011001;
            5'b10010: color_data = 16'b0111011000011001;
            5'b10011: color_data = 16'b0110110111011000;
            5'b10100: color_data = 16'b0101001100101100;
            5'b10101: color_data = 16'b0000100000000000;
            5'b10110: color_data = 16'b0000100000000000;
            5'b10111: color_data = 16'b0101001100101100;
            5'b11000: color_data = 16'b0110111001011010;
            5'b11001: color_data = 16'b0010000100100101;
            5'b11010: color_data = 16'b0010000100100101;
            5'b11011: color_data = 16'b0110111001011010;
            5'b11100: color_data = 16'b0110011011011101;
            5'b11101: color_data = 16'b0111011000111010;
            5'b11110: color_data = 16'b0111011000111010;
            5'b11111: color_data = 16'b0110011011011101;
            //.....
        endcase
    
    
endmodule
