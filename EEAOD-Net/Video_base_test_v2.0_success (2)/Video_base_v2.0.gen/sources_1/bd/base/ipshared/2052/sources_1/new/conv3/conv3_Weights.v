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


module conv3_Weights#(
    parameter WIDTH = 8,
    parameter channel_in=6,
    parameter channel_out=3,
    parameter kernel_size=5
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

    //信号声明
    reg [1:0] cstate=IDLE,nstate=IDLE;//状态寄存器
    reg [4:0]cnt=0;//输出控制寄存器
    wire cnt_8_flag;
    assign cnt_8_flag = (cnt == 5'd8)?1'b1:1'b0;
    reg [kernel_size*kernel_size*WIDTH-1:0] W_RF [channel_in*channel_out-1:0];//权重寄存器组

    //寄存器初始化
    initial begin
        W_RF[0]  = 200'hf80c0c07fff30bede2f9f0f7f8fefbfaf411f80bf41200fa01;
        W_RF[1]  = 200'h030009f40ffdf802fa0204ff05edfffff70006fc03effc0bed;
        W_RF[2]  = 200'hacd0c4c6a4d7d7cddaceaba8969da9c1c2b0b8bb95a09ca181;
        W_RF[3]  = 200'hfcff1802080afff2f9f71a0510060806efff20fb06f2081103;
        W_RF[4]  = 200'hff06f3f806ef0210f40d080a0209fdf7fe11fbfe0805fcf50c;
        W_RF[5]  = 200'h02fd030402fefffbfb03010103ff01ff02fffff9f8f9fcff00;
        W_RF[6]  = 200'hf807030304f804030402f21101f801fdf40b06feee0303f914;
        W_RF[7]  = 200'hfb0307fbff0afafd0402f5140304fffbfff4050afef10bf9f4;
        W_RF[8]  = 200'hc3e6eae7c2dff7fefceac4d2ded9ccd0e6eef2daa7cacfd3ac;
        W_RF[9]  = 200'h06e57ff95b09e72fd94fe1ab14db1707c408096ababd1681e6;
        W_RF[10] = 200'hcd0f1790d8df2733a60d414a6d2b7fdafc32b7ebd91d48befe;
        W_RF[11] = 200'hfd0ff4dfe4f503f2d5d7322b19111bf908f0d8dd0e1200f5f8;
        W_RF[12] = 200'he5dbedf5fa000efc04f4ebf10dff150611fc2028fdf50408f9;
        W_RF[13] = 200'hf7f603e7f1fe08fa0002fd0a0df0f1fdeb00f8ff0c02060504;
        W_RF[14] = 200'hff02000404000103050103000506fe02fffe03ff09050102ff;
        W_RF[15] = 200'h07f5f908def5fbecfed701f6f2f6f612ee0c1bef06edf102d4;
        W_RF[16] = 200'h03fe0d02fd0f021119fafafaf801010e07fc0bfafa00f3f1fe;
        W_RF[17] = 200'hfcff0105ff05fffc03020200fe0000fb03fcfffb04fc020302;
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
