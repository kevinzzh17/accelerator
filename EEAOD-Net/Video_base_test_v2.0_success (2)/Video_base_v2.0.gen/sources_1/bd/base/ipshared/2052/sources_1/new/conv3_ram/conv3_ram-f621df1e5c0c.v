module conv3_ram #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter addr_width = 10,
    parameter channel_out=3,
    parameter kernel_size=5
)(
    input               clk,
    input               rstn,
    input               en, //全局使能信号
    output           reg   valid, //输出有效
    input  [channel_in*WIDTH-1:0]  data2ram_in, //data input
    output [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2conv//data output
);
    // localparam PIX_W = 640;
    // localparam PIX_H = 480;

//write
    reg   [addr_width-1:0] addra =0 ;//写地址
    reg   [2:0] addra_head =0 ;//写RAM地址
    wire addra_full,addra_head_full;
    reg loop2end =0 ;//从loop状态变到end状态的控制信号
    reg en_r =0;//全局使能信号延时一周期
    wire [kernel_size*kernel_size*channel_out*WIDTH-1:0] ram_out;//从ram中出来的数据 600bit
    wire ram_valid;
    //写状态机的参数
    parameter IDLE_A  = 1'b0;//空闲
    parameter WRITE_A = 1'b1;//写

    reg [0:0] state_a=IDLE_A;//写状态机
//read
    reg [kernel_size*kernel_size-1:0] addrb_en=0;//读地址所在的数据有效 25bit
    reg [4:0] cnt_valid=0;//valid控制信号
    reg flag =0;//cnt_valid的控制信号
    reg [2:0] cnt_row =0;//读计数器（用于给行）,行的首地址(共五行)PIX_W*4
    reg [addr_width - 1:0] cnt_tile =0;//块计数器（计算到本行滑窗到第几个5x5,每行滑窗最高为PIX_W-1个）
    // reg [10:0] addrb_center; //kernel中心读地址(mem)
    wire enb;//ram读使能
    
    //读状态机
    localparam IDLE       = 5'b00000;//0
    localparam UP_R2_C2_L = 5'b00001;//1
    localparam UP_R2_C1_L = 5'b00011;//3
    localparam UP_R2_C0_M = 5'b00010;//2
    localparam UP_R2_C1_R = 5'b00110;//6
    localparam UP_R2_C2_R = 5'b00111;//7
    localparam UP_R1_C2_L = 5'b00101;//5
    localparam UP_R1_C1_L = 5'b00100;//4
    localparam UP_R1_C0_M = 5'b01100;//12
    localparam UP_R1_C1_R = 5'b01101;//13
    localparam UP_R1_C2_R = 5'b01111;//15
    localparam CT_R0_C2_L = 5'b01110;//14
    localparam CT_R0_C1_L = 5'b01010;//10
    localparam CT_R0_C0_M = 5'b01011;//11
    localparam CT_R0_C1_R = 5'b01001;//9
    localparam CT_R0_C2_R = 5'b01000;//8
    localparam DN_R1_C2_L = 5'b11000;//24
    localparam DN_R1_C1_L = 5'b11001;//25
    localparam DN_R1_C0_M = 5'b11011;//27
    localparam DN_R1_C1_R = 5'b11010;//26
    localparam DN_R1_C2_R = 5'b11110;//30
    localparam DN_R2_C2_L = 5'b11111;//31
    localparam DN_R2_C1_L = 5'b11101;//29
    localparam DN_R2_C0_M = 5'b11100;//28
    localparam DN_R2_C1_R = 5'b10100;//20
    localparam DN_R2_C2_R = 5'b10000;//16

    reg [3:0]cnt_8 = 0;//9个周期有效
    // reg cnt_8_valid = 0;

    reg [4:0] cstate=0,nstate=0;
    reg [11:0] cnt1=0;//小循环用
    reg [11:0] cnt2=0;//大循环用
    wire cnt1_full,cnt2_full;
    reg flag_en;
    wire cnt_8_en;
    wire cnt_loop_full;
    assign cnt1_full = (cnt1==PIX_W -5)?1'b1:1'b0;
    assign cnt2_full = (cnt2==PIX_H -3)?1'b1:1'b0;
    assign cnt_loop_full = (cnt2 == PIX_H)&&(nstate == IDLE)&&(cnt_8 == 4'd7);


    assign addra_full = (addra == PIX_W-1)?1'b1:1'b0;
    assign addra_head_full = (addra_head == kernel_size-1)?1'b1:1'b0;

    always @(posedge clk or negedge rstn) begin
        if (!rstn||cnt_loop_full) begin
            valid <= 1'b0;
        end
        else begin
            valid <= ram_valid;
        end
    end
    //写使能
    always @(posedge clk) begin
        en_r<=en;
    end

//写状态机
    //状态转移、地址生成
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state_a <= IDLE_A;
            addra  <=0;
        end
        else if (cnt_loop_full) begin
            state_a <= IDLE_A;
            addra  <=0;
        end
        else if(en) begin
            case (state_a)
                IDLE_A:begin//空闲
                    state_a <= WRITE_A;//状态转移
                    addra <= 0;//地址
                end
                WRITE_A:begin
                    state_a <= WRITE_A;
                    if(addra_full)begin
                        addra <= 0;//地址
                    end
                    else begin
                        addra<=addra + 1;
                    end
                end
                default:begin
                    state_a <= IDLE_A;
                    addra <= addra;
                end
            endcase
        end
        else begin
            state_a<=state_a;
            addra <= addra;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addra_head  <=0;
        end
        else if((en&&addra_head_full&&addra_full)||cnt_loop_full)begin
            addra_head <= 0;
        end
        else if(en&&!addra_head_full&&addra_full) begin
            addra_head <= addra_head + 1;
        end
        else begin
            addra_head <= addra_head;
        end
    end

//read logic:
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            flag_en <= 0;
        end
        else if (en) begin
            flag_en <= 1;
        end
        else if (cnt_loop_full) begin
            flag_en <= 0;
        end
        else flag_en <= flag_en;
    end

    //cnt_8_valid与en_r同步，代替原先的en_r信号
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_8<=0;
            // cnt_8_valid <=0;
        end
        else if (flag_en) begin
            if (cnt_8[3] == 1) begin
                // cnt_8_valid <= 1;
                cnt_8 <= 0;
            end
            else begin
                cnt_8 <= cnt_8 + 1;
                // cnt_8_valid <= 0;
            end
        end
        else begin
            cnt_8<=0;
            // cnt_8_valid <=0;
        end
    end
    assign cnt_8_en = (cnt_8[3] == 1); //除第一个en除外，cnt_8_en与en同步
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cstate <= IDLE;//复位后状态机处于空闲态
        end
        else begin
            cstate <= nstate;//更新状态
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            nstate <= IDLE;//复位后状态机处于空闲态
        end
        else if(cnt_8_en) begin
            case (nstate)
                IDLE: begin
                    if ((addra==2)&&(addra_head==2)) begin//数据写到第二行低三列即可开始读出
                        nstate<=UP_R2_C2_L;
                    end
                    else begin
                        nstate<=IDLE;
                    end
                end
                //|0|0|0|0|0|
                //|0|0|0|0|0|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                UP_R2_C2_L:begin
                    nstate<=UP_R2_C1_L;
                end
                UP_R2_C1_L:begin
                    nstate<=UP_R2_C0_M;
                end
                UP_R2_C0_M:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=UP_R2_C1_R;
                    end
                    else begin
                        nstate<=UP_R2_C0_M;
                    end
                end
                UP_R2_C1_R:begin//en加不加
                    nstate<=UP_R2_C2_R;
                end
                UP_R2_C2_R:begin//en加不加
                    nstate<=UP_R1_C2_L;
                end
                //|0|0|0|0|0|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                UP_R1_C2_L:begin
                    nstate<=UP_R1_C1_L;
                end
                UP_R1_C1_L:begin
                    nstate<=UP_R1_C0_M;
                end
                UP_R1_C0_M:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=UP_R1_C1_R;
                    end
                    else begin
                        nstate<=UP_R1_C0_M;
                    end
                end
                UP_R1_C1_R:begin//en加不加
                    nstate<=UP_R1_C2_R;
                end
                UP_R1_C2_R:begin//en加不加
                    nstate<=CT_R0_C2_L;
                end
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                CT_R0_C2_L:begin
                    nstate<=CT_R0_C1_L;
                end
                CT_R0_C1_L:begin
                    nstate<=CT_R0_C0_M;
                end
                CT_R0_C0_M:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=CT_R0_C1_R;
                    end
                    else begin
                        nstate<=CT_R0_C0_M;
                    end
                end
                CT_R0_C1_R:begin//en加不加
                    nstate<=CT_R0_C2_R;
                end
                CT_R0_C2_R:begin//en加不加
                    if (loop2end) begin
                        nstate<=DN_R1_C2_L;
                    end
                    else begin
                        nstate<=CT_R0_C2_L;
                    end
                end
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|0|0|0|
                DN_R1_C2_L:begin
                    nstate<=DN_R1_C1_L;
                end
                DN_R1_C1_L:begin
                    nstate<=DN_R1_C0_M;
                end
                DN_R1_C0_M:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=DN_R1_C1_R;
                    end
                    else begin
                        nstate<=DN_R1_C0_M;
                    end
                end
                DN_R1_C1_R:begin//en加不加
                    nstate<=DN_R1_C2_R;
                end
                DN_R1_C2_R:begin//en加不加
                    nstate<=DN_R2_C2_L;
                end
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|n|n|n|
                //|0|0|0|0|0|
                //|0|0|0|0|0|
                DN_R2_C2_L:begin
                    nstate<=DN_R2_C1_L;
                end
                DN_R2_C1_L:begin
                    nstate<=DN_R2_C0_M;
                end
                DN_R2_C0_M:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=DN_R2_C1_R;
                    end
                    else begin
                        nstate<=DN_R2_C0_M;
                    end
                end
                DN_R2_C1_R:begin//en加不加
                    nstate<=DN_R2_C2_R;
                end
                DN_R2_C2_R:begin//en加不加
                    nstate<=IDLE;
                end
                default:begin
                    nstate<=IDLE;
                end
            endcase
        end
        else begin
            nstate<=nstate;
        end
    end

    //从loop状态变到end状态的控制信号生成
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            loop2end<=0;
        end
        else if(cnt1_full && cnt2_full && cnt_8_en) begin
            loop2end<=1;
        end
        else if(cnt1_full && cnt2==PIX_H-2 && cnt_8_en) begin
            loop2end<=0;
        end
        else begin
            loop2end<=loop2end;
        end
    end
    reg [4:0]cstate_r;
    always @(posedge clk) begin
        if (cnt_loop_full) begin
            cstate_r <= 0;
        end
        else if (cnt_8 == 4'd7) begin
            cstate_r <=cstate;
        end
        else cstate_r <= cstate_r;
        
    end
    //读地址所在的数据有效
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addrb_en<=25'd0;
        end
        else begin
            case (cstate_r)
                // |24|23|22|21|20|
                // |19|18|17|16|15|
                // |14|13|12|11|10|
                // | 9| 8| 7| 6| 5|
                // | 4| 3| 2| 1| 0|
                IDLE      :addrb_en <= 25'b00000_00000_00000_00000_00000;//0
                UP_R2_C2_L:addrb_en <= 25'b00000_00000_00111_00111_00111;//1
                UP_R2_C1_L:addrb_en <= 25'b00000_00000_01111_01111_01111;//3
                UP_R2_C0_M:addrb_en <= 25'b00000_00000_11111_11111_11111;//2
                UP_R2_C1_R:addrb_en <= 25'b00000_00000_11110_11110_11110;//6
                UP_R2_C2_R:addrb_en <= 25'b00000_00000_11100_11100_11100;//7
                UP_R1_C2_L:addrb_en <= 25'b00000_00111_00111_00111_00111;//5
                UP_R1_C1_L:addrb_en <= 25'b00000_01111_01111_01111_01111;//4
                UP_R1_C0_M:addrb_en <= 25'b00000_11111_11111_11111_11111;//12
                UP_R1_C1_R:addrb_en <= 25'b00000_11110_11110_11110_11110;//13
                UP_R1_C2_R:addrb_en <= 25'b00000_11100_11100_11100_11100;//15
                CT_R0_C2_L:addrb_en <= 25'b00111_00111_00111_00111_00111;//14
                CT_R0_C1_L:addrb_en <= 25'b01111_01111_01111_01111_01111;//10
                CT_R0_C0_M:addrb_en <= 25'b11111_11111_11111_11111_11111;//11
                CT_R0_C1_R:addrb_en <= 25'b11110_11110_11110_11110_11110;//9
                CT_R0_C2_R:addrb_en <= 25'b11100_11100_11100_11100_11100;//8
                DN_R1_C2_L:addrb_en <= 25'b00111_00111_00111_00111_00000;//24
                DN_R1_C1_L:addrb_en <= 25'b01111_01111_01111_01111_00000;//25
                DN_R1_C0_M:addrb_en <= 25'b11111_11111_11111_11111_00000;//27
                DN_R1_C1_R:addrb_en <= 25'b11110_11110_11110_11110_00000;//26
                DN_R1_C2_R:addrb_en <= 25'b11100_11100_11100_11100_00000;//30
                DN_R2_C2_L:addrb_en <= 25'b00111_00111_00111_00000_00000;//31
                DN_R2_C1_L:addrb_en <= 25'b01111_01111_01111_00000_00000;//29
                DN_R2_C0_M:addrb_en <= 25'b11111_11111_11111_00000_00000;//28
                DN_R2_C1_R:addrb_en <= 25'b11110_11110_11110_00000_00000;//20
                DN_R2_C2_R:addrb_en <= 25'b11100_11100_11100_00000_00000;//16
                default   :addrb_en <= 25'b00000_00000_00000_00000_00000;
            endcase
        end
    end

    //计算 UP_R2_C0_M/UP_R1_C0_M/CT_R0_C0_M/DN_R1_C0_M/DN_R2_C0_M 运行了多久
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt1<=0;
        end
        else if(cnt_8_en &&(cstate==UP_R2_C0_M||cstate==UP_R1_C0_M||cstate==CT_R0_C0_M||cstate==DN_R1_C0_M||cstate==DN_R2_C0_M))
        begin
            if (cnt1_full) begin
                cnt1<=0;
            end
            else begin
                cnt1<=cnt1+1;
            end
        end
        else begin
            cnt1<=cnt1;
        end
    end

    //计算loop运行了多久
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt2<=0;
        end
        else if(cnt_8_en && cnt1_full) begin
            cnt2<=cnt2+1;
        end
        else if(cnt_loop_full) begin
                cnt2<=0;
            end
        else begin
            cnt2<=cnt2;
        end
    end

    //行地址生成
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt_row<=0;
        end
        else if (cnt_loop_full) begin
            cnt_row<=0;
        end
        else if(cnt_8_en&&(cnt_tile==PIX_W-1)) begin
            if (cnt_row==kernel_size-1) begin
                cnt_row<=0;
            end
            else begin
                cnt_row<=cnt_row+1;
            end
        end
        else begin
            cnt_row<=cnt_row;
        end
    end

    //计算本行了几个3x3，同时也是生成块地址（cnt_tile）
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_tile<=0;
        end
        else if (cnt_loop_full) begin
            cnt_tile<=0;
        end
        else if(cnt_8_en) begin
            if(cnt_tile==PIX_W-1) begin
                cnt_tile<=0;
            end
            else if(|cstate) begin//IDLE状态除外
                cnt_tile<=cnt_tile+1;
            end
            else begin
                cnt_tile<=cnt_tile;
            end
        end
        else begin
            cnt_tile<=cnt_tile;
        end
    end

    //读开始运行时，flag拉高
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            flag<=0;
        end
        else if (cnt_loop_full) begin
            flag <= 0;
        end
        else if(|nstate) begin
            flag<=1;
        end

        else begin
            flag<=flag;
        end
    end

    //根据cnt，控制读使能
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_valid<=0;
        end
        else if(flag) begin
            if(cnt_valid==8)begin
                cnt_valid<=0;
            end
            else begin
                cnt_valid<=cnt_valid+1;
            end
        end
        else begin
            cnt_valid<=0;
        end
    end

    //读使能
    assign enb=(cnt_valid==0&&flag)?1:0;

    //就是verilog不能mem输出
    genvar j;
    generate
        for (j = 0;j < kernel_size*kernel_size;j = j+1) begin
            assign data2conv[(600-24*j)-1:(600-24*j-24)]=addrb_en[24-j]?ram_out[(600-24*j)-1:(600-24*j-24)]:24'h808080;
        end
    endgenerate

    conv3_TPRAM #(
        .WIDTH(WIDTH),
        .addr_width(addr_width)
    ) conv3_TPRAM_U (
        .clk(clk),
        .rstn(rstn),
        .wea(en_r),//a通道的写使能信号
        .cnt_loop_full(cnt_loop_full),
        .addra_head(addra_head),
        .addra(addra),//写地址
        .data_i_a(data2ram_in),//写数据
        .enb(enb),//enb是b通道的读使能信号
        .cnt_row(cnt_row),
        .cnt_tile(cnt_tile),
        .data2pe(ram_out),
        .valid(ram_valid)
    );

endmodule
