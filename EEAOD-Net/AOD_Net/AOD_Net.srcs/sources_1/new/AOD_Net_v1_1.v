`timescale 1 ns / 1 ps

module AOD_Net_v1_1 #(
	// Users to add parameters here
	parameter integer PIXEL_WIDTH	= 24,
	parameter integer PIX_W 	= 	640,
	parameter integer PIX_H 	= 	480,
	// User parameters ends
	// Do not modify the parameters beyond this line
	// Parameters of Axi Slave Bus Interface S00_AXIS
	parameter integer C_S00_AXIS_TDATA_WIDTH	= 32,

	// Parameters of Axi Master Bus Interface M00_AXIS
	parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
	parameter integer C_M00_AXIS_START_COUNT	= 32
)(
	// Users to add ports here
	// input wire ap_clk,
	// input wire ap_rst_n,
	// User ports ends
	// Do not modify the ports beyond this line

	// Ports of Axi Slave Bus Interface S00_AXIS
	input wire  s00_axis_aclk,
	input wire  s00_axis_aresetn,
	output wire s00_axis_tready,
	input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
	input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
	input wire s00_axis_tlast,
	input wire s00_axis_tvalid,	
	// input wire [0:0]s00_axis_tuser,


	// Ports of Axi Master Bus Interface M00_AXIS
	input wire  m00_axis_aclk,
	input wire  m00_axis_aresetn,
	output wire  m00_axis_tvalid,
	output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
	output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
	output wire m00_axis_tlast,	
	// output wire [0:0] m00_axis_tuser,
	input wire m00_axis_tready
);
	//*************************************************************************************************修改
	// wire  s00_axis_aclk;
	// wire  s00_axis_aresetn;
	// wire  m00_axis_aclk;
	// wire  m00_axis_aresetn;
	// assign s00_axis_aclk = ap_clk;
	// assign s00_axis_aresetn = ap_rst_n;
	// assign m00_axis_aclk = ap_clk;
	// assign m00_axis_aresetn = ap_rst_n;

	wire conv1_en,data_out_valid;
	wire [PIXEL_WIDTH-1:0]conv1_in;
	wire [PIXEL_WIDTH-1:0]data_out;
	//*************************************************************************************************修改
	// Instantiation of Axi Bus Interface S00_AXIS
	AOD_Net_v1_1_S00_AXIS # ( 
		.PIX_W(PIX_W),
		.PIX_H(PIX_H),
		.C_S_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH)
	) AOD_Net_v1_1_S00_AXIS_inst (
		.S_AXIS_ACLK(s00_axis_aclk),
		.S_AXIS_ARESETN(s00_axis_aresetn),
		.S_AXIS_TREADY(s00_axis_tready),
		.S_AXIS_TDATA(s00_axis_tdata),
		.S_AXIS_TSTRB(s00_axis_tstrb),
		.S_AXIS_TLAST(s00_axis_tlast),
		.S_AXIS_TVALID(s00_axis_tvalid),
		// .S_AXIS_TUSER(s00_axis_tuser),
		.conv1_in(conv1_in),
		.conv1_en(conv1_en)
	);

	// Instantiation of Axi Bus Interface M00_AXIS
	AOD_Net_v1_1_M00_AXIS # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.PIX_W(PIX_W),
		.PIX_H(PIX_H),
		.C_M_START_COUNT(C_M00_AXIS_START_COUNT)
	) AOD_Net_v1_1_M00_AXIS_inst (
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TREADY(m00_axis_tready),
		// .M_AXIS_TUSER(m00_axis_tuser),
		.data_out(data_out),
		.data_out_valid(data_out_valid)
	);

	// Add user logic here
	AOD_Net#(
		.PIX_W(PIX_W),
		.PIX_H(PIX_H)
	)  AOD_Net_U (
		.clk(s00_axis_aclk),
		.rstn(s00_axis_aresetn),
		.conv1_en(conv1_en),
		.conv1_in(conv1_in),
		.data_out_valid(data_out_valid),
		.data_out(data_out)
	);
	// User logic ends

endmodule
