module conv2_TPRAM #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3,
    parameter addr_width = 11,
    parameter kernel_size=3
)(
    input clk,
    input rstn,
    input wea,                  //enable write signal of channel a,a通道的写使能信号
    input enb,                  //enable signal of channel b,enb是b通道的读使能信号
    input cnt_loop_full,
    input [addr_width:0] addra,          //address of channel a
    input [channel_in*WIDTH-1:0] data_i_a,      //data input of channel a
    input [9*addr_width-1:0] addrb,
    output reg valid,
    output reg [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2pe
);
    //信号声明
    reg [channel_in*WIDTH-1:0] data_o_b [kernel_size*kernel_size-1:0] ;//输出滑窗数据寄存器
    reg [addr_width-1:0] addrb_m [kernel_size*kernel_size-1:0] ;//输出数据地址
    wire [addr_width-1:0] addrb_mm;//给RAM的输出数据地址
    reg [3:0] cnt_b=0;//读出计数器
    reg cnt_b_en=0;
    wire cnt_b_8;
    wire [23 : 0] doutb; //从RAM读出数据
    reg [3:0] cnt_b_r =0;
    wire  [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2pe_r;
    reg ram_valid;
    
    //产生读地址
    integer i;
    always @(*) begin
        for (i = 0;i < 9;i = i+1) begin
            addrb_m[i] = addrb[i*addr_width+:addr_width];
        end
    end

    //产生一维输出数据
    genvar j;
    generate
        for (j = 0;j < 9;j = j+1) begin
            assign data2pe_r[(216-24*j)-1:(216-24*j-24)] = data_o_b[j];
        end
    endgenerate
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            valid <= 1'b0;
        end
        else begin
            valid <= ram_valid;
        end
    end
    always @(posedge clk) begin
        if (cnt_loop_full) begin
            data2pe <= 0;
        end
        else if (valid) begin
            data2pe <= data2pe_r;
        end
        else data2pe <= data2pe;
    end
    //cnt_b计数器控制逻辑
    assign cnt_b_8 = (cnt_b == 8)?1'b1:1'b0;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt_b_en <= 0;
        end
        else if(cnt_loop_full)begin
            cnt_b_en <= 0;
        end
        else if(enb)begin
            cnt_b_en <= 1;
        end
        else begin
            cnt_b_en <= cnt_b_en;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt_b <= 0;
        end
        else if(cnt_loop_full)begin
            cnt_b <= 0;
        end
        else if(cnt_b_en||enb)begin
            if(cnt_b_8)begin
                cnt_b <= 0;
            end
            else begin
                cnt_b <= cnt_b + 1;
            end
        end
        else begin
            cnt_b <= cnt_b;
        end
    end
    
    always @(posedge clk) begin
        cnt_b_r <= cnt_b;
    end
    //RAM读地址
    assign addrb_mm = addrb_m[cnt_b];

    //RAM读数据
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            data_o_b[0] <= 0;
            data_o_b[1] <= 0;
            data_o_b[2] <= 0;
            data_o_b[3] <= 0;
            data_o_b[4] <= 0;
            data_o_b[5] <= 0;
            data_o_b[6] <= 0;
            data_o_b[7] <= 0;
            data_o_b[8] <= 0;
        end
        else if(cnt_b_en) begin
            data_o_b[cnt_b_r] <= doutb;
        end
        else begin
            data_o_b[0] <= data_o_b[0];
            data_o_b[1] <= data_o_b[1];
            data_o_b[2] <= data_o_b[2];
            data_o_b[3] <= data_o_b[3];
            data_o_b[4] <= data_o_b[4];
            data_o_b[5] <= data_o_b[5];
            data_o_b[6] <= data_o_b[6];
            data_o_b[7] <= data_o_b[7];
            data_o_b[8] <= data_o_b[8];
        end
    end

    //产生valid信号
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            ram_valid <= 0;
        end
        else begin
            ram_valid <= cnt_b_8;
        end
    end

    //RAM实例化
    RAM_c1_c2 RAM_c1_c2_U (
        .clka(clk),    // input wire clka
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [10 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb_mm),  // input wire [10 : 0] addrb
        .doutb(doutb)  // output wire [23 : 0] doutb
    );
    
endmodule
