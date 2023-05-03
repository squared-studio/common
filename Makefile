TOP_DIR = $(shell find -name "$(TOP).sv" | sed "s/$(TOP).sv//g")

DES_LIB_CMP += $(shell find $(realpath ./cmp/) -name "*.sv")
TBF_LIB_CMP += $(shell find $(realpath ./)/$(TOP_DIR) -name "*.sv")
INC_DIR = $(shell realpath ./include)

CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.out")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.vcd")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.log")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.wdb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.jou")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.pb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name ".Xil")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "xsim.dir")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "CI_REPORT")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "ci_error_log")

.PHONY: run
run:
	@clear
	@echo "To run a test with iverilog or vivado, please type:"
	@echo "make iverilog TOP=<top_module>"
	@echo "make vivado TOP=<top_module>"
	@echo "make CI"

.PHONY: CI
CI:
	@make -f runner
	@make clean
	@clear
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";

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

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)
	@clear