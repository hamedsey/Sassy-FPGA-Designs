# start xilinx hw server
#puts "waiting for USB driver to kick in..."
#after 2000
open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/*]
# set JTAG frequency to 12MHz rather than the default 6MHz
set_property PARAM.FREQUENCY 12000000 [get_hw_targets */xilinx_tcf/Xilinx/*]
open_hw_target
# manage bug of failing initial connection
close_hw_target