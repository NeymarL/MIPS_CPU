`timescale 1ns / 1ps

module MEM (
    input clk,
    input clear,
    input NewHalt,
    input SysCall3,
    input Halt3,
    input MemToReg3,
    input MemWrite3,
    input wire [31:0] MEM_NM,
    input wire [31:0] Addr,
    input wire [31:0] Data,
    input MemRead3,
    input wire [31:0] PC3,
    input wire [31:0] IR3,
    input RegWrite3,
    input wire [4:0] RW3,
    input PCtoReg3,
    output reg SysCall4,
    output reg Halt4,
    output reg MemToReg4,
    output reg [31:0] WB_NM,
    output reg [31:0] WB_Data,
    output reg [31:0] PC4,
    output reg [31:0] IR4,
    output reg RegWrite4,
    output reg [4:0] RW4,
    output reg PCtoReg4,
    output wire [31:0] WB_Data_
);

    RAM ram_ins (
        .clk(clk),
        .ram_write(MemWrite3), 
        .ram_addr(Addr[11:2]), 
        .ram_din(Data), 
        .ram_dout(WB_Data_)
    );

    always @(posedge clk) begin
        if (clear) begin
            SysCall4 <= 0;
            Halt4 <= 0;
            MemToReg4 <= 0;
            WB_NM <= 0;
            WB_Data <= 0;
            PC4 <= 0;
            IR4 <= 0;
            RegWrite4 <= 0;
            RW4 <= 0;
            PCtoReg4 <= 0;
        end
        else if (NewHalt) begin
            SysCall4 <= SysCall3;
            Halt4 <= Halt3;
            MemToReg4 <= MemToReg3;
            WB_NM <= MEM_NM;
            WB_Data <= WB_Data_;
            PC4 <= PC3;
            IR4 <= IR3;
            RegWrite4 <= RegWrite3;
            RW4 <= RW3;
            PCtoReg4 <= PCtoReg3;
        end
    end

endmodule
