`timescale 1ns / 1ns

module tb_AOD_Net();
    //参数定义
    localparam IMG_W = 640;
    localparam IMG_H = 480;
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
    // reg conv1_en;
    reg [32-1:0] s00_axis_tdata;//24bit
    reg [3:0] s00_axis_tstrb = 4'b1111;
    reg s00_axis_tlast = 0;
    reg s00_axis_tvalid = 0;
    wire s00_axis_tready;

    reg m00_axis_tready = 1;
    wire m00_axis_tvalid;
    wire m00_axis_tlast;
    wire [3:0] m00_axis_tstrb;
    wire [32-1:0] m00_axis_tdata;//24bit
    // wire conv5_valid;
    //仿真控制
    reg [31:0] count,count1;
    reg cnt;
    reg sel;
    //测试向量存放寄存器组
    reg [kernel_1*kernel_1*channel_in_1*WIDTH-1:0]data_reg[IMG_W*IMG_H-1:0];

    //文件句柄
    integer handle1;
    integer handle2;
    integer i=0;

    initial begin
        $readmemh("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv1_in.txt",data_reg);
        $write("success_read");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv3_out.txt");
        // handle1 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv4_out.txt");
        handle1 = $fopen("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv5_out.txt");
        handle2 = $fopen("C:/Users/lenovo/vivado/18.3/AOD-Net_test_v1.0/AOD-Net_test_v1.0.sim/conv5_out_r.txt");
        // handle2 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.1.0/AOD_Net_v2.1.0.srcs/sim_1/new/conv4_in.txt");
        // handle2 = $fopen("E:/FPGA_project/DeHazeNet_modified/AOD_Net_v2.2/AOD_Net_v2.2.srcs/sim_1/new/conv5_in.txt");
        
        clk=0;
        // set=0;
        rstn = 0;
        s00_axis_tvalid = 0;
        s00_axis_tdata = data_reg[i];//RGB
        count=0;
        count1=0;
        cnt=1;
        sel = 0;
        #100 rstn = 1;
        // #100 set = 1;
        #90;
        @(posedge clk) s00_axis_tvalid = 1;
        // #90
        while (cnt==1) begin
            // #10;
            @(posedge AOD_Net_v1_1_U.s00_axis_tready);//
            s00_axis_tdata = data_reg[i];//RGB
            i=i+1;
            // s00_axis_tvalid=1;
            // @(posedge clk) s00_axis_tvalid = 0;
            if(i == IMG_W*IMG_H)begin
                cnt=0;
            end
        end
        @(posedge clk) s00_axis_tvalid = 0;
        s00_axis_tlast = 1;
        @(posedge clk)    s00_axis_tlast = 0;
        #45_0000 i = 0;
        cnt = 1;
        sel = 1;
        #90;          
        s00_axis_tdata = data_reg[i];
        @(posedge clk) s00_axis_tvalid = 1;
        // #90
        while (cnt==1) begin
            // #10;
            @(posedge AOD_Net_v1_1_U.s00_axis_tready);//
            s00_axis_tdata = data_reg[i];//RGB
            i=i+1;
            // s00_axis_tvalid=1;
            // @(posedge clk) s00_axis_tvalid = 0;
            if(i == IMG_W*IMG_H)begin
                cnt=0;
            end
        end
    end

    always #5 clk = ~clk;

    always @(posedge clk ) begin
        if(AOD_Net_v1_1_U.m00_axis_tvalid)
            count1<=count1 + 1;
    end

    always @(posedge clk ) begin
        if(AOD_Net_v1_1_U.s00_axis_tready)
            count<=count + 1;
    end
    // always @(*) begin
    //     if (count==IMG_W*IMG_H) begin
    //         #100;                AOD_Net_v1_1_S00_AXIS_inst
    //         $finish;
    //     end
    // end
    always @(*) begin
        if(count==IMG_W*IMG_H)
            s00_axis_tvalid <= 0;
    end
    always @(*) begin
        if(count1==IMG_W*IMG_H*2)
            $finish;
    end

    // always @(posedge clk ) begin
    //     if(AOD_Net_v1_1_U.m00_axis_tvalid&&!sel)
    //         $fstrobe(handle1,"%h",m00_axis_tdata[23:0]);
    // end
    // $fstrobe(handle1,$signed(AOD_Net_U.conv5_out[23:16]),",",$signed(AOD_Net_U.conv5_out[15:8]),",",$signed(AOD_Net_U.conv5_out[7:0]));
    always @(posedge clk ) begin
        if(AOD_Net_v1_1_U.m00_axis_tvalid&&sel)
            $fstrobe(handle2,"%h",m00_axis_tdata[23:0]);
    end

    //模块实例化
    AOD_Net_v1_1  AOD_Net_v1_1_U (
        // .ap_clk(clk),
        // .ap_rst_n(rstn),
        .m00_axis_aclk(clk),
        .m00_axis_aresetn(rstn),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tstrb(m00_axis_tstrb),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready),
        .s00_axis_aclk(clk),
        .s00_axis_aresetn(rstn),
        .s00_axis_tready(s00_axis_tready),
        .s00_axis_tdata(s00_axis_tdata),
        .s00_axis_tstrb(s00_axis_tstrb),
        .s00_axis_tlast(s00_axis_tlast),
        .s00_axis_tvalid(s00_axis_tvalid)
    );

endmodule

