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


module conv4_PE_7x7 #(
    parameter WIDTH = 8,
    parameter Kernel_size=7
)(
    input clk,//系统时钟
    input rstn,//系统复位

    input PE_en,//PE计算使能信号
    output PE_valid,//PE计算有效信号

    input [WIDTH*Kernel_size*Kernel_size-1:0]Weight,//输入权重:(7*7)*8
    input [WIDTH*Kernel_size*Kernel_size-1:0]Input,//输入特征图:(7*7)*8
    output signed [2*WIDTH+4:0]Output//输出数据:21bit
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

    //四级流水寄存器声明及初始化
    //1级流水:乘法
    reg signed [2*WIDTH-1:0] mul_reg_0,mul_reg_1,mul_reg_2,mul_reg_3,mul_reg_4,mul_reg_5,mul_reg_6,mul_reg_7,mul_reg_8,mul_reg_9;
    reg signed [2*WIDTH-1:0] mul_reg_10,mul_reg_11,mul_reg_12,mul_reg_13,mul_reg_14,mul_reg_15,mul_reg_16,mul_reg_17,mul_reg_18,mul_reg_19;
    reg signed [2*WIDTH-1:0] mul_reg_20,mul_reg_21,mul_reg_22,mul_reg_23,mul_reg_24,mul_reg_25,mul_reg_26,mul_reg_27,mul_reg_28,mul_reg_29;
    reg signed [2*WIDTH-1:0] mul_reg_30,mul_reg_31,mul_reg_32,mul_reg_33,mul_reg_34,mul_reg_35,mul_reg_36,mul_reg_37,mul_reg_38,mul_reg_39;
    reg signed [2*WIDTH-1:0] mul_reg_40,mul_reg_41,mul_reg_42,mul_reg_43,mul_reg_44,mul_reg_45,mul_reg_46,mul_reg_47,mul_reg_48;
    //2级流水:加法*2
    reg signed [2*WIDTH:0] add_reg1_0,add_reg1_1,add_reg1_2,add_reg1_3,add_reg1_4,add_reg1_5,add_reg1_6,add_reg1_7,add_reg1_8,add_reg1_9;
    reg signed [2*WIDTH:0] add_reg1_10,add_reg1_11,add_reg1_12,add_reg1_13,add_reg1_14,add_reg1_15,add_reg1_16,add_reg1_17,add_reg1_18,add_reg1_19;
    reg signed [2*WIDTH:0] add_reg1_20,add_reg1_21,add_reg1_22,add_reg1_23,add_reg1_24;
    reg signed [2*WIDTH+1:0] add_reg2_0,add_reg2_1,add_reg2_2,add_reg2_3,add_reg2_4,add_reg2_5,add_reg2_6,add_reg2_7,add_reg2_8,add_reg2_9,add_reg2_10,add_reg2_11,add_reg2_12;
    //3级流水:加法*2
    reg signed [2*WIDTH+2:0] add_reg3_0,add_reg3_1,add_reg3_2,add_reg3_3,add_reg3_4,add_reg3_5,add_reg3_6;
    reg signed [2*WIDTH+3:0] add_reg4_0,add_reg4_1,add_reg4_2,add_reg4_3;
    //4级流水:加法*2
    reg signed [2*WIDTH+4:0] add_reg5_0,add_reg5_1;
    reg signed [2*WIDTH+4:0] add_reg6;



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
        mul_reg_25 = 0;
        mul_reg_26 = 0;
        mul_reg_27 = 0;
        mul_reg_28 = 0;
        mul_reg_29 = 0;
        mul_reg_30 = 0;
        mul_reg_31 = 0;
        mul_reg_32 = 0;
        mul_reg_33 = 0;
        mul_reg_34 = 0;
        mul_reg_35 = 0;
        mul_reg_36 = 0;
        mul_reg_37 = 0;
        mul_reg_38 = 0;
        mul_reg_39 = 0;
        mul_reg_40 = 0;
        mul_reg_41 = 0;
        mul_reg_42 = 0;
        mul_reg_43 = 0;
        mul_reg_44 = 0;
        mul_reg_45 = 0;
        mul_reg_46 = 0;
        mul_reg_47 = 0;
        mul_reg_48 = 0;

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
        add_reg1_13 = 0;
        add_reg1_14 = 0;
        add_reg1_15 = 0;
        add_reg1_16 = 0;
        add_reg1_17 = 0;
        add_reg1_18 = 0;
        add_reg1_19 = 0;
        add_reg1_20 = 0;
        add_reg1_21 = 0;
        add_reg1_22 = 0;
        add_reg1_23 = 0;
        add_reg1_24 = 0;

        add_reg2_0 = 0;
        add_reg2_1 = 0;
        add_reg2_2 = 0;
        add_reg2_3 = 0;
        add_reg2_4 = 0;
        add_reg2_5 = 0;
        add_reg2_6 = 0;
        add_reg2_7 = 0;
        add_reg2_8 = 0;
        add_reg2_9 = 0;
        add_reg2_10 = 0;
        add_reg2_11 = 0;
        add_reg2_12 = 0;

        add_reg3_0 = 0;
        add_reg3_1 = 0;
        add_reg3_2 = 0;
        add_reg3_3 = 0;
        add_reg3_4 = 0;
        add_reg3_5 = 0;
        add_reg3_6 = 0;

        add_reg4_0 = 0;
        add_reg4_1 = 0;
        add_reg4_2 = 0;
        add_reg4_3 = 0;

        add_reg5_0 = 0;
        add_reg5_1 = 0;

        add_reg6 = 0;
    end

    //一级流水:补码乘法 16bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            mul_reg_0  <= 0;
            mul_reg_1  <= 0;
            mul_reg_2  <= 0;
            mul_reg_3  <= 0;
            mul_reg_4  <= 0;
            mul_reg_5  <= 0;
            mul_reg_6  <= 0;
            mul_reg_7  <= 0;
            mul_reg_8  <= 0;
            mul_reg_9  <= 0;
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
            mul_reg_25 <= 0;
            mul_reg_26 <= 0;
            mul_reg_27 <= 0;
            mul_reg_28 <= 0;
            mul_reg_29 <= 0;
            mul_reg_30 <= 0;
            mul_reg_31 <= 0;
            mul_reg_32 <= 0;
            mul_reg_33 <= 0;
            mul_reg_34 <= 0;
            mul_reg_35 <= 0;
            mul_reg_36 <= 0;
            mul_reg_37 <= 0;
            mul_reg_38 <= 0;
            mul_reg_39 <= 0;
            mul_reg_40 <= 0;
            mul_reg_41 <= 0;
            mul_reg_42 <= 0;
            mul_reg_43 <= 0;
            mul_reg_44 <= 0;
            mul_reg_45 <= 0;
            mul_reg_46 <= 0;
            mul_reg_47 <= 0;
            mul_reg_48 <= 0;
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
            mul_reg_25 <= weight_element[25]*input_element[25];
            mul_reg_26 <= weight_element[26]*input_element[26];
            mul_reg_27 <= weight_element[27]*input_element[27];
            mul_reg_28 <= weight_element[28]*input_element[28];
            mul_reg_29 <= weight_element[29]*input_element[29];
            mul_reg_30 <= weight_element[30]*input_element[30];
            mul_reg_31 <= weight_element[31]*input_element[31];
            mul_reg_32 <= weight_element[32]*input_element[32];
            mul_reg_33 <= weight_element[33]*input_element[33];
            mul_reg_34 <= weight_element[34]*input_element[34];
            mul_reg_35 <= weight_element[35]*input_element[35];
            mul_reg_36 <= weight_element[36]*input_element[36];
            mul_reg_37 <= weight_element[37]*input_element[37];
            mul_reg_38 <= weight_element[38]*input_element[38];
            mul_reg_39 <= weight_element[39]*input_element[39];
            mul_reg_40 <= weight_element[40]*input_element[40];
            mul_reg_41 <= weight_element[41]*input_element[41];
            mul_reg_42 <= weight_element[42]*input_element[42];
            mul_reg_43 <= weight_element[43]*input_element[43];
            mul_reg_44 <= weight_element[44]*input_element[44];
            mul_reg_45 <= weight_element[45]*input_element[45];
            mul_reg_46 <= weight_element[46]*input_element[46];
            mul_reg_47 <= weight_element[47]*input_element[47];
            mul_reg_48 <= weight_element[48]*input_element[48];
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
            add_reg1_13 = 0;
            add_reg1_14 = 0;
            add_reg1_15 = 0;
            add_reg1_16 = 0;
            add_reg1_17 = 0;
            add_reg1_18 = 0;
            add_reg1_19 = 0;
            add_reg1_20 = 0;
            add_reg1_21 = 0;
            add_reg1_22 = 0;
            add_reg1_23 = 0;
            add_reg1_24 = 0;
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
            add_reg1_12 = mul_reg_24 + mul_reg_25;
            add_reg1_13 = mul_reg_26 + mul_reg_27;
            add_reg1_14 = mul_reg_28 + mul_reg_29;
            add_reg1_15 = mul_reg_30 + mul_reg_31;
            add_reg1_16 = mul_reg_32 + mul_reg_33;
            add_reg1_17 = mul_reg_34 + mul_reg_35;
            add_reg1_18 = mul_reg_36 + mul_reg_37;
            add_reg1_19 = mul_reg_38 + mul_reg_39;
            add_reg1_20 = mul_reg_40 + mul_reg_41;
            add_reg1_21 = mul_reg_42 + mul_reg_43;
            add_reg1_22 = mul_reg_44 + mul_reg_45;
            add_reg1_23 = mul_reg_46 + mul_reg_47;
            add_reg1_24 = mul_reg_48;
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
            add_reg2_7 <= 0;
            add_reg2_8 <= 0;
            add_reg2_9 <= 0;
            add_reg2_10 <= 0;
            add_reg2_11 <= 0;
            add_reg2_12 <= 0;
        end
        else begin
            add_reg2_0 <= add_reg1_0 + add_reg1_1;
            add_reg2_1 <= add_reg1_2 + add_reg1_3;
            add_reg2_2 <= add_reg1_4 + add_reg1_5;
            add_reg2_3 <= add_reg1_6 + add_reg1_7;
            add_reg2_4 <= add_reg1_8 + add_reg1_9;
            add_reg2_5 <= add_reg1_10 + add_reg1_11;
            add_reg2_6 <= add_reg1_12 + add_reg1_13;
            add_reg2_7 <= add_reg1_14 + add_reg1_15;
            add_reg2_8 <= add_reg1_16 + add_reg1_17;
            add_reg2_9 <= add_reg1_18 + add_reg1_19;
            add_reg2_10 <= add_reg1_20 + add_reg1_21;
            add_reg2_11 <= add_reg1_22 + add_reg1_23;
            add_reg2_12 <= add_reg1_24;
        end
    end

    //加法 19bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg3_0 = 0;
            add_reg3_1 = 0;
            add_reg3_2 = 0;
            add_reg3_3 = 0;
            add_reg3_4 = 0;
            add_reg3_5 = 0;
            add_reg3_6 = 0;
        end
        else begin
            add_reg3_0 = add_reg2_0 + add_reg2_1;
            add_reg3_1 = add_reg2_2 + add_reg2_3;
            add_reg3_2 = add_reg2_4 + add_reg2_5;
            add_reg3_3 = add_reg2_6 + add_reg2_7;
            add_reg3_4 = add_reg2_8 + add_reg2_9;
            add_reg3_5 = add_reg2_10 + add_reg2_11;
            add_reg3_6 = add_reg2_12;
        end
    end

    //三级流水:加法 20bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg4_0 <= 0;
            add_reg4_1 <= 0;
            add_reg4_2 <= 0;
            add_reg4_3 <= 0;
        end
        else begin
            add_reg4_0 <= add_reg3_0 + add_reg3_1;
            add_reg4_1 <= add_reg3_2 + add_reg3_3;
            add_reg4_2 <= add_reg3_4 + add_reg3_5;
            add_reg4_3 <= add_reg3_6;
        end
    end

    //加法 21bit输出
    always @(*) begin
        if(!rstn)begin
            add_reg5_0 = 0;
            add_reg5_1 = 0;
        end
        else begin
            add_reg5_0 = add_reg4_0 + add_reg4_1;
            add_reg5_1 = add_reg4_2 + add_reg4_3;
        end
    end

    //四级流水:加法 21bit输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            add_reg6 <= 0;
        end
        else begin
            add_reg6 <= add_reg5_0 + add_reg5_1;
        end
    end

    //PE_valid信号计数器
    reg [2:0]cnt=0;
    reg cnt_add_flag=0;
    wire cnt_2_flag;
    assign cnt_2_flag = (cnt == 2);

    //输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt_add_flag <= 0; 
        end
        else if(PE_en)begin
            cnt_add_flag <= ~cnt_add_flag; 
        end
        else if(cnt_2_flag)begin
            cnt_add_flag <= ~cnt_add_flag; 
        end
        else begin
            cnt_add_flag <= cnt_add_flag; 
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt <= 2'd0;
        end
        else if(cnt_2_flag)begin//cnt == 2'd3
            cnt <= 2'd0;
        end
        else if(cnt_add_flag)begin
            cnt <= cnt + 2'd1; 
        end
        else begin
            cnt <= 2'd0;
        end
    end

    //输出
    assign Output = add_reg6;
    assign PE_valid = cnt_2_flag;
    
endmodule
