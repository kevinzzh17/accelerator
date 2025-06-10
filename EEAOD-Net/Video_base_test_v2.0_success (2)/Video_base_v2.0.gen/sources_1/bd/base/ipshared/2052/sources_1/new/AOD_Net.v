`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/20 15:15:12
// Design Name: 
// Module Name: AOD_Net
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


module AOD_Net #(
    parameter integer PIX_W = 640,
    parameter integer PIX_H = 480
)(
    input clk,
    input rstn,
    input conv1_en,
    input [23:0]conv1_in,
    output data_out_valid,
    output [23:0] data_out
);
    //参数定义
    // localparam PIX_W = 1280;
    // localparam PIX_H = 960;
    localparam WIDTH = 8;
    localparam addr_width = 11;
    //conv1
    localparam kernel_1 = 1;
    localparam channel_in_1=3;
    localparam channel_out_1=3;
    //conv2
    localparam kernel_2 = 3;
    localparam channel_in_2=3;
    localparam channel_out_2=3;
    //conv3
    localparam kernel_3 = 5;
    localparam channel_in_3=6;
    localparam channel_out_3=3;
    //conv4
    localparam kernel_4 = 7;
    localparam channel_in_4=6;
    localparam channel_out_4=3;
    //conv5
    localparam kernel_5 = 3;
    localparam channel_in_5=6;
    localparam channel_out_5=3;

    //信号声明
    wire [23:0] img_out;
    //conv1
    wire conv1_valid;
    wire [23:0] conv1_out;//24bit
    //conv2
    wire conv2_valid;
    wire [kernel_2*kernel_2*channel_in_2*WIDTH-1:0] conv2_in;//216bit
    wire [23:0] conv2_out;//24bit
    //conv3
    wire conv3_valid;
    wire [kernel_3*kernel_3*channel_in_3*WIDTH-1:0] conv3_in;//1200bit
    wire [23:0] conv3_out;//24bit
    //conv4
    wire conv4_valid;
    wire [kernel_4*kernel_4*channel_in_4*WIDTH-1:0] conv4_in;//2352bit
    wire [23:0] conv4_out;//24bit
    //conv5
    wire valid_ram;
    wire conv5_valid;
    wire [kernel_5*kernel_5*channel_in_5*WIDTH-1:0] conv5_in;//2352bit
    wire [23:0] conv5_out;//24bit

    //conv2_ram
    wire conv2_ram_valid;
    //conv3_ram
    wire conv3_ram_valid;
    wire [kernel_3*kernel_3*channel_out_3*WIDTH-1:0] conv3_ram_o1,conv3_ram_o2;
    //conv4_ram
    wire conv4_ram_valid;
    wire [kernel_4*kernel_4*channel_out_4*WIDTH-1:0] conv4_ram_o1,conv4_ram_o2;
    //conv5_ram
    wire conv5_ram_valid;
    wire [kernel_5*kernel_5*channel_out_5*WIDTH-1:0] conv5_ram_o1,conv5_ram_o2;
    
    //quant
    wire Quantize1_valid,Quantize2_valid,Quantize3_valid;
    wire [23:0]Quantize1_data,Quantize2_data,Quantize3_data;
    
    //模块实例化
    conv1 #(
        .PIX_W(PIX_W),
        .PIX_H(PIX_H)
    )conv1_U(//conv1计算单元
        .clk(clk),
        .rstn(rstn),
        .start(conv1_en),
        .data_in(conv1_in),//RGB
        .valid(conv1_valid),
        .data_out(conv1_out)
    );

    conv2_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width+1)
    )conv2_ram_U (//输入RAM:conv1-->conv2
        .clk(clk),
        .rstn(rstn),
        .en(conv1_valid),
        .valid(conv2_ram_valid),
        .data2ram_in(conv1_out),
        .data2conv(conv2_in)
    );

    conv2 #(
        .PIX_W(PIX_W),
        .PIX_H(PIX_H)
    )conv2_U (//conv2计算单元
        .clk(clk),
        .rstn(rstn),
        .en(conv2_ram_valid),
        .data_in(conv2_in),
        .valid(conv2_valid),
        .data_out(conv2_out)
    );

    Quantize_2_3_top  Quantize_2_3_top_U (//quant1计算单元
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(conv2_valid),
        .Quantize_valid(Quantize1_valid),
        .qx(conv2_out),
        .qy(Quantize1_data)
    );
    wire  conv3_ram_valid2;
    conv3_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width)
    ) conv3_ram_U (//输入RAM:conv2-->quant1-->conv3
        .clk(clk),
        .rstn(rstn),
        .en(Quantize1_valid),
        .valid(conv3_ram_valid2),
        .data2ram_in(Quantize1_data),
        .data2conv(conv3_ram_o2)//concat1后三通道
    );

    conv3_q_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width)
    )conv3_q_ram_U (//输入RAM:conv1-->conv3
        .clk(clk),
        .rstn(rstn),
        .en(conv1_valid),
        .valid(conv3_ram_valid),
        .data2ram_in(conv1_out),
        .data2conv(conv3_ram_o1)//concat1前三通道
    );

    genvar i,j;
    generate
        for (i =0 ;i<kernel_3*kernel_3 ;i=i+1 ) begin//concat1前三通道
            assign conv3_in[kernel_3*kernel_3*channel_in_3*WIDTH-48*i-1-:24]=conv3_ram_o1[kernel_3*kernel_3*channel_out_2*WIDTH-1-24*i-:24];
        end
    endgenerate

    generate
        for (j =0 ;j<kernel_3*kernel_3 ;j=j+1 ) begin//concat1后三通道
            assign conv3_in[kernel_3*kernel_3*channel_in_3*WIDTH-48*j-1-24-:24]=conv3_ram_o2[kernel_3*kernel_3*channel_out_2*WIDTH-1-24*j-:24];
        end
    endgenerate

    conv3#(
        .PIX_W(PIX_W),
        .PIX_H(PIX_H)
    ) conv3_U (//conv3计算单元
		.clk(clk),
		.rstn(rstn),
		.en(conv3_ram_valid),
		.data_in(conv3_in),
		.valid(conv3_valid),
		.data_out(conv3_out)
	);

    Quantize_3_4_top  Quantize_3_4_top_U (//quant2计算单元
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(conv3_valid),
        .Quantize_valid(Quantize2_valid),
        .qx(conv3_out),
        .qy(Quantize2_data)
    );
    wire conv4_ram_valid1;
    conv4_ram  #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width)
    )conv4_ram_U (//输入RAM:conv3-->quant2-->conv4
        .clk(clk),
        .rstn(rstn),
        .en(Quantize2_valid),
        .valid( conv4_ram_valid),
        .data2ram_in(Quantize2_data),
        .data2conv(conv4_ram_o2)//concat2后三通道
    );

    conv4_q_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width)
    )conv4_q_ram_U (//输入RAM:conv1-->conv3
        .clk(clk),
        .rstn(rstn),
        .en(conv2_valid),
        .valid(conv4_ram_valid1),
        .data2ram_in(conv2_out),
        .data2conv(conv4_ram_o1)//concat2前三通道
    );

    genvar p,q;
    generate
        for (p =0 ;p<kernel_4*kernel_4 ;p=p+1 ) begin//concat2前三通道
            assign conv4_in[kernel_4*kernel_4*channel_in_4*WIDTH-48*p-1-:24]=conv4_ram_o1[kernel_4*kernel_4*channel_out_3*WIDTH-1-24*p-:24];
        end
    endgenerate

    generate
        for (q =0 ;q<kernel_4*kernel_4 ;q=q+1 ) begin//concat2后三通道
            assign conv4_in[kernel_4*kernel_4*channel_in_4*WIDTH-48*q-1-24-:24]=conv4_ram_o2[kernel_4*kernel_4*channel_out_2*WIDTH-1-24*q-:24];
        end
    endgenerate

    conv4#(
        .PIX_W(PIX_W),
        .PIX_H(PIX_H)
    ) conv4_U (//conv4计算单元
        .clk(clk),
        .rstn(rstn),
        .en(conv4_ram_valid),
        .data_in(conv4_in),
        .valid(conv4_valid),
        .data_out(conv4_out)
    );

    Quantize_4_5_top Quantize_4_5_top_U (//quant3计算单元
        .clk(clk),
        .rstn(rstn),
        .Quantize_en(conv4_valid),
        .Quantize_valid(Quantize3_valid),
        .qx(conv4_out),
        .qy(Quantize3_data)
    );
    wire conv5_ram_valid1;
    conv5_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width+1)
    )conv5_ram_U(//concat3后三通道
        .clk(clk),
        .rstn(rstn),
        .en(Quantize3_valid),
        .valid(conv5_ram_valid),
        .data2ram_in(Quantize3_data),
        .data2conv(conv5_ram_o2)
    );

    conv5_q_ram #(        
        .PIX_W(PIX_W),
        .PIX_H(PIX_H),
        .addr_width(addr_width+2)
    )conv5_q_ram_U(//concat3前三通道
        .clk(clk),
        .rstn(rstn),
        .en(conv3_valid),
        .valid(conv5_ram_valid1),
        .data2ram_in(conv3_out),
        .data2conv(conv5_ram_o1)
    );

    genvar s,t;
    generate
        for (s =0 ;s<kernel_5*kernel_5 ;s=s+1 ) begin//concat3前三通道
            assign conv5_in[kernel_5*kernel_5*channel_in_5*WIDTH-48*s-1-:24]=conv5_ram_o1[kernel_5*kernel_5*channel_out_4*WIDTH-1-24*s-:24];
        end
    endgenerate

    generate
        for (t =0 ;t<kernel_5*kernel_5 ;t=t+1 ) begin//concat3后三通道
            assign conv5_in[kernel_5*kernel_5*channel_in_5*WIDTH-48*t-1-24-:24]=conv5_ram_o2[kernel_5*kernel_5*channel_out_3*WIDTH-1-24*t-:24];
        end
    endgenerate

    conv5 #(
        .PIX_W(PIX_W),
        .PIX_H(PIX_H)
    )conv5_U (//conv5计算单元
        .clk(clk),
        .rstn(rstn),
        .en(conv5_ram_valid),
        .data_in(conv5_in),
        .valid(conv5_valid),
        .valid_ram(valid_ram),
        .conv_stop(conv_stop),
        .data_out(conv5_out)
    );

    img_ori_ctrl # (
    .WIDTH(WIDTH),
    .channel_in(channel_in_1),
    .PIX_W(PIX_W),
    .addr_width(addr_width+3),
    .channel_out(channel_out_1)
    )
    img_ori_ctrl_inst (
        .clk(clk),
        .rstn(rstn),
        .en(conv1_en),
        .data_in(conv1_in),
        .en_conv5(valid_ram),
        .conv_stop(conv_stop),
        .data_out(img_out)
    );

    Calculate_AXIS  Calculate_AXIS_inst (
    .clk_100M(clk),
    .rstn(rstn),
    .data_in_valid(conv5_valid),
    .data_in(conv5_out),
    .data_pixel(img_out),
    .data_out_valid(data_out_valid),
    .data_out(data_out)
  );

endmodule
