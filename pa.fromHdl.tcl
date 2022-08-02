
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name XilinxSpartan6-VGA_BlinkRGB -dir "D:/AMP/Research and Development/FPGA/XilinxSpartan6-VGA_BlinkRGB/planAhead_run_2" -part xc6slx25ftg256-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "TopModule.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ipcore_dir/DigitalClockManager.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {TopModule.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top TopModule $srcset
add_files [list {TopModule.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx25ftg256-3
