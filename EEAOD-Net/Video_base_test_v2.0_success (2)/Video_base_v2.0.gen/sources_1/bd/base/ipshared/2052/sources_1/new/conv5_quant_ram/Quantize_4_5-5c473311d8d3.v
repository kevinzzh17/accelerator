`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/10 21:38:33
// Design Name: 
// Module Name: Quantize_3_4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Quantize_4_5#(
    parameter WIDTH = 8,
    parameter M = 16'd666,
    parameter SHIFT = 8
)(
    input clk,//系统时钟
    input rstn,//系统复位

    input Quantize_en,//Quantize节点使能信号
    output Quantize_valid,//Quantize输出有效信号

    input signed [WIDTH-1:0]qx,//输入8bit数据
    output signed [WIDTH-1:0]qy//输出重量化后8bit数据
    );
    //信号声明
    reg signed [WIDTH:0]Zx =  9'd128;
    reg signed [WIDTH-1:0]Zy =  -8'd128;
    always @(posedge clk) begin
        Zx <=  9'd128;
        Zy <=  -8'd128;
    end

    wire signed [WIDTH:0] add_r1;//9bit
    reg signed [3*WIDTH+3:0] mul_r=0;//9bit*19bit-->28bit
    wire signed [2*WIDTH+3:0] shift_r;//20bit
    reg signed [2*WIDTH+4:0] add_r2=0;//21bit
    reg signed [WIDTH-1:0] qy_clip=0;//8bit
    
    //Quantize_valid控制信号
    wire Quantize_en_neg_flag;//Quantize_en下降沿标志位
    reg Quantize_en_r0=0,Quantize_en_r1=1;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            Quantize_en_r0 <= 0;
            Quantize_en_r1 <= 0;
        end
        else begin
            Quantize_en_r0 <= Quantize_en;
            Quantize_en_r1 <= Quantize_en_r0;
        end
    end
    assign Quantize_en_neg_flag = Quantize_en_r1&(!Quantize_en_r0);
    assign Quantize_valid = Quantize_en_neg_flag;

    //一级流水:M*(q+128)
    assign add_r1 = qx + Zx;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            mul_r <= 0;
        end
        else if(Quantize_en)begin
            mul_r <= add_r1*M;
        end
        else begin
            mul_r <= mul_r;
        end
    end

    //二级流水:clip(M*(q+128))>>>8-128)
    assign shift_r = mul_r>>>SHIFT;
    always @(*) begin
        if(!rstn)begin
            add_r2 = 0;
        end
        else begin
            add_r2 = shift_r+Zy;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            qy_clip <= 0;
        end
        else if (add_r2 > 127) begin
            qy_clip <= 127;
        end
        else if(add_r2 < -128) begin
            qy_clip <= -128;
        end
        else begin
            qy_clip <= add_r2;
        end
    end

    //产生输出
    assign qy = qy_clip;
    
endmodule
