// (c) Copyright 1995-2024 Xilinx, Inc. All rights reserved.
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


#include "base_m04_regslice_0_sc.h"

#include "axi_register_slice.h"

#include <map>
#include <string>

base_m04_regslice_0_sc::base_m04_regslice_0_sc(const sc_core::sc_module_name& nm) : sc_core::sc_module(nm), mp_impl(NULL)
{
  // configure connectivity manager
  xsc::utils::xsc_sim_manager::addInstance("base_m04_regslice_0", this);

  // initialize module
    xsc::common_cpp::properties model_param_props;
    model_param_props.addLong("C_AXI_PROTOCOL", "2");
    model_param_props.addLong("C_AXI_ID_WIDTH", "1");
    model_param_props.addLong("C_AXI_ADDR_WIDTH", "9");
    model_param_props.addLong("C_AXI_DATA_WIDTH", "32");
    model_param_props.addLong("C_AXI_SUPPORTS_USER_SIGNALS", "0");
    model_param_props.addLong("C_AXI_AWUSER_WIDTH", "1");
    model_param_props.addLong("C_AXI_ARUSER_WIDTH", "1");
    model_param_props.addLong("C_AXI_WUSER_WIDTH", "1");
    model_param_props.addLong("C_AXI_RUSER_WIDTH", "1");
    model_param_props.addLong("C_AXI_BUSER_WIDTH", "1");
    model_param_props.addLong("C_REG_CONFIG_AW", "7");
    model_param_props.addLong("C_REG_CONFIG_W", "7");
    model_param_props.addLong("C_REG_CONFIG_B", "7");
    model_param_props.addLong("C_REG_CONFIG_AR", "7");
    model_param_props.addLong("C_REG_CONFIG_R", "7");
    model_param_props.addLong("C_RESERVE_MODE", "0");
    model_param_props.addLong("C_NUM_SLR_CROSSINGS", "0");
    model_param_props.addLong("C_PIPELINES_MASTER_AW", "0");
    model_param_props.addLong("C_PIPELINES_MASTER_W", "0");
    model_param_props.addLong("C_PIPELINES_MASTER_B", "0");
    model_param_props.addLong("C_PIPELINES_MASTER_AR", "0");
    model_param_props.addLong("C_PIPELINES_MASTER_R", "0");
    model_param_props.addLong("C_PIPELINES_SLAVE_AW", "0");
    model_param_props.addLong("C_PIPELINES_SLAVE_W", "0");
    model_param_props.addLong("C_PIPELINES_SLAVE_B", "0");
    model_param_props.addLong("C_PIPELINES_SLAVE_AR", "0");
    model_param_props.addLong("C_PIPELINES_SLAVE_R", "0");
    model_param_props.addLong("C_PIPELINES_MIDDLE_AW", "0");
    model_param_props.addLong("C_PIPELINES_MIDDLE_W", "0");
    model_param_props.addLong("C_PIPELINES_MIDDLE_B", "0");
    model_param_props.addLong("C_PIPELINES_MIDDLE_AR", "0");
    model_param_props.addLong("C_PIPELINES_MIDDLE_R", "0");
    model_param_props.addString("C_FAMILY", "zynq");
    model_param_props.addString("COMPONENT_NAME", "base_m04_regslice_0");

  mp_impl = new axi_register_slice("inst", model_param_props);

  // initialize AXI sockets
  M_INITIATOR_rd_socket = mp_impl->M_INITIATOR_rd_socket;
  M_INITIATOR_wr_socket = mp_impl->M_INITIATOR_wr_socket;
  S_TARGET_rd_socket = mp_impl->S_TARGET_rd_socket;
  S_TARGET_wr_socket = mp_impl->S_TARGET_wr_socket;
}

base_m04_regslice_0_sc::~base_m04_regslice_0_sc()
{
  xsc::utils::xsc_sim_manager::clean();

  delete mp_impl;
}

