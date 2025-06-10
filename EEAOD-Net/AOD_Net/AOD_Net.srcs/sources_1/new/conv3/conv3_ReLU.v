`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: LionelZhao
//
// Create Date: 2023/07/24 09:03:50
// Design Name: Conv_3qy3
// Module Name: ReLU
// Project Name:
// Target Devices:
// Tool Versions:
// Description: ReLU激活函数实现
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv3_ReLU#(
    parameter WIDTH = 8
)
(
    input clk,
    input rstn,
    input signed [21:0]qy,//输入数据
    output reg signed [WIDTH-1:0]q_relu //输出数据
    );

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            q_relu <= 0;
        end
        else begin
            if (qy>127) begin
                q_relu<=127;
            end
            else if(qy<-128) begin
                q_relu<=-128;
            end
            else q_relu<=qy;
        end
    end


endmodule
