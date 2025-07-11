// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module pixel_pack_pixel_pack_Pipeline_VITIS_LOOP_21_1 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        stream_in_24_TVALID,
        stream_out_32_TREADY,
        stream_out_32_TDATA,
        stream_out_32_TVALID,
        stream_out_32_TKEEP,
        stream_out_32_TSTRB,
        stream_out_32_TUSER,
        stream_out_32_TLAST,
        stream_in_24_TDATA,
        stream_in_24_TREADY,
        stream_in_24_TKEEP,
        stream_in_24_TSTRB,
        stream_in_24_TUSER,
        stream_in_24_TLAST
);

parameter    ap_ST_fsm_pp0_stage0 = 4'd1;
parameter    ap_ST_fsm_pp0_stage1 = 4'd2;
parameter    ap_ST_fsm_pp0_stage2 = 4'd4;
parameter    ap_ST_fsm_pp0_stage3 = 4'd8;
parameter    ap_const_lv96_0 = 96'd0;
parameter    ap_const_lv4_0 = 4'd0;


input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input   stream_in_24_TVALID;
input   stream_out_32_TREADY;
output  [31:0] stream_out_32_TDATA;
output   stream_out_32_TVALID;
output  [3:0] stream_out_32_TKEEP;
output  [3:0] stream_out_32_TSTRB;
output  [0:0] stream_out_32_TUSER;
output  [0:0] stream_out_32_TLAST;
input  [23:0] stream_in_24_TDATA;
output   stream_in_24_TREADY;
input  [2:0] stream_in_24_TKEEP;
input  [2:0] stream_in_24_TSTRB;
input  [0:0] stream_in_24_TUSER;
input  [0:0] stream_in_24_TLAST;

reg ap_idle;
reg[31:0] stream_out_32_TDATA;
reg stream_out_32_TVALID;
reg[0:0] stream_out_32_TUSER;
reg[0:0] stream_out_32_TLAST;
reg stream_in_24_TREADY;

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
wire    ap_CS_fsm_pp0_stage1;
reg   [0:0] delayed_last_reg_129;
reg   [0:0] last_8_reg_140;
reg   [0:0] tmp_last_V_reg_447;
reg    ap_predicate_op30_read_state2;
reg    ap_block_state2_pp0_stage1_iter0;
reg   [0:0] delayed_last_reg_129_pp0_iter1_reg;
reg   [0:0] last_8_reg_140_pp0_iter1_reg;
reg    ap_predicate_op78_write_state6;
reg    ap_block_state6_pp0_stage1_iter1;
reg    ap_block_state6_io;
reg    ap_block_pp0_stage1_subdone;
reg    ap_condition_exit_pp0_iter0_stage1;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
wire    ap_CS_fsm_pp0_stage3;
reg   [0:0] tmp_last_V_7_reg_464;
reg   [0:0] tmp_last_V_8_reg_509;
reg    ap_predicate_op53_read_state4;
reg    ap_predicate_op67_write_state4;
reg    ap_block_state4_pp0_stage3_iter0;
reg    ap_block_state4_io;
reg    ap_block_pp0_stage3_subdone;
reg    stream_out_32_TDATA_blk_n;
wire    ap_block_pp0_stage3;
wire    ap_block_pp0_stage0;
wire    ap_block_pp0_stage1;
reg    stream_in_24_TDATA_blk_n;
reg   [0:0] ap_phi_mux_delayed_last_phi_fu_132_p4;
reg   [0:0] ap_phi_mux_last_8_phi_fu_144_p4;
wire    ap_CS_fsm_pp0_stage2;
wire    ap_block_pp0_stage2;
reg    ap_predicate_op26_read_state1;
reg    ap_block_state1_pp0_stage0_iter0;
reg    ap_predicate_op77_write_state5;
reg    ap_block_state5_pp0_stage0_iter1;
reg    ap_block_state5_io;
reg    ap_block_pp0_stage0_11001;
reg   [0:0] last_2_31065_reg_208;
reg   [23:0] tmp_data_V_reg_435;
reg   [0:0] tmp_user_V_reg_441;
wire   [0:0] grp_fu_230_p1;
reg   [23:0] tmp_data_V_10_reg_452;
reg    ap_block_pp0_stage1_11001;
reg   [0:0] tmp_user_V_9_reg_458;
wire   [95:0] p_Result_9_fu_235_p5;
reg    ap_predicate_op44_read_state3;
reg    ap_block_state3_pp0_stage2_iter0;
reg    ap_block_pp0_stage2_11001;
wire   [2:0] trunc_ln855_fu_255_p1;
wire   [3:0] p_Result_11_fu_259_p4;
wire   [95:0] p_Result_12_fu_268_p5;
wire   [2:0] trunc_ln855_1_fu_288_p1;
wire   [3:0] p_Result_14_fu_292_p4;
reg   [23:0] tmp_data_V_11_reg_499;
reg   [0:0] tmp_user_V_10_reg_504;
wire   [95:0] p_Result_15_fu_301_p5;
wire   [2:0] trunc_ln855_2_fu_323_p1;
wire   [3:0] p_Result_17_fu_327_p4;
reg   [31:0] out_pixel_data_V_1_reg_528;
reg    ap_block_pp0_stage3_11001;
reg   [0:0] p_Result_5_reg_533;
reg   [0:0] p_Result_6_reg_538;
reg   [31:0] out_pixel_data_V_2_reg_543;
reg   [0:0] p_Result_7_reg_548;
reg   [0:0] p_Result_8_reg_553;
reg    ap_enable_reg_pp0_iter0_reg;
wire    ap_loop_init;
reg    ap_block_pp0_stage0_subdone;
reg   [95:0] ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8;
wire   [95:0] p_Result_18_fu_337_p5;
reg   [95:0] ap_phi_reg_pp0_iter0_buffer_1_3_ph_reg_152;
reg   [3:0] ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8;
wire   [3:0] p_Result_20_fu_355_p3;
reg   [3:0] ap_phi_reg_pp0_iter0_has_last_1_3_ph_reg_165;
reg   [2:0] ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8;
wire   [2:0] p_Result_19_fu_347_p4;
reg   [2:0] ap_phi_reg_pp0_iter0_has_user_1_3_ph_reg_178;
reg   [0:0] ap_phi_mux_last_2_3_ph_phi_fu_195_p8;
wire   [0:0] ap_phi_reg_pp0_iter0_last_2_31065_reg_208;
wire   [31:0] out_pixel_data_V_fu_369_p1;
reg    ap_block_pp0_stage3_01001;
reg    ap_block_pp0_stage0_01001;
reg    ap_block_pp0_stage1_01001;
wire   [0:0] p_Result_s_fu_364_p1;
wire   [3:0] p_Result_10_fu_246_p4;
wire   [3:0] p_Result_13_fu_279_p4;
wire   [3:0] p_Result_16_fu_313_p4;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg   [3:0] ap_NS_fsm;
reg    ap_idle_pp0_1to1;
reg    ap_block_pp0_stage2_subdone;
wire    ap_enable_pp0;
wire    ap_start_int;
reg    ap_condition_526;
reg    ap_condition_534;
reg    ap_condition_531;
reg    ap_condition_540;
reg    ap_condition_285;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 4'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter0_reg = 1'b0;
#0 ap_done_reg = 1'b0;
end

pixel_pack_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage1),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage1)) begin
            ap_enable_reg_pp0_iter0_reg <= 1'b0;
        end else if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
            ap_enable_reg_pp0_iter0_reg <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage3_subdone) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_531)) begin
        if ((1'b1 == ap_condition_534)) begin
            ap_phi_reg_pp0_iter0_buffer_1_3_ph_reg_152 <= p_Result_15_fu_301_p5;
        end else if (((tmp_last_V_7_reg_464 == 1'd1) & (tmp_last_V_reg_447 == 1'd0))) begin
            ap_phi_reg_pp0_iter0_buffer_1_3_ph_reg_152 <= p_Result_12_fu_268_p5;
        end else if ((tmp_last_V_reg_447 == 1'd1)) begin
            ap_phi_reg_pp0_iter0_buffer_1_3_ph_reg_152 <= p_Result_9_fu_235_p5;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_531)) begin
        if ((1'b1 == ap_condition_534)) begin
            ap_phi_reg_pp0_iter0_has_last_1_3_ph_reg_165 <= p_Result_17_fu_327_p4;
        end else if (((tmp_last_V_7_reg_464 == 1'd1) & (tmp_last_V_reg_447 == 1'd0))) begin
            ap_phi_reg_pp0_iter0_has_last_1_3_ph_reg_165 <= p_Result_14_fu_292_p4;
        end else if ((tmp_last_V_reg_447 == 1'd1)) begin
            ap_phi_reg_pp0_iter0_has_last_1_3_ph_reg_165 <= p_Result_11_fu_259_p4;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_531)) begin
        if ((1'b1 == ap_condition_534)) begin
            ap_phi_reg_pp0_iter0_has_user_1_3_ph_reg_178 <= trunc_ln855_2_fu_323_p1;
        end else if (((tmp_last_V_7_reg_464 == 1'd1) & (tmp_last_V_reg_447 == 1'd0))) begin
            ap_phi_reg_pp0_iter0_has_user_1_3_ph_reg_178 <= trunc_ln855_1_fu_288_p1;
        end else if ((tmp_last_V_reg_447 == 1'd1)) begin
            ap_phi_reg_pp0_iter0_has_user_1_3_ph_reg_178 <= trunc_ln855_fu_255_p1;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_init == 1'b1))) begin
            delayed_last_reg_129 <= 1'd0;
        end else if ((1'b1 == ap_condition_540)) begin
            delayed_last_reg_129 <= last_8_reg_140;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_285)) begin
        if (((last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0))) begin
            last_2_31065_reg_208 <= ap_phi_mux_last_2_3_ph_phi_fu_195_p8;
        end else if ((1'b1 == 1'b1)) begin
            last_2_31065_reg_208 <= ap_phi_reg_pp0_iter0_last_2_31065_reg_208;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_init == 1'b1))) begin
            last_8_reg_140 <= 1'd0;
        end else if ((1'b1 == ap_condition_540)) begin
            last_8_reg_140 <= last_2_31065_reg_208;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        delayed_last_reg_129_pp0_iter1_reg <= delayed_last_reg_129;
        last_8_reg_140_pp0_iter1_reg <= last_8_reg_140;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage3_11001) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        out_pixel_data_V_1_reg_528 <= {{ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8[63:32]}};
        out_pixel_data_V_2_reg_543 <= {{ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8[95:64]}};
        p_Result_5_reg_533 <= ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8[32'd1];
        p_Result_6_reg_538 <= ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8[32'd2];
        p_Result_7_reg_548 <= ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8[32'd2];
        p_Result_8_reg_553 <= ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8[32'd3];
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        tmp_data_V_10_reg_452 <= stream_in_24_TDATA;
        tmp_last_V_7_reg_464 <= stream_in_24_TLAST;
        tmp_user_V_9_reg_458 <= stream_in_24_TUSER;
    end
end

always @ (posedge ap_clk) begin
    if (((tmp_last_V_7_reg_464 == 1'd0) & (1'b0 == ap_block_pp0_stage2_11001) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        tmp_data_V_11_reg_499 <= stream_in_24_TDATA;
        tmp_last_V_8_reg_509 <= stream_in_24_TLAST;
        tmp_user_V_10_reg_504 <= stream_in_24_TUSER;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_phi_mux_last_8_phi_fu_144_p4 == 1'd0) & (ap_phi_mux_delayed_last_phi_fu_132_p4 == 1'd0))) begin
        tmp_data_V_reg_435 <= stream_in_24_TDATA;
        tmp_last_V_reg_447 <= stream_in_24_TLAST;
        tmp_user_V_reg_441 <= stream_in_24_TUSER;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_subdone) & (delayed_last_reg_129 == 1'd1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_condition_exit_pp0_iter0_stage1 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage1 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        ap_enable_reg_pp0_iter0 = ap_start_int;
    end else begin
        ap_enable_reg_pp0_iter0 = ap_enable_reg_pp0_iter0_reg;
    end
end

always @ (*) begin
    if (((ap_start_int == 1'b0) & (ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if ((ap_enable_reg_pp0_iter1 == 1'b0)) begin
        ap_idle_pp0_1to1 = 1'b1;
    end else begin
        ap_idle_pp0_1to1 = 1'b0;
    end
end

always @ (*) begin
    if (((tmp_last_V_8_reg_509 == 1'd0) & (tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0))) begin
        ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8 = p_Result_18_fu_337_p5;
    end else begin
        ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8 = ap_phi_reg_pp0_iter0_buffer_1_3_ph_reg_152;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if ((ap_loop_init == 1'b1)) begin
            ap_phi_mux_delayed_last_phi_fu_132_p4 = 1'd0;
        end else if ((1'b1 == ap_condition_526)) begin
            ap_phi_mux_delayed_last_phi_fu_132_p4 = last_8_reg_140;
        end else begin
            ap_phi_mux_delayed_last_phi_fu_132_p4 = 1'd0;
        end
    end else begin
        ap_phi_mux_delayed_last_phi_fu_132_p4 = 1'd0;
    end
end

always @ (*) begin
    if (((tmp_last_V_8_reg_509 == 1'd0) & (tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0))) begin
        ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8 = p_Result_20_fu_355_p3;
    end else begin
        ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8 = ap_phi_reg_pp0_iter0_has_last_1_3_ph_reg_165;
    end
end

always @ (*) begin
    if (((tmp_last_V_8_reg_509 == 1'd0) & (tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0))) begin
        ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8 = p_Result_19_fu_347_p4;
    end else begin
        ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8 = ap_phi_reg_pp0_iter0_has_user_1_3_ph_reg_178;
    end
end

always @ (*) begin
    if (((tmp_last_V_8_reg_509 == 1'd0) & (tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0))) begin
        ap_phi_mux_last_2_3_ph_phi_fu_195_p8 = stream_in_24_TLAST;
    end else begin
        ap_phi_mux_last_2_3_ph_phi_fu_195_p8 = 1'd1;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        if ((ap_loop_init == 1'b1)) begin
            ap_phi_mux_last_8_phi_fu_144_p4 = 1'd0;
        end else if ((1'b1 == ap_condition_526)) begin
            ap_phi_mux_last_8_phi_fu_144_p4 = last_2_31065_reg_208;
        end else begin
            ap_phi_mux_last_8_phi_fu_144_p4 = 1'd0;
        end
    end else begin
        ap_phi_mux_last_8_phi_fu_144_p4 = 1'd0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage3_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if ((((ap_predicate_op53_read_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((tmp_last_V_7_reg_464 == 1'd0) & (1'b0 == ap_block_pp0_stage2) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage1) & (ap_predicate_op30_read_state2 == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_phi_mux_last_8_phi_fu_144_p4 == 1'd0) & (ap_phi_mux_delayed_last_phi_fu_132_p4 == 1'd0)))) begin
        stream_in_24_TDATA_blk_n = stream_in_24_TVALID;
    end else begin
        stream_in_24_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((((ap_predicate_op53_read_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op44_read_state3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage1_11001) & (ap_predicate_op30_read_state2 == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_predicate_op26_read_state1 == 1'b1)))) begin
        stream_in_24_TREADY = 1'b1;
    end else begin
        stream_in_24_TREADY = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_01001) & (ap_predicate_op78_write_state6 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        stream_out_32_TDATA = out_pixel_data_V_2_reg_543;
    end else if (((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_predicate_op77_write_state5 == 1'b1))) begin
        stream_out_32_TDATA = out_pixel_data_V_1_reg_528;
    end else if (((ap_predicate_op67_write_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        stream_out_32_TDATA = out_pixel_data_V_fu_369_p1;
    end else begin
        stream_out_32_TDATA = 'bx;
    end
end

always @ (*) begin
    if ((((ap_predicate_op67_write_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1) & (ap_predicate_op78_write_state6 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        stream_out_32_TDATA_blk_n = stream_out_32_TREADY;
    end else begin
        stream_out_32_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_01001) & (ap_predicate_op78_write_state6 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        stream_out_32_TLAST = p_Result_8_reg_553;
    end else if (((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_predicate_op77_write_state5 == 1'b1))) begin
        stream_out_32_TLAST = p_Result_6_reg_538;
    end else if (((ap_predicate_op67_write_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        stream_out_32_TLAST = ap_phi_mux_has_last_1_3_ph_phi_fu_168_p8[32'd1];
    end else begin
        stream_out_32_TLAST = 'bx;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_01001) & (ap_predicate_op78_write_state6 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        stream_out_32_TUSER = p_Result_7_reg_548;
    end else if (((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_predicate_op77_write_state5 == 1'b1))) begin
        stream_out_32_TUSER = p_Result_5_reg_533;
    end else if (((ap_predicate_op67_write_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        stream_out_32_TUSER = p_Result_s_fu_364_p1;
    end else begin
        stream_out_32_TUSER = 'bx;
    end
end

always @ (*) begin
    if ((((ap_predicate_op67_write_state4 == 1'b1) & (1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (ap_predicate_op78_write_state6 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_predicate_op77_write_state5 == 1'b1)))) begin
        stream_out_32_TVALID = 1'b1;
    end else begin
        stream_out_32_TVALID = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            if ((~((ap_start_int == 1'b0) & (ap_idle_pp0_1to1 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage1 : begin
            if ((1'b1 == ap_condition_exit_pp0_iter0_stage1)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if ((1'b0 == ap_block_pp0_stage1_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end
        end
        ap_ST_fsm_pp0_stage2 : begin
            if ((1'b0 == ap_block_pp0_stage2_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end
        end
        ap_ST_fsm_pp0_stage3 : begin
            if ((1'b0 == ap_block_pp0_stage3_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage2 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_pp0_stage3 = ap_CS_fsm[32'd3];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = (((stream_out_32_TREADY == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (ap_predicate_op77_write_state5 == 1'b1)) | ((stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op26_read_state1 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = (((ap_enable_reg_pp0_iter1 == 1'b1) & ((1'b1 == ap_block_state5_io) | ((stream_out_32_TREADY == 1'b0) & (ap_predicate_op77_write_state5 == 1'b1)))) | ((stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op26_read_state1 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = (((ap_enable_reg_pp0_iter1 == 1'b1) & ((1'b1 == ap_block_state5_io) | ((stream_out_32_TREADY == 1'b0) & (ap_predicate_op77_write_state5 == 1'b1)))) | ((stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op26_read_state1 == 1'b1)));
end

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage1_01001 = (((ap_predicate_op78_write_state6 == 1'b1) & (stream_out_32_TREADY == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1)) | ((ap_predicate_op30_read_state2 == 1'b1) & (stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage1_11001 = (((ap_enable_reg_pp0_iter1 == 1'b1) & ((1'b1 == ap_block_state6_io) | ((ap_predicate_op78_write_state6 == 1'b1) & (stream_out_32_TREADY == 1'b0)))) | ((ap_predicate_op30_read_state2 == 1'b1) & (stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage1_subdone = (((ap_enable_reg_pp0_iter1 == 1'b1) & ((1'b1 == ap_block_state6_io) | ((ap_predicate_op78_write_state6 == 1'b1) & (stream_out_32_TREADY == 1'b0)))) | ((ap_predicate_op30_read_state2 == 1'b1) & (stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

assign ap_block_pp0_stage2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage2_11001 = ((stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op44_read_state3 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_subdone = ((stream_in_24_TVALID == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (ap_predicate_op44_read_state3 == 1'b1));
end

assign ap_block_pp0_stage3 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage3_01001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & (((ap_predicate_op67_write_state4 == 1'b1) & (stream_out_32_TREADY == 1'b0)) | ((ap_predicate_op53_read_state4 == 1'b1) & (stream_in_24_TVALID == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage3_11001 = ((ap_enable_reg_pp0_iter0 == 1'b1) & ((1'b1 == ap_block_state4_io) | ((ap_predicate_op67_write_state4 == 1'b1) & (stream_out_32_TREADY == 1'b0)) | ((ap_predicate_op53_read_state4 == 1'b1) & (stream_in_24_TVALID == 1'b0))));
end

always @ (*) begin
    ap_block_pp0_stage3_subdone = ((ap_enable_reg_pp0_iter0 == 1'b1) & ((1'b1 == ap_block_state4_io) | ((ap_predicate_op67_write_state4 == 1'b1) & (stream_out_32_TREADY == 1'b0)) | ((ap_predicate_op53_read_state4 == 1'b1) & (stream_in_24_TVALID == 1'b0))));
end

always @ (*) begin
    ap_block_state1_pp0_stage0_iter0 = ((stream_in_24_TVALID == 1'b0) & (ap_predicate_op26_read_state1 == 1'b1));
end

always @ (*) begin
    ap_block_state2_pp0_stage1_iter0 = ((ap_predicate_op30_read_state2 == 1'b1) & (stream_in_24_TVALID == 1'b0));
end

always @ (*) begin
    ap_block_state3_pp0_stage2_iter0 = ((stream_in_24_TVALID == 1'b0) & (ap_predicate_op44_read_state3 == 1'b1));
end

always @ (*) begin
    ap_block_state4_io = ((ap_predicate_op67_write_state4 == 1'b1) & (stream_out_32_TREADY == 1'b0));
end

always @ (*) begin
    ap_block_state4_pp0_stage3_iter0 = (((ap_predicate_op67_write_state4 == 1'b1) & (stream_out_32_TREADY == 1'b0)) | ((ap_predicate_op53_read_state4 == 1'b1) & (stream_in_24_TVALID == 1'b0)));
end

always @ (*) begin
    ap_block_state5_io = ((stream_out_32_TREADY == 1'b0) & (ap_predicate_op77_write_state5 == 1'b1));
end

always @ (*) begin
    ap_block_state5_pp0_stage0_iter1 = ((stream_out_32_TREADY == 1'b0) & (ap_predicate_op77_write_state5 == 1'b1));
end

always @ (*) begin
    ap_block_state6_io = ((ap_predicate_op78_write_state6 == 1'b1) & (stream_out_32_TREADY == 1'b0));
end

always @ (*) begin
    ap_block_state6_pp0_stage1_iter1 = ((ap_predicate_op78_write_state6 == 1'b1) & (stream_out_32_TREADY == 1'b0));
end

always @ (*) begin
    ap_condition_285 = ((1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3));
end

always @ (*) begin
    ap_condition_526 = ((1'b0 == ap_block_pp0_stage0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_condition_531 = ((1'b0 == ap_block_pp0_stage2_11001) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2));
end

always @ (*) begin
    ap_condition_534 = ((tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (grp_fu_230_p1 == 1'd1));
end

always @ (*) begin
    ap_condition_540 = ((1'b0 == ap_block_pp0_stage0_11001) & (delayed_last_reg_129 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage1;

assign ap_phi_reg_pp0_iter0_last_2_31065_reg_208 = 1'd1;

always @ (*) begin
    ap_predicate_op26_read_state1 = ((ap_phi_mux_last_8_phi_fu_144_p4 == 1'd0) & (ap_phi_mux_delayed_last_phi_fu_132_p4 == 1'd0));
end

always @ (*) begin
    ap_predicate_op30_read_state2 = ((tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0));
end

always @ (*) begin
    ap_predicate_op44_read_state3 = ((tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0));
end

always @ (*) begin
    ap_predicate_op53_read_state4 = ((tmp_last_V_8_reg_509 == 1'd0) & (tmp_last_V_7_reg_464 == 1'd0) & (tmp_last_V_reg_447 == 1'd0) & (last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0));
end

always @ (*) begin
    ap_predicate_op67_write_state4 = ((last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0));
end

always @ (*) begin
    ap_predicate_op77_write_state5 = ((last_8_reg_140 == 1'd0) & (delayed_last_reg_129 == 1'd0));
end

always @ (*) begin
    ap_predicate_op78_write_state6 = ((last_8_reg_140_pp0_iter1_reg == 1'd0) & (delayed_last_reg_129_pp0_iter1_reg == 1'd0));
end

assign grp_fu_230_p1 = stream_in_24_TLAST;

assign out_pixel_data_V_fu_369_p1 = ap_phi_mux_buffer_1_3_ph_phi_fu_155_p8[31:0];

assign p_Result_10_fu_246_p4 = {ap_const_lv4_0[4-1:1], |(tmp_user_V_reg_441)};

assign p_Result_11_fu_259_p4 = {ap_const_lv4_0[4-1:1], |(tmp_last_V_reg_447)};

assign p_Result_12_fu_268_p5 = {{p_Result_9_fu_235_p5[95:48]}, {tmp_data_V_10_reg_452}, {p_Result_9_fu_235_p5[23:0]}};

assign p_Result_13_fu_279_p4 = {p_Result_10_fu_246_p4[4 - 1:2], |(tmp_user_V_9_reg_458), p_Result_10_fu_246_p4[0:0]};

assign p_Result_14_fu_292_p4 = {p_Result_11_fu_259_p4[4 - 1:2], |(tmp_last_V_7_reg_464), p_Result_11_fu_259_p4[0:0]};

assign p_Result_15_fu_301_p5 = {{p_Result_12_fu_268_p5[95:72]}, {stream_in_24_TDATA}, {p_Result_12_fu_268_p5[47:0]}};

assign p_Result_16_fu_313_p4 = {p_Result_13_fu_279_p4[4 - 1:3], |(stream_in_24_TUSER), p_Result_13_fu_279_p4[1:0]};

assign p_Result_17_fu_327_p4 = {p_Result_14_fu_292_p4[4 - 1:3], |(stream_in_24_TLAST), p_Result_14_fu_292_p4[1:0]};

assign p_Result_18_fu_337_p5 = {{{{stream_in_24_TDATA}, {tmp_data_V_11_reg_499}}, {tmp_data_V_10_reg_452}}, {tmp_data_V_reg_435}};

assign p_Result_19_fu_347_p4 = {{{tmp_user_V_10_reg_504}, {tmp_user_V_9_reg_458}}, {tmp_user_V_reg_441}};

assign p_Result_20_fu_355_p3 = {{stream_in_24_TLAST}, {3'd0}};

assign p_Result_9_fu_235_p5 = {{ap_const_lv96_0[95:24]}, {tmp_data_V_reg_435}};

assign p_Result_s_fu_364_p1 = ap_phi_mux_has_user_1_3_ph_phi_fu_181_p8[0:0];

assign stream_out_32_TKEEP = 4'd0;

assign stream_out_32_TSTRB = 4'd0;

assign trunc_ln855_1_fu_288_p1 = p_Result_13_fu_279_p4[2:0];

assign trunc_ln855_2_fu_323_p1 = p_Result_16_fu_313_p4[2:0];

assign trunc_ln855_fu_255_p1 = p_Result_10_fu_246_p4[2:0];

endmodule //pixel_pack_pixel_pack_Pipeline_VITIS_LOOP_21_1
