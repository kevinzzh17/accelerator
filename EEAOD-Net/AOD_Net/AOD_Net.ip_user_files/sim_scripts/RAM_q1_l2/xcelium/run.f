-makelib xcelium_lib/xpm -sv \
  "D:/Vivado_22_1/Vivado/2022.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Vivado_22_1/Vivado/2022.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_5 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../../Video_base_test_cal_v1_0/Video_base_test_cal_v1_0.tmp/aod_net_v1_1_v1_0_project/AOD_Net_v1_1_v1_0_project.gen/sources_1/ip/RAM_q1_l2/sim/RAM_q1_l2.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

