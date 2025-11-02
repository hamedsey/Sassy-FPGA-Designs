# in case no bitstream is input:
set default_image ../image/top.mcs
# start xilinx hw server
open_hw
connect_hw_server -url localhost:3121

current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/*]
# set JTAG frequency to 12MHz rather than the default 6MHz
set_property PARAM.FREQUENCY 12000000 [get_hw_targets */xilinx_tcf/Xilinx/*]
open_hw_target
# manage bug of failing initial connection
close_hw_target
open_hw_target
#current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
set mem_size [lindex $argv 1]
	if {$mem_size == 32} {
		create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {n25q256-3.3v-spi-x1_x2_x4}] 0]
	} else {
		create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {mt25ql512-spi-x1_x2_x4}] 0]
	}
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

    if { $argc == 0 } {
        puts "*************************************"
        puts "\n"
        puts "\n"
        puts "\n"
        puts "Burning Default Image: $default_image"
		puts "\n"
		puts "(Default Flash Size 64 MB - mt25ql512)"
        puts "\n"
        puts "\n"
        puts "\n"
        puts "*************************************"
		set mem_size 64
    } elseif { $argc == 1 } {
	    set requested_image [lindex $argv 0]
		puts "*************************************"
        puts "\n"
        puts "\n"
        puts "\n"
        puts "Burning Requested Image: $requested_image"
		puts "\n"
		puts "(Default Flash Size 64 MB - mt25ql512)"
        puts "\n"
        puts "\n"
        puts "\n"
        puts "*************************************"
		set mem_size 64
	} else {
        set requested_image [lindex $argv 0]
		puts "*****************************************"
        puts "\n"
        puts "\n"
        puts "\n"
        puts "Burning Requested Image: $requested_image"
        puts "\n"
		puts "(Flash Size $mem_size MB )"
		puts "\n"
        puts "\n"
        puts "\n"
        puts "*****************************************"
        }
             
set_property PROGRAM.FILES [list "$requested_image" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.PRM_FILE {/tmp/xlx_flash_image.prm} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-up} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
startgroup 
if {![string equal [get_property PROGRAM.HW_CFGMEM_TYPE  [lindex [get_hw_devices] 0]] [get_property MEM_TYPE [get_property CFGMEM_PART [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]]]] } { 
    create_hw_bitstream -hw_device [lindex [get_hw_devices] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices] 0]]; 
    program_hw_devices [lindex [get_hw_devices] 0]; 
    }; 
program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
boot_hw_device  [lindex [get_hw_devices] 0]
refresh_hw_device [lindex [get_hw_devices] 0]