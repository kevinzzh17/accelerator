//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/03 15:50:48
// Design Name:
// Module Name: conv3
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
//          1.02 - add cnt_loop module and can cycle input,              (success)
//                 and is right when using zzh's tb.                     (success)
// Additional Comments:Change to output one data every nine cycles
//
//////////////////////////////////////////////////////////////////////////////////

module conv1 #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter channel_out=3
)(
    input clk,//系统时钟
    input rstn,//系统复位
    input start,//conv1使能信号
    input [channel_in*WIDTH-1:0] data_in,//RGB888数据
    output reg valid,//conv1数据有效信号
    output reg [channel_out*WIDTH-1:0] data_out//输出重量化后三通道信号
);
    //signal define
    reg signed [WIDTH-1:0] data=0;
    reg signed [WIDTH-1:0] weights=0;
    reg signed [2*WIDTH-1:0] data_bb=0;
    reg signed [2*WIDTH-1:0] data_b=0;
    reg signed [2*WIDTH-1:0] data_m=0;
    reg signed [2*WIDTH:0] data_shift_add=0;
    reg signed [2*WIDTH+2:0] data_c1=0;
    reg signed [2*WIDTH+2:0] data_c2=0;
    reg signed [2*WIDTH+2:0] data_c3=0;
    reg signed [2*WIDTH+2:0] data_sum=0;
    reg signed [4*WIDTH-1:0] data_mul=0;
    reg signed [WIDTH-1:0] data_relu=0;
    reg cnt1_en,conv_stop_r;
    reg [4:0] cnt=0;
    reg [4:0] cnt1=0;
    reg [4:0] cnt2=0;
    reg [4:0] cnt2_r=0;
    reg signed [WIDTH-1:0] W_RF [9:0];
    reg signed [2*WIDTH-1:0] M_RF [2:0];
    reg signed [2*WIDTH-1:0] B_RF [2:0];
    //c=a*b
    wire signed [2*WIDTH-1:0] tmp;
    reg signed [2*WIDTH-1:0] data_part;
    wire conv_stop;
    //data_in寄存
    reg [channel_in*WIDTH-1:0] data_in_reg=0;
    // always @(posedge clk or negedge rstn) begin
    //     if(!rstn)begin
    //         start_r <= 0;
    //     end
    //     else 
    //         start_r <= start;
    // end
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            data_in_reg <= 0;
        end
        else if(start)begin
            data_in_reg <= data_in;
        end
        else begin
            data_in_reg <= data_in_reg;
        end
    end
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            conv_stop_r<=0;
        end
        else if(conv_stop) begin
            conv_stop_r<=1;
        end
        else conv_stop_r<=0;
    end
    
    //上电置位（weights、bias和M都放一起）
    initial begin
        W_RF[ 0] = 8'h4f;
        W_RF[ 1] = 8'h77;
        W_RF[ 2] = 8'h87;
        W_RF[ 3] = 8'hff;
        W_RF[ 4] = 8'h81;
        W_RF[ 5] = 8'h81;
        W_RF[ 6] = 8'h81;
        W_RF[ 7] = 8'hd4;
        W_RF[ 8] = 8'h55;
        W_RF[ 9] = 8'h4f;
        M_RF[0]  = $signed(16'd661);
        M_RF[1]  = $signed(16'd472);
        M_RF[2]  = $signed(16'd494);
        B_RF[0]  = $signed(-16'd48);
        B_RF[1]  = $signed(-16'd100);
        B_RF[2]  = $signed(-16'd107);
    end

    //状态机的参数
    parameter IDLE  = 3'b000;//空闲
    parameter C1    = 3'b011;//channel1
    parameter C2    = 3'b010;//channel2
    parameter C3    = 3'b110;//channel3
    // parameter STOP  = 3'b100;//STOP

    reg [2:0] cstate=IDLE;//状态机
    reg [2:0] nstate=IDLE;//状态机

    //FSM1
    always@(posedge clk or negedge rstn)begin
        if(!rstn)begin
            cstate <= IDLE;
        end
        else begin
            cstate <= nstate;
        end
    end
    //FSM2
    always@(*)begin
        if(conv_stop_r) begin
            nstate = IDLE;
        end
        else begin
            case(cstate)
                IDLE:begin
                    if(start) nstate = C1;
                    else nstate = IDLE;
                end
                C1:begin
                    if(cnt == 3) nstate = C2;
                    else nstate = C1;
                end
                C2:begin
                    if(cnt == 6) nstate = C3;
                    else nstate = C2;
                end
                C3:begin
                    if(cnt == 9) nstate = C1;
                    else nstate = C3;
                end
                default: nstate = IDLE;
            endcase
        end
    end
    //FSM3
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            data <= 0;
            weights <= 0;
        end
        else begin
            case (cstate)
                IDLE:begin
                    data <= 0;
                    weights <= 0;
                end
                C1:begin
                    data <= data_in_reg[23:16];//R
                    weights <= W_RF[cnt2];
                end
                C2:begin
                    data <= data_in_reg[15:8];//G
                    weights <= W_RF[cnt2];
                end
                C3:begin
                    data <= data_in_reg[7:0];//B
                    weights <= W_RF[cnt2];
                end
                default:begin
                    data <= 0;
                    weights <= 0;
                end
            endcase
        end
    end

    //cnt 用于控制FSM和input、weights输出
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt <= 0;
        end
        else if(nstate==IDLE) cnt <= 0; 
        else begin
            if(cnt == 9)begin
                cnt <= 1;
            end
            else if((nstate==C1)||(nstate==C2)||(nstate==C3))begin//nstate[1]
                cnt <= cnt + 1;
            end
            else begin
                cnt <= cnt;
            end
        end
    end
    always @(posedge clk or negedge rstn) begin
            if(!rstn)begin
                cnt1_en <= 0;
            end
            else if(cstate==IDLE) cnt1_en <= 0; 
            else begin
                if(cnt2_r == 7)begin
                    cnt1_en <= 1;
                end
        end
end 


    //cnt1 用于控制STOP状态周期数和valid信号
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt1 <= 0;
        end
        else if(cstate==IDLE) cnt1 <= 0; 
        else begin
            if(cnt2==8)begin
                cnt1 <= 0;
            end
            else if(cnt1_en)begin
                cnt1 <= cnt1 + 1;
            end
            else begin
                cnt1 <= cnt1;
            end
        end
    end

    //qw*qx --> data_part
    assign tmp = weights * data;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            data_part <= 0;
        else if(cstate==IDLE) data_part <= 0; 
        else
            data_part <= tmp;
    end

    //产生valid信号
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            valid <= 0;
        else if(cnt1==7)
            valid <= 1;
        else
            valid <= 0;
    end

    //cnt2为conv延时一个时钟周期
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt2 <= 0;
            cnt2_r <= 0;
        end
        else begin
            cnt2<=cnt;
            cnt2_r <= cnt2;
        end
    end

    //sum(qw*qx) --> data_sum
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_c1<=0;
            data_c2<=0;
            data_c3<=0;
        end
        else if(cstate==IDLE) begin
            data_c1<=0;
            data_c2<=0;
            data_c3<=0;
        end
        else begin
            case (cnt2_r)
                1:begin
                    data_c1<=data_part;
                    data_c2<=data_c2;
                    data_c3<=data_c3;
                end
                2:begin
                    data_c1<=data_c1;
                    data_c2<=data_part;
                    data_c3<=data_c3;
                end
                3:begin
                    data_c1<=data_c1;
                    data_c2<=data_c2;
                    data_c3<=data_part;
                end
                4:begin
                    data_c1<=data_part+data_c1;
                    data_c2<=data_c2;
                    data_c3<=data_c3;
                end
                5:begin
                    data_c1<=data_c1;
                    data_c2<=data_part+data_c2;
                    data_c3<=data_c3;
                end
                6:begin
                    data_c1<=data_c1;
                    data_c2<=data_c2;
                    data_c3<=data_part+data_c3;
                end
                7:begin
                    data_c1<=data_part+data_c1;
                    data_c2<=data_c2;
                    data_c3<=data_c3;
                end
                8:begin
                    data_c1<=data_c1;
                    data_c2<=data_part+data_c2;
                    data_c3<=data_c3;
                end
                9:begin
                    data_c1<=data_c1;
                    data_c2<=data_c2;
                    data_c3<=data_part+data_c3;
                end
                default:begin
                    data_c1<=0;
                    data_c2<=0;
                    data_c3<=0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_sum<=0;
            data_m<=0;
            data_b<=0;
        end
        else if(cstate==IDLE) begin
            data_sum<=0;
            data_m<=0;
            data_b<=0;
        end
        else begin
            case (cnt1)
                0:begin
                    data_sum<=data_c1;
                    data_m<=M_RF[0];
                    data_b<=B_RF[0];
                end
                1:begin
                    data_sum<=data_c2;
                    data_m<=M_RF[1];
                    data_b<=B_RF[1];
                end
                2:begin
                    data_sum<=data_c3;
                    data_m<=M_RF[2];
                    data_b<=B_RF[2];
                end
                default:begin
                    data_sum<=0;
                    data_m<=0;
                    data_b<=0;
                end
            endcase
        end
    end

    //M*sum(qx*qw)>>16+B
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_mul<=0;
            data_bb<=0;
            data_shift_add<=0;
        end
        else if(cstate==IDLE) begin
            data_mul<=0;
            data_bb<=0;
            data_shift_add<=0;
        end
        else begin
            data_mul<=data_m*data_sum;
            data_bb<=data_b;
            data_shift_add<=(data_mul>>>16)+data_bb;
        end
    end

    //ReLU
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_relu <= 0;
        end
        else begin
            if (data_shift_add>127) begin
                data_relu<=127;
            end
            else if(data_shift_add<-128) begin
                data_relu<=-128;
            end
            else data_relu<=data_shift_add;
        end
    end

    //输出排序
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            data_out <= 0;
        end
        else if(cnt1==4) begin
            data_out[23:16]<=data_relu;
        end
        else if(cnt1==5) begin
            data_out[15:8]<=data_relu;
        end
        else if(cnt1==6) begin
            data_out[7:0]<=data_relu;
        end
        else begin
            data_out <= data_out;
        end
    end

    cnt_loop#(
        .PIX_W   ( PIX_W ),
        .PIX_H   ( PIX_H )
    )cnt_loop_c1_U(
        .clk     ( clk     ),
        .rstn    ( rstn    ),
        .loop_en ( valid ),
        .cnt_loop_full  ( conv_stop  )
    );

endmodule

