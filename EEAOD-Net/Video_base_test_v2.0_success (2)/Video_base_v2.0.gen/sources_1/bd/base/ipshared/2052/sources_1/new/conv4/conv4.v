//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/03 15:50:48
// Design Name:
// Module Name: conv3
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//1. 将输入数据
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//          1.01 - Change to output one data every nine cycles(dwft)
//          1.02 - add cnt_loop module and can cycle input,
//                 and is right when using zzh's tb.
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module conv4 #(
    parameter WIDTH = 8,
    parameter channel_in=6,
    parameter channel_out=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter kernel_size=7
)(
    input clk,
    input rstn,
    input en,//使能信号，data有效信号
    input [kernel_size*kernel_size*channel_in*WIDTH-1:0] data_in,//数据的输入,2352bit
    output reg valid,//输出有效信号
    output reg [channel_out*WIDTH-1:0] data_out//数据输出,24bit（3*8）
);
    wire [2:0] state;//状态机
    wire [3:0] cnt;//用于状态机的计数器
    wire signed [WIDTH*kernel_size*kernel_size-1:0] data2pe_1;
    wire signed [WIDTH*kernel_size*kernel_size-1:0] data2pe_2;
    wire signed [kernel_size*kernel_size*WIDTH-1:0] weights2pe_1;
    wire signed [kernel_size*kernel_size*WIDTH-1:0] weights2pe_2;
    reg pe_en;
    reg en_r;
    reg [4:0] cnt1;
    wire pe_valid_1,pe_valid_2;
    wire bais_en;
    wire bias_valid;
    wire signed [2*WIDTH+5:0] bais2relu;
    wire signed [2*WIDTH+4:0] pe_out_1;//输出数据:21bit
    wire signed [2*WIDTH+4:0] pe_out_2;//输出数据:21bit
    reg signed [3*WIDTH-1:0] data2bias_1;//输出数据:23bit
    reg signed [3*WIDTH-1:0] data2bias_2;//输出数据:23bit
    reg signed [3*WIDTH-1:0] data2bias_3;//输出数据:23bit
    reg signed [3*WIDTH-1:0] data2bias;//输出数据:23bit
    reg signed [3*WIDTH-1:0] data2bias_last;//输出数据:23bit
    wire signed [WIDTH-1:0] q_relu;
    reg [0:0] state1=0,data_out_ok;
    wire conv_stop;
    reg [kernel_size*kernel_size*channel_in*WIDTH-1:0] data_in_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_r<=0;
        end
        else begin
            en_r<=en;
        end
    end
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_in_reg<=0;
        end
        else if(en) begin
            data_in_reg <= data_in;
        end
        else begin
            data_in_reg <= data_in_reg;
        end
    end

    //循环停止信号
    cnt_loop #(
        .PIX_W   ( PIX_W ),
        .PIX_H   ( PIX_H )
    )cnt_loop_c4_U(
        .clk     ( clk     ),
        .rstn    ( rstn    ),
        .loop_en ( valid ),
        .cnt_loop_full  ( conv_stop  )
    );

    conv4_rearrange #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out),
        .kernel_size(kernel_size)
    ) conv4_rearrange_U (
        .clk(clk),
        .rstn(rstn),
        .rearrange_en(en),
        .conv_stop(conv_stop),
        .data2rearrange(data_in_reg),
        .state(state),
        .cnt(cnt),
        .data2pe_1(data2pe_1),
        .data2pe_2(data2pe_2)
    );

    conv4_Weights #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out),
        .kernel_size(kernel_size)
    ) conv4_weights_U (
        .clk(clk),
        .rstn(rstn),
        .Weight_en(en_r),
        .conv_stop(conv_stop),
        .weights2pe_1(weights2pe_1),
        .weights2pe_2(weights2pe_2)
    );

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pe_en<=0;
        end
        else begin
            pe_en<=en_r;
        end
    end

    conv4_PE_7x7 #(
        .WIDTH(WIDTH),
        .Kernel_size(kernel_size)
    ) conv4_PE_7x7_U1 (
        .clk(clk),
        .rstn(rstn),
        .PE_en(pe_en),
        .PE_valid(pe_valid_1),
        .Weight(weights2pe_1),
        .Input(data2pe_1),
        .Output(pe_out_1)
    );
    
    conv4_PE_7x7 #(
        .WIDTH(WIDTH),
        .Kernel_size(kernel_size)
    ) conv4_PE_7x7_U2 (
        .clk(clk),
        .rstn(rstn),
        .PE_en(pe_en),
        .PE_valid(pe_valid_2),
        .Weight(weights2pe_2),
        .Input(data2pe_2),
        .Output(pe_out_2)
    );

//开启pe
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state1<=0;
        end
        else if(state==0) state1<=0; 
        else if(!state1&&pe_valid_2)begin
            state1<=1; 
        end
            else begin
            state1<=state1;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out_ok<=0;
        end
        else if(state==0) data_out_ok<=0; 
        else if(!data_out_ok&&bias_valid)begin
            data_out_ok<=1; 
        end
        else begin
            data_out_ok<=data_out_ok;
        end
    end

    //pe控制状态机的计数信号
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt1<=0;
        end
        else if(state==0) cnt1<=0; 
        else if(cnt1==8)
            cnt1<=0;
        else if(state1)
            cnt1<=cnt1+1;
        else cnt1<=cnt1;
    end

    //pe_out累加到data2bias_i累加器中
    //最后三组直接累加进data2bias节省周期
    //因为例化了两个pe，需要用data2bias_last暂存一个pe的数据
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data2bias_1<=0;
            data2bias_2<=0;
            data2bias_3<=0;
            data2bias<=0;
            data2bias_last<=0;
        end
        else if((!state1))begin
            data2bias_1<=0;
            data2bias_2<=0;
            data2bias_3<=0;
            data2bias<=0;
            data2bias_last<=0;
        end
        else begin
            case (cnt1)
                0:begin
                data2bias_1<=pe_out_1;
                data2bias_2<=pe_out_2;
                data2bias<=data2bias_last;
            end
            1:begin
                data2bias_3<=pe_out_1;
                data2bias_1<=pe_out_2+data2bias_1;
                data2bias<=0;
            end
            3,6:begin
                data2bias_1<=pe_out_1+data2bias_1;
                data2bias_2<=pe_out_2+data2bias_2;
                end
            4:begin
                data2bias_3<=pe_out_1+data2bias_3;
                data2bias_1<=pe_out_2+data2bias_1;
            end
            2,5:begin
                data2bias_2<=pe_out_1+data2bias_2;
                data2bias_3<=pe_out_2+data2bias_3;
            end
            7:begin
                data2bias_3<=pe_out_1+data2bias_3;
                data2bias<=pe_out_2+data2bias_1;
            end
            8:begin
                data2bias_last<=pe_out_2+data2bias_3;
                data2bias<=pe_out_1+data2bias_2;
            end
                default:begin
                    data2bias_1 <= data2bias_1;
                    data2bias_2 <= data2bias_2;
                    data2bias_3 <= data2bias_3;
                    data2bias<=data2bias;
                end
            endcase
        end
    end

    assign bais_en=(cnt1==8)?1:0;

    //{[M*(卷积结果)>>>16]+bias}
    conv4_bais #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out)
    ) conv4_bais1 (
        .clk(clk),
        .rstn(rstn),
        .bais_en(bais_en),
        .pe2bias(data2bias),
        .bais_valid(bias_valid),
        .bais2relu(bais2relu)
    );

    //relu
    conv4_ReLU #(
        .WIDTH(WIDTH)
    ) conv4_relu (
        .clk(clk),
        .rstn(rstn),
        .qy(bais2relu),
        .q_relu(q_relu)
    );

    //数据输出
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out<=0;
        end
        else if(state==3&&cnt==2) begin
            data_out[23:16]<=q_relu;
        end
        else if(state==1&&cnt==0) begin
            data_out[15:8]<=q_relu;
        end
        else if(state==1&&cnt==1) begin
            data_out[7:0]<=q_relu;
        end
        else begin
            data_out<=data_out;
        end
    end

    //数据输出有效
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid <= 0;
        end
        else if(state==1&&cnt==1&&data_out_ok)
            valid<=1;
        else valid<=0;
    end

endmodule
