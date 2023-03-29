set lib { platforms/asap7/lib/asap7sc7p5t_AO_SLVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_SLVT_FF_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_SLVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_SLVT_FF_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_FF_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_AO_SLVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_SLVT_SS_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_SLVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_SLVT_SS_nldm_211120.lib.gz \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_SS_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib.gz \
platforms/asap7/lib/asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib \
platforms/asap7/lib/asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib.gz \
platforms/asap7/lib/fakeram7_256x32.lib \
platforms/asap7/lib/asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib }

foreach library $lib {
	read_liberty $library
}

#read_verilog results/asap7/riscv32i/base/1_1_yosys.v
read_verilog results/asap7/riscv32i/slvt_syn_timing/1_synth.v

link_design riscv_top
#read_sdc results/asap7/riscv32i/base/1_synth.sdc
read_sdc results/asap7/riscv32i/slvt_syn_timing/1_synth.sdc

source scripts/report_metrics_synthesis.tcl
report_metrics synthesis
