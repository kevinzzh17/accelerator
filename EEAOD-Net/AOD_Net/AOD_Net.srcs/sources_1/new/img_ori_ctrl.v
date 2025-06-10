`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 17:10:35
// Design Name: 
// Module Name: img_ori_ctrl
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


module img_ori_ctrl#(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter PIX_W =640,
    parameter addr_width = 13,
    parameter channel_out=3
)(  
    input clk,//系统时钟
    input rstn,//系统复位
    input en,//image使能信号
    input [channel_in*WIDTH-1:0] data_in,//RGB888数据
    input en_conv5,
    input conv_stop,
    output [channel_out*WIDTH-1:0] data_out//输出重量化后三通道信号
    );

    reg [addr_width-1:0] addra;
    reg [addr_width-1:0] addrb;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            addra <= 0;
        end
        else if(conv_stop||addra==PIX_W*7+29)begin
            addra <= 0;  
        end
        else if(en)begin
            addra <= addra + 1;
        end
        else begin
            addra <= addra;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            addrb <= 0;
        end
        else if(conv_stop||addrb==PIX_W*7+29)begin
            addrb <= 0;  
        end
        else if(en_conv5)begin
            addrb <= addrb + 1;
        end
        else begin
            addrb <= addrb;
        end
    end

    RAM_c5_cal your_instance_name (
    .clka(clk),    // input wire clka
    .ena(1'b1),      // input wire ena
    .wea(en),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [12 : 0] addra
    .dina(data_in),    // input wire [23 : 0] dina
    .clkb(clk),    // input wire clkb
    .enb(en_conv5),      // input wire enb
    .addrb(addrb),  // input wire [12 : 0] addrb
    .doutb(data_out)  // output wire [23 : 0] doutb
    );
endmodule
