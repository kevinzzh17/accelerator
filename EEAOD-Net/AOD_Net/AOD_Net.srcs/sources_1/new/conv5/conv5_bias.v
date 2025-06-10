`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/03 18:46:35
// Design Name:
// Module Name: bais
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv5_bais#(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3
)(
    input clk,
    input rstn,
    input bais_en,//使能
    input signed [3*WIDTH-2:0] pe2bias,//data_in,23bit
    output reg bais_valid,//输出有效
    output reg signed [21:0] bais2relu//data_out,22bit
);
    reg signed [2*WIDTH-1:0] M_RF [2:0];//M存储
    reg signed [2*WIDTH-1:0] B_RF [2:0];//bais存储
    reg signed [37:0] data_m =0;//M*PE的数据
    reg signed [2*WIDTH-1:0] Bais =0;//bais
    reg [1:0] cnt=0;
    reg flag=0;
    
    reg signed [3*WIDTH-2:0] pe2bias_reg=0;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pe2bias_reg<=0;
        end
        else begin
            pe2bias_reg<=pe2bias;
        end
    end

    initial begin
        M_RF[0] = 16'd62;
        M_RF[1] = 16'd69;
        M_RF[2] = 16'd65;
        B_RF[0] = 16'd166;
        B_RF[1] = 16'd168;
        B_RF[2] = 16'd161;
    end
    
    ///cnt 控制信号
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            flag<=0;
        end
        else if(bais_en) begin
            flag<=1;
        end
        else if(cnt==2) begin
            flag<=0;
        end
        else begin
            flag<=flag;
        end
    end
    
    //cnt++
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt<=0;
        end
        else if(cnt==2) begin
            cnt<=0;
        end
        else if(flag)begin
            cnt<=cnt+1;
        end
        else begin
            cnt<=cnt;
        end
    end

    //
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_m<=0;
            Bais<=0;
            bais2relu<=0;
        end
        else begin
            data_m<=pe2bias_reg*M_RF[cnt];//DATA*M
            Bais<=B_RF[cnt];//缓存一下Bias
            bais2relu<=(data_m>>>16)+Bais;//(M*DATA)>>>16+Bias
        end
    end

    //bias_valid信号
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bais_valid<=0;
        end
        else if(cnt==1) begin
            bais_valid<=1;
        end
        else begin
            bais_valid<=0;
        end
    end

endmodule
