module conv2_ram #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter addr_width = 11,
    parameter channel_out=3,
    parameter kernel_size=3
)(
    input clk ,
    input rstn ,
    input en , //全局使能信号
    output reg valid , //输出有效
    input [channel_in*WIDTH-1:0] data2ram_in , //data input
    output [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2conv //data output
);
    // localparam PIX_W = 640;
    // localparam PIX_H = 480;
    reg   [addr_width-1:0]        addra             =0      ;//写地址
    reg                 loop2end          =0      ;//从loop状态变到end状态的控制信号
    reg                 en_r                      ;//全局使能信号延时一周期
    wire [kernel_size*kernel_size*channel_out*WIDTH-1:0] ram_out;//从ram中出来的数据
    wire ram_valid;
    //写
    //写状态机的参数
    parameter IDLE_A  = 1'b0;//空闲
    parameter WRITE_A = 1'b1;//写

    reg [ 0:0] state_a=IDLE_A;//写状态机
    reg [ 8:0] addrb_en=0;//读地址所在的数据有效
    reg [ 4:0] cnt_valid=0;//valid控制信号
    reg        flag     =0;//cnt_valid的控制信号
    reg [11:0] cnt_row           =0      ;//读计数器（用于给行）,行的首地址(共三行)
    reg [11:0] cnt_tile          =0      ;//块计数器（计算到本行滑窗到第几个3x3,每行滑窗最高为640-1个）
    reg [3:0] cstate=0,nstate=0;
    reg [11:0] cnt1=0;//小循环用
    reg [11:0] cnt2=0;//大循环用
    reg [addr_width -1:0] addrb  [8:0];             //读地址(mem)，共9个地址
    wire [addr_width*9 -1:0] addrb2ram;              //读地址(wire)
    wire enb;//ram读使能
    wire cnt_tile_full;
    wire cnt_row_full;
    wire cnt1_full;
    wire cnt2_full,cnt_loop_full;
    
    reg [3:0]cnt_8 = 0;//9个周期有效
    // reg cnt_8_valid = 0;
    reg flag_en;
    wire cnt_8_en;

    assign cnt_tile_full = (cnt_tile==PIX_W-1)?1:0;
    assign cnt_row_full = (cnt_row==PIX_W*2)?1:0;
    assign cnt1_full = (cnt1==PIX_W - 3)?1:0;
    assign cnt2_full = (cnt2==PIX_H - 2)?1:0;

    //读状态机
    localparam IDLE       = 4'b0000;//0
    localparam FIR_FIR    = 4'b0001;//1
    localparam FIR_LOOP   = 4'b0010;//2
    localparam FIR_END    = 4'b0011;//3
    localparam LOOP_FIR   = 4'b0100;//4
    localparam LOOP_LOOP  = 4'b0101;//5
    localparam LOOP_END   = 4'b0110;//6
    localparam END_FIR    = 4'b0111;//7
    localparam END_LOOP   = 4'b1000;//8
    localparam END_END    = 4'b1001;//9
    
    assign cnt_loop_full = (cnt2 == PIX_H)&&(cstate == IDLE)&&(cnt_8[3]);
    //valid生成
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            valid <= 1'b0;
        end
        else begin
            valid <= ram_valid;
        end
    end

    //写使能
    always @(posedge clk ) begin
        en_r<=en;
    end

//写状态机
    //状态转移、地址生成
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addra  <=0;
            state_a<=IDLE_A;
        end
        else if (cnt_loop_full) begin
            addra  <=0;
            state_a<=IDLE_A;
        end
        else if(en) begin
            case (state_a)
                IDLE_A:begin//空闲
                    state_a<=WRITE_A;//状态转移
                    addra<=addra;//地址
                end
                WRITE_A:begin
                    state_a<=WRITE_A;
                    if (addra==PIX_W*kernel_size-1) begin
                        addra<=0;//地址
                    end
                    else begin
                        addra<=addra+1;
                    end
                end
                default:begin
                    state_a<=state_a;
                    addra<=addra;
                end
            endcase
        end
        else begin
            state_a<=state_a;
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
            cstate <= IDLE; // 复位后状态机处于空闲态
        end
        else begin
            cstate <= nstate; // 更新状态
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            nstate <= IDLE; // 复位后状态机处于空闲态
        end
        else if(cnt_8_en) begin
            case (cstate)
                IDLE:begin
                    if (addra==PIX_W+1) begin//改地址
                        nstate<=FIR_FIR;
                    end
                    else begin
                        nstate<=nstate;
                    end
                end
                FIR_FIR:nstate<=FIR_LOOP;
                FIR_LOOP:begin
                    if (cnt1_full) begin//en加不加
                        nstate<=FIR_END;
                    end
                    else begin
                        nstate<=nstate;
                    end
                end
                FIR_END:nstate<=LOOP_FIR;//en加不加
                LOOP_FIR:nstate<=LOOP_LOOP;
                LOOP_LOOP:begin
                    if (cnt1_full) begin
                        nstate<=LOOP_END;
                    end
                    else begin
                        nstate<=nstate;
                    end
                end
                LOOP_END:begin
                    if (loop2end) begin
                        nstate<=END_FIR;
                    end
                    else begin
                        nstate<=LOOP_FIR;
                    end
                end
                END_FIR:nstate<=END_LOOP;
                END_LOOP:begin
                    if (cnt1_full) begin
                        nstate<=END_END;
                    end
                    else begin
                        nstate<=nstate;
                    end
                end
                END_END:nstate<=IDLE;
                default:nstate<=IDLE;
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
        else if(cnt1==0 && cnt2==PIX_H-1 && cnt_8_en) begin
            loop2end<=0;
        end
        else begin
            loop2end<=loop2end;
        end
    end

    reg [3:0] cstate_r;
    always @(posedge clk) begin
        if (cnt_loop_full) begin
            cstate_r <= 0;
        end
        else if (cnt_8_en) begin
            cstate_r <=cstate;
        end
        else cstate_r <= cstate_r;
    end
    //读地址所在的数据有效
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addrb_en<=9'b000_000_000;
        end
        else begin
            case (cstate_r)
                IDLE     : addrb_en<=9'b000_000_000;
                FIR_FIR  : addrb_en<=9'b000_011_011;
                FIR_LOOP : addrb_en<=9'b000_111_111;
                FIR_END  : addrb_en<=9'b000_110_110;
                LOOP_FIR : addrb_en<=9'b011_011_011;
                LOOP_LOOP: addrb_en<=9'b111_111_111;
                LOOP_END : addrb_en<=9'b110_110_110;
                END_FIR  : addrb_en<=9'b011_011_000;
                END_LOOP : addrb_en<=9'b111_111_000;
                END_END  : addrb_en<=9'b110_110_000;
                default  : addrb_en<=9'b000_000_000;
            endcase
        end
    end

    //计算FIR_LOOP，LOOP_LOOP，END_LOOP运行了多久
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt1<=0;
        end
        else if(cnt_8_en &&(cstate==FIR_LOOP||cstate==LOOP_LOOP||cstate==END_LOOP))
        begin
            if (cnt1_full) begin
                cnt1<=0;
            end
            else cnt1<=cnt1+1;
        end
        else cnt1<=cnt1;
    end

    //计算loop运行了多久
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt2<=0;
        end
        else if (cnt_loop_full) begin
            cnt2<=0;
        end
        else if(cnt_8_en && cnt1_full) begin
            cnt2<=cnt2+1;
        end
        else cnt2<=cnt2;
    end

    //行地址生成
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt_row<=0;
        end
        else if (cnt_loop_full) begin
            cnt_row<=0;
        end
        else if(cnt_8_en) begin
            if (cnt_tile_full) begin
                if (cnt_row_full) begin
                    cnt_row<=0;
                end
                else begin
                    cnt_row<=cnt_row+PIX_W;
                end
            end
            else cnt_row<=cnt_row;
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
            if(cnt_tile_full) begin
                cnt_tile<=0;
            end
            else if(|cstate) begin
                cnt_tile<=cnt_tile+1;
            end
            else cnt_tile<=cnt_tile;
        end
        else cnt_tile<=cnt_tile;
    end

    //读开始运行时，flag拉高
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            flag<=0;
        end 
       else if (cnt_loop_full) begin
            flag<=0;
        end
        else if(nstate == 1) begin
            flag<=1;
        end
        else flag<=flag;
    end
    //根据cnt，控制读使能
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_valid<=0;
        end
        else if(flag) begin
            if(cnt_valid==8)
                cnt_valid<=0;
            else  cnt_valid<=cnt_valid+1;
        end
        else cnt_valid<=0;
    end
    //读使能
    assign enb=((cnt_valid==0)&&flag)?1:0;
//读地址生成
    /*
    0 1 2
    3 4 5
    6 7 8
    */
    //上面
    always @(posedge clk ) begin
        if(addrb[4]<PIX_W) begin
            addrb[1]<=addrb[4]+2*PIX_W;
            addrb[0]<=addrb[4]+2*PIX_W-1;
            addrb[2]<=addrb[4]+2*PIX_W+1;
        end
        else begin
            addrb[1]<=addrb[4]-PIX_W;
            addrb[0]<=addrb[4]-PIX_W-1;
            addrb[2]<=addrb[4]-PIX_W+1;
        end
    end
    //中间
    always @(*) begin
        addrb[4]=cnt_row+cnt_tile;//用组合逻辑
    end
    //下面
    always @(posedge clk ) begin
        if(addrb[4]>=2*PIX_W) begin
            addrb[7]<=addrb[4]-2*PIX_W;
            addrb[6]<=addrb[4]-2*PIX_W-1;
            addrb[8]<=addrb[4]-2*PIX_W+1;
        end
        else begin
            addrb[7]<=addrb[4]+PIX_W;
            addrb[6]<=addrb[4]+PIX_W-1;
            addrb[8]<=addrb[4]+PIX_W+1;
        end
    end

    //其余地址
    always @(posedge clk ) begin
        addrb[3]<=addrb[4]-1;
        addrb[5]<=addrb[4]+1;
    end

    //就是verilog不能mem输入
    genvar i;
    generate
        for (i = 0;i<9 ;i=i+1 ) begin
            assign addrb2ram[addr_width*(i+1)-1:addr_width*i]=addrb[i];
        end
    endgenerate

    //就是verilog不能mem输出
    genvar j;
    generate
        for (j = 0;j<9 ;j=j+1 ) begin
            assign data2conv[(216-24*j)-1:(216-24*j-24)]=addrb_en[8-j]?ram_out[(216-24*j)-1:(216-24*j-24)]:24'h808080;
        end
    endgenerate

    conv2_TPRAM #(
        .WIDTH(WIDTH),
        .addr_width(addr_width)
    ) conv2_TPRAM_U (
        .clk(clk),
        .rstn(rstn),
        .wea(en_r),//a通道的写使能信号
        .cnt_loop_full(cnt_loop_full),
        .addra(addra),//写地址
        .data_i_a(data2ram_in),//写数据
        .enb(enb),//enb是b通道的读使能信号
        .addrb(addrb2ram),
        .valid(ram_valid),
        .data2pe(ram_out)
    );

endmodule


