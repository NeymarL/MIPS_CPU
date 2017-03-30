`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2017 04:02:59 PM
// Design Name: 
// Module Name: ALU
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

module ALU(
input [3:0] AluOp,
input [31:0] X, Y,
output reg [31:0] Result,
output Equal);

wire [31:0] sub_ab;
wire [31:0] add_ab;
wire         slt;

assign Equal = (X == Y);

assign sub_ab = X - Y;
assign add_ab = X + Y;
/*rc_adder #(.N(32)) add0(.a(a), .b(b), .s(add_ab));*/
/*rc_adder #(.N(32)) add1(.a(a), .b(-b), .s(sub_ab));*/

always @(*) begin
case (AluOp)
    4'd0:  Result = X << (Y[4:0]);
    4'd1:  Result = ($signed(X)) >>> (Y[4:0]);
    4'd2:  Result = X >> (Y[4:0]);
    4'd5:  Result = add_ab;
    4'd6:  Result = sub_ab;
    4'd7:  Result = X & Y;
    4'd8:  Result = X | Y;
    4'd9:  Result = X ^ Y;
    4'd10:  Result = ~(X | Y);
    4'd12:  Result = (X < Y)?1:0;
    4'd11:  Result = ($signed(X) < $signed(Y))?1:0;
    default: Result = 0;
endcase
end
endmodule
