source $::env(SCRIPTS_DIR)/read_liberty.tcl
read_verilog $::env(RESULTS_DIR)/1_synth.v
link_design $::env(DESIGN_NAME)
read_sdc $::env(RESULTS_DIR)/1_synth.sdc
source $::env(SCRIPTS_DIR)/report_metrics.tcl
report_metrics synthesis

