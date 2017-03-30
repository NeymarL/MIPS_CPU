`timescale 1ns / 1ps

module Associative_Memory (
    input clk,
    input clear,
    input pred_result,          // 上次的预测结�?
    input wire query,
    input wire store,
    input wire [31:0] PC_query, // 要预测的PC
    input wire [31:0] PC_update,
    input wire [31:0] Next_PC,  // 实际下一条PC
    output reg success,         // 查询结果
    output reg [31:0] predict   // 预测结果
);

    reg [31:0] PC_Store [31:0];
    reg [31:0] Branch_Addr [31:0];
    reg [1:0] Predict_State [31:0];
    reg [6:0] Used [31:0];
    integer i;
    integer update = 0;
    integer has_empty = 0;
    integer max_used = 0;
    integer max_index = 0;

    parameter 
        Strong_not_token = 0, 
        Weak_not_token = 1, 
        Weak_token = 2, 
        Strong_token = 3;

    always @(posedge clear or posedge query or posedge store) begin
    //always @(clk or clear) begin
        if (clear) begin
            for (i = 0; i < 32; i = i + 1) begin
                
                //Branch_Addr[i] <= 0;
                // Predict_State[i] <= Strong_token;
                Used[i] <= 0;
            end
            predict <= 0;
            success <= 0;
        end
        else begin
            // predict
            success <= 0;
            if (query) begin
                for (i = 0; i < 32; i = i + 1) begin
                    if (PC_query == PC_Store[i]) begin
                        success <= 1;
                        predict <= Branch_Addr[i];
                        // 把Used位置�?
                        Used[i] <= 0;
                        // 其他行的Used位加1
                    end
                    else begin 
                        Used[i] <= Used[i] + 1;
                    end
                end
            end
           
       end
            
    end

    always @(negedge clk) begin
        /*if (store) begin
            PC_Store[0] = PC_update;
            Branch_Addr[0] = Next_PC;
        end*/
        if (clear) begin
            for (i = 0; i < 32; i = i + 1) begin
                Branch_Addr[i] <= 0;
                Predict_State[i] <= Strong_token;
                PC_Store[i] <= -1;
            end
        end
        if (store) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (PC_Store[i] == PC_update) begin
                    update = 1;
                    case (Predict_State[i])
                        Strong_not_token:
                            if(pred_result) begin
                                Predict_State[i] <= Strong_not_token;
                            end
                            else begin 
                                Predict_State[i] <= Weak_not_token;
                            end
                        Weak_not_token:
                            if(pred_result) begin
                                Predict_State[i] <= Strong_not_token;
                            end
                            else begin 
                                Predict_State[i] <= Weak_token;
                                Branch_Addr[i] <= Next_PC;
                            end
                        Weak_token:
                            if(pred_result) begin
                                Predict_State[i] <= Weak_not_token;
                            end
                            else begin 
                                Predict_State[i] <= Strong_token;
                                Branch_Addr[i] <= Next_PC;
                            end
                        Strong_token:
                            if (pred_result) begin 
                                Predict_State[i] <= Weak_token;
                                Branch_Addr[i] <= Next_PC;
                            end
                            else begin 
                                Predict_State[i] <= Strong_token;
                                Branch_Addr[i] <= Next_PC;
                            end
                    endcase // Predict_State[i]
                end
            end
            if(update == 0) begin
                // 判断有没有空�?
                for (i = 0; i < 32 && has_empty == 0; i = i + 1) begin
                    if(PC_Store[i] == -1) begin
                        has_empty = 1;
                        Predict_State[i] = Strong_not_token;
                        PC_Store[i] = PC_update;
                        Branch_Addr[i] = Next_PC;
                    end
                end
                if(has_empty == 0) begin
                    // 找Used�?大的淘汰
                    for (i = 0; i < 32; i = i + 1) begin
                        if(Used[i] > max_used) begin
                            max_used = Used[i];
                            max_index = i;
                        end
                    end
                    Predict_State[max_index] = Strong_not_token;
                    PC_Store[max_index] = PC_update;
                    Branch_Addr[max_index] = Next_PC;
                end
            end
            has_empty <= 0;
            update <= 0;
        end
    end
        


endmodule
