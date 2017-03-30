`timescale 1ns / 1ps

module regisiter(data, enable, clock, clear, output_32);
    parameter WIDTH = 32;
    input enable,clear,clock;
    input [WIDTH-1:0] data;

    output reg [WIDTH-1:0] output_32;
    
    /*initial begin
        output_32 <= 0;
    end*/
    
    always @(posedge clock) begin
        if(clear) begin
             output_32 <= 0;
        end else if (enable)begin
             output_32 <= data;
        end
    end
    
endmodule

module selecter_two(
    a, b, s, result
);
    parameter WIDTH = 32;
    input [WIDTH-1:0] a, b;
    input s;
    output reg [WIDTH-1:0] result;
    
    always @* begin
        if (s == 0)
            result = a;
        else
            result = b;
    end
endmodule

module decoder(in, Op, Rs, Rt, Rd, Shamt, funct, IMMI, IMMJ);
    input [31:0] in;
    output wire [5:0] Op, funct;
    output wire [4:0] Rs, Rt, Rd, Shamt;
    output wire [15:0] IMMI;
    output wire [25:0] IMMJ;
    
    assign 
        Op = in[31:26],
        Rs = in[25:21],
        Rt = in[20:16],
        Rd = in[15:11],
        Shamt = in[10:6],
        funct = in[5:0],
        IMMI = in[15:0],
        IMMJ = in[25:0];
    
endmodule

module sign_extender_5_32(in, out);
    input [4:0] in;
    output [31:0] out;
    
    assign out = (in[4] == 0) ? {27'b000000000000000000000000000, in}: {27'b111111111111111111111111111, in};
    
endmodule

module sign_extender_16_32(in, out);
    input [15:0] in;
    output [31:0] out;
    
    assign out = (in[15] == 0) ? {16'b0000000000000000, in}: {16'b1111111111111111, in};
    
endmodule

module zero_extender_16_32(in, out);
    input [15:0] in;
    output [31:0] out;
    
    assign out = {16'b0000000000000000, in};
    
endmodule

module seven_segment_decoder(input [3:0] in, output reg[6:0] out);
    always @(in) begin
        case (in)
            4'b0000 : out = 7'b0000001;
            4'b0001 : out = 7'b1001111;
            4'b0010 : out = 7'b0010010;
            4'b0011 : out = 7'b0000110;
            4'b0100 : out = 7'b1001100;
            4'b0101 : out = 7'b0100100;
            4'b0110 : out = 7'b0100000;
            4'b0111 : out = 7'b0001111;
            4'b1000 : out = 7'b0000000;
            4'b1001 : out = 7'b0000100;
            4'b1010 : out = 7'b0001000;
            4'b1100 : out = 7'b0110001;
            4'b1111 : out = 7'b0111000;
            default : out = 7'b1111111;
        endcase
    end
endmodule
