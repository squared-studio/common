INC_DIR += -i common_cells/
INC_DIR += -i include/

FLIST += axi_to_mem.sv
FLIST += tb_axi_to_mem.sv

TOP = tb_axi_to_mem

CT += *.log
CT += *.pb
CT += *.jou
CT += *.vcd
CT += xsim.dir

run: clean
	@xvlog $(INC_DIR) -sv $(FLIST)
	@xelab $(TOP) -s top
	@xsim top -runall

clean:
	@rm -rf $(CT)