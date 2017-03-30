`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 12:02:15 AM
// Design Name: 
// Module Name: regfile
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

module regfile(
input clk,
input rf_we,
input [4:0] rf_addr,
input [31:0] rf_din,
input [4:0] rf_r1,
input [4:0] rf_r2,
output [31:0] rfd1,
output [31:0] rfd2,
output [31:0] rr2,
output [31:0] rr4
);

parameter DATA_WID=32;
parameter ADDR_WID=5;

reg [DATA_WID-1:0] rf_content[2**ADDR_WID-1:0];
    
always@(negedge clk)
begin
    if(rf_we && (rf_addr != 5'd0))
    begin
        rf_content[rf_addr]<=rf_din;            
    end
end
assign rfd1 = (rf_r1 != 5'd0)? rf_content[rf_r1] : 32'd0;
assign rfd2 = (rf_r2 != 5'd0)? rf_content[rf_r2] : 32'd0;
assign rr2 = rf_content[2];
assign rr4 = rf_content[4];

endmodule
