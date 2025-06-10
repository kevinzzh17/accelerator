module conv4_q_fir #(
    parameter WIDTH = 8,
    parameter channel_in=3,
    parameter channel_out=3,
    parameter PIX_W = 640,
    parameter kernel_size=7//改
)(
    input clk,
    input rstn,
    input [2:0] state_b,
    input en,
    input cnt_loop_full,
    output [6:0] sel_fir,
    output reg fir_end
);
    localparam IDLE    =  3'b000;//0
    localparam FIR     =  3'b001;//1
    localparam SEC     =  3'b010;//2
    localparam THI     =  3'b011;//3
    localparam LOOP    =  3'b100;//4
    localparam NTHI    =  3'b101;//5
    localparam NSEC    =  3'b110;//6
    localparam NEND    =  3'b111;//7

    localparam Idle    =  2'b00;
    localparam First   =  2'b01;
    localparam Loop    =  2'b10;
    localparam Nend    =  2'b11;

    reg [1:0] state;
    reg [11:0] cnt1;
    reg [1:0] cnt0;
    reg [6:0] den;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state<=Idle;
        end
        else if (cnt_loop_full) begin
            state <= Idle;
        end
        else if(en) begin
            case (state)
                Idle:if(state_b==FIR) begin
                    state<=First;
                end
                First:if(cnt0==2) begin
                    state<=Loop;
                end
                else begin
                    state<=state;
                end
                Loop:if(cnt1==PIX_W-7) begin
                    state<=Nend;
                end
                else begin
                    state<=state;
                end
                Nend:if(cnt0==2) begin
                    state<=First;
                end
                else begin
                    state<=state;
                end
                default:state<=Idle;
            endcase
        end
        else begin
            state<=state;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            den <= 7'b0001_111;
        end
        else if (en) begin
            case (state)
                Idle: den <= 7'b0001_111;
                First:den <= (den<<1)+1;
                Loop: begin
                    if(cnt1==PIX_W-7) 
                        den <= den<<1;
                    else 
                        den<=den;
                end
                Nend: begin
                    if(cnt0==2) 
                        den<=7'b0001_111;
                    else 
                        den<=den<<1;
                end
                default:den<=den;
            endcase
        end
        else den<=den;
    end

    always @(posedge clk or negedge rstn ) begin
        if (!rstn) begin
            cnt0<=0;
        end
        else if (cnt_loop_full) begin
            cnt0<=0;
        end
        else if((en)&&(state==First||state==Nend)) begin
            if (cnt0==2) 
                cnt0<=0;
            else 
                cnt0 <= cnt0+1;
        end
        else cnt0 <= cnt0;
    end

    always @(posedge clk or negedge rstn ) begin
        if (!rstn) begin
            cnt1<=0;
        end
        else if((en)&&(state==Loop)) begin
            if (cnt1==PIX_W-7) begin
                cnt1<=0;
            end
            else cnt1 <= cnt1+1;
        end
        else cnt1 <= cnt1;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            fir_end<=0;
        end
        else if(state==Nend &&cnt0==2)begin
            fir_end<=1;
        end
        else fir_end<=0;
    end
    
    assign sel_fir = den;

endmodule