`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HFUT
// Engineer: sonne
//
// Create Date: 2023/07/18 12:02:34
// Design Name: Conv_3x3
// Module Name: PE
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 用于计算一个input channel的3x3卷积
// 采用3级流水线 2T出一个数据
// 如果流水级数过多则再调整
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv2_PE_3x3 #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3
)(
    input clk,
    input rstn,
    input [WIDTH*3*3-1:0]Weight,//输入权重:(3*3)*8
    input [WIDTH*3*3-1:0]Input,//输入特征图:(3*3)*8
    output signed [19:0]Output//输出数据:20bit
    );
    //声明weight、input信号线用于存放拆分的Weight和Input
    wire signed[WIDTH-1:0] weight_element [0:8];
    wire signed[WIDTH-1:0] input_element [0:8];

    //对weight、input信号线进行数据流赋值
    genvar i;
    generate
        for(i=0;i<9;i=i+1)begin
            assign weight_element[i] = Weight[(i+1)*8-1:i*8];
            assign input_element[i] = Input[(i+1)*8-1:i*8];
        end
    endgenerate

    //三级流水寄存器声明及初始化
    reg signed [15:0] mul_reg_0,mul_reg_1,mul_reg_2,mul_reg_3,mul_reg_4,mul_reg_5,mul_reg_6,mul_reg_7,mul_reg_8;//1级流水
    reg signed [16:0] add_reg1_0,add_reg1_1,add_reg1_2,add_reg1_3,add_reg1_4;
    reg signed [17:0] add_reg2_0,add_reg2_1,add_reg2_2;//2级流水
    reg signed [18:0] add_reg3_0,add_reg3_1;
    reg signed [19:0] add_reg4;//3级流水

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

        add_reg1_0 = 0;
        add_reg1_1 = 0;
        add_reg1_2 = 0;
        add_reg1_3 = 0;
        add_reg1_4 = 0;

        add_reg2_0 = 0;
        add_reg2_1 = 0;
        add_reg2_2 = 0;

        add_reg3_0 = 0;
        add_reg3_1 = 0;

        add_reg4 = 0;
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
        end
        else begin
            add_reg1_0 = mul_reg_0 + mul_reg_1;
            add_reg1_1 = mul_reg_2 + mul_reg_3;
            add_reg1_2 = mul_reg_4 + mul_reg_5;
            add_reg1_3 = mul_reg_6 + mul_reg_7;
            add_reg1_4 = mul_reg_8;
        end
    end

    //二级流水:加法 18bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg2_0 <= 0;
            add_reg2_1 <= 0;
            add_reg2_2 <= 0;
        end
        else begin
            add_reg2_0 <= add_reg1_0 + add_reg1_1;
            add_reg2_1 <= add_reg1_2 + add_reg1_3;
            add_reg2_2 <= add_reg1_4;
        end
    end

    //加法 19bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg3_0 = 0;
            add_reg3_1 = 0;
        end
        else begin
            add_reg3_0 = add_reg2_0 + add_reg2_1;
            add_reg3_1 = add_reg2_2;
        end
    end

    //三级流水:加法 20bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg4 <= 0;
        end
        else begin
            add_reg4 <= add_reg3_0 + add_reg3_1;
        end
    end

    //输出
    assign Output = add_reg4;

endmodule
