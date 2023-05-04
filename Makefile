TOP_DIR = $(shell find $(realpath ./) -name "$(TOP).sv" | sed "s/$(TOP).sv//g")
DES_LIB_CMP += $(shell find $(realpath ./cmp/) -name "*.sv")
TBF_LIB_CMP += $(shell find $(TOP_DIR) -name "*.sv")
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
	@echo "TOP:"
	@echo "$(TOP)";
	@echo ""
	@echo "TOP_DIR:"
	@echo "$(TOP_DIR)";
	@echo ""
	@echo "DES_LIB_CMP:"
	@echo "$(DES_LIB_CMP)";
	@echo ""
	@echo "TBF_LIB_CMP:"
	@echo "$(TBF_LIB_CMP)";
	@echo ""
	@echo "INC_DIR:"
	@echo "$(INC_DIR)";
	@echo ""
	@echo "CI_LIST:"
	@echo "$(CI_LIST)";

.PHONY: iverilog
iverilog: clean
	@cd $(TOP_DIR); iverilog -I $(INC_DIR) -g2012 -o $(TOP).out -s $(TOP) -l $(DES_LIB_CMP) $(TBF_LIB_CMP)
	@cd $(TOP_DIR); vvp $(TOP).out

.PHONY: vivado
vivado: elaborate
	@cd $(TOP_DIR); xsim top -runall

.PHONY: elaborate
elaborate: compile
	@cd $(TOP_DIR); xelab $(TOP) -s top

.PHONY: compile
compile: clean
	@cd $(TOP_DIR); xvlog -i $(INC_DIR) -sv $(TOP).sv -L UVM -L TBF=$(TBF_LIB_CMP) -L CMP=$(DES_LIB_CMP)

.PHONY: CI
CI: ci_collect_all_logs
	@echo " " >> CI_REPORT;
	@git log -1 >> CI_REPORT;
	@make clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat CI_REPORT

.PHONY: ci_collect_all_logs
ci_collect_all_logs: ci_run_all_tests
	@$(eval _TMP := $(shell find -name "*.log"))
	@$(foreach word,$(_TMP), cat $(word) >> CI_REPORT_TEMP;)
	@cat CI_REPORT_TEMP | grep -E "ERROR: |\[PASS\]|\[FAIL\]" >> CI_REPORT;

.PHONY: ci_run_all_tests
ci_run_all_tests: clean
	@> CI_REPORT;
	@$(foreach word,$(CI_LIST), make ci_run_single SEL_TOP=$(word);)

.PHONY: ci_run_single
ci_run_single:
	@$(eval SEL_TOP_DIR = $(shell find $(realpath ./tb/) -name "$(SEL_TOP).sv" | sed "s/$(SEL_TOP).sv//g"))
	@$(eval TBF_LIB_CMP = $(shell find $(SEL_TOP_DIR) -name "*.sv"))
	@cd $(SEL_TOP_DIR); xvlog -i $(INC_DIR) -sv $(SEL_TOP_DIR)$(SEL_TOP).sv -L UVM -L TBF=$(TBF_LIB_CMP) -L CMP=$(DES_LIB_CMP)
	@cd $(SEL_TOP_DIR); xelab $(SEL_TOP) -s top
	@cd $(SEL_TOP_DIR); xsim top -runall

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)
