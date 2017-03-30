`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2017 10:59:49 PM
// Design Name: 
// Module Name: RAM
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


module RAM(clk,ram_write,ram_addr, ram_din, ram_dout);
parameter DATA_WID=32;
parameter ADDR_WID=10;

input clk, ram_write;
input [ADDR_WID-1:0] ram_addr;
input [DATA_WID-1:0] ram_din;
output wire [DATA_WID-1:0] ram_dout;

reg [DATA_WID-1:0] ram_content[2**ADDR_WID-1:0];
    
always@(negedge clk)
begin
    if(ram_write)
    begin
        ram_content[ram_addr]<=ram_din;            
    end
end

assign ram_dout = ram_content[ram_addr];

endmodule

