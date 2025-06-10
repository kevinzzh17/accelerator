`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/04 18:02:33
// Design Name:
// Module Name: Weights
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


module conv5_Weights#(
    parameter WIDTH = 8,
    parameter channel_in=6,
    parameter channel_out=3,
    parameter kernel_size=3
)(
    input clk,
    input rstn,
    input Weight_en,
    input conv_stop,
    output reg [kernel_size*kernel_size*WIDTH-1:0] weights2pe_1,
    output reg [kernel_size*kernel_size*WIDTH-1:0] weights2pe_2 //交替将weight输入两个PE中
);
    //参数定义
    localparam IDLE = 2'b00;//空闲状态
    localparam SEND = 2'b01;//权重发送状态
    localparam STOP = 2'b11;//暂停发送状态

    //信号声明
    reg [1:0] cstate=IDLE,nstate=IDLE;//状态寄存器
    reg [4:0]cnt=0;//输出控制寄存器
    wire cnt_8_flag;
    assign cnt_8_flag = (cnt == 5'd8)?1'b1:1'b0;
    reg [kernel_size*kernel_size*WIDTH-1:0] W_RF [channel_in*channel_out-1:0];//权重寄存器组

    //寄存器初始化
    initial begin
        W_RF[0]  = {8'h0c,8'hec,8'h7f,8'hfa,8'h3b,8'h0c,8'hea,8'h52,8'h11};
        W_RF[1]  = {8'hfc,8'h02,8'h6a,8'hfb,8'h1e,8'h40,8'h30,8'h05,8'h08};
        W_RF[2]  = {8'he7,8'h4a,8'h3d,8'hfe,8'h30,8'h35,8'h1a,8'h20,8'h07};
        W_RF[3]  = {8'h33,8'h34,8'h61,8'h63,8'h06,8'h61,8'h30,8'h29,8'h52};
        W_RF[4]  = {8'h1a,8'h39,8'h5e,8'h40,8'h35,8'h0a,8'h3a,8'h3b,8'h2a};
        W_RF[5]  = {8'heb,8'h60,8'h50,8'h43,8'h55,8'he2,8'h48,8'h40,8'hf5};
        W_RF[6]  = {8'h15,8'he6,8'hf2,8'h0d,8'h1e,8'h08,8'h2a,8'hcd,8'h37};
        W_RF[7]  = {8'h18,8'h15,8'hff,8'h2d,8'hf8,8'h08,8'h09,8'h03,8'h04};
        W_RF[8]  = {8'h1c,8'hf1,8'hff,8'h10,8'h02,8'h03,8'h01,8'h3f,8'h18};
        W_RF[9]  = {8'h2b,8'h21,8'hfe,8'h1f,8'h73,8'h06,8'hf8,8'h0c,8'h11};
        W_RF[10] = {8'h1c,8'h38,8'hee,8'h00,8'h5e,8'h33,8'h15,8'h08,8'hf5};
        W_RF[11] = {8'h00,8'h24,8'h09,8'h39,8'h26,8'h38,8'hdc,8'h33,8'h05};
        W_RF[12] = {8'h4f,8'h59,8'hc2,8'h4c,8'h46,8'he8,8'h77,8'h24,8'h10};
        W_RF[13] = {8'h2c,8'h57,8'hd2,8'h3b,8'h6f,8'hf2,8'h7f,8'h1a,8'hf0};
        W_RF[14] = {8'h36,8'h30,8'hed,8'h7f,8'h4d,8'he3,8'h61,8'h3c,8'hf6};
        W_RF[15] = {8'h30,8'h3c,8'hd2,8'h3c,8'h35,8'h04,8'h24,8'h0d,8'h59};
        W_RF[16] = {8'h31,8'hf2,8'h18,8'h38,8'h2f,8'h1a,8'h42,8'h0f,8'h1e};
        W_RF[17] = {8'h47,8'hf4,8'h13,8'h2f,8'h2a,8'h3b,8'h44,8'h54,8'he9};
    end

    //计数器控制逻辑
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt <= 5'd0;
        end
        else begin
            if(cnt_8_flag)begin
                cnt <= 5'd0;
            end
            else if((nstate != IDLE)||Weight_en)begin
                cnt <= cnt + 5'd1;
            end
            else begin
                cnt <= 5'd0;
            end
        end
    end

    //FSM1:状态转移时序逻辑
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cstate <= IDLE;
        end
        else begin
            cstate <= nstate;
        end
    end

    //FSM2:产生下一个状态组合逻辑
    always @(*) begin
        if(!rstn)begin
            nstate = IDLE;
        end
        else begin
            case(cstate)
                IDLE:begin
                    if(Weight_en) nstate = SEND;
                    else nstate = IDLE;
                end
                SEND:begin
                    if(conv_stop) nstate = IDLE;
                    else nstate = SEND;
                end
                default: nstate = IDLE;
            endcase
        end
    end

    //FSM3:产生输出时序逻辑
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            weights2pe_1 <= 200'd0;
        weights2pe_2 <= 200'd0;
        end
        else begin
            case(nstate)
                SEND:begin 
                    weights2pe_1 <= W_RF[2*cnt];
                    weights2pe_2 <= W_RF[2*cnt+1];
                end
                default:begin
                    weights2pe_1 <= 200'd0;
                    weights2pe_2 <= 200'd0;
                end
            endcase
        end
    end

endmodule
