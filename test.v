`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/07 10:57:08
// Design Name: 
// Module Name: test
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


module test(

    );
    reg clk, clear;
    reg choose;
    wire [6:0] eight_decode;
    wire [7:0] mie;
    
    CPU DUT(.clk(clk), .clear(clear), .eight_decode(eight_decode), .mie(mie));
    
    initial begin
        clk = 0;
        clear = 1;
        choose = 0;
        #100 clear = 0;
    end
    
    always begin
        #50 clk = ~clk;
    end
    
endmodule
