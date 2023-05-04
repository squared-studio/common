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
CLEAN_TARGETS += $(shell find $(realpath ./) -name "error_log")

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
CI: ci_run_step2
	@make clean
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat CI_REPORT

.PHONY: ci_run_step2
ci_run_step2: ci_run_step1
	@$(eval _TMP := $(shell find -name "error_log"))
	@$(foreach word,$(_TMP), cat $(word) >> CI_REPORT;)

.PHONY: ci_run_step1
ci_run_step1:
	@> CI_REPORT;
	@$(foreach word,$(CI_LIST), make -f runner vivado TOP=$(word);)

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)
