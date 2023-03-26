source scripts/read_liberty.tcl

#read_verilog results/asap7/riscv32i/base/1_1_yosys.v
read_verilog $::env(RESULTS_DIR)/1_synth.v

link_design riscv_top
#read_sdc results/asap7/riscv32i/base/1_synth.sdc
read_sdc $::env(RESULTS_DIR)/1_synth.sdc

source scripts/report_metrics.tcl
report_metrics synthesis
