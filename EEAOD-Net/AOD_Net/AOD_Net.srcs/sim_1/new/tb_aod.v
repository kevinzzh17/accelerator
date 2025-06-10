`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 14:08:24
// Design Name: 
// Module Name: tb_aod
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


module tb_aod;
    //参数定义
    localparam IMG_W = 1280;
    localparam IMG_H = 960;
    localparam WIDTH = 8;
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
    reg clk;
    reg rstn;
    // reg set;
    //conv1
    reg conv1_en;
    reg [kernel_1*kernel_1*channel_in_1*WIDTH-1:0] conv1_in;//24bit

    // wire [23:0] conv5_out;//24bit
    wire [23:0] data_out;//24bit
    wire conv5_valid;
    wire data_out_valid;
    //仿真控制
    reg [31:0] count;
    reg [31:0] count1;
    reg cnt;
    reg sel;
    //测试向量存放寄存器组
    reg [kernel_1*kernel_1*channel_in_1*WIDTH-1:0]data_reg[IMG_W*IMG_H-1:0];

    //文件句柄
    integer handle1;
    integer handle2;
    // integer handle3;
    // integer handle4;
    // integer handle5;
    // integer handle6;
    // integer handle7;
    // integer handle8;
    // integer handle9;
    integer i=0;

    initial begin
        // $readmemh("D:/AI_Defog/AOD_net_numpy_2/Buffer_test/Python_hex/conv1_in.txt",data_reg);
        $readmemh("D:/AI_Defog/AOD_net_numpy_2/test/txt_hex/in/conv1_in.txt",data_reg);
        $write("success_read");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv3_out.txt");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv4_out.txt");
        handle1 = $fopen("D:/AI_Defog/AOD_net_numpy_2/Buffer_test/Verilog_hex/result.txt");
        // handle2 = $fopen("D:/AI_Defog/AOD_net_numpy_2/Buffer_test/Verilog_hex/conv1_in.txt");
        // handle9 = $fopen("D:/AI_Defog/AOD_net_numpy_2/Buffer_test/Verilog_hex/conv5_out_r.txt");
        // handle2 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/concat2_in_2_ram.txt");
        // handle3 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/concat2_in_3_ram.txt");
        // handle4 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/concat3_in_4_ram.txt");
        // handle5 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv3_out.txt");
        // handle6 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv5_in.txt");
        // handle7 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/requantize_conv4_out.txt");
        // handle8 = $fopen("D:/20212/user/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv4_in.txt");
        clk=0;
        // set=0;
        rstn = 0;
        conv1_en = 0;
        conv1_in = data_reg[i];//RGB
        count=0;
        count1=0;
        cnt=1;
        sel = 0;
        #100 rstn = 1;
        // #100 set = 1;
        #90;
        while (cnt==1) begin
            @(posedge clk) conv1_en = 1;
            @(posedge clk) conv1_en = 0;
            i = i + 1;
            #80
            conv1_in = data_reg[i];
            if (i == IMG_W*IMG_H) begin
                cnt = 0;
            end
        end
        #45_0000 i = 0;
        cnt = 1;
        sel = 1;
        conv1_in = data_reg[i];
        while (cnt==1) begin
            @(posedge clk) conv1_en = 1;
            @(posedge clk) conv1_en = 0;
            i = i + 1;
            #80
            conv1_in = data_reg[i];
            if (i == IMG_W*IMG_H) begin
                cnt = 0;
            end
        end
    end

    always #5 clk = ~clk;

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.Quantize_4_5_top_U.Quantize_valid)
    //         count<=count+1;
    // end
    always @(posedge clk ) begin
        if(AOD_Net_U.data_out_valid)
            count1<=count1+1;
    end

    // always @(*) begin
    //     if (count==IMG_W*IMG_H) begin
    //         #100;
    //         $finish;
    //     end
    // end
    // always @(*) begin
    //     if(count1==IMG_W*IMG_H *2)
    //         $finish;
    // end
    always @(*) begin
        if(count1==IMG_W*IMG_H)
            $finish;
    end
    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_ram_valid)
    //         $fstrobe(handle2,"%h",AOD_Net_U.conv5_in);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_valid&&!sel)
    //         $fstrobe(handle1,"%h",AOD_Net_U.data_out[47:24]);
    // end
    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_valid&&!sel)
    //         $fstrobe(handle2,"%h",AOD_Net_U.data_out[23:0]);
    // end
    always @(posedge clk ) begin
        if(AOD_Net_U.data_out_valid&&!sel)
            $fstrobe(handle1,"%h",AOD_Net_U.data_out[23:0]);
    end
    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_valid&&sel)
    //         $fstrobe(handle9,"%h",AOD_Net_U.conv5_out);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv4_q_ram_U.valid&&sel)
    //         $fstrobe(handle2,"%h",AOD_Net_U.conv4_q_ram_U.data2conv);
    // end
    
    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv4_ram_U.valid&&sel)
    //         $fstrobe(handle3,"%h",AOD_Net_U.conv4_ram_U.data2conv);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_ram_U.valid&&sel)
    //         $fstrobe(handle4,"%h",AOD_Net_U.conv5_ram_U.data2conv);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv3_U.valid&&sel)
    //         $fstrobe(handle5,"%h",AOD_Net_U.conv3_U.data_out);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv5_U.en&&sel)
    //         $fstrobe(handle6,"%h",AOD_Net_U.conv5_U.data_in);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.Quantize_4_5_top_U.Quantize_valid&&sel)
    //         $fstrobe(handle7,"%h",AOD_Net_U.Quantize_4_5_top_U.qy);
    // end

    // always @(posedge clk ) begin
    //     if(AOD_Net_U.conv4_U.en&&sel)
    //         $fstrobe(handle8,"%h",AOD_Net_U.conv4_U.data_in);
    // end

    //模块实例化
    AOD_Net  AOD_Net_U (
        .clk(clk),
        .rstn(rstn),
        // .set(set),
        .conv1_en(conv1_en),
        .conv1_in(conv1_in),
        .data_out_valid(data_out_valid),
        .data_out(data_out)
    );

endmodule
