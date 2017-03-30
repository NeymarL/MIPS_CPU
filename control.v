`timescale 1ns / 1ps

module control(op,func,,Extype,RegDst,AluShift,R1Src,RegWrite,PCtoReg,W31,Jump,AluSrc,Branch,
    MemWrite,MemRead,SysCall,MemtoReg,JmpReg,ALUop, SelectBase);

    input [5:0]op;
    input [5:0]func;
    wire add, addi, addiu, addu, and1, andi, sll, sra, srl, sub, or1, ori;
    wire nor1, lw, beq, bne, slt, slti, sltu, j, jal, jr, syscall, sw;
    output wire Extype,RegDst,AluShift,R1Src,RegWrite,PCtoReg,W31;
    output wire Jump,AluSrc,Branch,MemWrite,MemRead,SysCall,MemtoReg,JmpReg;
    wire Add, Sub, And, Or, Nor, SLL, SRL, SRA, SLTU, SLT;
    output wire [3:0]ALUop;
    output wire SelectBase;
    wire xori, sltiu, sh, bgtz;
    
    

    IC0 ic0(.op(op), .func(func), .add(add), .addi(addi), .addiu(addiu), 
        .addu(addu), .and1(and1), .andi(andi), .sll(sll), .sra(sra), 
        .srl(srl), .sub(sub), .or1(or1), .ori(ori));
    
    IC1 ic1(.op(op), .func(func), .nor1(nor1), .lw(lw), .sw(sw), .beq(beq), .bne(bne),
     .slt(slt), .slti(slti), .sltu(sltu), .j(j), .jal(jal), .jr(jr), .syscall(syscall));

    IC2 ic2(.op(op), .xori(xori), .sltiu(sltiu), .sh(sh), .bgtz(bgtz));

    ALUop_Creator aluc(.add(add), .addi(addi), .addiu(addiu), .addu(addu), .lw(lw),
    .sw(sw), .sub(sub), .and1(and1), .andi(andi), .or1(or1), .ori(ori), 
    .nor1(nor1), .sll(sll), .srl(srl), .sra(sra), .sltu(sltu), .slt(slt), 
    .slti(slti), .Add(Add), .Sub(Sub), .And(And), .Or(Or), .Nor(Nor), .SLL(SLL),
    .SRL(SRL), .SRA(SRA), .SLTU(SLTU), .SLT(SLT));

    ALU_Control aluctrl(.Add(Add), .Sub(Sub), .And(And), .Or(Or), .Nor(Nor), 
        .SRA(SRA), .SLTU(SLTU), .SLT(SLT), .SRL(SRL), .sh(sh), .bgtz(bgtz), 
        .sltiu(sltiu), .xori(xori), .ALUop(ALUop));

    Signal_Creator sc(.add(add), .addu(addu), .and1(and1), .sll(sll), .sra(sra),
    .srl(srl), .sub(sub), .or1(or1), .nor1(nor1), .slt(slt), .addi(addi),
    .andi(andi), .addiu(addiu), .ori(ori), .lw(lw), .slti(slti), .sltu(sltu),
    .jal(jal), .j(j), .jr(jr), .sw(sw), .beq(beq), .bne(bne), .syscall(syscall),
    .Extype(Extype), .RegDst(RegDst), .AluShift(AluShift), .R1Src(R1Src), .RegWrite(RegWrite), 
    .PCtoReg(PCtoReg), .W31(W31), .AluSrc(AluSrc), .MemWrite(MemWrite),
    .MemRead(MemRead), .MemtoReg(MemtoReg), .Jump(Jump), .Branch(Branch), 
    .SysCall(SysCall), .JmpReg(JmpReg), .sh(sh), .bgtz(bgtz), .sltiu(sltiu), .xori(xori), 
    .SelectBase(SelectBase));

    assign addi_out = addi;
endmodule


module IC0(op, func, add, addi, addiu, addu, and1, andi, sll, sra, srl, sub, or1, ori);

    input [5:0]op;
    input [5:0]func;
    output wire add, addi, addiu, addu, and1, andi, sll, sra, srl, sub, or1, ori;

    assign 
    add = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(~func[2])&(~func[1])&(~func[0]),
    addi = (~op[5])&(~op[4])&(op[3])&(~op[2])&(~op[1])&(~op[0]),
    addiu = (~op[5])&(~op[4])&(op[3])&(~op[2])&(~op[1])&(op[0]),
    addu = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(~func[2])&(~func[1])&(func[0]),
    and1 = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(func[2])&(~func[1])&(~func[0]),
    andi = (~op[5])&(~op[4])&(op[3])&(op[2])&(~op[1])&(~op[0]),
    sll = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(~func[5])&(~func[4])&(~func[3])&(~func[2])&(~func[1])&(~func[0]),
    sra = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(~func[5])&(~func[4])&(~func[3])&(~func[2])&(func[1])&(func[0]),
    srl = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(~func[5])&(~func[4])&(~func[3])&(~func[2])&(func[1])&(~func[0]),
    sub = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(~func[2])&(func[1])&(~func[0]),
    or1 = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(func[2])&(~func[1])&(func[0]),
    ori = (~op[5])&(~op[4])&(op[3])&(op[2])&(~op[1])&(op[0]);

endmodule


module IC1(op, func, nor1, lw, sw, beq, bne, slt, slti, sltu, j, jal, jr, syscall);
    
    input [5:0]op;
    input [5:0]func;
    output wire nor1, lw, sw, beq, bne, slt, slti, sltu, j, jal, jr, syscall;

    assign 
    nor1 = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(~func[3])&(func[2])&(func[1])&(func[0]),
    lw = (op[5])&(~op[4])&(~op[3])&(~op[2])&(op[1])&(op[0]),
    sw = (op[5])&(~op[4])&(op[3])&(~op[2])&(op[1])&(op[0]),
    beq = ((~op[5])&(~op[4])&(~op[3])&(op[2])&(~op[1])&(~op[0])),
    bne = ((~op[5])&(~op[4])&(~op[3])&(op[2])&(~op[1])&(op[0])),
    slt = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(func[3])&(~func[2])&(func[1])&(~func[0]),
    slti = (~op[5])&(~op[4])&(op[3])&(~op[2])&(op[1])&(~op[0]),
    sltu = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(func[5])&(~func[4])&(func[3])&(~func[2])&(func[1])&(func[0]),
    j = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(op[1])&(~op[0]),
    jal = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(op[1])&(op[0]),
    jr = (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(~func[5])&(~func[4])&(func[3])&(~func[2])&(~func[1])&(~func[0]),
    syscall= (~op[5])&(~op[4])&(~op[3])&(~op[2])&(~op[1])&(~op[0])&(~func[5])&(~func[4])&(func[3])&(func[2])&(~func[1])&(~func[0]);

endmodule

module IC2 (op, xori, sltiu, sh, bgtz);
    input [5:0] op;
    output xori, sltiu, sh, bgtz;

    assign xori = (~op[5]) & (~op[4]) & (op[3]) & (op[2]) & (op[1]) & (~op[0]);
    assign sltiu = (~op[5]) & (~op[4]) & (op[3]) & (~op[2]) & (op[1]) & (op[0]);
    assign sh = (op[5]) & (~op[4]) & (op[3]) & (~op[2]) & (~op[1]) & (op[0]);
    assign bgtz = (~op[5]) & (~op[4]) & (~op[3]) & (op[2]) & (op[1]) & (op[0]);
endmodule


module ALUop_Creator(add, addi, addiu, addu, lw, sw, sub, and1, andi, or1, ori, 
    nor1, sll, srl, sra, sltu, slt, slti, Add, Sub, And, Or, Nor, SLL, SRL, SRA, SLTU, SLT);

    input add, addi, addiu, addu, lw, sw, sub, and1, andi, or1, ori;
    input nor1, sll, srl, sra, sltu, slt, slti;
    output wire Add, Sub, And, Or, Nor, SLL, SRL, SRA, SLTU, SLT;
    assign
        Add = add + addi + addiu + addu + lw + sw,
        Sub = sub,
        And = and1 + andi,
        Or = or1 + ori,
        Nor = nor1,
        SLL = sll,
        SRL = srl,
        SRA  = sra,
        SLTU = sltu,
        SLT = slt + slti;

endmodule

module ALU_Control(Add, Sub, And, Or, Nor, SRA, SLTU, SLT, 
                   SRL, sh, bgtz, sltiu, xori, ALUop);
    input Add, Sub, And, Or, Nor, SRA, SLTU, SLT, SRL;
    input  sh, bgtz, sltiu, xori;
    output wire [3:0]ALUop;

    assign
        ALUop[0] = SRA + Add + And + SLT + bgtz + xori + sh,
        ALUop[1] = SRL + Sub + And + Nor + SLT + bgtz,
        ALUop[2] = Add + Sub + And + SLTU + sltiu + sh,
        ALUop[3] = Or + Nor + SLTU + SLT + sltiu + bgtz + xori;

endmodule

module Signal_Creator(add, addu, and1, sll, sra, srl, sub, or1, nor1, slt, addi
    ,andi, addiu, ori, lw, slti, sltu, jal, j, jr, sw, beq, bne, syscall,
    Extype, RegDst, AluShift, R1Src, RegWrite, PCtoReg, W31, AluSrc, MemWrite,
    MemRead, MemtoReg, Jump, Branch, SysCall, JmpReg, sh, bgtz, sltiu, xori, SelectBase);

    input add, addu, and1, sll, sra, srl, sub, or1, nor1, slt, addi
    ,andi, addiu, ori, lw, slti, sltu, jal, j, jr, sw, beq, bne, syscall,
    sh, bgtz, sltiu, xori;

    output wire Extype, RegDst, AluShift, R1Src, RegWrite, PCtoReg, W31, AluSrc, MemWrite,
    MemRead, MemtoReg, Jump, Branch, SysCall, JmpReg, SelectBase;

    assign
    Extype = andi + ori + sltiu + xori,
    RegDst = add + addu + and1 + sll + sra + srl + sub + or1 + nor1 +slt,
    AluShift = sll + sra + srl,
    R1Src = sll + sra + srl,
    RegWrite = add + addi + addiu + addu + and1+ andi + sll + sra + srl + sub 
    + or1 + ori + nor1 + slt + slti + sltu + jal + sltiu + xori + lw,
    PCtoReg = jal,
    W31 = jal,
    AluSrc = addi + addiu + andi + ori + lw + sw + slti + sh + sltiu + xori,
    MemWrite = sw + sh,
    MemRead = lw,
    MemtoReg = lw,
    Jump = j + jal + jr,
    Branch = beq + bne + bgtz,
    SysCall = syscall,
    JmpReg = jr,
    SelectBase = sh;

endmodule

