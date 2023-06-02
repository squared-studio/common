####################################################################################################
##
##    Author : Foez Ahmed (foez.official@gmail.com)
##
####################################################################################################

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

.PHONY: run
run:
	@echo "To run a test with iverilog or vivado, please type:"
	@echo "make iverilog TOP=<top_module>"
	@echo "make vivado TOP=<top_module>"
	@echo "make CI"

.PHONY: print_vars
print_vars: 
	@echo "TOP:"
	@echo "$(TOP)";
	@echo ""
	@echo "TOP_DIR:"
	@echo "$(TOP_DIR)";
	@echo ""
	@echo "vivado_compile:"
	@echo "$(shell cat $(TOP_DIR)vivado_compile.config)";
	@echo ""
	@echo "vivado_elaborate:"
	@echo "$(shell cat $(TOP_DIR)vivado_elaborate.config)";
	@echo ""
	@echo "vivado_stimulate:"
	@echo "$(shell cat $(TOP_DIR)vivado_stimulate.config)";
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

.PHONY: iverilog
iverilog: clean
	@cd $(TOP_DIR); iverilog -I $(INC_DIR) -g2012 -o $(TOP).out -s $(TOP) -l $(DES_LIB) $(TBF_LIB)
	@cd $(TOP_DIR); vvp $(TOP).out

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

.PHONY: vivado
vivado: clean
	@make sim_vivado

.PHONY: sim_vivado
sim_vivado:
	@touch $(TOP_DIR)vivado_compile.config 
	@touch $(TOP_DIR)vivado_elaborate.config 
	@touch $(TOP_DIR)vivado_stimulate.config 
	@cd $(TOP_DIR); xvlog -f $(TOP_DIR)vivado_compile.config -i $(INC_DIR) -sv $(TOP_DIR)$(TOP).sv -L UVM -L TBF=$(TBF_LIB) -L RTL=$(DES_LIB) -L INTF=$(INTF_LIB)
	@cd $(TOP_DIR); xelab -f $(TOP_DIR)vivado_elaborate.config $(TOP) -s top
	@cd $(TOP_DIR); xsim top -f $(TOP_DIR)vivado_stimulate.config -runall

.PHONY: CI
CI: clean
	@make ci_vivado_run
	@make ci_vivado_collect
	@make ci_print

.PHONY: ci_vivado_run
ci_vivado_run:
	@> CI_REPORT;
	@$(foreach word, $(CI_LIST), make sim_vivado TOP=$(word);)

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

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)

.PHONY: gen_check_list
gen_check_list:
	@$(eval CHECK_LIST := $(shell find include -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@$(eval CHECK_LIST += $(shell find rtl -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@$(eval CHECK_LIST += $(shell find tb -name "*.v" -o -name "*.vh" -o -name "*.sv" -o -name "*.svh"))
	@($(foreach word, $(CHECK_LIST), echo "[](./$(word))";)) | clip
	@echo -e "\x1b[2;35mList copied to clipboard\x1b[0m"
	