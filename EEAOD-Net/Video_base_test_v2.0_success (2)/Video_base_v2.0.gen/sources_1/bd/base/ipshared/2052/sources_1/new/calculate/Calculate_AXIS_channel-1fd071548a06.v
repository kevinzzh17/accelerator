`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 09:11:08
// Design Name: 
// Module Name: Calculate_AXIS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Calculate_AXIS_channel(
    //系统时钟和复位
    input clk_100M,
    input rstn,
    //输入控制和数据信号
    input data_in_valid,
    input signed [7:0]data_in,
    input signed [7:0]data_pixel,
    //输出控制和数据信号
    output data_out_valid,
    output signed [7:0]data_out
);
    // 信号声明
    parameter signed [9:0]M_mul = $signed(10'd280);
    parameter signed [15:0]M_sub1 = $signed(16'd20183);
    parameter signed [15:0]M_sub2 = $signed(-16'd21995);
    parameter signed [7:0]B_sub = $signed(8'd113);
    parameter signed [15:0]M_add = $signed(16'd20488);
    parameter signed [7:0]C_add = $signed(-8'd32);//128-32
    // parameter signed [7:0]C_add = $signed(8'd96);//128-32
    parameter signed [7:0]Zy = $signed(-8'd128);
    parameter signed [8:0]Zx = $signed(9'd128);

    //一级流水
    reg signed[8:0] l1_add_1=0,l1_add_2=0;
    reg signed[16:0] l1_add_mul=0;
    //二级流水
    reg signed[25:0] l2_mul=0;
    reg signed[9:0] l2_mul_sft=0;
    //三级流水
    reg signed[8:0] l3_add=0;
    reg signed[22:0] l3_add_mul_1=0;
    reg signed[22:0] l3_add_mul_2=0;
    //四级流水
    reg signed[23:0] l4_add=0;
    reg signed[9:0] l4_add_sft=0;
    reg signed[9:0] l4_add_sft_add=0;
    //五级流水
    reg signed[24:0] l5_mul=0;
    reg signed[10:0] l5_mul_sft=0;
    reg signed[10:0] l5_mul_sft_add=0;
    //valid信号寄存器
    reg [4:0] valid_reg =0;

    //数据寄存器
    reg signed [ 7:0] data_in_r0,data_in_r1;

    //数据寄存
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            data_in_r0 <= 0;
            data_in_r1 <= 0;
        end
        else begin
            data_in_r0 <= data_in;
            data_in_r1 <= data_in_r0;
        end
    end

    //一级流水
    always @(*) begin
        l1_add_1 = data_in + Zx;
        l1_add_2 = data_pixel + Zx;
    end
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            l1_add_mul <= 0;
        end
        else begin
            l1_add_mul <= l1_add_1 * l1_add_2;
        end
    end

    //二级流水
    // assign l2_mul = l1_add_mul * M_mul;
    always @(*) begin
        l2_mul = l1_add_mul * M_mul;
    end
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            l2_mul_sft <= 0;
            // l3_add <= 0;
        end
        else begin
            l2_mul_sft <= (l2_mul>>>16);
            // l3_add <= l2_mul_sft + Zy;
        end
    end

    //三级流水
    always @(*) begin
        l3_add = l2_mul_sft + Zy;
    end
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            l3_add_mul_1 <= 0;
            l3_add_mul_2 <= 0;
        end
        else begin
            l3_add_mul_1 <= l3_add * M_sub1;//l3_add_mul_10
            l3_add_mul_2 <= data_in_r1 * M_sub2;// CTRL C 20
        end
    end

    //四级流水
    always @(*) begin
        l4_add = l3_add_mul_1 + l3_add_mul_2;
        l4_add_sft = l4_add>>>14;
    end
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            l4_add_sft_add <= 0;
        end
        else begin
            l4_add_sft_add <= l4_add_sft + B_sub;
        end
    end

    //五级流水
    always @(*) begin
        l5_mul = l4_add_sft_add * M_add;
        l5_mul_sft = l5_mul>>>14;
    end
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            l5_mul_sft_add <= 0;
        end
        else begin
            l5_mul_sft_add <= l5_mul_sft + C_add;
        end
    end

    //产生valid
    always @(posedge clk_100M or negedge rstn) begin
        if(!rstn)begin
            valid_reg <= 0;
        end
        else begin
            valid_reg <= {valid_reg[3:0],data_in_valid};
        end
    end

    assign data_out_valid = valid_reg[4];
    assign data_out = l5_mul_sft_add[7:0];

endmodule
