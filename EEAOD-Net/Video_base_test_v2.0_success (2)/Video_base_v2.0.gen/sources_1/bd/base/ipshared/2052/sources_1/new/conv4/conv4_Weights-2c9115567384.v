`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/04 18:02:33
// Design Name:
// Module Name: Weights
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////


module conv4_Weights#(
    parameter WIDTH = 8,
    parameter channel_in=6,
    parameter channel_out=3,
    parameter kernel_size=7
)(
    input clk,
    input rstn,
    input Weight_en,
    input conv_stop,
    output reg [kernel_size*kernel_size*WIDTH-1:0] weights2pe_1,
    output reg [kernel_size*kernel_size*WIDTH-1:0] weights2pe_2 //交替将weight输入两个PE中
);
    //参数定义
localparam IDLE = 2'b00;//空闲状态
localparam SEND = 2'b01;//权重发送状态

    //信号声明
reg [1:0] cstate=IDLE,nstate=IDLE;//状态寄存器
reg [4:0]cnt=0;//输出控制寄存器
wire cnt_8_flag;
assign cnt_8_flag = (cnt == 5'd8)?1'b1:1'b0;
reg [kernel_size*kernel_size*WIDTH-1:0] W_RF [channel_in*channel_out-1:0];//权重寄存器组

    //寄存器初始化
initial begin
    W_RF[0] <= {8'hec,8'h14,8'hb0,8'h68,8'hb6,8'hec,8'he9,8'h1c,8'h42,8'hf0,8'h7f,8'hef,8'h1d,8'h1d,8'hd0,8'hf4,8'ha1,8'h53,8'hb9,8'hd8,8'hc0,8'hf7,8'h10,8'hc8,8'h37,8'hc9,8'h07,8'h14,8'hd5,8'hf7,8'hac,8'h50,8'hb0,8'he4,8'he3,8'hf6,8'h0d,8'hd9,8'h5a,8'hca,8'hf8,8'heb,8'he9,8'hfb,8'hc3,8'h5f,8'hbd,8'hf1,8'hea};
    W_RF[1] <= {8'hea,8'hee,8'hf2,8'hf9,8'h29,8'h49,8'h2b,8'h03,8'hd2,8'hec,8'he6,8'h36,8'h57,8'h3a,8'h49,8'h23,8'h12,8'h28,8'h5f,8'h7f,8'h58,8'h0f,8'hfa,8'hf6,8'he3,8'h34,8'h31,8'h16,8'hf8,8'heb,8'hed,8'hef,8'h32,8'h4b,8'h15,8'hde,8'hd9,8'hda,8'hd3,8'h1e,8'h56,8'h2f,8'hef,8'hfb,8'he0,8'h11,8'h47,8'h77,8'h55};
    W_RF[2] <= {8'hd1,8'hfb,8'hcb,8'hf1,8'h8d,8'hd9,8'hed,8'he2,8'hff,8'hcb,8'hf2,8'h97,8'hd0,8'he6,8'he7,8'h04,8'hc8,8'hdf,8'h8c,8'he1,8'h01,8'h3a,8'h40,8'h08,8'hf8,8'hce,8'h2f,8'h4a,8'h06,8'hf9,8'he8,8'hf6,8'haf,8'hf9,8'h13,8'hdf,8'heb,8'hd7,8'hee,8'h9b,8'hee,8'he8,8'hd3,8'he1,8'hbd,8'hd5,8'h81,8'hc8,8'hde};
    W_RF[3] <= {8'hff,8'h03,8'hf9,8'h03,8'h02,8'hfd,8'hff,8'h09,8'h05,8'hf8,8'hff,8'hfd,8'hfd,8'hfb,8'h02,8'hfd,8'hf4,8'h0c,8'hfc,8'hfa,8'hfe,8'h07,8'h07,8'hfa,8'h05,8'hfb,8'hfe,8'h04,8'h01,8'hfc,8'hff,8'h00,8'hf4,8'h02,8'hfc,8'h00,8'hfe,8'hfe,8'hff,8'h02,8'hfe,8'h01,8'hfe,8'hf9,8'h04,8'hfb,8'hfd,8'h01,8'hfe};
    W_RF[4] <= {8'hfc,8'hec,8'hfe,8'h09,8'h0a,8'hfb,8'h05,8'hea,8'h13,8'h0c,8'h1f,8'hfa,8'h0e,8'h08,8'h06,8'hf3,8'h0c,8'hfd,8'h0c,8'h12,8'h15,8'he8,8'h06,8'h05,8'hfa,8'h10,8'h04,8'h05,8'hfd,8'hf2,8'h00,8'h16,8'h00,8'h09,8'hfa,8'hf7,8'h0c,8'h09,8'hf6,8'h11,8'h05,8'hfb,8'hee,8'hfb,8'hf1,8'h04,8'hea,8'hea,8'h06};
    W_RF[5] <= {8'hf7,8'h0a,8'hf8,8'hf3,8'hfb,8'hf5,8'hfb,8'h05,8'h01,8'hf4,8'hf7,8'hfe,8'h02,8'hfc,8'hf8,8'h03,8'hfc,8'hfa,8'h0b,8'hf3,8'hf1,8'h11,8'hfe,8'hf6,8'hfa,8'h08,8'hf9,8'hfe,8'hff,8'hfa,8'h06,8'hfe,8'h0b,8'h00,8'h0d,8'h0d,8'h00,8'h06,8'h02,8'h01,8'hfe,8'h02,8'h01,8'h02,8'hfb,8'hfe,8'h09,8'h01,8'h00};
    W_RF[6] <= {8'hf9,8'h02,8'hfd,8'hfc,8'hfe,8'hfa,8'hf9,8'hff,8'hff,8'hfb,8'h02,8'hf7,8'hf8,8'h03,8'hf9,8'hf8,8'hfa,8'hfd,8'hf9,8'hf9,8'hfb,8'hfe,8'h06,8'hfd,8'h06,8'h06,8'hfc,8'h04,8'hfb,8'hff,8'hf4,8'h00,8'hf6,8'hf6,8'hfa,8'hf8,8'h03,8'hf8,8'h02,8'hf7,8'hfd,8'hf8,8'hf7,8'h00,8'hfb,8'h08,8'hfc,8'h00,8'hf7};
    W_RF[7] <= {8'h00,8'h06,8'he6,8'h03,8'h06,8'h0d,8'h1a,8'h0b,8'h02,8'h08,8'h18,8'h08,8'h28,8'h31,8'h02,8'h20,8'h14,8'hfc,8'h07,8'h0e,8'h08,8'h0a,8'h02,8'h0d,8'h06,8'hfe,8'h29,8'hfc,8'h0a,8'hf8,8'h06,8'hf0,8'h13,8'h1a,8'h1d,8'h04,8'h1a,8'h15,8'h24,8'h0c,8'h3a,8'h27,8'h07,8'h12,8'h03,8'h0c,8'h24,8'h12,8'hfe};
    W_RF[8] <= {8'hf5,8'hf9,8'hf3,8'h03,8'hf7,8'hf5,8'he7,8'hec,8'hf4,8'hff,8'hf6,8'hfc,8'hf2,8'hf9,8'hf7,8'hf6,8'hf7,8'hfc,8'hf9,8'hec,8'hef,8'hf3,8'hfd,8'hfa,8'h07,8'hf1,8'h05,8'hfc,8'hf9,8'hf4,8'hf1,8'hf3,8'hf3,8'hf2,8'hed,8'hf5,8'hef,8'hf6,8'hf7,8'hee,8'hf6,8'hf7,8'hed,8'heb,8'hf3,8'hff,8'hf1,8'he4,8'hf6};
    W_RF[9] <= {8'h0d,8'h06,8'h01,8'h0c,8'hff,8'h03,8'h02,8'h04,8'h04,8'hff,8'h0d,8'h0c,8'h03,8'h00,8'h06,8'hfd,8'h04,8'hff,8'h02,8'h01,8'h00,8'h08,8'h00,8'hfe,8'hfd,8'h07,8'h09,8'hfa,8'h04,8'hfb,8'h04,8'h04,8'hfa,8'h01,8'h04,8'hfe,8'hfe,8'h01,8'h01,8'h03,8'h02,8'h04,8'h07,8'h05,8'hfe,8'h02,8'h02,8'h07,8'hf7};
    W_RF[10] <= {8'hdd,8'hed,8'hed,8'hf7,8'heb,8'he1,8'hf7,8'hec,8'hde,8'hd5,8'he8,8'hdf,8'hdc,8'hf3,8'hea,8'hfb,8'hf4,8'h0a,8'hdd,8'hf8,8'hfe,8'hfa,8'hfd,8'hec,8'hff,8'he0,8'he1,8'hec,8'hf7,8'hef,8'h00,8'hf8,8'he2,8'hfa,8'h12,8'h07,8'hf9,8'hff,8'h1c,8'h08,8'h10,8'h0b,8'h02,8'h00,8'hf6,8'h05,8'h09,8'hf9,8'h19};
    W_RF[11] <= {8'h10,8'h16,8'h0d,8'h11,8'h0b,8'h0b,8'h0e,8'h12,8'hf7,8'hfb,8'h02,8'hf4,8'h02,8'hf6,8'h15,8'h02,8'h08,8'hfb,8'hfc,8'h0d,8'hf8,8'h0a,8'h0b,8'h00,8'hfd,8'hf2,8'hf6,8'h06,8'h0a,8'hfa,8'h0b,8'h03,8'hf7,8'hf7,8'hf4,8'hff,8'hf9,8'h07,8'hf2,8'hfd,8'h08,8'hf0,8'hfc,8'hfe,8'hff,8'hf4,8'hea,8'hf7,8'hf0};
    W_RF[12] <= {8'h01,8'h01,8'h0a,8'h11,8'h0c,8'h00,8'h12,8'h03,8'h0b,8'h06,8'h08,8'h00,8'h07,8'h01,8'h09,8'h02,8'h03,8'hff,8'hfc,8'h0b,8'h05,8'h06,8'h06,8'h03,8'h0a,8'hfa,8'h0b,8'h0d,8'h03,8'h07,8'h04,8'h06,8'hf8,8'hfd,8'h03,8'h0d,8'h03,8'h08,8'h05,8'h04,8'h05,8'h0c,8'h0f,8'h06,8'h10,8'h11,8'h02,8'h03,8'h07};
    W_RF[13] <= {8'h09,8'hf8,8'hff,8'hf6,8'he6,8'hf0,8'hea,8'hfe,8'hf3,8'h05,8'he6,8'he0,8'hed,8'he6,8'hf4,8'hf1,8'hfe,8'h00,8'hd7,8'he6,8'hd3,8'hf4,8'hfc,8'hf4,8'hfe,8'he8,8'hdb,8'hd5,8'hf9,8'hf7,8'he8,8'hf5,8'hd2,8'hfb,8'hda,8'hfe,8'hf1,8'hfd,8'hed,8'hc7,8'hec,8'hee,8'h00,8'h01,8'h0d,8'hf6,8'hd0,8'hf5,8'hdc};
    W_RF[14] <= {8'h10,8'h16,8'h19,8'h0b,8'h0e,8'h0f,8'h11,8'h08,8'hff,8'h05,8'h00,8'hff,8'h0b,8'h0d,8'h03,8'hfe,8'h0a,8'hfc,8'hf9,8'hf6,8'h09,8'h14,8'h05,8'h0a,8'h03,8'h06,8'h0d,8'h13,8'h08,8'h0a,8'h0c,8'h08,8'hfb,8'h09,8'h11,8'h0d,8'h0a,8'h05,8'h10,8'h14,8'h0f,8'h18,8'h1b,8'h19,8'h19,8'h21,8'h23,8'h0e,8'h1c};
    W_RF[15] <= {8'h01,8'hff,8'h04,8'h01,8'h03,8'hfa,8'h05,8'hff,8'h01,8'hfd,8'hf8,8'h00,8'hfc,8'hff,8'h07,8'h05,8'h00,8'hff,8'h02,8'h02,8'h01,8'hfc,8'hfd,8'h01,8'hf8,8'hfe,8'h00,8'h05,8'hfb,8'h00,8'hff,8'hfe,8'hf8,8'h01,8'h08,8'hff,8'h05,8'hfa,8'h02,8'h06,8'hff,8'h04,8'hfc,8'hf7,8'h00,8'hfc,8'hfd,8'hf8,8'h08};
    W_RF[16] <= {8'h0d,8'h0b,8'h28,8'h0e,8'h03,8'hf1,8'hcf,8'h04,8'h12,8'h1f,8'hfa,8'h05,8'hed,8'hce,8'h08,8'hff,8'hfb,8'h04,8'h03,8'hda,8'hc6,8'h0b,8'hff,8'h18,8'hfa,8'h13,8'he3,8'hb7,8'h09,8'hfc,8'h0a,8'h13,8'hfc,8'hf5,8'hc7,8'h0b,8'h08,8'h11,8'hf8,8'h11,8'hdd,8'hb2,8'h06,8'h19,8'h08,8'hf8,8'h11,8'he4,8'hdd};
    W_RF[17] <= {8'h0c,8'hfe,8'hf5,8'hf8,8'h0a,8'h00,8'hfd,8'h02,8'h01,8'h05,8'hfc,8'h06,8'h01,8'h04,8'hfa,8'hfe,8'hf2,8'hf0,8'hf8,8'he7,8'h02,8'h17,8'hf5,8'hf2,8'h00,8'hf6,8'hf6,8'h01,8'h08,8'h0a,8'hfe,8'h0f,8'hf8,8'hf9,8'h01,8'h0f,8'hfd,8'h08,8'h06,8'hf8,8'h07,8'h0a,8'h1d,8'h1a,8'h16,8'h06,8'h09,8'h0e,8'h1b};
end

    //计数器控制逻辑
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        cnt <= 5'd0;
    end
    else begin
        if(cnt_8_flag)begin
            cnt <= 5'd0;
        end
        else if((nstate != IDLE)||Weight_en)begin
            cnt <= cnt + 5'd1;
        end
        else begin
            cnt <= 5'd0;
        end
    end
end

//FSM1:状态转移时序逻辑
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        cstate <= IDLE;
    end
    else begin
        cstate <= nstate;
    end
end

  //FSM2:产生下一个状态组合逻辑
always @(*) begin
    if(!rstn)begin
        nstate = IDLE;
    end
    else begin
        case(cstate)
            IDLE:begin
                if(Weight_en) nstate = SEND;
                else nstate = IDLE;
            end
            SEND:begin
                if(conv_stop) nstate = IDLE;
                else nstate = SEND;
            end
            default: nstate = IDLE;
        endcase
    end
end

    //FSM3:产生输出时序逻辑
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        weights2pe_1 <= 200'd0;
        weights2pe_2 <= 200'd0;
    end
    else begin
        case(nstate)
            SEND:begin 
                weights2pe_1 <= W_RF[2*cnt];
                weights2pe_2 <= W_RF[2*cnt+1];
            end
            default:begin
                weights2pe_1 <= 200'd0;
                weights2pe_2 <= 200'd0;
            end
        endcase
    end
end

endmodule
