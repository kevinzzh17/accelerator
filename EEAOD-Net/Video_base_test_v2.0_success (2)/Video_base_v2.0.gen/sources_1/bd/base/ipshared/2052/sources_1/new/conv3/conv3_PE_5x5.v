`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: LionelZhao
//
// Create Date: 2023/08/04 18:08:14
// Design Name: Conv_5x5
// Module Name: PE_5x5
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 用于计算一个input channel的5x5卷积
// 采用3级流水线 2T出一个数据
// 如果流水级数过多则再调整
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv3_PE_5x5 #(
    parameter WIDTH = 8,
    parameter Kernel_size=5
)(
    input clk,//系统时钟
    input rstn,//系统复位

    input PE_en,//PE计算使能信号
    output PE_valid,//PE计算有效信号

    input [WIDTH*Kernel_size*Kernel_size-1:0]Weight,//输入权重:(5*5)*8
    input [WIDTH*Kernel_size*Kernel_size-1:0]Input,//输入特征图:(5*5)*8
    output signed [2*WIDTH+3:0]Output//输出数据:20bit
    );
    //声明weight、input信号线用于存放拆分的Weight和Input
    wire signed[WIDTH-1:0] weight_element [0:Kernel_size*Kernel_size-1];
    wire signed[WIDTH-1:0] input_element [0:Kernel_size*Kernel_size-1];

    //对weight、input信号线进行数据流赋值
    genvar i;
    generate
        for(i=0;i<Kernel_size*Kernel_size;i=i+1)begin
            assign weight_element[i] = Weight[(i+1)*WIDTH-1:i*WIDTH];
            assign input_element[i] = Input[(i+1)*WIDTH-1:i*WIDTH];
        end
    endgenerate

    //三级流水寄存器声明及初始化
    reg signed [2*WIDTH-1:0] mul_reg_0,mul_reg_1,mul_reg_2,mul_reg_3,mul_reg_4,mul_reg_5,mul_reg_6,mul_reg_7,mul_reg_8,mul_reg_9;//1级流水:乘法
    reg signed [2*WIDTH-1:0] mul_reg_10,mul_reg_11,mul_reg_12,mul_reg_13,mul_reg_14,mul_reg_15,mul_reg_16,mul_reg_17,mul_reg_18,mul_reg_19;//1级流水:乘法
    reg signed [2*WIDTH-1:0] mul_reg_20,mul_reg_21,mul_reg_22,mul_reg_23,mul_reg_24;//1级流水:乘法

    reg signed [2*WIDTH:0] add_reg1_0,add_reg1_1,add_reg1_2,add_reg1_3,add_reg1_4,add_reg1_5,add_reg1_6,add_reg1_7,add_reg1_8,add_reg1_9,add_reg1_10,add_reg1_11,add_reg1_12;
    reg signed [2*WIDTH+1:0] add_reg2_0,add_reg2_1,add_reg2_2,add_reg2_3,add_reg2_4,add_reg2_5,add_reg2_6;//2级流水

    reg signed [2*WIDTH+2:0] add_reg3_0,add_reg3_1,add_reg3_2,add_reg3_3;
    reg signed [2*WIDTH+3:0] add_reg4_0,add_reg4_1;
    reg signed [2*WIDTH+3:0] add_reg5;//3级流水

    initial begin
        mul_reg_0 = 0;
        mul_reg_1 = 0;
        mul_reg_2 = 0;
        mul_reg_3 = 0;
        mul_reg_4 = 0;
        mul_reg_5 = 0;
        mul_reg_6 = 0;
        mul_reg_7 = 0;
        mul_reg_8 = 0;
        mul_reg_9 = 0;
        mul_reg_10 = 0;
        mul_reg_11 = 0;
        mul_reg_12 = 0;
        mul_reg_13 = 0;
        mul_reg_14 = 0;
        mul_reg_15 = 0;
        mul_reg_16 = 0;
        mul_reg_17 = 0;
        mul_reg_18 = 0;
        mul_reg_19 = 0;
        mul_reg_20 = 0;
        mul_reg_21 = 0;
        mul_reg_22 = 0;
        mul_reg_23 = 0;
        mul_reg_24 = 0;

        add_reg1_0 = 0;
        add_reg1_1 = 0;
        add_reg1_2 = 0;
        add_reg1_3 = 0;
        add_reg1_4 = 0;
        add_reg1_5 = 0;
        add_reg1_6 = 0;
        add_reg1_7 = 0;
        add_reg1_8 = 0;
        add_reg1_9 = 0;
        add_reg1_10 = 0;
        add_reg1_11 = 0;
        add_reg1_12 = 0;

        add_reg2_0 = 0;
        add_reg2_1 = 0;
        add_reg2_2 = 0;
        add_reg2_3 = 0;
        add_reg2_4 = 0;
        add_reg2_5 = 0;
        add_reg2_6 = 0;

        add_reg3_0 = 0;
        add_reg3_1 = 0;
        add_reg3_2 = 0;
        add_reg3_3 = 0;

        add_reg4_0 = 0;
        add_reg4_1 = 0;

        add_reg5 = 0;
    end

    //一级流水:补码乘法 16bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            mul_reg_0 <= 0;
            mul_reg_1 <= 0;
            mul_reg_2 <= 0;
            mul_reg_3 <= 0;
            mul_reg_4 <= 0;
            mul_reg_5 <= 0;
            mul_reg_6 <= 0;
            mul_reg_7 <= 0;
            mul_reg_8 <= 0;
            mul_reg_9 <= 0;
            mul_reg_10 <= 0;
            mul_reg_11 <= 0;
            mul_reg_12 <= 0;
            mul_reg_13 <= 0;
            mul_reg_14 <= 0;
            mul_reg_15 <= 0;
            mul_reg_16 <= 0;
            mul_reg_17 <= 0;
            mul_reg_18 <= 0;
            mul_reg_19 <= 0;
            mul_reg_20 <= 0;
            mul_reg_21 <= 0;
            mul_reg_22 <= 0;
            mul_reg_23 <= 0;
            mul_reg_24 <= 0;
        end
        else begin
            mul_reg_0 <= weight_element[0]*input_element[0];
            mul_reg_1 <= weight_element[1]*input_element[1];
            mul_reg_2 <= weight_element[2]*input_element[2];
            mul_reg_3 <= weight_element[3]*input_element[3];
            mul_reg_4 <= weight_element[4]*input_element[4];
            mul_reg_5 <= weight_element[5]*input_element[5];
            mul_reg_6 <= weight_element[6]*input_element[6];
            mul_reg_7 <= weight_element[7]*input_element[7];
            mul_reg_8 <= weight_element[8]*input_element[8];
            mul_reg_9 <= weight_element[9]*input_element[9];
            mul_reg_10 <= weight_element[10]*input_element[10];
            mul_reg_11 <= weight_element[11]*input_element[11];
            mul_reg_12 <= weight_element[12]*input_element[12];
            mul_reg_13 <= weight_element[13]*input_element[13];
            mul_reg_14 <= weight_element[14]*input_element[14];
            mul_reg_15 <= weight_element[15]*input_element[15];
            mul_reg_16 <= weight_element[16]*input_element[16];
            mul_reg_17 <= weight_element[17]*input_element[17];
            mul_reg_18 <= weight_element[18]*input_element[18];
            mul_reg_19 <= weight_element[19]*input_element[19];
            mul_reg_20 <= weight_element[20]*input_element[20];
            mul_reg_21 <= weight_element[21]*input_element[21];
            mul_reg_22 <= weight_element[22]*input_element[22];
            mul_reg_23 <= weight_element[23]*input_element[23];
            mul_reg_24 <= weight_element[24]*input_element[24];
        end
    end

    //加法 17bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg1_0 = 0;
            add_reg1_1 = 0;
            add_reg1_2 = 0;
            add_reg1_3 = 0;
            add_reg1_4 = 0;
            add_reg1_5 = 0;
            add_reg1_6 = 0;
            add_reg1_7 = 0;
            add_reg1_8 = 0;
            add_reg1_9 = 0;
            add_reg1_10 = 0;
            add_reg1_11 = 0;
            add_reg1_12 = 0;
        end
        else begin
            add_reg1_0 = mul_reg_0 + mul_reg_1;
            add_reg1_1 = mul_reg_2 + mul_reg_3;
            add_reg1_2 = mul_reg_4 + mul_reg_5;
            add_reg1_3 = mul_reg_6 + mul_reg_7;
            add_reg1_4 = mul_reg_8 + mul_reg_9;
            add_reg1_5 = mul_reg_10 + mul_reg_11;
            add_reg1_6 = mul_reg_12 + mul_reg_13;
            add_reg1_7 = mul_reg_14 + mul_reg_15;
            add_reg1_8 = mul_reg_16 + mul_reg_17;
            add_reg1_9 = mul_reg_18 + mul_reg_19;
            add_reg1_10 = mul_reg_20 + mul_reg_21;
            add_reg1_11 = mul_reg_22 + mul_reg_23;
            add_reg1_12 = mul_reg_24;
        end
    end

    //二级流水:加法 18bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg2_0 <= 0;
            add_reg2_1 <= 0;
            add_reg2_2 <= 0;
            add_reg2_3 <= 0;
            add_reg2_4 <= 0;
            add_reg2_5 <= 0;
            add_reg2_6 <= 0;
        end
        else begin
            add_reg2_0 <= add_reg1_0 + add_reg1_1;
            add_reg2_1 <= add_reg1_2 + add_reg1_3;
            add_reg2_2 <= add_reg1_4 + add_reg1_5;
            add_reg2_3 <= add_reg1_6 + add_reg1_7;
            add_reg2_4 <= add_reg1_8 + add_reg1_9;
            add_reg2_5 <= add_reg1_10 + add_reg1_11;
            add_reg2_6 <= add_reg1_12;
        end
    end

    //加法 19bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg3_0 = 0;
            add_reg3_1 = 0;
            add_reg3_2 = 0;
            add_reg3_3 = 0;
        end
        else begin
            add_reg3_0 = add_reg2_0 + add_reg2_1;
            add_reg3_1 = add_reg2_2 + add_reg2_3;
            add_reg3_2 = add_reg2_4 + add_reg2_5;
            add_reg3_3 = add_reg2_6;
        end
    end

    //加法 20bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg4_0 = 0;
            add_reg4_1 = 0;
        end
        else begin
            add_reg4_0 = add_reg3_0 + add_reg3_1;
            add_reg4_1 = add_reg3_2 + add_reg3_3;
        end
    end

    //三级流水:加法 20bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg5 <= 0;
        end
        else begin
            add_reg5 <= add_reg4_0 + add_reg4_1;
        end
    end

    //PE_valid信号计数器
    reg [0:0]cnt=0;
    reg cnt_add_flag=0;
    wire cnt_1_flag;
    assign cnt_1_flag = (cnt == 1);

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt_add_flag <= 0;
        end
        else if(PE_en)begin
            cnt_add_flag <= ~cnt_add_flag;
        end
        else if(cnt_1_flag)begin
            cnt_add_flag <= ~cnt_add_flag;
        end
        else begin
            cnt_add_flag <= cnt_add_flag;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt <= 1'd0;
        end
        else if(cnt_1_flag)begin//cnt == 2'd3
            cnt <= 1'd0;
        end
        else if(cnt_add_flag)begin
            cnt <= ~cnt;
        end
        else begin
            cnt <= 1'd0;
        end
    end

    //输出
    assign Output = add_reg5;
    assign PE_valid = cnt_1_flag;
    
endmodule
