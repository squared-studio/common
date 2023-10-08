####################################################################################################
##
##    Author : Foez Ahmed (foez.official@gmail.com)
##
####################################################################################################

ROOT        = $(shell pwd)
TOP         = $(shell cat ___TOP)
RTL         = $(shell cat ___RTL)
TOP_DIR     = $(shell find $(realpath ./tb/) -wholename "*$(TOP)/$(TOP).sv" | sed "s/\/$(TOP).sv//g")
TBF_LIB     = $(shell find $(TOP_DIR) -name "*.v" -o -name "*.sv")
DES_LIB     = $(shell find $(realpath ./rtl/) -name "*.v" -o -name "*.sv")
INTF_LIB    = $(shell find $(realpath ./intf/) -name "*.sv")
INC_DIR     = $(realpath ./include)
RTL_FILE    = $(shell find $(realpath ./rtl/) -name "$(RTL).sv")
CONFIG      = default
CONFIG_PATH = $(TOP_DIR)/config/$(CONFIG)

CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.out")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.vcd")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.log")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.wdb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.jou")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.pb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name ".Xil")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "xsim.dir")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___CI_REPORT_TEMP")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___list")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___flist")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_header")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___TO_COPY")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.cache")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.hw")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.ip_user_files")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.sim")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.xpr")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.tcl")

OS = $(shell uname)
ifeq ($(OS),Linux)
  CLIP = xclip -sel clip
else
	CLIP = clip
endif

GIT_UNAME = $(shell git config user.name)
GIT_UMAIL = $(shell git config user.email)

CI_LIST  = $(shell cat CI_LIST)

####################################################################################################
# General
####################################################################################################

.PHONY: help
help:
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a testbench, type:\033[0m"
	@echo -e "\033[1;38mmake create_tb TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a rtl, type:\033[0m"
	@echo -e "\033[1;38mmake create_rtl RTL=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with vivado, type:\033[0m"
	@echo -e "\033[1;38mmake simulate TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo clean all temps, type:\033[0m"
	@echo -e "\033[1;38mmake clean\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wavedump using gtkwave, type:\033[0m"
	@echo -e "\033[1;38mmake gwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wave using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake vwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo copy an instance of any rtl, type:\033[0m"
	@echo -e "\033[1;38mmake copy_instance RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open schematic using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake schematic RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo find any rtl, type:\033[0m"
	@echo -e "\033[1;38mmake find_rtl RTL=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run CI check, type:\033[0m"
	@echo -e "\033[1;38mmake CI\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with iverilog, type:\033[0m"
	@echo -e "\033[1;38mmake iverilog TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo generate a list of all Verilog/SystemVerilog files, type:\033[0m"
	@echo -e "\033[1;38mmake gen_check_list\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo generate flist of an RTL, type:\033[0m"
	@echo -e "\033[1;38mmake flist RTL=<rtl>\033[0m"
	@echo -e ""

.PHONY: gen_check_list
gen_check_list:
	@$(eval CHECK_LIST := $(shell find include -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@$(eval CHECK_LIST += $(shell find rtl -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@$(eval CHECK_LIST += $(shell find intf -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@$(eval CHECK_LIST += $(shell find tb -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@($(foreach word, $(CHECK_LIST), echo "[](./$(word))";)) | $(CLIP)
	@echo -e "\033[2;35mList copied to clipboard\033[0m"

.PHONY: clean
clean:
	@echo -e "$(CLEAN_TARGETS)" | sed "s/  //g" | sed "s/ /\nremoving /g"
	@rm -rf $(CLEAN_TARGETS)

####################################################################################################
# FLIST (Vivado)
####################################################################################################

.PHONY: find_rtl
find_rtl:
	@find $(realpath ./rtl/) -iname "*$(RTL)*.sv"

.PHONY: list_modules
list_modules: clean
	@$(eval RTL_FILE := $(shell find rtl -name "$(RTL).sv"))
	@xvlog -i $(INC_DIR) -sv $(RTL_FILE) -L RTL=$(DES_LIB)
	@xelab $(RTL) -s top
	@cat xelab.log | grep -E "work" > ___list
	@sed -i "s/.*work\.//gi" ___list;
	@sed -i "s/(.*//gi" ___list;
	@sed -i "s/_default.*//gi" ___list;

.PHONY: locate_files
locate_files: list_modules
	@$(eval _TMP := $(shell cat ___list))
	@$(foreach word,$(_TMP), find -name "$(word).sv" >> ___flist;)

.PHONY: flist
flist: locate_files
	@cat ___flist | $(CLIP)
	@make clean
	@clear
	@echo -e "\033[2;35m$(RTL) flist copied to clipboard\033[0m"

####################################################################################################
# Schematic (Vivado)
####################################################################################################

.PHONY: schematic
schematic: locate_files
	@echo "$(RTL)" > ___RTL
	@echo "create_project top" > top.tcl
	@echo "set_property include_dirs ./include [current_fileset]" >> top.tcl
	@$(foreach word, $(shell cat ___flist), echo "add_files $(word)" >> top.tcl;)
	@echo "set_property top $(RTL) [current_fileset]" >> top.tcl
	@echo "start_gui" >> top.tcl
	@echo "synth_design -top $(RTL) -lint" >> top.tcl
	@echo "synth_design -rtl -rtl_skip_mlo -name rtl_1" >> top.tcl
	@vivado -mode tcl -source top.tcl
	@make clean

####################################################################################################
# Simulate (Vivado)
####################################################################################################

.PHONY: simulate
simulate: 
	@echo "$(TOP)" > ___TOP
	make clean vivado TOP=$(TOP) CONFIG=$(CONFIG)

.PHONY: vivado
vivado:
	@mkdir -p $(CONFIG_PATH)
	@touch $(CONFIG_PATH)/xvlog
	@touch $(CONFIG_PATH)/xelab
	@touch $(CONFIG_PATH)/xsim
	@cd $(TOP_DIR); xvlog \
		-f $(CONFIG_PATH)/xvlog \
		-d SIMULATION \
		--define CONFIG=\"$(CONFIG)\" \
		-i $(INC_DIR) \
		-sv $(TOP_DIR)/$(TOP).sv \
		-L UVM \
		-L TBF=$(TBF_LIB) \
		-L RTL=$(DES_LIB) \
		-L INTF=$(INTF_LIB)
	@cd $(TOP_DIR); xelab \
		-f $(CONFIG_PATH)/xelab \
		$(TOP) -s top
	@cd $(TOP_DIR); xsim \
		top -f $(CONFIG_PATH)/xsim \
		-runall

.PHONY: rtl_init_sim
rtl_init_sim: clean
	@echo "$(RTL)" > ___RTL
	@xvlog -d SIMULATION -i $(INC_DIR) -sv -L RTL=$(DES_LIB)
	@xelab $(RTL) -s top
	@xsim top -runall

####################################################################################################
# CI (Vivado)
####################################################################################################

.PHONY: CI
CI: clean ci_vivado_run ci_vivado_collect ci_print

include ci_run

.PHONY: ci_vivado_collect
ci_vivado_collect:
	@$(eval _TMP := $(shell find -name "*.log"))
	@$(foreach word,$(_TMP), cat $(word) >> ___CI_REPORT_TEMP;)
	@cat ___CI_REPORT_TEMP | grep -E "ERROR: |\[PASS\]|\[FAIL\]" >> ___CI_REPORT;

.PHONY: ci_print
ci_print:
	@$(eval _PASS := $(shell grep -c "1;32m\[PASS\]" ___CI_REPORT))
	@$(eval _FAIL := $(shell grep -c "1;31m\[FAIL\]" ___CI_REPORT))
	@if [ "$(_FAIL)" = "0" ]; then \
		echo -e "\033[1;32m" >> ___CI_REPORT;\
	else\
		echo -e "\033[1;31m" >> ___CI_REPORT;\
	fi
	@echo ">>>>>>>>>>>>>>>>>>>> $(_PASS)/$(shell expr $(_FAIL) + $(_PASS)) PASSED <<<<<<<<<<<<<<<<<<<<" >> ___CI_REPORT;
	@echo -e "\033[0m" >> ___CI_REPORT;
	@git log -1 >> ___CI_REPORT;
	@make clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat ___CI_REPORT

####################################################################################################
# Lint (Verilator)
####################################################################################################

.PHONY: verilator_lint
verilator_lint:
	@($(foreach word, $(DES_LIB), \
		verilator --lint-only $(DES_LIB) --top-module $(shell basename -s .sv $(word));))

####################################################################################################
# Simulate (iverilog)
####################################################################################################

.PHONY: iverilog
iverilog: clean
	@echo "$(TOP)" > ___TOP
	@cd $(TOP_DIR); iverilog -I $(INC_DIR) -g2012 -o $(TOP).out -s $(TOP) -l $(DES_LIB) $(TBF_LIB)
	@cd $(TOP_DIR); vvp $(TOP).out

####################################################################################################
# Waveform (GTKWave)
####################################################################################################

.PHONY: rawVCD
rawVCD:
	@cd $(TOP_DIR); test -e dump.vcd && gtkwave dump.vcd || echo -e "\033[1;31mNo wave found\033[0m"

.PHONY: gwave
gwave:
	@cd $(TOP_DIR); test -e *.gtkw && gtkwave *.gtkw || cd $(ROOT); make rawVCD

####################################################################################################
# Waveform (Vivado)
####################################################################################################

.PHONY: vwave
vwave:
	@cd $(TOP_DIR); xsim top -f $(CONFIG_PATH)/xsim -gui

####################################################################################################
# Copy Instance
####################################################################################################

.PHONY: module_header
module_header:
	@sed -n '/^module /,/);$$/p' $(RTL_FILE) \
		| sed "s/\/\/.*//g" \
		| sed "s/  *$$//g" \
		| sed -z "s/\n\n/\n/g" \
		| sed -z "s/\n\n/\n/g" \
		> ___module_header

.PHONY: module_param
module_param:
	@cat ___module_header \
		| grep -E -w "parameter" \
		| sed "s/,//g" \
		| sed "s/$$/;/g" \
		| sed "s/ *parameter */localparam /g" \
		> ___module_param

.PHONY: module_port
module_port:
	@cat ___module_header \
		| grep -E -w "input|output|inout" \
		| sed "s/,//g" \
		| sed "s/$$/;/g" \
		| sed "s/ *input *\| *output *\| *inout *//g" \
		| sed "s/_ni;/_ni = '1;/g" \
		| sed "s/_i;/_i = '0;/g" \
		>___module_port

.PHONY: module_raw_param
module_raw_param:
	@cat ___module_param \
		| sed "s/\[.*\]//g" \
		| sed "s/;//g" \
		| sed "s/  *=.*//g" \
		| sed "s/localparam.* //g" \
		> ___module_raw_param

.PHONY: module_raw_port
module_raw_port:
	@cat ___module_port \
		| sed "s/\[.*\]//g" \
		| sed "s/;//g" \
		| sed "s/  *=.*//g" \
		| sed "s/^.* //g" \
		> ___module_raw_port

.PHONY: module_raw_inst
module_raw_inst:
	@echo "$(RTL) #(" > ___module_raw_inst
	@$(foreach word, $(shell cat ___module_raw_param), echo "  .$(word)($(word))," >> ___module_raw_inst;)
	@echo ") u_$(RTL) (" >> ___module_raw_inst
	@$(foreach word, $(shell cat ___module_raw_port), echo "  .$(word)($(word))," >> ___module_raw_inst;)
	@echo ");" >> ___module_raw_inst
	
.PHONY: module_inst
module_inst:
	@cat ___module_raw_inst \
		| sed -z "s/,\n)/\n)/g" > ___module_inst
		
.PHONY: copy_instance
copy_instance:
	@make clean
	@make module_header RTL=$(RTL)
	@make module_param
	@make module_port
	@make module_raw_param
	@make module_raw_port
	@make module_raw_inst
	@make module_inst
	@echo "" > ___TO_COPY
	@cat ___module_param >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___module_port >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___module_inst >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___TO_COPY | $(CLIP)
	@make clean
	@echo -e "\033[2;35m$(RTL) instance copied to clipboard\033[0m"

####################################################################################################
# Create TB
####################################################################################################

.PHONY: create_tb
create_tb:
	@echo "$(TOP)" > ___TOP
	@test -e ./tb/$(TOP)/$(TOP).sv || \
		(	\
			mkdir -p ./tb/$(TOP) && cat tb_model.sv	\
			  | sed "s/^module tb_model;$$/module $(TOP);/g" \
			  | sed "s/.*### Author :.*/\/\/ ### Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./tb/$(TOP)/$(TOP).sv \
		)
	@code ./tb/$(TOP)/$(TOP).sv

####################################################################################################
# Create RTL
####################################################################################################

.PHONY: create_rtl
create_rtl:
	@echo "$(RTL)" > ___RTL
	@test -e ./rtl/$(RTL).sv || \
		(	\
			cat rtl_model.sv	\
			  | sed "s/^module rtl_model #($$/module $(RTL) #(/g" \
			  | sed "s/.*### Author :.*/\/\/ ### Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./rtl/$(RTL).sv \
		)
	@code ./rtl/$(RTL).sv

####################################################################################################
# Update Doc List
####################################################################################################

update_doc_list:
	@cat readme_base.md > readme.md
	@echo "" >> readme.md
	@echo "## RTL" >> readme.md
	@$(foreach file, $(shell find ./docs/rtl -name "*.md"), make get_rtl_doc_header FILE=$(file);)
	@echo "" >> readme.md
	@echo "## INCLUDE" >> readme.md
	@$(foreach file, $(shell find ./docs/include -name "*.md"), make get_inc_doc_header FILE=$(file);)
	@echo "" >> readme.md
  
get_rtl_doc_header:
	@$(eval HEADER := $(shell cat $(FILE) | grep -E "# " | sed "s/^# //g"))
	@echo "[$(HEADER)]($(FILE))<br>" >> readme.md
  
get_inc_doc_header:
	@$(eval HEADER := $(shell echo $(FILE) | sed "s/\.\/docs\/include\///g" | sed "s/\.md$$//g"))
	@echo "[$(HEADER)]($(FILE))<br>" >> readme.md

