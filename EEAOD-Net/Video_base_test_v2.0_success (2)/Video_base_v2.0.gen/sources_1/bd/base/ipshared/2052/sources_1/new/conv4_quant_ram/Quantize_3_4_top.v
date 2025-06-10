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


module Quantize_3_4_top (
    input clk,//系统时钟
    input rstn,//系统复位
    input Quantize_en,//Quantize节点使能信号
    output Quantize_valid,//Quantize输出有效信号
    input [23:0]qx,//输入8bit数据
    output [23:0]qy//输出重量化后8bit数据
    );
    //参数定义
    localparam WIDTH = 8;
    localparam M = 16'd249;
    localparam SHIFT = 8;
    
    //模块实例化
    Quantize_3_4 # (
        .WIDTH(WIDTH),
        .M(M),
        .SHIFT(SHIFT)
    )Quantize_3_4_1 (
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(Quantize_en),
        .Quantize_valid(Quantize_valid),
        .qx(qx[23:16]),
        .qy(qy[23:16])
    );

    Quantize_3_4 # (
        .WIDTH(WIDTH),
        .M(M),
        .SHIFT(SHIFT)
    )Quantize_3_4_2 (
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(Quantize_en),
        .Quantize_valid(),
        .qx(qx[15:8]),
        .qy(qy[15:8])
    );

    Quantize_3_4 # (
        .WIDTH(WIDTH),
        .M(M),
        .SHIFT(SHIFT)
    )Quantize_3_4_3 (
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(Quantize_en),
        .Quantize_valid(),
        .qx(qx[7:0]),
        .qy(qy[7:0])
    );
    
endmodule
