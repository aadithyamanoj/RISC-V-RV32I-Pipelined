read_lef $::env(TECH_LEF)
read_lef $::env(STD_CELL_LEF)
read_lef $::env(SRAM_LEF)
read_liberty $::env(STD_CELL_LIB_TT)
read_liberty $::env(SRAM_LIB)
read_verilog $::env(PPA_NETLIST)
link_design cached_core

create_clock -name core_clock -period $::env(CLOCK_PERIOD_NS) [get_ports clk]
set non_clock_inputs [get_ports -filter "direction == input && name != clk" *]
set_input_delay 0.0 -clock core_clock $non_clock_inputs
set_input_transition 0.10 $non_clock_inputs
set_output_delay 0.0 -clock core_clock [all_outputs]
set_load 0.02 [all_outputs]
set_power_activity -global -activity $::env(POWER_ACTIVITY) -duty 0.50

puts "PPA_ASSUMPTIONS corner=TT_1p8V_25C clock_period_ns=$::env(CLOCK_PERIOD_NS) input_transition_ns=0.10 output_load_pf=0.02 activity=$::env(POWER_ACTIVITY) duty=0.50 parasitics=none"
puts "PPA_TIMING_BEGIN"
report_checks -path_delay max -group_count 10 -fields {slew cap input_pins} -digits 4
report_worst_slack -max -digits 4
report_tns -digits 4
puts "PPA_TIMING_END"
puts "PPA_POWER_BEGIN"
report_power
puts "PPA_POWER_END"
