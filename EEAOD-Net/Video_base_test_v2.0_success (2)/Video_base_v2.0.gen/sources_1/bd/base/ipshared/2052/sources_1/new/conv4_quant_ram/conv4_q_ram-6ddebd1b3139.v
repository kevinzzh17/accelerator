module conv4_q_ram #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3,
    parameter PIX_W = 640,
    parameter PIX_H = 480,
    parameter addr_width = 10,
    parameter kernel_size=7//改
)(
    input               clk,
    input               rstn,
    input               en   , //全局使能信号
    output         reg     valid, //输出有效
    input  [channel_in*WIDTH-1:0]  data2ram_in, //data input
    output [kernel_size*kernel_size*channel_out*WIDTH-1:0] data2conv//data output 1176bit
);
    // localparam PIX_W = 640;
    // localparam PIX_H = 480;

    reg en_r=0;//全局使能信号延时一周期

    wire enb;//ram读使能
    reg [48:0] dvalid=0;
    wire [6:0] sel_fir;
    reg [4:0] cnt_valid=0;//valid控制信号
    reg flag = 0;
    reg [3:0]cnt_8 = 0;
    reg cnt_8_valid = 0,cnt_8_valid_r = 0,cnt_8_valid_rr = 0;
    reg [3:0]addra_head=0;
    reg [addr_width-1:0] addra=0;
    wire addra_full,addra_head_full;
    reg [11:0] cnt_loop=0;
    reg [3:0] cnt_row=0;
    reg [ addr_width-1:0] cnt_tile=0;
    wire [kernel_size*kernel_size*channel_out*WIDTH-1:0] ram_out;
    wire fir_end,cnt_loop_full;
    wire ram_valid;
    reg flag_en;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            valid <= 1'b0;
        end
        else begin
            valid <= ram_valid;
        end
    end
    assign addra_full = (addra==PIX_W-1)?1'b1:1'b0;
    assign addra_head_full = addra_head[3];
    assign cnt_loop_full = (cnt_loop == PIX_H)&&(cnt_8 == 4'd7); //代表整个ram读数据读取完毕
//写
    //写状态机的参数
    localparam IDLE_A  = 1'b0;//空闲
    localparam WRITE_A = 1'b1;//写

    reg state_a=IDLE_A;

    //写使能
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_r<=0;
        end
        else begin
            en_r<=en;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_8_valid_r<=0;
            cnt_8_valid_rr<=0;
        end
        else begin
            cnt_8_valid_r<=cnt_8_valid;
            cnt_8_valid_rr <=cnt_8_valid_r;
        end
    end
    // assign en_pos = !en_r && en; //flag_en与第一个en同步拉高
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
            cnt_8_valid <=0;
        end
        else if (flag_en) begin
            if (cnt_8[3] == 1) begin
                cnt_8_valid <= 1;
                cnt_8 <= 0;
            end
            else begin
                cnt_8 <= cnt_8 + 1;
                cnt_8_valid <= 0;
            end
        end
        else begin
            cnt_8<=0;
            cnt_8_valid <=0;
        end
    end
    assign cnt_8_en = (cnt_8[3] == 1); //除第一个en除外，cnt_8_en与en同步

//写状态机
    //状态转移、地址生成
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
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
        else if (cnt_loop_full) begin
            state_a <= IDLE_A;
            addra  <=0;
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

    localparam IDLE    =  3'b000;//0
    localparam FIR     =  3'b001;//1
    localparam SEC     =  3'b010;//2
    localparam THI     =  3'b011;//3
    localparam LOOP    =  3'b100;//4
    localparam NTHI    =  3'b101;//5
    localparam NSEC    =  3'b110;//6
    localparam NEND    =  3'b111;//7

    reg [2:0] cstate=IDLE,nstate=IDLE;

    always @(posedge clk or negedge rstn) begin
        if(!rstn||cnt_loop_full) begin
            cstate <= IDLE; // 复位后状态机处于空闲态
        end
        else begin
            cstate <= nstate; // 更新状态
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            nstate <= IDLE;
        end
        else if (cnt_loop_full) begin
            nstate <= IDLE;
        end
        else if (cnt_8_en) begin
            case (cstate)
                IDLE:begin
                    if ((addra==10)&&(addra_head==5)) begin
                        nstate<=FIR;
                    end
                    else begin
                        nstate<=IDLE;
                    end
                end
                FIR:begin
                    if (fir_end) begin
                        nstate<=SEC;
                    end
                    else begin
                        nstate<=FIR;
                    end
                end
                SEC:begin
                    if (fir_end) begin
                        nstate<=THI;
                    end
                    else begin
                        nstate<=SEC;
                    end
                end
                THI:begin
                    if (fir_end) begin
                        nstate<=LOOP;
                    end
                    else begin
                        nstate<=THI;
                    end
                end
                LOOP:begin
                    if (cnt_loop==PIX_H-3) begin
                        nstate<=NTHI;
                    end
                    else begin
                        nstate<=LOOP;
                    end
                end
                NTHI:begin
                    if (fir_end) begin
                        nstate<=NSEC;
                    end
                    else begin
                        nstate<=NTHI;
                    end
                end
                NSEC:begin
                    if (fir_end) begin
                        nstate<=NEND;
                    end
                    else begin
                        nstate<=NSEC;
                    end
                end
                NEND:begin
                    if (fir_end) begin
                        nstate <=IDLE;
                    end
                    else begin
                        nstate <=NEND;
                    end
                end
                default:nstate <=IDLE;
            endcase
        end
        else begin
            nstate <= nstate;
        end
    end

    // always @(posedge clk or negedge rstn) begin
    //     if(!rstn) begin
    //         r_cstate<=0;
    //     end
    //     else if(en_r) begin
    //         r_cstate<=cstate;
    //     end
    // end

    //行地址生成
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt_row<=0;
        end
        else if (cnt_loop_full) begin
            cnt_row<=0;
        end
        else if(cnt_8_en&&(cnt_tile==PIX_W-1)) begin
            if (cnt_row[3]) begin
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

    //计算本行了几个7x7，同时也是生成块地址（cnt_tile）
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_tile<=0;
        end
        else if(cnt_8_en) begin
            if(cnt_tile==PIX_W-1) begin
                cnt_tile<=0;
            end
            else if(|cstate) begin
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


    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt_loop<=0;
        end
        else if(fir_end &&(cnt_8_valid_rr)) begin
                cnt_loop<=cnt_loop+1;
            end
        else if (cnt_loop_full) begin
            cnt_loop <= 0;
        end
        else begin
            cnt_loop<=cnt_loop;
        end
    end
    
    //读开始运行时，flag拉高
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            flag<=0;
        end
        else if(nstate==1) begin
            flag<=1;
        end
        else if (cnt_loop_full) begin
            flag <= 0;
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
            else 
                cnt_valid<=cnt_valid+1;
        end
        else cnt_valid<=0;
    end

    //读使能
    assign enb=((cnt_valid==0)&&flag)?1:0;

    reg [2:0] cstate_r;
    always @(posedge clk) begin
        if (cnt_loop_full) begin
            cstate_r <= 0;
        end
        else if (cnt_8_en) begin
            cstate_r <=cstate;
        end
        else cstate_r <= cstate_r;
    end
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            dvalid<=0;
        end
        else if (cnt_8_valid_r) begin
            case (cstate)
                IDLE:dvalid<={{3{7'b000_0000}},{4{7'b0001_111}}};
                FIR:dvalid<= {{3{7'b000_0000}},{4{sel_fir[6:0]}}};
                SEC:dvalid<= {{2{7'b000_0000}},{5{sel_fir[6:0]}}};
                THI:dvalid<= {{1{7'b000_0000}},{6{sel_fir[6:0]}}};
                LOOP:dvalid<={7{sel_fir[6:0]}};
                NTHI:dvalid<= {{6{sel_fir[6:0]}},{1{7'b000_0000}}};
                NSEC:dvalid<= {{5{sel_fir[6:0]}},{2{7'b000_0000}}};
                NEND:dvalid<= {{4{sel_fir[6:0]}},{3{7'b000_0000}}};
                default:dvalid<={{3{7'b000_0000}},{4{7'b0001_111}}};
            endcase
        end
        else dvalid<=dvalid;
    end

    genvar j;
    generate
        for (j = 0;j<49 ;j=j+1 ) begin
            assign data2conv[(1176-24*j)-1:(1176-24*j-24)]=dvalid[49-1-j:49-j-1]?ram_out[(1176-24*j)-1:(1176-24*j-24)]:24'h808080;
        end
    endgenerate

    //模块实例化
    conv4_q_fir #(
        .WIDTH(WIDTH),
        .channel_in(channel_in),
        .channel_out(channel_out),
        .PIX_W(PIX_W),
        .kernel_size(kernel_size)
    ) conv4_q_fir_U (
        .clk(clk),
        .rstn(rstn),
        .state_b(cstate_r),
        .en(cnt_8_valid),
        .cnt_loop_full(cnt_loop_full),
        .sel_fir(sel_fir),
        .fir_end(fir_end)
    );

    conv4_q_TPRAM # (
        .WIDTH(WIDTH),
        .addr_width(addr_width)
    ) conv4_q_TPRAM_U(
        .clk(clk),
        .rstn(rstn),
        .wea(en_r),
        .enb(enb),
        .cnt_loop_full(cnt_loop_full),
        .addra_head(addra_head),
        .addra(addra),
        .data_i_a(data2ram_in),
        .cnt_row(cnt_row),
        .cnt_tile(cnt_tile),
        .data2pe(ram_out),
        .valid(ram_valid)
    );

endmodule
