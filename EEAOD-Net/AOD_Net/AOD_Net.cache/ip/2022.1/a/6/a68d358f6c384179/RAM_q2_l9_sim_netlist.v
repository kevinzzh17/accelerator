// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Sat Nov  4 16:43:43 2023
// Host        : LAPTOP-HC05NL1J running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ RAM_q2_l9_sim_netlist.v
// Design      : RAM_q2_l9
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_q2_l9,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [23:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [23:0]dina;
  wire [23:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [23:0]NLW_U0_douta_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.973125 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "RAM_q2_l9.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "640" *) 
  (* C_READ_DEPTH_B = "640" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "24" *) 
  (* C_READ_WIDTH_B = "24" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "640" *) 
  (* C_WRITE_DEPTH_B = "640" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[23:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[23:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RgPKnWr9n0dGgttm3akiFhAlfB96usOQYxnEmPhGyTGg1AbizYAjGPWLXBWl50n/d0IA71ci4aJB
wt6mtfyNADm3ZReK7D3mKu037BOgxryoEwwf1kiC6q/PllxsdAgEMfQrfHJ3E2AzSpdYjoxVYito
y0JW6CUDcWvWa4WV0EA=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M0l6KpOGH3jL8eRt3NCD7e2USYnkg5H9GAnE1PKmnjiouFN3Y8kjWA2PZDAQLm9UW+TsC1HeVlzO
WjNCHkjR/6ubCsIcWfpPZWdIuAenlsyq8Y9l6b8vMj8JSbDEOiFF/GHSbKsn22MJdDJKEhHFK6GV
s8gR2vywRFwG69gIRE4qGhVB+WIg8GJrDpDMYH6lCjMkTrjXuKDUcNlJN3NPLuhJ7tsditwf1pr5
moJRmGpJnip/rGm0g4o4A6ev4CtePjoao8C1wFtzHkERX9oenhh7cGjDMejU5IrLv8NxFnLj1FpB
9MuF1beTU20NI5oAn6zLiLiOtXjf0ghU3AN4DA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hAsrUfp6Qgjm8yBjNYTEtQmVQmMxzL8TE/3oiQSxSI3+yEkXAbQCXkT9mo+LCdv+fGECOB0istHd
eLtbsiYbxjxNxYkXiUrRE5O+aSxynIray+uF9DJigTEUZu8JJXUbzxK4DDUu1Lm9tpGps4+Prz1m
0gkj13RT/Y/418s2VTw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BP/54Wm/GJmb1jy0bxWJJX4aiKyiWPVh4X3VL30BQrmX4PlEsNKzBJH3Qu8IIYERfnFP0ifAgboa
vypMQ5Ed0BrMePGkWIgT6I8hxJCMFpHdkSK7m1giSKyZzFfTOrVqoNFXE+qdzLfY1J5hBWCvouYo
jllavK4N3gF9FLScH2AUWYVMcVth2QPaTAU2NLnAUNH8kgtBjBfc8/KbPPTznD1QNVqvFstzcbTA
hGQ1ETVPvINQ0KqxxAG5PRhtQD4+pC+hr/Tvk+RSvGyBOfy9zE86OXkJiYs9dSFhNiMFmCPL9DBO
se4OxNNC0/7aBtb1mkSEA9YFDYEb9jS7Jasy2A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SnzT9DVH3xlEN8nrr2YrlvTO5qj7L22d7WaBcuKyTaiHoIwwFHrC4HQbfs0TAwkdWcOgmJoATPSF
F6qm0KiddbrlERF3MfKUldeGBJtqLdX+zGw7+3JD7S+HB9dIMOFOHy+IiCZp1/Pz8epKpi238cel
rcVoJQKz406wmXDvOo8KsT+XhRLs9BVCrBErPGGXKYDk6NXAp0duOgQE9DbslzMU83M/kUC7uERV
tQW02240peKQFp2elEZC7Tetvgp0TaFTtJiKN45REi8GQUCKGa85JjNIk1qb/+k95TIIP1xrHirc
6iX7qbwnPetv8TVu2NjkZ0WDEK5RXdOXcxBwHA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
erkR82V0jX8ytva+9MzEs0c75Z7j7TsgxWRLNAUfbbU28i+U9YzuZlSfYU75M0f9jx1gvxtBrfKv
cNHVdkR+i5zfHDZsDwfMEEBhs8wzDCKqe+eex6BBEvlIOesCPXrr2RozQgaQ1PBh/os2Arfu+873
BjsVxFJkbhpzIqlddOo/XZV9Yi+eih7A7pXXEBR6IL7Poo4Ka49MiVQU0xJrDTm+ddOuMPDRRD7g
dsxS/uzdcBcO2myV6g/7YH/C2Ce9s6+UywJN/0JeXSqwA7bsBqqnfFicVAT0lckLopMLiuzK7dsN
EwhFeqoetciFrDIj9+o0xDMWBZhgNP1u68vURA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R+BI65BKLT0I9hEtsxGnDyM5XY9gzULeTPOSDXvd3KWOzZJAx6C0xlbyZcFZhAEG/QIK2yd0wAi6
IUWxyF/sx3HsqKjhVi5KxnpuXDBOZVoj811O7JukedFVmDW7OHGtBkuiJ5X5irw7mfsEKRQmF/1i
V6lj9HYHZEjxtDeZjACsLY4y1QxWalSKT4HIMOHznBLL8dLbGMlS+ZmFuFn0gcwZavVl7gTkTtkf
W0gn01A9ru7NKsf+iLX0kj4dgItPu9N2g02M1vWQ9UUQEVvfV7lUc7GY1suibrD8aEkhH9S7lZ7n
bFsT4qxyvzg8ML6v4g4v7N6VuyhEtgFgNd725Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
jNUVKiwH68vHsU54idgvKwaVJcoxTUuxfgrQpbpmM/IpesWA3wHsGzYClwAxkKzw3KRnFyQqTWcZ
yj1EQ2CMBxlJ0kyNbZW8OK8pXzeigToZ0U6Aq3Gy+j7wBbhe83wE1Ygn82sK8dHTEulvaRLn/c5r
ispy1s7jMKIvYNzoUuZrgyBQyfaYmdqUia8XlQjFd+VwzhTXKwzvmaqHWyaHjfBKeCooO7+oUxMG
OJg83W54EVe9ronFQ8Wr9EOL8ia7qelCAgyQe/bC0HHCoMAm8apI7sX23iMR/wMiPP5V2bQzycy+
rBX/+SWkqSeIE1FLm+muFPvrE7iLwJaW8d1fzdFFjAZ5aIXArbWNfwbK8S0TczXc9lEzmpb69rwA
UJIrs4alo81qGQ32UFhjuMQjX75O9Od1HWHDj5PFaT/Ja5Ly+bK8Cc3gfO6dCE81m7d+B2JBZ/Hl
tBA19QuOAYwT2EIPOdpaVtCULb33cWODWu3qQFhZMmDzKTb3kwpcr0LL

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MnzcA2swaxH1LRacKDou0ZmiiMRETbWIdHgeBgyQz7ILronsXLoB/C20WuFNGEVSiL2/51EZ6MXZ
vMHI8fFcMQCJcuTBDBibUMKv6bXI9s8fTbtrBZppbF/R1icG5JYhqmX4aRnv4W/dxJRjI2L35nLN
Y48E9OfgfkD1sr+IRwx8WEKFmUhuk8dLe0VOK7ywe3XEcneYvrz+HhPj16bGmNfMwNnDgZ3gKKZD
hRnys+jzvAX3HyISrErWXhMKrhWMxXeTNFJCqNQ0LWAVHQYwyKnF5xVpyXSuGNSIrva+QXqOrZBG
3VNLirNVtMRiKLfwZeMaqvswkqBDAa53utlAAA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
d0xXkKtsKM8GvXhDZr16p1+oE3uBtD04BJ76eGGIEj/CFECfHVy9qsJ43oSKjas0+AJr4GFFnVb6
X7gJV6MmX/OboC9ier5joUCGz0mxVzkRZK9a+LPEDcg0K6+cLE36kr+FfxW9Uk2816EHBCMCf5mK
A4eAhSmAb5Nq74F/q0quiG416npbny7faiQ+xmPDfYYiM3UuMKaD4iE8ODlz1w5xThPllWESf3LZ
NTkw6fozyTqZ47vvE21O3dgIGAY1v+C6BwlCK24VwPJa1xs9csY+qTk31j5jjAc1ExlB6QF7t9UH
lk70qdNPWxT87OH7kFT8UvPO1D6BTC3/WkDZfA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYhdzKTvo93uJrAaiP5OfCDuOnu2BSvPnxlv6I7h2n1+xHtj34LNNKzWEgOg9dUV9cYDaHYUjjEt
DKdWcz6mZ61d5qyxAhpv67fc90v7JVgtOAcT94/Yb+AuLxXFcGA6Gic7uoJtUgz6JmTnb22Dxdjc
KuIewDj4IOTfP8XGXKTaF+cNp0CFrQgTAcVSQFyLFxr0I/9h3S+GZLecA7ntEeHEOfCJzPvy0ddi
7MCdQWECLb+fXC0IAn8V95TumcpINiRAX1BHi9IGJ4QoMrb3jOCrPkFhDMTJj2aiImUWdi/l/0QE
d7wcXlgIEYVeoKYUOJ4mqy+zZPUbLNeOPADUDQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29408)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
