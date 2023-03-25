TOP_MODULE = $(shell ls -1 | grep -E ".gtkw" | sed 's/\.[a-z]*//g')

CLEAN_TARGETS += *.out
CLEAN_TARGETS += *.vcd
CLEAN_TARGETS += *.log
CLEAN_TARGETS += *.wdb
CLEAN_TARGETS += *.jou
CLEAN_TARGETS += *.pb
CLEAN_TARGETS += xsim.dir

COMPONENTS += ../../cmp/*

iverilog: clean
	@iverilog -g2012 -o $(TOP_MODULE).out -s $(TOP_MODULE) -l $(COMPONENTS) $(TOP_MODULE).sv
	@vvp $(TOP_MODULE).out

vivado: elaborate
	@xsim top -runall

elaborate: compile
	@xelab $(TOP_MODULE) -s top

compile: clean
	@xvlog -sv $(TOP_MODULE).sv -L UVM -L ../../cmp/*

wave:
	@gtkwave $(TOP_MODULE).gtkw

clean:
	@rm -rf $(CLEAN_TARGETS)
	@clear