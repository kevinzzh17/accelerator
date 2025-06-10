`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:    sonne
//
// Create Date: 2023/08/03 18:46:10
// Design Name:
// Module Name: Weights_buffer_CTRL
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every !***!nine!***! cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv2_Weights #(
    parameter WIDTH = 8
)(
    //系统信号
    input clk,
    input rstn,
    //使能信号
    input weight_en,
    input w_stop,
    //输出权重数据
    // |[71:64]|[63:56]|[55:48]|
    // |[47:40]|[39:32]|[31:24]|
    // |[23:16]|[15:8 ]|[7 :0 ]|
    output reg [3*3*WIDTH-1:0]kernel_weights
    );


    //信号声明
    reg [9*WIDTH-1:0] W_RF [8:0];//权重寄存器组
    reg [4:0]cnt=0;//输出控制寄存器
    wire cnt_8_flag;
    reg w_en_r;


    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            w_en_r<=0;
        end
        else if(weight_en)   w_en_r<=1;
        else if(w_stop)   w_en_r<=0;  
        else  w_en_r<=w_en_r;
    end
    //寄存器初始化
    initial begin
        W_RF[0] = {8'hfd,8'h09,8'h1d,8'hf4,8'he2,8'hfc,8'h03,8'hed,8'hfa};
        W_RF[1] = {8'h32,8'h1d,8'h3c,8'hff,8'hce,8'h05,8'h8b,8'hc3,8'h1c};
        W_RF[2] = {8'h81,8'h0c,8'hd4,8'hfa,8'h23,8'h2f,8'h89,8'hfd,8'hda};
        W_RF[3] = {8'had,8'hf3,8'he5,8'h10,8'h49,8'h14,8'h81,8'hfd,8'he5};
        W_RF[4] = {8'h27,8'hc5,8'hd9,8'h26,8'h2f,8'hfd,8'hdf,8'ha0,8'h12};
        W_RF[5] = {8'h45,8'h65,8'h3d,8'h2d,8'h2f,8'h05,8'hf0,8'h0d,8'hdd};
        W_RF[6] = {8'he5,8'hfc,8'hf8,8'h12,8'h09,8'h04,8'he2,8'hfd,8'hf8};
        W_RF[7] = {8'h37,8'h3c,8'h47,8'h0a,8'hec,8'h1e,8'hd3,8'h81,8'h15};
        W_RF[8] = {8'hfa,8'h39,8'h09,8'hdb,8'h2f,8'h22,8'hcc,8'hf0,8'hf1};
    end

    //计数器控制逻辑
        assign cnt_8_flag = (cnt == 5'd8)?1'b1:1'b0;
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt <= 5'd0;
        end
        else if (w_stop) begin
            cnt <= 5'd0;
        end
        else if (w_en_r||weight_en)begin
            if(cnt_8_flag)begin
                cnt <= 5'd0;
            end
            else cnt <= cnt + 5'd1;
        end
    end
    //FSM3:产生输出时序逻辑
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            kernel_weights <= 0;
        end
        else begin
                case (cnt)
                    5'd0: kernel_weights <= W_RF[0];
                    5'd1: kernel_weights <= W_RF[1];
                    5'd2: kernel_weights <= W_RF[2];
                    5'd3: kernel_weights <= W_RF[3];
                    5'd4: kernel_weights <= W_RF[4];
                    5'd5: kernel_weights <= W_RF[5];
                    5'd6: kernel_weights <= W_RF[6];
                    5'd7: kernel_weights <= W_RF[7];
                    5'd8: kernel_weights <= W_RF[8];
                    default: kernel_weights <= 72'd0;
                endcase
            end
        end

endmodule
