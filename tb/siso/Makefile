TOP_MODULE = tb_siso

CLEAN_TARGETS += *.out
CLEAN_TARGETS += *.vcd
CLEAN_TARGETS += *.log

COMPONENTS += ../../cmp/*

run: clean
	@iverilog -g2012 -o $(TOP_MODULE).out -s $(TOP_MODULE) -l $(COMPONENTS) $(TOP_MODULE).sv
	@vvp $(TOP_MODULE).out

wave:
	@gtkwave $(TOP_MODULE).gtkw

clean:
	@rm -rf $(CLEAN_TARGETS)
	@clear