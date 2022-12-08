lappend search_path rtl/
define_design_lib WORK -path work
set link_library [list /apps/designlib/SAED90_EDK/SAED_EDK90nm/Digital_Standard_cell_Library/synopsys/models/saed90nm_max.db /apps/designlib/SAED90_EDK/SAED_EDK90nm/Digital_Standard_cell_Library/synopsys/models/saed90nm_typ.db /apps/designlib/SAED90_EDK/SAED_EDK90nm/Digital_Standard_cell_Library/synopsys/models/saed90nm_min.db]
set target_library [list /apps/designlib/SAED90_EDK/SAED_EDK90nm/Digital_Standard_cell_Library/synopsys/models/saed90nm_typ.db]
analyze -library WORK -format sverilog fft8.sv
elaborate -architecture verilog -library WORK fft8
check_design > build/reports/synth_check_design.rpt
create_clock clk -name ideal_clock1 -period 7
set_input_delay 2.0 [all_inputs]
set_output_delay 2.0 [all_outputs]
set_max_area 0
compile -map_effort medium -area_effort medium
report_area > build/reports/fft8_area.rpt
report_timing > build/reports/fft8_timing.rpt
report_resources > build/reports/fft8_resources.rpt
report_constraints > build/reports/fft8_constraints.rpt
report_qor > build/reports/fft8_qor.rpt
write_sdc build/constraints/fft8.sdc
write -f ddc -hierarchy -output build/synthesis/fft8.ddc
write -hierarchy -format verilog -output build/synthesis/fft8_synth.v
quit