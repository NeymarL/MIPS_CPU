`timescale 1ns / 1ps

module CPU (
    input clock,
    input clear,
    input wire [1:0] choose,
    output reg [6:0] eight_decode,
    output reg [7:0] mie
);
    wire [31:0] display;
    reg [31:0] disp;
    wire Bubble, Bubble_j, Halt4, SysCall4, Jump2, NewBranch, NewHalt;
    wire [31:0] PC_Next, PC1, IR1, PCnext1;
    wire [4:0] RW4;
    wire [31:0] PC4;
    wire [31:0] WB_Out;
    wire [31:0] MEM_NM_, WB_Data_;
    wire [1:0] Bypass1, Bypass2, Bypass3, Bypass4;
    wire [1:0] Bypass12, Bypass22, Bypass32, Bypass42;
    wire MemWrite2;
    wire MemRead2;
    wire SelectBase2;
    wire SysCall2;
    wire MemToReg2;
    wire Branch2;
    wire [3:0] AluControl2;
    wire [31:0] IR2;
    wire [31:0] reg22;
    wire [31:0] reg42;
    wire [31:0] wire22;
    wire [31:0] wire42;
    wire [31:0] X2;
    wire [31:0] Y2;
    wire [31:0] regData2;
    wire [31:0] IMMI2;
    wire [31:0] PCnext2;
    wire [31:0] IMMJ2;
    wire RegWrite2;
    wire [4:0] RW2;
    wire PCtoReg2;
    wire Bubble_f;

    wire [31:0] WB_NM;
    wire [31:0] WB_Data;
    wire SysCall3;
    wire Halt3;
    wire MemToReg3;
    wire MemWrite3;
    wire [31:0] MEM_NM;
    wire [31:0] Addr;
    wire [31:0] Data;
    wire MemRead3;
    wire [31:0] PC3;
    wire [31:0] IR3;
    wire RegWrite3;
    wire [4:0] RW3;
    wire PCtoReg3;
    wire [31:0] PC2;

    wire MemToReg4;
    wire [31:0] IR4;
    wire RegWrite4;
    wire PCtoReg4;
    wire [4:0] R1_addr, R2_addr;

    wire LoadUse;
    integer qscan, qflash;
    reg scan;
    reg clk;
    wire [6:0] seven1, seven2,seven3,seven4,seven5,seven6,seven7,seven8;
    reg [31:0] count_cycle, count_loaduse, count_bubble;

    reg pred_result;
    reg [31:0] PC_query, PC_update, Next_PC_asm;
    wire query_res;
    wire [31:0] predict_res;
    reg [31:0] predict_res2;
    integer branch_num, success_num;
    wire Branch;
    reg [31:0] PC_Next_new;
    reg Bubble_f_new;
    reg query, store;
    wire [31:0] IR0;
    
    always @* begin
        if (choose == 2'b00)
            disp <= display;
        else if (choose == 2'b01)
            disp <= count_cycle;
        else if (choose == 2'b10)
            disp <= branch_num;
        else
            disp <= success_num;
    end
    
    always @(posedge clk) begin
        predict_res2 <= predict_res;
             if (clear) begin
                 count_cycle = 0;
                 count_loaduse = 0;
                 count_bubble = 0;
             end else if (NewHalt == 1) begin
                count_cycle = count_cycle + 1;
                if (LoadUse == 1) begin
                   count_loaduse = count_loaduse + 1;
                end
                if ((Branch2 & NewBranch + Jump2) == 1) begin
                   count_bubble = count_bubble + 1;
                end
             end
    end
    
    always @(posedge clock) begin 
        if (qflash == 1000000) begin
            clk <= ~clk;
            qflash <= 0;
        end
        else
            qflash = qflash + 1;
     end
     
     seven_segment_decoder
         ssd1(.in(disp[3:0]), .out(seven1)),
         ssd2(.in(disp[7:4]), .out(seven2)),
         ssd3(.in(disp[11:8]), .out(seven3)),
         ssd4(.in(disp[15:12]), .out(seven4)),
         ssd5(.in(disp[19:16]), .out(seven5)),
         ssd6(.in(disp[23:20]), .out(seven6)),
         ssd7(.in(disp[27:24]), .out(seven7)),
         ssd8(.in(disp[31:28]), .out(seven8));
         
 
     always @(posedge clock) begin
         if (qscan == 100000) begin
             scan <= ~scan;
             qscan <= 0;
         end else begin
             qscan <= qscan + 1;
         end
     end
    
     
     always @(posedge scan) begin
     //always @(posedge clk) begin
         if (~mie[0]) begin
             mie = 8'b11111101;
             eight_decode = seven2;
         end else if (~mie[1]) begin
             mie = 8'b11111011;
             eight_decode = seven3;
         end else if (~mie[2]) begin
             mie = 8'b11110111;
             eight_decode = seven4;
         end else if (~mie[3]) begin
             mie = 8'b11101111;
             eight_decode = seven5;
         end else if (~mie[4]) begin
             mie = 8'b11011111;
             eight_decode = seven6;
         end else if (~mie[5]) begin
             mie = 8'b10111111;
             eight_decode = seven7;
         end else if (~mie[6]) begin
             mie = 8'b01111111;
             eight_decode = seven8;
         end else if (~mie[7]) begin
             mie = 8'b11111110;
             eight_decode = seven1;
         end
     end

     always @* begin 
        if(clear) begin
            pred_result <= 0;
            PC_query <= 0;
            PC_update <= 0;
            Next_PC_asm <= 0;
            PC_Next_new <= PC_Next;
            query <= 0;
            store <= 0;
            Bubble_f_new <= 0;
        end
        else begin
            if (Branch == 1 || Branch2 == 1) begin
                if(Branch == 1) begin
                    // query
                    PC_query <= PC1;
                    query <= 1;
                    PC_Next_new <= predict_res;
                end
                if(Branch2 == 1) begin
                    // update result
                    store <= 1;
                    if (((NewBranch == 1) && (predict_res2 == PC_Next))
                        || ((NewBranch == 0) && (predict_res2 == PC2 + 4))) 
                    begin
                        pred_result <= 1;
                        PC_update <= PC2;
                        Next_PC_asm <= (NewBranch == 1) ? PC_Next : PC2 + 4;
                        Bubble_f_new <= 0;
                    end
                    else begin
                        pred_result <= 0;
                        PC_update <= PC2;
                        Next_PC_asm <= (NewBranch == 1) ? PC_Next : PC2 + 4;
                        // Bubble_f_new <= Bubble_f;
                        Bubble_f_new <= 1;
                    end
                end
            end
            else begin 
                pred_result <= 0;
                PC_update <= 0;
                PC_query <= 0;
                Next_PC_asm <= 0;
                PC_Next_new <= PC_Next;
                Bubble_f_new <= 0;
                query <= 0;
                store <= 0;
            end
        end
     end
    
    // assign Bubble_f_new = (~pred_result) & Bubble_f;
     
    always @(posedge Branch or posedge clear) begin
        if (clear)
            branch_num <= 0;
        else
            branch_num = branch_num + 1;
    end
    
    always @(posedge clk or posedge clear) begin
        if (clear)
            success_num <= 0;
        else if (pred_result)
            success_num = success_num + 1;
    end
    
    // IR_Branch2 irb2 (.IR(IR0), .Branch(Branch));

    Associative_Memory asm (
        .clk(clk),
        .clear(clear),
        .query(query),
        .store(store),
        .pred_result(pred_result),      // 上次的预测结�?
        .PC_query(PC_query),            // 要预测或存储的PC
        .PC_update(PC_update),
        .Next_PC(Next_PC_asm),          // 实际下一条PC
        .success(query_res),            // 查询结果
        .predict(predict_res)           // 预测结果
    );

    IF if_module (
        .clk(clk), 
        .clear(clear), 
        .Bubble(Bubble), 
        .Bubble_j(Bubble_j), 
        .Halt4(Halt4), 
        .SysCall4(SysCall4), 
        .Jump2(Jump2), 
        .PC_Next(PC_Next), 
        .NewBranch(NewBranch), 
        .PC1(PC1), 
        .IR1(IR1), 
        .PCnext1(PCnext1), 
        .NewHalt(NewHalt),
        .PC_pred(PC_Next_new),
        .chose_pred(Branch),
        .IR0(IR0),
        .predict(pred_result),
        .Next_PC_asm(Next_PC_asm),
        .Bubble_f_new(Bubble_f_new)
    );

    ID id_module (
        .clk(clk),    // Clock
        .clear(clear), // Clock Enable
        .NewHalt(NewHalt),
        .Bubble(Bubble),
        .Bubble_f(Bubble_f_new),
        .RegWrite4(RegWrite4),
        .PCtoReg4(PCtoReg4),
        .RW4(RW4),
        .PC1(PC1), 
        .IR1(IR1), 
        .PCnext1(PCnext1),
        .PC4(PC4),
        .WB_Out(WB_Out),
        .MEM_NM_(MEM_NM_), 
        .WB_Data_(WB_Data_), 
        .WB_NM_(MEM_NM),
        .Bypass1(Bypass1), 
        .Bypass2(Bypass2), 
        .Bypass3(Bypass3), 
        .Bypass4(Bypass4),
        .Bypass12(Bypass12), 
        .Bypass22(Bypass22), 
        .Bypass32(Bypass32), 
        .Bypass42(Bypass42),
        .MemWrite2(MemWrite2),
        .MemRead2(MemRead2),
        .SelectBase2(SelectBase2),
        .SysCall2(SysCall2),
        .MemToReg2(MemToReg2),
        .Branch2(Branch2),
        .AluControl2(AluControl2),
        .Jump2(Jump2),
        .PC2(PC2),
        .IR2(IR2),
        .reg22(reg22),
        .reg42(reg42),
        .X2(X2),
        .Y2(Y2),
        .regData2(regData2),
        .IMMI2(IMMI2),
        .PCnext2(PCnext2),
        .IMMJ2(IMMJ2),
        .RegWrite2(RegWrite2),
        .RW2(RW2),
        .PCtoReg2(PCtoReg2),
        .R1_addr(R1_addr),
        .R2_addr(R2_addr),
        .JmpReg(JmpReg),
        .Jump(Jump),
        .R1Src(R1Src),
        .RegDst(RegDst),
        .Branch(Branch)
    );

    EX ex_module(
        .clk(clk),
        .clear(clear),
        .NewHalt(NewHalt),
        .Bypass12(Bypass12), 
        .Bypass22(Bypass22), 
        .Bypass32(Bypass32), 
        .Bypass42(Bypass42),
        .MemWrite2(MemWrite2),
        .MemRead2(MemRead2),
        .SelectBase2(SelectBase2),
        .SysCall2(SysCall2),
        .MemToReg2(MemToReg2),
        .Branch2(Branch2),
        .AluControl2(AluControl2),
        .Jump2(Jump2),
        .PC2(PC2),
        .IR2(IR2),
        .reg22(reg22),
        .reg42(reg42),
        .X2(X2),
        .Y2(Y2),
        .regData2(regData2),
        .IMMI2(IMMI2),
        .PCnext2(PCnext2),
        .IMMJ2(IMMJ2),
        .RegWrite2(RegWrite2),
        .RW2(RW2),
        .PCtoReg2(PCtoReg2),
        .WB_NM(WB_NM),
        .WB_Data(WB_Data),
        .SysCall3(SysCall3),
        .Halt3(Halt3),
        .MemToReg3(MemToReg3),
        .MemWrite3(MemWrite3),
        .MEM_NM(MEM_NM),
        .Addr(Addr),
        .Data(Data),
        .MemRead3(MemRead3),
        .PC3(PC3),
        .IR3(IR3),
        .RegWrite3(RegWrite3),
        .RW3(RW3),
        .PCtoReg3(PCtoReg3),
        .PC_Next(PC_Next),
        .MEM_NM_(MEM_NM_),
        .display(display),
        .NewBranch(NewBranch)
    );

    MEM mem_module (
        .clk(clk),
        .clear(clear),
        .NewHalt(NewHalt),
        .SysCall3(SysCall3),
        .Halt3(Halt3),
        .MemToReg3(MemToReg3),
        .MemWrite3(MemWrite3),
        .MEM_NM(MEM_NM),
        .Addr(Addr),
        .Data(Data),
        .MemRead3(MemRead3),
        .PC3(PC3),
        .IR3(IR3),
        .RegWrite3(RegWrite3),
        .RW3(RW3),
        .PCtoReg3(PCtoReg3),
        .SysCall4(SysCall4),
        .Halt4(Halt4),
        .MemToReg4(MemToReg4),
        .WB_NM(WB_NM),
        .WB_Data(WB_Data),
        .PC4(PC4),
        .IR4(IR4),
        .RegWrite4(RegWrite4),
        .RW4(RW4),
        .PCtoReg4(PCtoReg4),
        .WB_Data_(WB_Data_)
    );

    WB wb_module (
        .clk(clk),
        .clear(clear),
        .NewHalt(NewHalt),
        .SysCall4(SysCall4),
        .Halt4(Halt4),
        .MemToReg4(MemToReg4),
        .WB_NM(WB_NM),
        .WB_Data(WB_Data),
        .PC4(PC4),
        .IR4(IR4),
        .RegWrite4(RegWrite4),
        .RW4(RW4),
        .PCtoReg4(PCtoReg4),
        .RegDin(WB_Out)
    );

    Redirect redirect_md (
        .R1(R1_addr),
        .R2_(R2_addr),
        .IR1(IR1),
        .RW2(RW2),
        .RW3(RW3),
        .Branch(NewBranch),
        .JmpReg(JmpReg),
        .Jump(Jump),
        .MemR(MemRead3),
        .RegW2(RegWrite2),
        .RegW3(RegWrite3),
        .R1Src(R1Src + (~RegDst)),
        .Bypass1(Bypass1),
        .Bypass2(Bypass2),
        .Bypass3(Bypass3),
        .Bypass4(Bypass4),
        .Bubble(Bubble),
        .Bubble_f(Bubble_f),
        .Bubble_j(Bubble_j),
        .LoadUse(LoadUse),
        .Bubble_f_new(Bubble_f_new)
    );

endmodule

module IR_Branch2 (IR, Branch);
    input wire [31:0] IR;
    output Branch;

    wire [5:0] op;
    wire [5:0] funct;
    wire [4:0] RW, Rs, Rt, Rd, Shamt;
    wire [15:0] IMMI;
    wire [25:0] IMMJ;

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
    assign beq = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (~op[1]) & (~op[0]);
    assign bne = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (~op[1]) & (op[0]);
    assign bgtz = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (op[1]) & (op[0]);
    
    assign Branch = beq + bne + bgtz;

endmodule
