####################################################################################################
##
##    Author : Foez Ahmed (foez.official@gmail.com)
##
####################################################################################################

TOP      = $(shell cat ___TOP)
TOP_DIR  = $(shell find $(realpath ./tb/) -wholename "*$(TOP)/$(TOP).sv" | sed "s/$(TOP).sv//g")
TBF_LIB  = $(shell find $(TOP_DIR) -name "*.v" -o -name "*.sv")
DES_LIB += $(shell find $(realpath ./rtl/) -name "*.v" -o -name "*.sv")
INTF_LIB = $(shell find $(realpath ./intf/) -name "*.sv")
INC_DIR  = $(realpath ./include)

CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.out")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.vcd")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.log")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.wdb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.jou")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.pb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name ".Xil")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "xsim.dir")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "CI_REPORT_TEMP")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___list")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___flist")

OS = $(shell uname)
CI_LIST  = $(shell cat CI_LIST)

####################################################################################################
# General
####################################################################################################

.PHONY: help
help:
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with vivado, type:\033[0m"
	@echo -e "\033[1;38mmake simulate TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo clean all temps, type:\033[0m"
	@echo -e "\033[1;38mmake clean\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wavedump using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake vwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open schematic using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake schematic RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wavedump using gtkwave, type:\033[0m"
	@echo -e "\033[1;38mmake gwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run CI check, type:\033[0m"
	@echo -e "\033[1;38mmake CI\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with iverilog, type:\033[0m"
	@echo -e "\033[1;38mmake iverilog TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo generate variables for a testbench, type:\033[0m"
	@echo -e "\033[1;38mmake gen_check_list TOP=<tb_top>\033[0m"
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
	@($(foreach word, $(CHECK_LIST), echo "[](./$(word))";)) | clip
	@echo -e "\x1b[2;35mList copied to clipboard\x1b[0m"

.PHONY: print_vars
print_vars: 
	@echo "TOP:"
	@echo "$(TOP)";
	@echo ""
	@echo "TOP_DIR:"
	@echo "$(TOP_DIR)";
	@echo ""
	@echo "vivado_compile:"
	@echo "$(shell cat $(TOP_DIR)vivado_compile_extra_command_line_options)";
	@echo ""
	@echo "vivado_elaborate:"
	@echo "$(shell cat $(TOP_DIR)vivado_elaborate_extra_command_line_options)";
	@echo ""
	@echo "vivado_stimulate:"
	@echo "$(shell cat $(TOP_DIR)vivado_stimulate_extra_command_line_options)";
	@echo ""
	@echo "DES_LIB:"
	@echo "$(DES_LIB)";
	@echo ""
	@echo "INTF_LIB:"
	@echo "$(INTF_LIB)";
	@echo ""
	@echo "TBF_LIB:"
	@echo "$(TBF_LIB)";
	@echo ""
	@echo "INC_DIR:"
	@echo "$(INC_DIR)";
	@echo ""
	@echo "CI_LIST:"
	@echo "$(CI_LIST)";

.PHONY: clean
clean:
	@rm -rf top.cache top.hw top.ip_user_files top.sim top.xpr top.tcl
	@rm -rf $(CLEAN_TARGETS)

####################################################################################################
# FLIST (Vivado) 
####################################################################################################

.PHONY: list_all
list_all: clean
	@$(foreach word, $(DES_LIB), echo "$(shell basename -s .sv $(word))";)

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
	@if [ "$(OS)" = "Linux" ]; then cat ___flist | xclip -sel clip >> CI_REPORT; else cat ___flist | clip; fi
	@make clean
	@clear
	@echo -e "\x1b[2;35m$(RTL) flist copied to clipboard\x1b[0m"

####################################################################################################
# Schematic (Vivado)
####################################################################################################

.PHONY: schematic
schematic: locate_files
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
simulate: clean vivado

.PHONY: vivado
vivado:
	@echo "$(TOP)" > ___TOP
	@touch $(TOP_DIR)vivado_compile_extra_command_line_options 
	@touch $(TOP_DIR)vivado_elaborate_extra_command_line_options 
	@touch $(TOP_DIR)vivado_stimulate_extra_command_line_options 
	@cd $(TOP_DIR); xvlog -f $(TOP_DIR)vivado_compile_extra_command_line_options -i $(INC_DIR) -sv $(TOP_DIR)$(TOP).sv -L UVM -L TBF=$(TBF_LIB) -L RTL=$(DES_LIB) -L INTF=$(INTF_LIB)
	@cd $(TOP_DIR); xelab -f $(TOP_DIR)vivado_elaborate_extra_command_line_options $(TOP) -s top
	@cd $(TOP_DIR); xsim top -f $(TOP_DIR)vivado_stimulate_extra_command_line_options -runall

####################################################################################################
# CI (Vivado) 
####################################################################################################

.PHONY: CI
CI: clean ci_vivado_run ci_vivado_collect ci_print

.PHONY: ci_vivado_run
ci_vivado_run:
	@> CI_REPORT;
	@$(foreach word, $(CI_LIST), make vivado TOP=$(word);)

.PHONY: ci_vivado_collect
ci_vivado_collect: 
	@$(eval _TMP := $(shell find -name "*.log"))
	@$(foreach word,$(_TMP), cat $(word) >> CI_REPORT_TEMP;)
	@cat CI_REPORT_TEMP | grep -E "ERROR: |\[PASS\]|\[FAIL\]" >> CI_REPORT;

.PHONY: ci_print
ci_print:
	@$(eval _PASS := $(shell grep -c "1;32m\[PASS\]" CI_REPORT))
	@$(eval _FAIL := $(shell grep -c "1;31m\[FAIL\]" CI_REPORT)) 
	@if [ "$(_FAIL)" = "0" ]; then \
		echo -e "\x1b[1;32m" >> CI_REPORT;\
	else\
		echo -e "\x1b[1;31m" >> CI_REPORT;\
	fi
	@echo ">>>>>>>>>>>>>>>>>>>> $(_PASS)/$(shell expr $(_FAIL) + $(_PASS)) PASSED <<<<<<<<<<<<<<<<<<<<" >> CI_REPORT;
	@echo -e "\x1b[0m" >> CI_REPORT;
	@git log -1 >> CI_REPORT;
	@make clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\x1b[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\x1b[0m";
	@cat CI_REPORT

####################################################################################################
# Lint (Verilator)
####################################################################################################

.PHONY: verilator_lint
verilator_lint:
	@($(foreach word, $(DES_LIB), verilator --lint-only $(DES_LIB) --top-module $(shell basename -s .sv $(word));))

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

.PHONY: gwave
gwave:
	@cd $(TOP_DIR); \
	test -e *.gtkw && gtkwave *.gtkw \
	|| test -e dump.vcd && gtkwave dump.vcd \
	|| echo -e "\033[1;31mNo wave found\033[0m"

####################################################################################################
# Waveform (Vivado)
####################################################################################################

.PHONY: vwave
vwave:
	@cd $(TOP_DIR); xsim top -f $(TOP_DIR)vivado_stimulate_extra_command_line_options -gui
