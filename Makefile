list += tb_fifo
list += tb_pipeline

final: step3
	@cat CICD_REPORT;
	@$(shell cat CICD_REPORT)

step1:
	@rm -rf CICD_REPORT;
	@> CICD_REPORT;

step2: step1	
	@cd tb; $(foreach word,$(list), make iverilog TOP=$(word);)
	@cd tb; make clean;
	@clear;

step3: step2	
	@$(eval _TMP := $(shell find -name "cicd_error_log"))
	@$(foreach word,$(_TMP), cat $(word) >> CICD_REPORT;)
	@rm -f *.vcd $(_TMP)