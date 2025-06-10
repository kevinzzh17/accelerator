`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/06 18:57:02
// Design Name: 
// Module Name: tb_conv3_ram
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


module tb_conv3_ram;
    //conv3
    localparam IMG_W = 640;
    localparam IMG_H = 480;
    localparam kernel = 5;
    localparam channel_in=3;
    localparam channel_out=3;
    localparam WIDTH = 8;

    //信号声明
    reg clk;
    reg rstn;
    reg en;
    reg [channel_in*WIDTH-1:0] data2ram_in ;//24bit
    wire [kernel*kernel*channel_out*WIDTH-1:0] data2conv;//600bit
    wire valid;

    //仿真控制
    // reg [31:0] count;
    reg [31:0] count1;
    reg cnt;

    //测试向量存放寄存器组
    reg [kernel*kernel*channel_in*WIDTH-1:0]data_reg[IMG_W*IMG_H-1:0];
    reg sel;
    integer handle1;
    integer handle2;
    integer i=0;
    initial begin
        $readmemh("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/requantize_conv2_out.txt",data_reg);
        $write("success_read");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv3_out.txt");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv4_out.txt");
        handle1 = $fopen("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/concat1_in_2_ram.txt");
        handle2 = $fopen("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/concat1_in_2_ram_r.txt");
        // handle2 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv3_in.txt");
        // handle2 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv4_in.txt");
        // handle2 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.2/AOD_Net_v2.2.srcs/sim_1/new/conv5_in.txt");
        
        clk=0;
        // set=0;
        rstn = 0;
        en = 0;
        cnt = 1;
        i  = 0;
        data2ram_in = data_reg[i];//RGB
        // count=0;
        count1=0;
        sel = 0;
        #100 rstn = 1;
        #90; 
       while (cnt==1) begin
            @(posedge clk) en = 1;
            @(posedge clk) en = 0;
            i = i + 1;
            #80
            data2ram_in = data_reg[i];
            if (i == IMG_W*IMG_H) begin
                cnt = 0;
            end
        end
        #150000 i = 0; //取决于你的ram需要0.几ms去完成第一个数据的读出（通过第一次仿真测试得到，改最前面的数字即可）
        cnt = 1;
        sel = 1;
        data2ram_in = data_reg[i];
        while (cnt==1) begin
            @(posedge clk) en = 1;
            @(posedge clk) en = 0;
            i = i + 1;
            #80
            data2ram_in = data_reg[i];
            if (i == IMG_W*IMG_H) begin
                cnt = 0;
            end
        end
    end


    always #5 clk = ~clk;

    always @(posedge clk ) begin
        if(conv3_ram_u.valid)
            count1<=count1 + 1;
    end

    // always @(*) begin
    //     if (count==IMG_W*IMG_H) begin
    //         #100;                AOD_Net_v1_1_S00_AXIS_inst
    //         $finish;
    //     end
    // end

    always @(*) begin
        if(count1==IMG_W*IMG_H *2)
            $finish;
    end

    always @(posedge clk ) begin
        if(conv3_ram_u.valid&&!sel)
            $fstrobe(handle1,"%h",data2conv);
    end
    always @(posedge clk ) begin
        if(conv3_ram_u.valid&&sel)
            $fstrobe(handle2,"%h",data2conv);
    end
    //模块实例化
    conv3_ram conv3_ram_u(
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .valid(valid),
        .data2ram_in(data2ram_in),
        .data2conv(data2conv)
    );

endmodule
