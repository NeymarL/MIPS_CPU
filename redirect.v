`timescale 1ns / 1ps

module Redirect (
    input wire [4:0] R1,    // Clock
    input wire [4:0] R2_,
    input wire [31:0] IR1,
    input wire [4:0] RW2,
    input wire [4:0] RW3,
    input Branch,
    input JmpReg,
    input Jump,
    input MemR,
    input RegW2,
    input RegW3,
    input R1Src,
    input Bubble_f_new,
    output [1:0] Bypass1,
    output [1:0] Bypass2,
    output [1:0] Bypass3,
    output [1:0] Bypass4,
    output Bubble,
    output Bubble_f,
    output Bubble_j,
    output LoadUse
);
    wire [4:0] R2;
    wire [4:0] reg2, reg4;

    assign Bubble_j = (JmpReg + Jump) & (~Bubble_f_new);
    assign Bubble_f = (Branch) & (~Bubble);
    assign R2 = ((R1 == R2_) & R1Src) ? 0 : R2_;
    assign reg2 = 2;
    assign reg4 = 4;
    assign LoadUse = ((R1 == RW2) & (R1 != 0) & MemR) +
                     ((R2 == RW2) & (R2 != 0) & MemR) +
                     ((IR1 == 12) & (RW2 == 2) & MemR) +
                     ((IR1 == 12) & (RW2 == 4) & MemR);
    assign Bubble = LoadUse;

    RD1 
        rd1_ins1(
            .R1(R1),
            .RW2(RW2),
            .RW3(RW3),
            .MemR(MemR),
            .RegW2(RegW2),
            .RegW3(RegW3),
            .Bypass(Bypass1)
        ),
        rd1_ins2(
            .R1(R2),
            .RW2(RW2),
            .RW3(RW3),
            .MemR(MemR),
            .RegW2(RegW2),
            .RegW3(RegW3),
            .Bypass(Bypass2)
        );

    RD2 
        rd2_ins1(
            .IR1(IR1),
            .RW2(RW2),
            .RW3(RW3),
            .REG(reg2),
            .MemR(MemR),
            .RegW2(RegW2),
            .RegW3(RegW3),
            .Bypass(Bypass3)
        ),
        rd2_ins2(
            .IR1(IR1),
            .RW2(RW2),
            .RW3(RW3),
            .REG(reg4),
            .MemR(MemR),
            .RegW2(RegW2),
            .RegW3(RegW3),
            .Bypass(Bypass4)
        );

endmodule

module RD1 (
    input wire [4:0] R1,
    input wire [4:0] RW2,
    input wire [4:0] RW3,
    input MemR,
    input RegW2,
    input RegW3,
    output [1:0] Bypass
);
    wire w01, w10, w11, w101;
    wire [1:0] bypass_tmp;
    wire choose;

    assign w01 = (R1 == RW2) & (R1 != 0) & (~MemR) & (RegW2);
    assign w101 = (R1 == RW3) & (R1 != 0) & (RegW3);
    assign w10 = (MemR == 1) ? 0 : w101;
    assign w11 = (MemR == 1) ? w101 : 0;
    assign bypass_tmp[0] = ((w01) + (w11)) & (~w10);
    assign bypass_tmp[1] = (w11 + w10) & (~w01);
    assign choose = (RW2 == RW3) & (RW2 == R1) & (R1 != 0);
    assign Bypass = (choose == 1) ? 1 : bypass_tmp;

endmodule

module RD2 (
    input wire [31:0] IR1,
    input wire [4:0] RW2,
    input wire [4:0] RW3,
    input wire [4:0] REG,
    input MemR,
    input RegW2,
    input RegW3,
    output [1:0] Bypass
);
    wire w01, w10, w11, w101;
    wire [1:0] bypass_tmp;
    wire choose;

    assign w01 = (IR1 == 12) & (RW2 == REG) & (~MemR) & (RegW2);
    assign w101 = (IR1 == 12) & (RW3 == REG) & (RegW3);
    assign w10 = (MemR == 1) ? 0 : w101;
    assign w11 = (MemR == 1) ? w101 : 0;
    assign bypass_tmp[0] = ((w01) + (w11)) & (~w10);
    assign bypass_tmp[1] = (w11 + w10) & (~w01);
    assign choose = (RW2 == RW3) & (RW2 == REG);
    assign Bypass = (choose == 1) ? 1 : bypass_tmp;

endmodule

