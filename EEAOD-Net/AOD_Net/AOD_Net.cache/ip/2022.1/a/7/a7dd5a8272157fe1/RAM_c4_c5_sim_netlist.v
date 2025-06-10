// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Sat Nov  4 19:17:48 2023
// Host        : LAPTOP-HC05NL1J running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ RAM_c4_c5_sim_netlist.v
// Design      : RAM_c4_c5
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_c4_c5,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [23:0]doutb;

  wire [10:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire clkb;
  wire [23:0]dina;
  wire [23:0]doutb;
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
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     7.213 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
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
  (* C_INIT_FILE = "RAM_c4_c5.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1920" *) 
  (* C_READ_DEPTH_B = "1920" *) 
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
  (* C_WRITE_DEPTH_A = "1920" *) 
  (* C_WRITE_DEPTH_B = "1920" *) 
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
        .ena(1'b0),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 38480)
`pragma protect data_block
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
b0NQwMY=
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
