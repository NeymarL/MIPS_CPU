`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2017 10:56:44 PM
// Design Name: 
// Module Name: ROM
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


module ROM(rom_addr, rom_data);
    parameter DATA_WID=32;
    parameter ADDR_WID=10;

    input [ADDR_WID-1:0] rom_addr;
    output [DATA_WID-1:0] rom_data;

    reg [DATA_WID-1:0] rom_content[2**ADDR_WID-1:0];

    initial $readmemh("/home/liuhe/five-seg-cpu/benchmark",rom_content);


    assign rom_data = rom_content[rom_addr];



endmodule
