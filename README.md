# OpenROAD Flow Improvement

## 1. Limitation of OpenROAD Synthesis flow

Most EDA toold that perform synthesis does the following:

* Provides essential reports to check power, timing etc.
* Allowing the designer to get an early estimate about the feasibility of the design.
* However, the OpenROAD flow lacked this feature.
* The task was to explore how to add these necessary checks after sythesizing a design and generate timing reorts sucessfully.

![plot](./openroad_pics/1.PNG)

&nbsp;

### 1.a. Synthesis report generation flow

![plot](./openroad_pics/2.PNG)

&nbsp;

### 1.b Evolution of the proposed Synthesis Flow

&nbsp;

#### 1.b.1 Version 1
Objective: Secure the success of the implemenatation.

Assesment:

* Using the OpenSTA tool to load the verilog(.v) and sdc(.sdc) file generated using the synthesis tool Yosys.
* Perform timing and power checks using OpenSTA.

Shortcomings:

* This script was hardcoded and used just to get a feasibility of the idea.

Scripts:
````
flow/ver1_synthesis_timing.tcl
flow/scripts/report_metrics_synthesis.tcl
````
After synthesis generate reports using:

````
# form flow directory
source ../setup_env.sh
sta
source scripts/ver1_synthesis_timing.tcl
````
Script description:

![plot](./openroad_pics/3.PNG)

![plot](./openroad_pics/4.PNG)

&nbsp;

#### 1.b.2 Version 2
Objective: Integrating the modifications of `report_metrics_synthesis.tcl` into `report_metrics.tcl` and integrating this syntheis report generation to Flow.

Assesment:

* Using the built in modified `report_metrics.tcl` with `ver1_synthesis_timing.tcl`.
* Added the report generation process to OpenROAD Flow Scripts(ORFS).

Shortcomings:
* `ver1_synthesis_timing` was used which is hardcoded. also modifications to flow `Makefile` were not completely dynamic.
* Also for local machine there was an issue with OpenSTA tool not being setup through flow. sourcing `setup_env.sh` elevate this problem. This was not an issue for cloud machine.

Scripts:
````
flow/ver1_synthesis_timing.tcl
flow/scripts/report_metrics.tcl
````
In `Makefile` just before the step **clean_synth:** below portion was added to generate reports just after completion of syntheis.
````
sta ver1_synthesis_timing.tcl -exit | tee $(LOG_DIR)/1_1_synth_timing_report.log
````
report is generated after synthesis by:
````
# form flow directory
source ../setup_env.sh
Make synth
````
Script description:

![plot](./openroad_pics/5.PNG)

![plot](./openroad_pics/6.PNG)

&nbsp;

#### 1.b.3 Version 3

Objective: Creating a dynamic `synthesis_timing.tcl` along with the modifications made in `Makefile` so that, it can be used for any designs. Also, add **Group Path** option to `report_metrics.tcl`.

Assesment:

* Ensuring that the whole proposed flow was dynamic along with the scripts used.
* Adding **Group Path** option to `report_metrics.tcl`. This was helpful to check timing paths based on group which is useful when debugging certain paths for causes of timing violation.

Scripts:
````
flow/scripts/synthesis_timing.tcl
flow/scripts/report_metrics.tcl
````
In `Makefile` the portion introduced in version 2 is made dynamic:
````
sta $(SCRIPTS_DIR)/synthesis_timing.tcl -exit | tee $(LOG_DIR)/1_1_synth_timing_report.log
````
To solve  local machine there was an issue with OpenSTA tool described in version 2, following is added to local `.bashrc`
````
source_tool=$(find /home/fahim/ -name setup_env.sh) >/dev/null
source $source_tool >/dev/null
````
Script description:

![plot](./openroad_pics/7.PNG)

![plot](./openroad_pics/8.PNG)

&nbsp;

### 1.c Final Output

Using the modifications and scripts mentioned in version 3, all the desired results was acheived in log file `1_1_synth_timing_report.log`

![plot](./openroad_pics/9.PNG)

![plot](./openroad_pics/10.PNG)

![plot](./openroad_pics/11.PNG)

&nbsp;

## 2. Limitation of DRC check options

&nbsp;

### 2.a. Challenges
* In the OpenROAD flow, DRC checks work on **nangate45** and **sky130hd** with `make drc` command. 
* But for asap7, There was no rule file ( `.lydrc` ) to run DRC checks with.
* `.lydrc` file works for Klayout version 0,27.1 or higher
but the ORFS was using Klayout 0.26.4.

&nbsp;

### 2.b. Observation

* The following files are necessary to perform drc check with **klayout** using `make drc`:
````
6_final.gds
$(PLATFORM).lydrc
````
* Here `.lydrc` file was missing from **asap7** pdk.

&nbsp;

### 2.c. Work done to resolve this issue

To add drc support for **asap7** pdk and run `make drc`:
* First, ensure that a KLayout tech file (`.lydrc` ) exists for the platform. If not, create it.
* Secondly, Create (or copy) a KLayout .lydrc file at 
`flow/platforms/$(PLATFORM)/drc/$(PLATFORM).lydrc`

* Add the following line at the end of `flow/platforms/$(PLATFORM)/config.mk:`
````
# KLayout DRC ruledeck
export KLAYOUT_DRC_FILE = $(PLATFORM_DIR)/drc/asap7.lydrc
````

&nbsp;

### 2.d. Flow for generating drc reports

![plot](./openroad_pics/12.PNG)

&nbsp;

### 2.e. DRCs in Klayout
* The output files gennerated from `make drc`:
````
6_drc.log
6_drc_count.rpt
6_drc.lyrdb
````
* Using `6_drc.lyrdb` and `6_final.gds` we can explore drc violations in the design using **klayout**.

![plot](./openroad_pics/13.PNG)

&nbsp;

## 3. Lack of Power grid connection to Macro

&nbsp;

### 3.a. Challenges
* In the OpenROAD flow, for **riscv32i** design with **asap7** pdk, macros were placed but they lacked connection to the design power grid.

&nbsp;

### 3.b. Observation
* Analyzing the issue revealed that power stripes for both VDD and VSS at M5 were present above macros but they lacked via connection to macros power grid which is at M4.

![plot](./openroad_pics/14.PNG)

&nbsp;

### 3.c. Work done to resolve this issue
To establish power connection to macros, vias are dropped from M5 to M4.
* This modification is added to the end of existing powergrid generating script `
flow/platforms/asap7/openRoad/pdn/grid_strategy-M2-M5-M7.tcl`:
````
#####################################
# macro via connection
#####################################
define_pdn_grid -name {core_macro} -voltage_domains {CORE} -macro -orient {R0 R180 MX MY} -halo {2.0 2.0 2.0 2.0} -default -grid_over_boundary
add_pdn_connect -grid {core_macro} -layers {M4 M5}
````
* This successfully establishing power connection to macros. Power via form M5 to M4 was generated connecting power stripe to macros.

![plot](./openroad_pics/15.PNG)
