
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# rgb2gray, ramArray, ramArbitor, sync_gen, sobel_compute, reset_sync

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
   set_property BOARD_PART digilentinc.com:zybo-z7-10:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
digilentinc.com:ip:dvi2rgb:2.0\
xilinx.com:ip:clk_wiz:6.0\
digilentinc.com:ip:rgb2dvi:1.4\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:system_ila:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
rgb2gray\
ramArray\
ramArbitor\
sync_gen\
sobel_compute\
reset_sync\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set hdmi_in [ create_bd_intf_port -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi_in ]

  set hdmi_in_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_in_ddc ]

  set hdmi_out [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi_out ]

  set hdmi_out_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_out_ddc ]


  # Create ports
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 125000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.0} \
 ] $sys_clock
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl
  set hdmi_in_hpd [ create_bd_port -dir O -from 0 -to 0 hdmi_in_hpd ]

  # Create instance: dvi2rgb_0, and set properties
  set dvi2rgb_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:2.0 dvi2rgb_0 ]
  set_property -dict [list \
    CONFIG.IIC_BOARD_INTERFACE {hdmi_in_ddc} \
    CONFIG.TMDS_BOARD_INTERFACE {hdmi_in} \
    CONFIG.kAddBUFG {true} \
    CONFIG.kClkRange {2} \
    CONFIG.kDebug {false} \
    CONFIG.kEdidFileName {dgl_1080p_cea.data} \
    CONFIG.kRstActiveHigh {true} \
  ] $dvi2rgb_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {80.0} \
    CONFIG.CLKOUT1_JITTER {109.241} \
    CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
    CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
    CONFIG.CLK_IN2_BOARD_INTERFACE {Custom} \
    CONFIG.ENABLE_CLOCK_MONITOR {false} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} \
    CONFIG.PRIMITIVE {MMCM} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $clk_wiz_0


  # Create instance: rgb2dvi_2, and set properties
  set rgb2dvi_2 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.4 rgb2dvi_2 ]
  set_property -dict [list \
    CONFIG.TMDS_BOARD_INTERFACE {hdmi_out} \
    CONFIG.kClkRange {2} \
    CONFIG.kGenerateSerialClk {true} \
    CONFIG.kRstActiveHigh {true} \
  ] $rgb2dvi_2


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: rgb2gray_0, and set properties
  set block_name rgb2gray
  set block_cell_name rgb2gray_0
  if { [catch {set rgb2gray_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rgb2gray_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ramArray_0, and set properties
  set block_name ramArray
  set block_cell_name ramArray_0
  if { [catch {set ramArray_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ramArray_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ramArbitor_0, and set properties
  set block_name ramArbitor
  set block_cell_name ramArbitor_0
  if { [catch {set ramArbitor_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ramArbitor_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sync_gen_0, and set properties
  set block_name sync_gen
  set block_cell_name sync_gen_0
  if { [catch {set sync_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sync_gen_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sobel_compute_0, and set properties
  set block_name sobel_compute
  set block_cell_name sobel_compute_0
  if { [catch {set sobel_compute_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sobel_compute_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: reset_sync_0, and set properties
  set block_name reset_sync
  set block_cell_name reset_sync_0
  if { [catch {set reset_sync_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reset_sync_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {8192} \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {5} \
    CONFIG.C_PROBE_WIDTH_PROPAGATION {AUTO} \
  ] $system_ila_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {8192} \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {10} \
  ] $system_ila_1


  # Create interface connections
  connect_bd_intf_net -intf_net dvi2rgb_0_DDC [get_bd_intf_ports hdmi_in_ddc] [get_bd_intf_pins dvi2rgb_0/DDC]
  connect_bd_intf_net -intf_net hdmi_in_1 [get_bd_intf_ports hdmi_in] [get_bd_intf_pins dvi2rgb_0/TMDS]
  connect_bd_intf_net -intf_net rgb2dvi_2_TMDS [get_bd_intf_ports hdmi_out] [get_bd_intf_pins rgb2dvi_2/TMDS]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins dvi2rgb_0/RefClk]
  connect_bd_net -net dvi2rgb_0_PixelClk  [get_bd_pins dvi2rgb_0/PixelClk] \
  [get_bd_pins rgb2dvi_2/PixelClk] \
  [get_bd_pins sync_gen_0/clk] \
  [get_bd_pins reset_sync_0/clk] \
  [get_bd_pins system_ila_0/clk] \
  [get_bd_pins system_ila_1/clk] \
  [get_bd_pins ramArbitor_0/clk] \
  [get_bd_pins ramArray_0/clk] \
  [get_bd_pins sobel_compute_0/clk] \
  [get_bd_pins rgb2gray_0/pixelClkIn]
  connect_bd_net -net dvi2rgb_0_vid_pData  [get_bd_pins dvi2rgb_0/vid_pData] \
  [get_bd_pins rgb2gray_0/RBG_in]
  connect_bd_net -net dvi2rgb_0_vid_pHSync  [get_bd_pins dvi2rgb_0/vid_pHSync] \
  [get_bd_pins rgb2gray_0/hSync_in]
  connect_bd_net -net dvi2rgb_0_vid_pVDE  [get_bd_pins dvi2rgb_0/vid_pVDE] \
  [get_bd_pins rgb2gray_0/vDe_in]
  connect_bd_net -net dvi2rgb_0_vid_pVSync  [get_bd_pins dvi2rgb_0/vid_pVSync] \
  [get_bd_pins rgb2gray_0/vSync_in]
  connect_bd_net -net ramArbitor_0_hsync_out  [get_bd_pins ramArbitor_0/hsync_out] \
  [get_bd_pins system_ila_1/probe3] \
  [get_bd_pins sobel_compute_0/hsync_IN]
  connect_bd_net -net ramArbitor_0_raddr0_out  [get_bd_pins ramArbitor_0/raddr0_out_vec] \
  [get_bd_pins system_ila_1/probe0] \
  [get_bd_pins ramArray_0/raddr0]
  connect_bd_net -net ramArbitor_0_raddr1_out  [get_bd_pins ramArbitor_0/raddr1_out_vec] \
  [get_bd_pins ramArray_0/raddr1]
  connect_bd_net -net ramArbitor_0_raddr2_out  [get_bd_pins ramArbitor_0/raddr2_out_vec] \
  [get_bd_pins ramArray_0/raddr2]
  connect_bd_net -net ramArbitor_0_ramVector  [get_bd_pins ramArbitor_0/ramVector] \
  [get_bd_pins system_ila_1/probe1] \
  [get_bd_pins sobel_compute_0/ramVector_in]
  connect_bd_net -net ramArbitor_0_vDe_out  [get_bd_pins ramArbitor_0/vDe_out] \
  [get_bd_pins system_ila_1/probe2] \
  [get_bd_pins sobel_compute_0/vDe_in]
  connect_bd_net -net ramArbitor_0_vsync_out  [get_bd_pins ramArbitor_0/vsync_out] \
  [get_bd_pins system_ila_1/probe4] \
  [get_bd_pins sobel_compute_0/vsync_IN]
  connect_bd_net -net ramArray_0_RAM_0_OUT  [get_bd_pins ramArray_0/RAM_0_OUT] \
  [get_bd_pins system_ila_1/probe5] \
  [get_bd_pins ramArbitor_0/RAM_0]
  connect_bd_net -net ramArray_0_RAM_1_OUT  [get_bd_pins ramArray_0/RAM_1_OUT] \
  [get_bd_pins ramArbitor_0/RAM_1]
  connect_bd_net -net ramArray_0_RAM_2_OUT  [get_bd_pins ramArray_0/RAM_2_OUT] \
  [get_bd_pins ramArbitor_0/RAM_2]
  connect_bd_net -net ramArray_0_RAM_3_OUT  [get_bd_pins ramArray_0/RAM_3_OUT] \
  [get_bd_pins ramArbitor_0/RAM_3]
  connect_bd_net -net ramArray_0_RAM_4_OUT  [get_bd_pins ramArray_0/RAM_4_OUT] \
  [get_bd_pins ramArbitor_0/RAM_4]
  connect_bd_net -net ramArray_0_RAM_5_OUT  [get_bd_pins ramArray_0/RAM_5_OUT] \
  [get_bd_pins ramArbitor_0/RAM_5]
  connect_bd_net -net ramArray_0_RAM_6_OUT  [get_bd_pins ramArray_0/RAM_6_OUT] \
  [get_bd_pins ramArbitor_0/RAM_6]
  connect_bd_net -net ramArray_0_RAM_7_OUT  [get_bd_pins ramArray_0/RAM_7_OUT] \
  [get_bd_pins ramArbitor_0/RAM_7]
  connect_bd_net -net ramArray_0_RAM_8_OUT  [get_bd_pins ramArray_0/RAM_8_OUT] \
  [get_bd_pins ramArbitor_0/RAM_8]
  connect_bd_net -net ramArray_0_start_gen  [get_bd_pins ramArray_0/start_gen] \
  [get_bd_pins sync_gen_0/start_gen]
  connect_bd_net -net ramArray_0_waddr_out  [get_bd_pins ramArray_0/waddr_out] \
  [get_bd_pins system_ila_1/probe6]
  connect_bd_net -net ramArray_0_wdata_out  [get_bd_pins ramArray_0/wdata_out] \
  [get_bd_pins system_ila_1/probe7]
  connect_bd_net -net ramArray_0_wen_out  [get_bd_pins ramArray_0/wen_out] \
  [get_bd_pins system_ila_1/probe8]
  connect_bd_net -net reset_rtl_1  [get_bd_pins reset_sync_0/async_reset_out] \
  [get_bd_pins rgb2dvi_2/aRst] \
  [get_bd_pins sync_gen_0/aresetp] \
  [get_bd_pins dvi2rgb_0/pRst] \
  [get_bd_pins ramArbitor_0/aresetp] \
  [get_bd_pins ramArray_0/aresetp] \
  [get_bd_pins sobel_compute_0/aresetp] \
  [get_bd_pins rgb2gray_0/aresetp]
  connect_bd_net -net reset_rtl_2  [get_bd_ports reset_rtl] \
  [get_bd_pins clk_wiz_0/reset] \
  [get_bd_pins dvi2rgb_0/aRst] \
  [get_bd_pins reset_sync_0/async_reset_in]
  connect_bd_net -net rgb2gray_0_gray  [get_bd_pins rgb2gray_0/gray] \
  [get_bd_pins ramArray_0/pixelIn]
  connect_bd_net -net rgb2gray_0_vDe_out  [get_bd_pins rgb2gray_0/vDe_out] \
  [get_bd_pins system_ila_1/probe9] \
  [get_bd_pins ramArray_0/validIn]
  connect_bd_net -net rgb2gray_0_vSync_out  [get_bd_pins rgb2gray_0/vSync_out] \
  [get_bd_pins ramArray_0/vsyncIn]
  connect_bd_net -net sobel_compute_0_hsync_out  [get_bd_pins sobel_compute_0/hsync_out] \
  [get_bd_pins rgb2dvi_2/vid_pHSync] \
  [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net sobel_compute_0_rgbVector  [get_bd_pins sobel_compute_0/rgbVector] \
  [get_bd_pins rgb2dvi_2/vid_pData] \
  [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net sobel_compute_0_vDe_out  [get_bd_pins sobel_compute_0/vDe_out] \
  [get_bd_pins rgb2dvi_2/vid_pVDE] \
  [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net sobel_compute_0_vsync_out  [get_bd_pins sobel_compute_0/vsync_out] \
  [get_bd_pins rgb2dvi_2/vid_pVSync] \
  [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net sync_gen_0_hsync  [get_bd_pins sync_gen_0/hsync] \
  [get_bd_pins ramArbitor_0/hsync_in]
  connect_bd_net -net sync_gen_0_vDe_out  [get_bd_pins sync_gen_0/vDe_out] \
  [get_bd_pins ramArbitor_0/vDe_in]
  connect_bd_net -net sync_gen_0_vsync  [get_bd_pins sync_gen_0/vsync] \
  [get_bd_pins ramArbitor_0/vsync_in]
  connect_bd_net -net sys_clock_1  [get_bd_ports sys_clock] \
  [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_ports hdmi_in_hpd]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


