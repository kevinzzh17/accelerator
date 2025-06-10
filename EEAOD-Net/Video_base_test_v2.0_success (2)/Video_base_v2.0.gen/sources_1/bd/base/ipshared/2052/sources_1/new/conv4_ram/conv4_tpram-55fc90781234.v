module conv4_TPRAM #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3,
    parameter addr_width = 10,
    parameter kernel_size=7
)(
    input clk,
    input rstn,
    input wea, //enable write signal of channel a,a通道的写使能信号
    input enb, //enable signal of channel b,enb是b通道的读使能信号
    input cnt_loop_full,
    input [2:0] addra_head,//RAM写选通
    input [addr_width-1:0] addra, //RAM写地址
    input [channel_in*WIDTH-1:0] data_i_a, //data input of channel a
    input [2:0] cnt_row,//行计数器 0~4
    input [addr_width-1:0] cnt_tile,//列计数器 0~PIX_W-1
    output reg [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2pe,
    output reg valid
);
    //参数定义
    localparam PIX_W = 640;
    localparam PIX_H = 480;

    //信号声明
    reg [channel_in*WIDTH-1:0] data_o_b [kernel_size*kernel_size-1:0] ;
    //RAM信号
    reg wea_l1=0,wea_l2=0,wea_l3=0,wea_l4=0,wea_l5=0,wea_l6=0,wea_l7=0;
    reg [addr_width-1:0]addrb=0;
    wire [23:0]doutb_l1,doutb_l2,doutb_l3,doutb_l4,doutb_l5,doutb_l6,doutb_l7;
    //读信号计数器
    reg [2:0]cnt_b=0;
    reg cnt_b_en=0;
    wire cnt_b_6;
    wire  [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2pe_r;
    reg ram_valid;
    //产生一维输出数据
    // genvar j;
    // generate
    //     for (j = 0; j<kernel_size*kernel_size ; j=j+1) begin
    //         assign data2pe[(channel_in*kernel_size*kernel_size*WIDTH-24*j)-1:(channel_in*kernel_size*kernel_size*WIDTH-24*j-24)]=data_o_b[j];
    //     end
    // endgenerate

    genvar j;
    generate
        for (j = 0; j<49; j=j+1) begin
            assign data2pe_r[(1176-24*j)-1:(1176-24*j-24)]=data_o_b[j];
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
    
    //根据addra_head产生写RAM信号
    always @(*) begin
        case (addra_head)
            3'd0:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b1000000;
            3'd1:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0100000;
            3'd2:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0010000;
            3'd3:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0001000;
            3'd4:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0000100;
            3'd5:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0000010;
            3'd6:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0000001;
            default:{wea_l1,wea_l2,wea_l3,wea_l4,wea_l5,wea_l6,wea_l7} = 7'b0000000;
        endcase
    end

    //cnt_b计数器控制逻辑
    assign cnt_b_6 = (cnt_b == 6)?1'b1:1'b0;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            cnt_b_en <= 0;
        end
        else if(cnt_b_6||cnt_loop_full)begin
            cnt_b_en <= 0;
        end
        else if(!cnt_b_6&&enb)begin
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
        else if(cnt_b_6||cnt_loop_full)begin
            cnt_b <= 0;
        end
        else if(cnt_b_en)begin
            cnt_b <= cnt_b + 1;
        end
        else begin
            cnt_b <= cnt_b;
        end
    end

    //产生读地址
    always @(*) begin
        if(!rstn)begin
            addrb = 0;
        end
        else begin
            addrb = cnt_tile + cnt_b - 3;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= 168'd0;
            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= 168'd0;
            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= 168'd0;
            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= 168'd0;
            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= 168'd0;
            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= 168'd0;
            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= 168'd0;
        end
        else begin
            case(cnt_row)
                3'd0:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l5,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l6,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l7,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l1,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l2,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l3,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l4,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l5,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l6,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l7,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l1,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l2,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l3,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l4,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l5,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l6,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l7,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l1,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l2,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l3,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l4,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l5,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l6,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l7,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l1,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l2,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l3,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l4,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l5,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l6,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l7,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l1,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l2,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l3,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l4,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l5,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l6,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l7,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l1,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l2,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l3,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l4,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l5};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l6};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l7};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l1};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l2};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l3};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l4};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                3'd1:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l6,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l7,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l1,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l2,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l3,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l4,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l5,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l6,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l7,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l1,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l2,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l3,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l4,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l5,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l6,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l7,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l1,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l2,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l3,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l4,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l5,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l6,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l7,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l1,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l2,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l3,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l4,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l5,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l6,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l7,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l1,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l2,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l3,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l4,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l5,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l6,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l7,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l1,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l2,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l3,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l4,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l5,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l6};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l7};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l1};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l2};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l3};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l4};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l5};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                    
                end
                3'd2:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l7,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l1,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l2,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l3,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l4,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l5,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l6,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l7,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l1,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l2,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l3,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l4,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l5,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l6,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l7,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l1,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l2,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l3,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l4,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l5,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l6,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l7,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l1,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l2,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l3,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l4,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l5,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l6,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l7,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l1,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l2,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l3,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l4,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l5,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l6,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l7,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l1,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l2,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l3,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l4,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l5,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l6,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l7};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l1};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l2};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l3};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l4};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l5};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l6};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                3'd3:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l1,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l2,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l3,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l4,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l5,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l6,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l7,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l1,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l2,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l3,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l4,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l5,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l6,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l7,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l1,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l2,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l3,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l4,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l5,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l6,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l7,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l1,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l2,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l3,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l4,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l5,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l6,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l7,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l1,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l2,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l3,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l4,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l5,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l6,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l7,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l1,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l2,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l3,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l4,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l5,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l6,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l7,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l1};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l2};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l3};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l4};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l5};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l6};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l7};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                3'd4:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l2,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l3,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l4,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l5,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l6,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l7,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l1,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l2,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l3,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l4,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l5,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l6,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l7,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l1,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l2,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l3,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l4,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l5,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l6,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l7,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l1,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l2,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l3,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l4,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l5,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l6,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l7,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l1,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l2,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l3,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l4,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l5,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l6,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l7,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l1,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l2,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l3,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l4,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l5,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l6,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l7,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l1,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l2};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l3};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l4};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l5};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l6};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l7};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l1};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                3'd5:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l3,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l4,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l5,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l6,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l7,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l1,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l2,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l3,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l4,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l5,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l6,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l7,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l1,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l2,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l3,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l4,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l5,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l6,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l7,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l1,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l2,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l3,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l4,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l5,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l6,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l7,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l1,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l2,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l3,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l4,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l5,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l6,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l7,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l1,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l2,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l3,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l4,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l5,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l6,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l7,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l1,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l2,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l3};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l4};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l5};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l6};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l7};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l1};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l2};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                3'd6:begin
                    case(cnt_b)
                        3'd1:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {doutb_l4,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {doutb_l5,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {doutb_l6,data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {doutb_l7,data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {doutb_l1,data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {doutb_l2,data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {doutb_l3,data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd2:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,doutb_l4,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,doutb_l5,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],doutb_l6,data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],doutb_l7,data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],doutb_l1,data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],doutb_l2,data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],doutb_l3,data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd3:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,doutb_l4,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,doutb_l5,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],doutb_l6,data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],doutb_l7,data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],doutb_l1,data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],doutb_l2,data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],doutb_l3,data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd4:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,doutb_l4,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,doutb_l5,data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],doutb_l6,data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],doutb_l7,data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],doutb_l1,data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],doutb_l2,data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],doutb_l3,data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                        3'd5:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,doutb_l4,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],doutb_l5,data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],doutb_l6,data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],doutb_l7,data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],doutb_l1,data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],doutb_l2,data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],doutb_l3,data_o_b[47],data_o_b[48]};
                        end
                        3'd6:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,doutb_l4,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],doutb_l5,data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],doutb_l6,data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],doutb_l7,data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],doutb_l1,data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],doutb_l2,data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],doutb_l3,data_o_b[48]};
                        end
                        3'd0:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,doutb_l4};
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],doutb_l5};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],doutb_l6};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],doutb_l7};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],doutb_l1};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],doutb_l2};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],doutb_l3};
                        end
                        default:begin
                            {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] };
                            {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]};
                            {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]};
                            {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]};
                            {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]};
                            {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]};
                            {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]};
                        end
                    endcase
                end
                default:begin
                    {data_o_b[0] ,data_o_b[1] ,data_o_b[2] ,data_o_b[3] ,data_o_b[4] ,data_o_b[5] ,data_o_b[6] } <= 168'd0;
                    {data_o_b[7] ,data_o_b[8] ,data_o_b[9] ,data_o_b[10],data_o_b[11],data_o_b[12],data_o_b[13]} <= 168'd0;
                    {data_o_b[14],data_o_b[15],data_o_b[16],data_o_b[17],data_o_b[18],data_o_b[19],data_o_b[20]} <= 168'd0;
                    {data_o_b[21],data_o_b[22],data_o_b[23],data_o_b[24],data_o_b[25],data_o_b[26],data_o_b[27]} <= 168'd0;
                    {data_o_b[28],data_o_b[29],data_o_b[30],data_o_b[31],data_o_b[32],data_o_b[33],data_o_b[34]} <= 168'd0;
                    {data_o_b[35],data_o_b[36],data_o_b[37],data_o_b[38],data_o_b[39],data_o_b[40],data_o_b[41]} <= 168'd0;
                    {data_o_b[42],data_o_b[43],data_o_b[44],data_o_b[45],data_o_b[46],data_o_b[47],data_o_b[48]} <= 168'd0;
                end
            endcase
        end
    end

    //产生有效信号
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            ram_valid <= 0;
        else
            ram_valid <= cnt_b_6; 
    end

    //RAM例化
    RAM_c3_c4_l1 RAM_c3_c4_l1_U (
        .clka(clk),    // input wire clka
        .ena(wea_l1),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l1)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l2 RAM_c3_c4_l2_U (
        .clka(clk),    // input wire clka
        .ena(wea_l2),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l2)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l3 RAM_c3_c4_l3_U (
        .clka(clk),    // input wire clka
        .ena(wea_l3),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l3)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l4 RAM_c3_c4_l4_U (
        .clka(clk),    // input wire clka
        .ena(wea_l4),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l4)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l5 RAM_c3_c4_l5_U (
        .clka(clk),    // input wire clka
        .ena(wea_l5),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l5)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l6 RAM_c3_c4_l6_U (
        .clka(clk),    // input wire clka
        .ena(wea_l6),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l6)  // output wire [23 : 0] doutb
    );
    RAM_c3_c4_l7 RAM_c3_c4_l7_U (
        .clka(clk),    // input wire clka
        .ena(wea_l7),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [9 : 0] addra
        .dina(data_i_a),    // input wire [23 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(cnt_b_en),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(doutb_l7)  // output wire [23 : 0] doutb
    );

endmodule
