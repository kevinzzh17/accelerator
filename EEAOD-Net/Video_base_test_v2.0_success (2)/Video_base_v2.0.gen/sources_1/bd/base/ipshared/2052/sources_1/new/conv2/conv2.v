`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:    sonne
//
// Create Date: 2023/08/03 15:50:48
// Design Name:
// Module Name: conv2
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
//状态没有使能信号就跳转

module conv2 #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter channel_out=3
)(
    input clk,
    input rstn,
    input en,
    // |[215:208]|[191:184]|[167:160]|
    // |[143:136]|[119:112]|[95 :88 ]|
    // |[71 :64 ]|[47 :40 ]|[23 :16 ]|

    // |[207:200]|[183:176]|[159:152]|
    // |[135:128]|[111:104]|[87 :80 ]|
    // |[63 :56 ]|[39 :32 ]|[15 :8  ]|

    // |[199:192]|[175:168]|[151:144]|
    // |[127:120]|[103:96 ]|[79 :72 ]|
    // |[55 :48 ]|[31 :24 ]|[7  :0  ]|
    input [3*3*channel_in*WIDTH-1:0] data_in,//CHW
    output reg valid,
    output reg [channel_out*WIDTH-1:0] data_out
);
    integer i,j;
    reg signed [3*3*WIDTH-1:0] channel_RF [channel_in-1:0];
    reg signed [WIDTH*3*3-1:0] data2pe=0;
    wire signed [3*3*WIDTH-1:0] weights2pe;
    // wire signed [3*20-1:0] pe2bais;
    wire signed [20:0] bais2relu;
    reg pe_valid,we_valid,data_okk;
    wire signed [19:0] pe_out ;
    wire signed [WIDTH-1:0] q_relu;
    wire bais_valid;
    wire bais_en;
    reg [2:0] state;
    // reg en_r;
    reg [4:0] cnt=0;
    reg [3:0] cnt1=0;
    reg signed [20:0] data2bias_1=0;
    reg signed [20:0] data2bias_2=0;
    reg signed [20:0] data2bias_3=0;
    reg signed [20:0] data2bias=0;

    reg [3*3*channel_in*WIDTH-1:0] data_in_reg=0;
    wire conv_stop;
    reg conv_stop_r;//计算完成640*480后拉高
    
    //输入数据暂存在reg中
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_in_reg <= 0;
        end
        else if(en)begin
            data_in_reg <= data_in;
        end
        else begin
            data_in_reg <= data_in_reg;
        end
    end
    
    //输入数据分3份存入数组
    always @(*) begin
        for ( i=0 ;i<3 ;i=i+1 ) begin
            for ( j=0 ;j<9;j=j+1 ) begin
                channel_RF[i][(71-j*8)-:WIDTH]<= data_in_reg[(215-24*j-8*i)-:WIDTH];
            end
        end
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
    //         en_r<=en;
    //     end
    // end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            conv_stop_r<=0;
        end
        else if(conv_stop) begin
            conv_stop_r<=1;
        end
        else conv_stop_r<=0;
    end


    //FSM
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
                    if (en) begin
                        state<=C1;
                        cnt<=cnt;
                    end
                    else begin
                        state<=IDLE;
                        cnt<=cnt;
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

    //1.输入数据拆分后放入data2pe,分3个状态输入pe
    always @(*) begin
        case (state)
            IDLE: data2pe<=0;
            C1: data2pe<=channel_RF[0];
            C2: data2pe<=channel_RF[1];
            C3: data2pe<=channel_RF[2];
            default: data2pe<=0;
        endcase
    end

    //生成pe_out标识计数器pe_valid
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pe_valid<=0;
            data_okk<=0;
        end
        else if(conv_stop_r) begin
            pe_valid<=0;
            data_okk<=0;
        end
        else if(state==IDLE) begin
            pe_valid<=pe_valid;
            data_okk<=0;
        end
        else if(state==C1&&cnt==1) pe_valid<=1;//提前了一个周期拉高pe_valid
        else if(bais_valid==1) data_okk<=1;
        else begin
            pe_valid<=pe_valid;
            data_okk<=data_okk;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            we_valid<=0;
        end
        else if(conv_stop_r) begin
            we_valid<=0;
        end
        else if(en==1) we_valid<=1;
        else begin
            we_valid<=we_valid;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt1<=0;
        end
        else if (conv_stop_r) begin
            cnt1<=0;
        end
        else if(cnt1==8)
            cnt1<=0;
        else if(we_valid)
            cnt1<=cnt1+1;
    end



    //2. 累加寄存pe_put到data2bias_i中，第三次直接累加到data2bias输入bias，
    //   并且在data2bias_i完成使命的下一周期将其清零
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data2bias_1<=0;
            data2bias_2<=0;
            data2bias_3<=0;
            data2bias<=0;
        end
        else if(pe_valid) begin 
                case (cnt1)
                3: begin
                    data2bias_1<=pe_out+data2bias_1;
                    data2bias_2<=data2bias_2;
                    data2bias_3<=0;
                end
                6: data2bias_1<=pe_out+data2bias_1;
                4,7: data2bias_2<=pe_out+data2bias_2;
                5: data2bias_3<=pe_out+data2bias_3;
                8:begin
                    data2bias_3<=pe_out+data2bias_3;
                    data2bias<=0;
                end
                0:data2bias<=pe_out+data2bias_1;
                1:begin
                    data2bias<=pe_out+data2bias_2;
                    data2bias_1<=0;
                end
                2:begin
                    data2bias<=pe_out+data2bias_3;
                    data2bias_2<=0;
                end
                default:begin
                    data2bias_1<=data2bias_1;
                    data2bias_2<=data2bias_2;
                    data2bias_3<=data2bias_3;
                    data2bias<=data2bias;
                end
            endcase
        end
        else begin
            data2bias_1<=0;
            data2bias_2<=0;
            data2bias_3<=0;
            data2bias<=0;
        end
    end

    //在cnt1=1时data2bias数据有效
    assign bais_en=(cnt1==1&&pe_valid==1)?1:0;

    //3.输出数据拼接
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data_out<=0;
        end
        else begin
            if(cnt1==5&&pe_valid==1) begin
                data_out<={q_relu,data_out[15:0]};
            end
            else if(cnt1==6&&pe_valid==1) begin
                data_out<={data_out[23:16],q_relu,data_out[7:0]};
            end
            else if(cnt1==7&&pe_valid==1) begin
                data_out<={data_out[23:8],q_relu};
            end
            else begin
                data_out<=data_out;
            end
        end
    end

    //输出valid信号
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid <= 0;
        end
        else if(cnt1==7&&data_okk==1) begin
            valid<=1;
        end
        else begin
            valid<=0;
        end
    end

    //子模块实例化
    conv2_Weights #(
        .WIDTH(WIDTH)
    ) conv2_weight_U (
        .clk(clk),
        .rstn(rstn),
        .weight_en(en),
        .kernel_weights(weights2pe),
        .w_stop  ( conv_stop  )
    );

    conv2_PE_3x3 #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out)
    ) conv2_pe_U (
        .clk(clk),              // 连接时钟信号
        .rstn(rstn),          // 连接复位信号
        .Weight(weights2pe),        // 连接输入权重信号
        .Input(data2pe),          // 连接输入特征图信号
        .Output(pe_out)         // 连接输出数据信号
    );

    conv2_bais #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out)
    ) conv2_bais_U (
        .clk(clk),
        .rstn(rstn),
        .bais_en(bais_en),
        .pe2bias(data2bias),
        .bais_valid(bais_valid),
        .bais2relu(bais2relu)
    );

    conv2_ReLU #(
        .WIDTH(WIDTH)
    ) conv2_relu_U (
        .clk(clk),
        .rstn(rstn),
        .qy(bais2relu),
        .q_relu(q_relu)
    );

    //循环停止信号
    cnt_loop#(
        .PIX_W   ( PIX_W ),
        .PIX_H   ( PIX_H )
    )cnt_loop_c2_U(
        .clk     ( clk     ),
        .rstn    ( rstn    ),
        .loop_en ( valid ),
        .cnt_loop_full  ( conv_stop  )
    );

endmodule
