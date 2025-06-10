//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/11/07 16:36
// Design Name:cnt_loop
// Module Name: cnt_loop
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
// 嵌套循环，计数en,en上升沿出现640*480=307200次时输出cnt_loop_full（拉高一个周期）
// 
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module cnt_loop #(
    parameter PIX_W = 640,
    parameter PIX_H = 480
) (
    input               clk,
    input               rstn,
    input               loop_en,
    output              cnt_loop_full //拉高一下
);


    reg [11:0] cnt_loop=0;
    reg [11:0] cnt_tile=0;
    reg en_r,full_r;
    reg cnt_start;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_r<=0;
            full_r<=0;
        end
        else begin
            en_r<=loop_en;
            full_r<=cnt_loop_full;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_start<=0;
        end
        else if (en_r) begin
            cnt_start<=1;
        end
        else if(full_r) begin
            cnt_start<=0;
        end
        else begin
            cnt_start<=cnt_start;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_tile<=0;
        end
        else if (cnt_loop_full) begin
            cnt_tile<=0;
        end
        else begin
            if(cnt_tile==PIX_W&&en_r) begin
                cnt_tile<=0;
            end
            else if(loop_en&&cnt_start) cnt_tile<=cnt_tile+1;
                else cnt_tile<=cnt_tile;
        end
    end

    assign cnt_loop_full = (cnt_loop == PIX_H-1)&&(cnt_tile== PIX_W-1);
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_loop<=0;
        end
        else if (full_r) begin
            cnt_loop <= 0;
        end
        else if(cnt_tile==PIX_W) begin
                cnt_loop<=cnt_loop+1;
            end
        else begin
            cnt_loop<=cnt_loop;
        end
    end

endmodule

