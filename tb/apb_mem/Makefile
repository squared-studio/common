TOP_MODULE = $(shell ls -1 | grep -E ".gtkw" | sed 's/\.[a-z]*//g')

CLEAN_TARGETS += *.out
CLEAN_TARGETS += *.vcd
CLEAN_TARGETS += *.log
CLEAN_TARGETS += *.wdb
CLEAN_TARGETS += *.jou
CLEAN_TARGETS += *.pb
CLEAN_TARGETS += xsim.dir

DES_LIB_CMP += $(shell find ../../cmp/ -name "*.sv")

.PHONY: iverilog
iverilog: clean
	@iverilog -g2012 -o $(TOP_MODULE).out -s $(TOP_MODULE) -l $(DES_LIB_CMP) $(TOP_MODULE).sv
	@vvp $(TOP_MODULE).out

.PHONY: vivado
vivado: elaborate
	@xsim top -runall

.PHONY: elaborate
elaborate: compile
	@xelab $(TOP_MODULE) -s top

.PHONY: compile
compile: clean
	@xvlog -sv $(TOP_MODULE).sv -L UVM -L CMP=$(DES_LIB_CMP)

.PHONY: wave
wave:
	@gtkwave $(TOP_MODULE).gtkw

.PHONY: clean
clean:
	@rm -rf $(CLEAN_TARGETS)
	@clear