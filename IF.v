`timescale 1ns / 1ps

module IF (clk, clear, Bubble, Bubble_j, Halt4, SysCall4, 
           Jump2, PC_Next, NewBranch, PC1, IR1, PCnext1, NewHalt,
           PC_pred, chose_pred, IR0, predict, Next_PC_asm, Bubble_f_new);
    input wire clk;
    input wire clear;
    input wire Bubble;
    input wire Bubble_j;
    input wire Jump2;
    input wire Halt4;
    input wire SysCall4;
    input wire NewBranch;
    input wire[31:0] PC_Next;
    input wire[31:0] PC_pred;
    input wire chose_pred;
    input wire predict;
    input wire [31:0] Next_PC_asm;
    input wire Bubble_f_new;

    output reg[31:0] PC1;
    output reg[31:0] IR1;
    output reg[31:0] PCnext1;
    output wire NewHalt;
    output wire [31:0] IR0;

    reg [31:0] PC0;
    // wire [31:0] IR0;
    wire [31:0] PCnext0;
    reg [31:0] PC_temp;
    reg H4N, S4N;
    reg [31:0] PC_Next_new;

    // PC
    always @(negedge clk) begin
        if (clear) begin
            PC0 <= 0;
        end
        else if (NewHalt) begin
            if (Bubble_f_new) begin
                PC0 <= Next_PC_asm;
            end
            else if (chose_pred) begin
                PC0 <= PC_pred;
            end
            else begin
                PC0 <= PC_Next_new;
            end
        end
    end

    always @(posedge clk) begin
        if (clear) begin
            H4N <= 0;
            S4N <= 0;
            PC1 <= 0;
            IR1 <= 0;
            PCnext1 <= 0;
        end
        else if (NewHalt) begin 
            H4N <= Halt4;
            S4N <= SysCall4;
            if (Bubble_j) begin
                PC1 <= 0;
                IR1 <= 0;
                PCnext1 <= 0;
            end
            else begin
                PC1 <= PC0;
                IR1 <= IR0;
                PCnext1 <= PCnext0;
            end
        end
    end

    always @* begin
        if ((NewBranch | Jump2) && (predict == 0)) begin
            PC_temp <= PC_Next;
        end
        else begin
            PC_temp <= PCnext0;
        end

        if (Bubble) begin 
            PC_Next_new <= PC0;
        end
        else begin
            PC_Next_new <= PC_temp;
        end
    end

    assign NewHalt = ~(H4N & S4N);
    assign PCnext0 = PC0 + 4;

    ROM rom_ins (.rom_addr(PC0[11:2]), .rom_data(IR0));

endmodule

