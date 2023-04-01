CLEAN_TARGETS += $(shell find -name "*.out")
CLEAN_TARGETS += $(shell find -name "*.vcd")
CLEAN_TARGETS += $(shell find -name "*.log")
CLEAN_TARGETS += $(shell find -name "*.wdb")
CLEAN_TARGETS += $(shell find -name "*.jou")
CLEAN_TARGETS += $(shell find -name "*.pb")
CLEAN_TARGETS += $(shell find -name ".Xil")
CLEAN_TARGETS += $(shell find -name "xsim.dir")

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)
	@clear