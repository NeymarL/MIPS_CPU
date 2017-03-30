`timescale 1ns / 1ps

module ID (
    input clk,    // Clock
    input clear, // Clock Enable
    input NewHalt,
    input Bubble,
    input Bubble_f,
    input RegWrite4,
    input PCtoReg4,
    input wire [4:0] RW4,
    input wire [31:0] PC1, IR1, PCnext1,
    input wire [31:0] PC4,
    input wire [31:0] WB_Out,
    input wire [31:0] MEM_NM_, WB_Data_, WB_NM_,
    input wire [1:0] Bypass1, Bypass2, Bypass3, Bypass4,
    output reg [1:0] Bypass12, Bypass22, Bypass32, Bypass42,
    output reg MemWrite2,
    output reg MemRead2,
    output reg SelectBase2,
    output reg SysCall2,
    output reg MemToReg2,
    output reg Branch2,
    output reg [3:0] AluControl2,
    output reg Jump2,
    output reg [31:0] PC2,
    output reg [31:0] IR2,
    output reg [31:0] reg22,
    output reg [31:0] reg42,
    output reg [31:0] X2,
    output reg [31:0] Y2,
    output reg [31:0] regData2,
    output reg [31:0] IMMI2,
    output reg [31:0] PCnext2,
    output reg [31:0] IMMJ2,
    output reg RegWrite2,
    output reg [4:0] RW2,
    output reg PCtoReg2,
    output wire [4:0] R1_addr,
    output wire [4:0] R2_addr,
    output wire JmpReg,
    output wire Jump,
    output wire R1Src, RegDst, Branch
);

    wire [5:0] Op;
    wire [5:0] funct;
    wire [4:0] RW, Rs, Rt, Rd, Shamt;
    wire [15:0] IMMI;
    wire [25:0] IMMJ;
    wire [4:0] R1_in, w_rtd;
    wire [31:0] Sh;
    wire [31:0] se_out, ze_out;
    // control output
    wire Extype, Shift,RegWrite, PCtoReg, Jal;
    wire MemWrite, MemRead, MemToReg, SelectBase, AluSrc;
    wire [3:0] AluControl;

    wire [31:0] Din;
    wire [31:0] R2;
    wire [31:0] Reg, reg2, reg4;
    wire [31:0] ext_out;
    wire [31:0] irj_out;
    reg [31:0] R2_redirect;
    wire [31:0] R2_redirect_wire;
    wire [31:0] re_out;
    wire [31:0] Y;
    
    assign R2_redirect_wire = R2_redirect;
    assign R2_addr = Rt;
    assign R1_addr = R1_in;
    
    decoder decoder_ins (
         .in(IR1), 
         .Op(Op), 
         .Rs(Rs), 
         .Rt(Rt), 
         .Rd(Rd), 
         .Shamt(Shamt), 
         .funct(funct), 
         .IMMI(IMMI), 
         .IMMJ(IMMJ)
    );

    regfile regfile_ins(
        .clk(clk), 
        .rf_we(RegWrite4), 
        .rf_addr(RW4), 
        .rf_din(Din), 
        .rf_r1(R1_in), 
        .rf_r2(Rt), 
        .rfd1(Reg), 
        .rfd2(R2), 
        .rr2(reg2), 
        .rr4(reg4)
    );

    control cpu_control(
        .op(Op), 
        .func(funct),  
        .Extype(Extype), 
        .RegDst(RegDst), 
        .AluShift(Shift), 
        .R1Src(R1Src), 
        .RegWrite(RegWrite),
        .PCtoReg(PCtoReg), 
        .W31(Jal), 
        .Jump(Jump), 
        .AluSrc(AluSrc), 
        .Branch(Branch), 
        .MemWrite(MemWrite),
        .MemRead(MemRead), 
        .SysCall(SysCall), 
        .MemtoReg(MemToReg), 
        .JmpReg(JmpReg), 
        .ALUop(AluControl),
        .SelectBase(SelectBase)
    );
    wire[4:0] wire_const;
    assign wire_const = 31;
    selecter_two #(5)
        S2(.a(Rs), .b(Rt), .s(R1Src), .result(R1_in)),
        S3(.a(Rt), .b(Rd), .s(RegDst), .result(w_rtd)),
        S4(.a(w_rtd), .b(wire_const), .s(Jal), .result(RW));

    selecter_two #(32)
        S6(.a(se_out), .b(ze_out), .s(Extype), .result(ext_out)),
        S7(.a(R2_redirect_wire), .b(ext_out), .s(AluSrc), .result(re_out)),
        S8(.a(re_out), .b(Sh), .s(Shift), .result(Y)),
        S10(.a(WB_Out), .b(PC4 + 4), .s(PCtoReg4), .result(Din)),
        S11(.a({4'b0000, IMMJ, 2'b00}), .b(Reg), .s(JmpReg), .result(irj_out));

    sign_extender_5_32 se1 (.in(Shamt), .out(Sh));
    
    sign_extender_16_32 se2 (.in(IMMI), .out(se_out));
    
    zero_extender_16_32 ze1 (.in(IMMI), .out(ze_out));

    always @* begin
        if (Bypass2 == 2'b00) begin
            R2_redirect <= R2;
        end
        else if (Bypass2 == 2'b01) begin
            R2_redirect <= MEM_NM_;
        end
        else if (Bypass2 == 2'b10) begin
            R2_redirect <= WB_NM_;
        end
        else begin
            R2_redirect <= WB_Data_;
        end
    end


    always @(posedge clk) begin
        if (clear) begin
            Bypass12 <= 0; 
            Bypass22 <= 0; 
            Bypass32 <= 0; 
            Bypass42 <= 0;
            MemWrite2 <= 0;
            MemRead2 <= 0;
            SelectBase2 <= 0;
            SysCall2 <= 0;
            MemToReg2 <= 0;
            Branch2 <= 0;
            AluControl2 <= 0;
            Jump2 <= 0;
            PC2 <= 0;
            IR2 <= 0;
            reg22 <= 0;
            reg42 <= 0;
            X2 <= 0;
            Y2 <= 0;
            regData2 <= 0;
            IMMI2 <= 0;
            PCnext2 <= 0;
            IMMJ2 <= 0;
            RegWrite2 <= 0;
            RW2 <= 0;
            PCtoReg2 <= 0;
        end
        else if (NewHalt) begin
            if (Bubble | Bubble_f) begin
                Bypass12 <= 0; 
                Bypass22 <= 0; 
                Bypass32 <= 0; 
                Bypass42 <= 0;
                MemWrite2 <= 0;
                MemRead2 <= 0;
                SelectBase2 <= 0;
                SysCall2 <= 0;
                MemToReg2 <= 0;
                Branch2 <= 0;
                AluControl2 <= 0;
                Jump2 <= 0;
                PC2 <= 0;
                IR2 <= 0;
                reg22 <= 0;
                reg42 <= 0;
                X2 <= 0;
                Y2 <= 0;
                regData2 <= 0;
                IMMI2 <= 0;
                PCnext2 <= 0;
                IMMJ2 <= 0;
                RegWrite2 <= 0;
                RW2 <= 0;
                PCtoReg2 <= 0;
            end
            else begin
                Bypass12 <= Bypass1; 
                Bypass22 <= Bypass2; 
                Bypass32 <= Bypass3; 
                Bypass42 <= Bypass4;
                MemWrite2 <= MemWrite;
                MemRead2 <= MemRead;
                SelectBase2 <= SelectBase;
                SysCall2 <= SysCall;
                MemToReg2 <= MemToReg;
                Branch2 <= Branch;
                AluControl2 <= AluControl;
                Jump2 <= Jump;
                PC2 <= PC1;
                IR2 <= IR1;
                reg22 <= reg2;
                reg42 <= reg4;
                X2 <= Reg;
                Y2 <= Y;
                regData2 <= R2_redirect;
                IMMI2 <= ext_out;
                PCnext2 <= PCnext1;
                IMMJ2 <= irj_out;
                RegWrite2 <= RegWrite;
                RW2 <= RW;
                PCtoReg2 <= PCtoReg; 
            end
        end
    end

endmodule