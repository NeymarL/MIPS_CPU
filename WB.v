`timescale 1ns / 1ps

module WB (
    input clk,
    input clear,
    input NewHalt,
    input SysCall4,
    input Halt4,
    input MemToReg4,
    input wire [31:0] WB_NM,
    input wire [31:0] WB_Data,
    input wire [31:0] PC4,
    input wire [31:0] IR4,
    input RegWrite4,
    input wire [4:0] RW4,
    input PCtoReg4,
    output reg [31:0] RegDin
);

    always @* begin
        if (MemToReg4 == 1) begin
            RegDin <= WB_Data;
        end
        else begin
            RegDin <= WB_NM;
        end
    end

endmodule

