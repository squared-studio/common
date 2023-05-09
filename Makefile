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

.PHONY: run
run:
	@echo "To run a test with iverilog or vivado, please type:"
	@echo "make iverilog TOP=<top_module>"
	@echo "make vivado TOP=<top_module>"
	@echo "make CI"

.PHONY: print_vars
print_vars: 
	@$(eval TOP_DIR = $(shell find $(realpath ./tb/) -name "$(TOP).sv" | sed "s/$(TOP).sv//g"))
	@$(eval TBF_LIB_RTL = $(shell find $(TOP_DIR) -name "*.sv"))
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

#.PHONY: locate
#locate:
#	@$(eval TOP_DIR := $(shell find $(realpath ./tb/) -name "$(TOP).sv" | sed "s/$(TOP).sv//g"))
#	@$(eval TBF_LIB_RTL := $(shell find $(TOP_DIR) -name "*.sv"))

.PHONY: iverilog
iverilog: clean
	@make sim_iverilog

.PHONY: sim_iverilog
sim_iverilog:
	@$(eval TOP_DIR = $(shell find $(realpath ./tb/) -name "$(TOP).sv" | sed "s/$(TOP).sv//g"))
	@$(eval TBF_LIB_RTL = $(shell find $(TOP_DIR) -name "*.sv"))
	@cd $(TOP_DIR); iverilog -I $(INC_DIR) -g2012 -o $(TOP).out -s $(TOP) -l $(DES_LIB_RTL) $(TBF_LIB_RTL)
	@cd $(TOP_DIR); vvp $(TOP).out

.PHONY: vivado
vivado: clean
	@make sim_vivado

.PHONY: sim_vivado
sim_vivado:
	@$(eval TOP_DIR = $(shell find $(realpath ./tb/) -name "$(TOP).sv" | sed "s/$(TOP).sv//g"))
	@$(eval TBF_LIB_RTL = $(shell find $(TOP_DIR) -name "*.sv"))
	@cd $(TOP_DIR); xvlog -i $(INC_DIR) -sv $(TOP_DIR)$(TOP).sv -L UVM -L TBF=$(TBF_LIB_RTL) -L RTL=$(DES_LIB_RTL)
	@cd $(TOP_DIR); xelab $(TOP) -s top
	@cd $(TOP_DIR); xsim top -runall

.PHONY: CI
CI: clean
	@make ci_vivado_run
	@make ci_vivado_collect
	@make ci_print
	
.PHONY: CI_iverilog
CI_iverilog: clean
	@make ci_iverilog_run
	@make ci_iverilog_collect
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

.PHONY: ci_iverilog_run
ci_iverilog_run:
	@> CI_REPORT;
	@$(foreach word, $(CI_LIST), make sim_iverilog TOP=$(word);)

.PHONY: ci_iverilog_collect
ci_iverilog_collect: 
	@$(eval _TMP := $(shell find -name "*.out"))
	@$(foreach word,$(_TMP), vvp $(word) >> CI_REPORT_TEMP;)
	@cat CI_REPORT_TEMP | grep -E "error: |\[PASS\]|\[FAIL\]" >> CI_REPORT;

.PHONY: ci_print
ci_print: 
	@echo " " >> CI_REPORT;
	@git log -1 >> CI_REPORT;
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
	