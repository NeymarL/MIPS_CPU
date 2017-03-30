`timescale 1ns / 1ps

module EX (
    input clk,
    input clear,
    input NewHalt,
    input wire [1:0] Bypass12, Bypass22, Bypass32, Bypass42,
    input MemWrite2,
    input MemRead2,
    input SelectBase2,
    input SysCall2,
    input MemToReg2,
    input Branch2,
    input wire [3:0] AluControl2,
    input Jump2,
    input wire [31:0] PC2,
    input wire [31:0] IR2,
    input wire [31:0] reg22,
    input wire [31:0] reg42,
    input wire [31:0] X2,
    input wire [31:0] Y2,
    input wire [31:0] regData2,
    input wire [31:0] IMMI2,
    input wire [31:0] PCnext2,
    input wire [31:0] IMMJ2,
    input RegWrite2,
    input wire [4:0] RW2,
    input PCtoReg2,
    input wire [31:0] WB_NM,
    input wire [31:0] WB_Data,
    output reg SysCall3,
    output reg Halt3,
    output reg MemToReg3,
    output reg MemWrite3,
    output reg [31:0] MEM_NM,
    output reg [31:0] Addr,
    output reg [31:0] Data,
    output reg MemRead3,
    output reg [31:0] PC3,
    output reg [31:0] IR3,
    output reg RegWrite3,
    output reg [4:0] RW3,
    output reg PCtoReg3,
    output wire [31:0] PC_Next,
    output wire [31:0] MEM_NM_,
    output reg [31:0] display,
    output wire NewBranch
);

    reg [31:0] X_redirect, reg2_redirect, reg4_redirect;
    wire Equal, Greater0;
    reg [31:0] regData2_new;
    wire [31:0] peb;
    wire [31:0] ext_plus;
    
    wire [31:0] R;
    wire Halt;

    always @* begin
        // redirect X
        if (Bypass12 == 2'b00) begin
            X_redirect <= X2;            
        end
        else if (Bypass12 == 2'b01) begin
            X_redirect <= MEM_NM;
        end
        else if (Bypass12 == 2'b10) begin
           X_redirect <= WB_NM; 
        end
        else begin
            X_redirect <= WB_Data;
        end
        // redirect reg2
        if (Bypass32 == 2'b00) begin
            reg2_redirect <= reg22;            
        end
        else if (Bypass32 == 2'b01) begin
            reg2_redirect <= MEM_NM;
        end
        else if (Bypass32 == 2'b10) begin
           reg2_redirect <= WB_NM; 
        end
        else begin
            reg2_redirect <= WB_Data;
        end
        // redirect reg4
        if (Bypass42 == 2'b00) begin
            reg4_redirect <= reg42;            
        end
        else if (Bypass42 == 2'b01) begin
            reg4_redirect <= MEM_NM;
        end
        else if (Bypass42 == 2'b10) begin
           reg4_redirect <= WB_NM; 
        end
        else begin
            reg4_redirect <= WB_Data;
        end
        // sh
        if (SelectBase2) begin
            regData2_new <= {16'b0, regData2[15:0]};
        end
        else begin
            regData2_new <= regData2;
        end
    end

    ALU alu_ins (.AluOp(AluControl2), 
                 .X(X_redirect), 
                 .Y(Y2), 
                 .Result(R), 
                 .Equal(Equal)
    );

    selecter_two #(32)
        S12(.a(PCnext2), .b(ext_plus), .s(NewBranch), .result(peb)),
        S13(.a(peb), .b(IMMJ2), .s(Jump2), .result(PC_Next));

    IR_Branch ir_branch(
        .Greater0(Greater0), 
        .Equal(Equal), 
        .IR(IR2), 
        .NewBranch(NewBranch)
    );

    assign ext_plus = (IMMI2 << 2) + PCnext2;
    assign MEM_NM_ = R;
    assign Greater0 = (~R[0]) & (~Equal);
    assign Halt = (reg2_redirect == 10) ? 1 : 0;

    always @(posedge clk) begin
        if (clear) begin
            // reset
            SysCall3 <= 0;
            Halt3 <= 0;
            MemToReg3 <= 0;
            MemWrite3 <= 0;
            Addr <= 0;
            Data <= 0;
            MemRead3 <= 0;
            PC3 <= 0;
            IR3 <= 0;
            RegWrite3 <= 0;
            RW3 <= 0;
            PCtoReg3 <= 0;
            display <= 0;
            MEM_NM <= 0;
        end
        else if (NewHalt) begin
            if ((~Halt) & SysCall2) begin
                display <= reg4_redirect;                
            end
            SysCall3 <= SysCall2;
            Halt3 <= Halt;
            MemToReg3 <= MemToReg2;
            MemWrite3 <= MemWrite2;
            Addr <= R;
            Data <= regData2_new;
            MemRead3 <= MemRead2;
            PC3 <= PC2;
            IR3 <= IR2;
            RegWrite3 <= RegWrite2;
            RW3 <= RW2;
            PCtoReg3 <= PCtoReg2;
            MEM_NM <= MEM_NM_;
        end
    end

endmodule

module IR_Branch (Greater0, Equal, IR, NewBranch);
    input Greater0;
    input Equal;
    input wire [31:0] IR;
    output NewBranch;

    wire [5:0] op;
    wire [5:0] funct;
    wire [4:0] RW, Rs, Rt, Rd, Shamt;
    wire [15:0] IMMI;
    wire [25:0] IMMJ;

    wire beq_t, bne_t, bgtz_t;
    wire beq, bne, bgtz;

    decoder decoder_ins (.in(IR), 
                         .Op(op), 
                         .Rs(Rs), 
                         .Rt(Rt), 
                         .Rd(Rd), 
                         .Shamt(Shamt), 
                         .funct(funct), 
                         .IMMI(IMMI), 
                         .IMMJ(IMMJ)
    );
    assign beq_t = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (~op[1]) & (~op[0]);
    assign bne_t = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (~op[1]) & (op[0]);
    assign bgtz_t = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (op[1]) & (op[0]);

    assign beq = beq_t & Equal;
    assign bne = bne_t & (~Equal);
    assign bgtz = bgtz_t & Greater0;

    assign NewBranch = beq + bne + bgtz;
endmodule

