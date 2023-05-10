TOP_DIR = $(shell find $(realpath ./tb/) -name "$(TOP).sv" | sed "s/$(TOP).sv//g")
TBF_LIB_RTL = $(shell find $(TOP_DIR) -name "*.sv")
DES_LIB_RTL += $(shell find $(realpath ./rtl/) -name "*.sv")
INC_DIR = $(realpath ./include)
CI_LIST = $(shell cat CI_LIST)

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
	@echo "DES_LIB_RTL:"
	@echo "$(DES_LIB_RTL)";
	@echo ""
	@echo "TBF_LIB_RTL:"
	@echo "$(TBF_LIB_RTL)";
	@echo ""
	@echo "INC_DIR:"
	@echo "$(INC_DIR)";
	@echo ""
	@echo "CI_LIST:"
	@echo "$(CI_LIST)";

.PHONY: iverilog
iverilog: clean
	@cd $(TOP_DIR); iverilog -I $(INC_DIR) -g2012 -o $(TOP).out -s $(TOP) -l $(DES_LIB_RTL) $(TBF_LIB_RTL)
	@cd $(TOP_DIR); vvp $(TOP).out

.PHONY: list_modules
list_modules: clean
	@$(eval RTL_FILE := $(shell find rtl -name "$(RTL).sv"))
	@xvlog -i $(INC_DIR) -sv $(RTL_FILE) -L UVM -L RTL=$(DES_LIB_RTL)
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
	@cat ___flist | clip
	@make clean
	@clear
	@echo -e "\033[2;35m$(RTL) flist copied to clipboard\033[0m"

.PHONY: vivado
vivado: clean
	@make sim_vivado

.PHONY: sim_vivado
sim_vivado:
	@cd $(TOP_DIR); xvlog -i $(INC_DIR) -sv $(TOP_DIR)$(TOP).sv -L UVM -L TBF=$(TBF_LIB_RTL) -L RTL=$(DES_LIB_RTL)
	@cd $(TOP_DIR); xelab $(TOP) -s top
	@cd $(TOP_DIR); xsim top -runall

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
	@echo " " >> CI_REPORT;
	@git log -1 >> CI_REPORT;
	@make clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat CI_REPORT

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)

.PHONY: gen_check_list
gen_check_list:
	@$(eval CHECK_LIST := $(shell find include -name "*.sv"))
	@$(eval CHECK_LIST += $(shell find rtl -name "*.sv"))
	@$(eval CHECK_LIST += $(shell find tb -name "*.sv"))
	@($(foreach word, $(CHECK_LIST), echo "[](./$(word))";)) | clip
	@echo -e "\033[2;35mList copied to clipboard\033[0m"
	