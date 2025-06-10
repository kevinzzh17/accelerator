`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 09:11:08
// Design Name: 
// Module Name: Calculate_AXIS
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


module Calculate_AXIS(
    //系统时钟和复位
    input clk_100M,
    input rstn,
    //输入控制和数据信号
    input data_in_valid,
    input [23:0]data_in,
    input [23:0]data_pixel,
    //输出控制和数据信号
    output data_out_valid,
    output [23:0]data_out
    );
    //模块实例化
    Calculate_AXIS_channel  Calculate_AXIS_channel_R (
        .clk_100M(clk_100M),
        .rstn(rstn),
        .data_in_valid(data_in_valid),
        .data_in(data_in[23:16]),
        .data_pixel(data_pixel[23:16]),
        .data_out_valid(data_out_valid),
        .data_out(data_out[23:16])
    );
    Calculate_AXIS_channel  Calculate_AXIS_channel_G (
        .clk_100M(clk_100M),
        .rstn(rstn),
        .data_in_valid(data_in_valid),
        .data_in(data_in[15:8]),
        .data_pixel(data_pixel[15:8]),
        .data_out_valid(),
        .data_out(data_out[15:8])
    );
    Calculate_AXIS_channel  Calculate_AXIS_channel_B (
        .clk_100M(clk_100M),
        .rstn(rstn),
        .data_in_valid(data_in_valid),
        .data_in(data_in[7:0]),
        .data_pixel(data_pixel[7:0]),
        .data_out_valid(),
        .data_out(data_out[7:0])
    );

endmodule
