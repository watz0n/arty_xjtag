###################################################################
#      Xilinx Official JTAG Interface Constraint for Digilent Arty Board
#      Author: Watson Huang
#      Description:
#           Describe input clock and debug ILA declaration.
#      Change Log:
#      01/25,  Add board_clock description for Debug ILA module
#      02/18, Change ILA generator to handle JDATA_WIDTH parameterization
###################################################################
## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports board_clock]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports board_clock]

set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L24N_T3_35 Sch=led[4]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]

#Original add debug ILA from Vivado GUI
#set_property MARK_DEBUG true [get_nets {jtag_data[2]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[18]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[17]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[13]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[4]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[11]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[10]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[31]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[20]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[12]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[0]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[25]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[14]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[15]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[16]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[19]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[22]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[1]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[26]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[21]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[23]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[24]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[27]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[28]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[29]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[30]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[32]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[3]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[5]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[6]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[7]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[8]}]
#set_property MARK_DEBUG true [get_nets {jtag_data[9]}]

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list board_pll/inst/clk_out1]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 33 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {jtag_data[0]} {jtag_data[1]} {jtag_data[2]} {jtag_data[3]} {jtag_data[4]} {jtag_data[5]} {jtag_data[6]} {jtag_data[7]} {jtag_data[8]} {jtag_data[9]} {jtag_data[10]} {jtag_data[11]} {jtag_data[12]} {jtag_data[13]} {jtag_data[14]} {jtag_data[15]} {jtag_data[16]} {jtag_data[17]} {jtag_data[18]} {jtag_data[19]} {jtag_data[20]} {jtag_data[21]} {jtag_data[22]} {jtag_data[23]} {jtag_data[24]} {jtag_data[25]} {jtag_data[26]} {jtag_data[27]} {jtag_data[28]} {jtag_data[29]} {jtag_data[30]} {jtag_data[31]} {jtag_data[32]}]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out1]

# Modified parameterized jtag_data width debug ILA
set_property MARK_DEBUG true [get_nets {jtag_data[*]}]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]

set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list board_pll/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width [llength [get_nets jtag_data[*]]] [get_debug_ports u_ila_0/probe0]
#https://forums.xilinx.com/t5/Vivado-TCL-Community/XDC-indexing-generated-cells/td-p/677208
connect_debug_port u_ila_0/probe0 [list {*}[get_nets -regexp {jtag_data\[([0-9])\]}] {*}[get_nets -regexp {jtag_data\[([0-9][0-9])\]}]]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out1]
