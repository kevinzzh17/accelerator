`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/04 18:04:46
// Design Name:
// Module Name: rearrange
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


module conv5_rearrange#(
    parameter WIDTH = 8,
    parameter channel_in=6,
    parameter channel_out=3,
    parameter kernel_size=3
)(
    input clk,
    input rstn,
    input rearrange_en,//使能信号，data有效信号
    input conv_stop,
    input [kernel_size*kernel_size*channel_in*WIDTH-1:0] data2rearrange,//数据的输入,432bit
    output reg [2:0] state,//状态机
    output reg [3:0] cnt,//用于状态机的计数器
    output reg [WIDTH*kernel_size*kernel_size-1:0] data2pe_1,
    output reg [WIDTH*kernel_size*kernel_size-1:0] data2pe_2//排完后的数据，交替按通道依次输入pe单元
);
reg conv_stop_r;//计算完成640*480后拉高
    reg [kernel_size*kernel_size*WIDTH-1:0] channel_RF [channel_in-1:0];//将输入的数据进行数据重排，WHC变成CWH
    reg en_r;
    //WHC变成CWH
    integer i,j;
    always @(*) begin
        for ( i=0 ;i<channel_in ;i=i+1 ) begin
            for ( j=0 ;j<kernel_size*kernel_size;j=j+1 ) begin
                channel_RF[i][(kernel_size*kernel_size*WIDTH-1-j*WIDTH)-:WIDTH]= data2rearrange[(kernel_size*kernel_size*channel_in*WIDTH-1-WIDTH*channel_in*j-WIDTH*i)-:WIDTH];
            end
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            conv_stop_r<=0;
        end
        else if(conv_stop) begin
            conv_stop_r<=1;
        end
        else conv_stop_r<=0;
    end

    //状态机的参数
    parameter IDLE  = 3'b000;//空闲
    parameter C1    = 3'b001;//channel1
    parameter C2    = 3'b010;//channel2
    parameter C3    = 3'b011;//channel3

    // always @(posedge clk or negedge rstn) begin
    //     if (!rstn) begin
    //         en_r<=0;
    //     end
    //     else begin
    //         en_r<=rearrange_en;
    //     end
    // end
    //状态机
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state<=0;
            cnt<=0;
        end
        else if (conv_stop_r) begin
            state<=IDLE;
            cnt<=0;
            // conv_stop_r<=0;
        end
        else begin
            case (state)
                IDLE: begin
                    cnt<=cnt;
                    if (rearrange_en) begin
                        state<=C1;
                    end
                    else begin
                        state<=IDLE;
                    end
                end
                C1:begin
                    if (cnt==2) begin
                        state<=C2;
                        cnt<=0;
                    end
                    else begin
                        state<=C1;
                        cnt<=cnt+1;
                    end
                end
                C2:begin
                    if (cnt==2) begin
                        state<=C3;
                        cnt<=0;
                    end
                    else begin
                        state<=C2;
                        cnt<=cnt+1;
                    end
                end
                C3:begin
                    if (cnt==2) begin
                        state<=C1;
                        cnt<=0;
                    end
                    else begin
                        state<=C3;
                        cnt<=cnt+1;
                    end
                end
                                default: begin
                    cnt<=cnt;
                    state<=IDLE;
                end
            endcase
        end
    end

    //数据选择器，选择哪个通道上的数据进pe
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data2pe_1 <=0;
            data2pe_2 <=0;
        end
        else begin
            case (state)
            IDLE: begin
                data2pe_1 <=0;
                data2pe_2 <=0;
            end
            C1: begin
                if(cnt==0)begin
                    data2pe_1 <=channel_RF[0];
                    data2pe_2 <=channel_RF[0];
                end
                else if(cnt==1)begin
                    data2pe_1 <=channel_RF[0];
                    data2pe_2 <=channel_RF[1];
                end
                else if(cnt==2)begin
                    data2pe_1 <=channel_RF[1];
                    data2pe_2 <=channel_RF[1];
                end
                else begin
                    data2pe_1 <=data2pe_1;
                    data2pe_2 <=data2pe_2;
                end 
            end
            C2: begin
                if(cnt==0)begin
                    data2pe_1 <=channel_RF[2];
                    data2pe_2 <=channel_RF[2];
                end
                else if(cnt==1)begin
                    data2pe_1 <=channel_RF[2];
                    data2pe_2 <=channel_RF[3];
                end
                else if(cnt==2)begin
                    data2pe_1 <=channel_RF[3];
                    data2pe_2 <=channel_RF[3];
                end
                else begin
                    data2pe_1 <=data2pe_1;
                    data2pe_2 <=data2pe_2;
                end 
            end
            C3: begin
                if(cnt==0)begin
                    data2pe_1 <=channel_RF[4];
                    data2pe_2 <=channel_RF[4];
                end
                else if(cnt==1)begin
                    data2pe_1 <=channel_RF[4];
                    data2pe_2 <=channel_RF[5];
                end
                else if(cnt==2)begin
                    data2pe_1 <=channel_RF[5];
                    data2pe_2 <=channel_RF[5];
                end
                else begin
                    data2pe_1 <=data2pe_1;
                    data2pe_2 <=data2pe_2;
                end 
            end
            default:begin
                data2pe_1 <=0;
                data2pe_2 <=0;
            end
        endcase
        end
    end
endmodule
