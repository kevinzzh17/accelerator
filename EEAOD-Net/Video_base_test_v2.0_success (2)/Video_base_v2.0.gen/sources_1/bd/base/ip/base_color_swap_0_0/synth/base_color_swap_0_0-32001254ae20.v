// (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:color_swap:1.1
// IP Revision: 3

(* X_CORE_INFO = "color_swap,Vivado 2022.1" *)
(* CHECK_LICENSE_TYPE = "base_color_swap_0_0,color_swap,{}" *)
(* CORE_GENERATION_INFO = "base_color_swap_0_0,color_swap,{x_ipProduct=Vivado 2022.1,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=color_swap,x_ipVersion=1.1,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,input_format=rbg,output_format=rgb}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module base_color_swap_0_0 (
  hsync_in,
  hsync_out,
  pixel_in,
  pixel_out,
  vde_in,
  vde_out,
  vsync_in,
  vsync_out
);

(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_input HSYNC" *)
input wire hsync_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_output HSYNC" *)
output wire hsync_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_input DATA" *)
input wire [23 : 0] pixel_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_output DATA" *)
output wire [23 : 0] pixel_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_input ACTIVE_VIDEO" *)
input wire vde_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_output ACTIVE_VIDEO" *)
output wire vde_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_input VSYNC" *)
input wire vsync_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 pixel_output VSYNC" *)
output wire vsync_out;

  color_swap #(
    .input_format("rbg"),
    .output_format("rgb")
  ) inst (
    .hsync_in(hsync_in),
    .hsync_out(hsync_out),
    .pixel_in(pixel_in),
    .pixel_out(pixel_out),
    .vde_in(vde_in),
    .vde_out(vde_out),
    .vsync_in(vsync_in),
    .vsync_out(vsync_out)
  );
endmodule
