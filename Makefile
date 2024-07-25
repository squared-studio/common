####################################################################################################
##
##    Author : Foez Ahmed (foez.official@gmail.com)
##
####################################################################################################

ROOT        = $(shell pwd)
TOP         = $(shell cat ___TOP)
RTL         = $(shell cat ___RTL)
TOP_DIR     = $(shell find $(realpath ./tb/) -wholename "*$(TOP)/$(TOP).sv" | sed "s/\/$(TOP).sv//g")
TB_LIB      = $(shell find $(TOP_DIR) -name "*.sv")
DES_LIB     = $(shell find $(realpath ./rtl/) -name "*.sv")
DES_LIB    += $(shell find $(realpath ./sub/) -wholename "*/rtl/*.sv" -type f | sed "s/.*\/sub\/.*\/sub\/.*//g")
INTF_LIB    = $(shell find $(realpath ./intf/) -name "*.sv")
INTF_LIB   += $(shell find $(realpath ./sub/) -wholename "*/intf/*.sv" -type f | sed "s/.*\/sub\/.*\/sub\/.*//g")
INC_DIR     = $(shell find $(realpath ./) -path "*/inc" | sed "s/^/-i /g" | sed "s/.*\/docs\/.*//g" | sed "s/.*\/sub\/.*\/sub\/.*//g")
RTL_FILE    = $(shell find $(realpath ./rtl/) -name "$(RTL).sv")
CONFIG      = default
CONFIG_PATH = $(TOP_DIR)/config/$(CONFIG)

CLEAN_TARGETS += $(shell find $(realpath ./) -name "___CI_REPORT_TEMP")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___flist")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___LINT_ERROR")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___list")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_header")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_inst")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_param")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___module_raw_port")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___temp")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "___TO_COPY")
CLEAN_TARGETS += $(shell find $(realpath ./) -name ".Xil")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.jou")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.log")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.out")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.pb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.vcd")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "*.wdb")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.cache")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.hw")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.ip_user_files")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.runs")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.sim")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.tcl")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "top.xpr")
CLEAN_TARGETS += $(shell find $(realpath ./) -name "xsim.dir")

OS = $(shell uname)
ifeq ($(OS),Linux)
  CLIP = xclip -sel clip
	PYTHON = python3
else
	CLIP = clip
	PYTHON = python
endif

GIT_UNAME = $(shell git config user.name)
GIT_UMAIL = $(shell git config user.email)

CI_LIST  = $(shell cat CI_LIST)

MAKE = make --no-print-directory

ifeq ($(CFG),$(CONFIG)) 
	COLOR = \033[1;33m
else 
	COLOR = \033[1;37m
endif

####################################################################################################
# General
####################################################################################################

.PHONY: help
help:
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a testbench, type:\033[0m"
	@echo -e "\033[1;38mmake tb TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo create or open a rtl, type:\033[0m"
	@echo -e "\033[1;38mmake rtl RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with vivado, type:\033[0m"
	@echo -e "\033[1;38mmake simulate TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo clean all temps, type:\033[0m"
	@echo -e "\033[1;38mmake clean\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wavedump using gtkwave, type:\033[0m"
	@echo -e "\033[1;38mmake gwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open wave using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake vwave TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run simulation on the initial block of an RTL, type:\033[0m"
	@echo -e "\033[1;38mmake rtl_init_sim RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo copy an instance of any rtl, type:\033[0m"
	@echo -e "\033[1;38mmake copy_instance RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo open schematic using vivado, type:\033[0m"
	@echo -e "\033[1;38mmake schematic RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo find any rtl, type:\033[0m"
	@echo -e "\033[1;38mmake find_rtl RTL=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run CI check, type:\033[0m"
	@echo -e "\033[1;38mmake CI\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo run a test with iverilog, type:\033[0m"
	@echo -e "\033[1;38mmake iverilog TOP=<tb_top>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo generate flist of an RTL, type:\033[0m"
	@echo -e "\033[1;38mmake flist RTL=<rtl>\033[0m"
	@echo -e ""
	@echo -e "\033[3;30mTo update documents, type:\033[0m"
	@echo -e "\033[1;38mmake update_doc_list\033[0m"
	@echo -e ""

.PHONY: clean
clean:
	@- echo -e "$(CLEAN_TARGETS)" | sed "s/  //g" | sed "s/ /\nremoving /g"
	@rm -rf $(CLEAN_TARGETS)

.PHONY: duplicate_check
duplicate_check:
	@$(if $(filter $(EX), $(shell cat ./___duplicate_list)), \
	echo -e "\033[1;31m$(EX) has multiple copies\033[0m" \
	&& echo -e "\033[1;31m$(EX) has multiple copies\033[0m" >> ___CI_ERROR, \
	echo "$(EX)" >> ./___duplicate_list)

.PHONY: find_duplicates
find_duplicates:
	@>___duplicate_list
	@$(foreach file, $(DES_LIB), $(MAKE) duplicate_check EX=$(shell basename $(file));)

####################################################################################################
# FLIST (Vivado)
####################################################################################################

define compile_rtl
$(eval SUB_LIB := $(shell echo "$(wordlist 1, 25,$(COMPILE_LIB))"))
xvlog $(INC_DIR) -sv $(SUB_LIB)
$(eval COMPILE_LIB := $(wordlist 26, $(words $(COMPILE_LIB)), $(COMPILE_LIB)))
$(if $(COMPILE_LIB), $(call compile_rtl))
endef

.PHONY: find_rtl
find_rtl:
	@$(foreach file, ${DES_LIB}, $(if $(findstring ${RTL}, ${file}), echo "$(file)",:);)

.PHONY: list_modules
list_modules: clean
	@$(eval RTL_FILE := $(shell find rtl -name "$(RTL).sv"))
	@$(eval COMPILE_LIB := $(DES_LIB))
	@$(call compile_rtl)
	@xelab $(RTL) -s top
	@cat xelab.log | grep -E "work" > ___list
	@sed -i "s/.*work\.//gi" ___list;
	@sed -i "s/(.*//gi" ___list;
	@sed -i "s/_default.*//gi" ___list;

.PHONY: locate_files
locate_files: list_modules
	@$(eval _TMP := )
	@$(foreach word,$(shell cat ___list), 		                                  \
		$(if $(filter $(word),$(_TMP)),					                                  \
			: ,                                                                     \
			$(eval _TMP += $(word))								                                  \
				find -name "$(word).sv" | sed "s/.*\/sub\/.*\/sub\/.*//g" >> ___flist	\
		);																			                                  \
	)

.PHONY: flist_blank_fix
flist_blank_fix:
	@$(eval temp := $(shell cat ___flist))
	@rm -rf ___flist
	@$(foreach file, $(temp), echo "$(file)" >> ___flist;)

.PHONY: flist
flist: locate_files flist_blank_fix
	@echo ""
	@cat ___flist
	@cat ___flist | $(CLIP)
	@$(MAKE) clean
	@echo -e "\033[2;35m$(RTL) flist copied to clipboard\033[0m"

####################################################################################################
# Schematic (Vivado)
####################################################################################################

.PHONY: schematic
schematic: locate_files
	@echo "$(RTL)" > ___RTL
	@echo "create_project top" > top.tcl
	@echo "set_property include_dirs ./inc [current_fileset]" >> top.tcl
	@$(foreach word, $(shell cat ___flist), echo "add_files $(word)" >> top.tcl;)
	@echo "set_property top $(RTL) [current_fileset]" >> top.tcl
	@echo "start_gui" >> top.tcl
	@echo "synth_design -top $(RTL) -lint" >> top.tcl
	@echo "synth_design -rtl -rtl_skip_mlo -name rtl_1" >> top.tcl
	@vivado -mode tcl -source top.tcl
	@$(MAKE) clean

####################################################################################################
# Simulate (Vivado)
####################################################################################################

.PHONY: config_touch
config_touch:
	@mkdir -p $(CONFIG_PATH)
	@touch $(CONFIG_PATH)/xvlog
	@touch $(CONFIG_PATH)/xelab
	@touch $(CONFIG_PATH)/xsim
	@touch $(CONFIG_PATH)/des

.PHONY: config_list
config_list: config_touch
	@echo ""
	@$(foreach cfg, $(shell ls -d $(TOP_DIR)/config/*/), \
		$(MAKE) config_print CFG=$(shell basename $(cfg));)

.PHONY: config_print
config_print:
	@echo -e "$(COLOR)$(CFG)\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/des)"
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xvlog), echo -e "\033[0;36mxvlog:\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xvlog)")
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xelab), echo -e "\033[0;36mxelab:\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xelab)")
	@$(if $(shell cat  $(TOP_DIR)/config/$(CFG)/xsim ), echo -e "\033[0;36mxsim :\033[0m $(shell cat $(TOP_DIR)/config/$(CFG)/xsim) ")
	@echo ""

.PHONY: simulate
simulate: clean
	@echo "$(TOP)" > ___TOP
	@$(MAKE) config_list
	$(MAKE) vivado TOP=$(TOP) CONFIG=$(CONFIG)

define compile_tb
$(eval SUB_LIB := $(shell echo "$(wordlist 1, 25,$(COMPILE_LIB))"))
cd $(TOP_DIR); xvlog -f $(CONFIG_PATH)/xvlog -d SIMULATION --define CONFIG=\"$(CONFIG)\" $(INC_DIR) -sv $(SUB_LIB)
$(eval COMPILE_LIB := $(wordlist 26, $(words $(COMPILE_LIB)), $(COMPILE_LIB)))
$(if $(COMPILE_LIB), $(call compile_tb))
endef

.PHONY: vivado
vivado:
	@$(MAKE) config_touch
	@touch $(TOP_DIR)/script.sh
	@cd $(TOP_DIR); ./script.sh
	@$(eval COMPILE_LIB := $(INTF_LIB) $(DES_LIB) $(TB_LIB))
	@$(call compile_tb)
	@cd $(TOP_DIR); xelab -f $(CONFIG_PATH)/xelab $(TOP) -s top
	@cd $(TOP_DIR); xsim top -f $(CONFIG_PATH)/xsim -runall -log xsim_$(CONFIG).log

.PHONY: rtl_init_sim
rtl_init_sim: clean
	@echo "$(RTL)" > ___RTL
	@xvlog -d SIMULATION $(INC_DIR) -sv -L RTL=$(DES_LIB) 
	@xelab $(RTL) -s top
	@xsim top -runall

####################################################################################################
# CI (Vivado)
####################################################################################################

.PHONY: CI
CI: clean ci_vivado_run ci_vivado_collect ci_print find_duplicates

include ci_run

___temp.log:
	@echo -e "\033[1;32m[PASS]\033[0m REPOSITORY INTEGRITY" > ___temp.log

.PHONY: ci_vivado_collect
ci_vivado_collect: ___temp.log
	@$(eval _TMP := $(shell find -name "*.log"))
	@$(foreach word,$(_TMP), cat $(word) >> ___CI_REPORT_TEMP;)
	@cat ___CI_REPORT_TEMP | grep -E "ERROR: |\[PASS\]|\[FAIL\]" >> ___CI_REPORT;

.PHONY: ci_print
ci_print:
	@$(eval _PASS := $(shell grep -c "1;32m\[PASS\]" ___CI_REPORT))
	@$(eval _FAIL := $(shell grep -c "1;31m\[FAIL\]" ___CI_REPORT))
	@if [ "$(_FAIL)" = "0" ]; then \
		echo -e "\033[1;32m" >> ___CI_REPORT;\
	else\
		echo -e "\033[1;31m" >> ___CI_REPORT;\
	fi
	@echo ">>>>>>>>>>>>>>>>>>>> $(_PASS)/$(shell expr $(_FAIL) + $(_PASS)) PASSED <<<<<<<<<<<<<<<<<<<<" >> ___CI_REPORT;
	@echo -e "\033[0m" >> ___CI_REPORT;
	@git log -1 >> ___CI_REPORT;
	@$(MAKE) clean
	@echo " "
	@echo " "
	@echo " "
	@echo -e "\033[1;32mCONTINUOUS INTEGRATION SUCCESSFULLY COMPLETE\033[0m";
	@cat ___CI_REPORT
	@grep -r "FAIL" ./___CI_REPORT | tee ___CI_ERROR

####################################################################################################
# Waveform (GTKWave)
####################################################################################################

.PHONY: rawVCD
rawVCD:
	@cd $(TOP_DIR); test -e dump.vcd && gtkwave dump.vcd || echo -e "\033[1;31mNo wave found\033[0m"

.PHONY: gwave
gwave:
	@cd $(TOP_DIR); test -e *.gtkw && gtkwave *.gtkw || cd $(ROOT); $(MAKE) rawVCD

####################################################################################################
# Waveform (Vivado)
####################################################################################################

.PHONY: vwave
vwave:
	@cd $(TOP_DIR); xsim top -f $(CONFIG_PATH)/xsim -gui

####################################################################################################
# Copy Instance
####################################################################################################

.PHONY: module_header
module_header:
	@sed -n '/^module /,/);$$/p' $(RTL_FILE) \
		| sed "s/\/\/.*//g" \
		| sed "s/  *$$//g" \
		| sed -z "s/\n\n/\n/g" \
		| sed -z "s/\n\n/\n/g" \
		> ___module_header

.PHONY: module_param
module_param:
	@cat ___module_header \
		| grep -E -w "parameter" \
		| sed "s/,//g" \
		| sed "s/$$/;/g" \
		| sed "s/ *parameter */localparam /g" \
		> ___module_param

.PHONY: module_port
module_port:
	@cat ___module_header \
		| grep -E -w "input|output|inout" \
		| sed "s/,//g" \
		| sed "s/$$/;/g" \
		| sed "s/ *input *\| *output *\| *inout *//g" \
		| sed "s/_ni;/_ni = '1;/g" \
		| sed "s/_i;/_i = '0;/g" \
		>___module_port

.PHONY: module_raw_param
module_raw_param:
	@cat ___module_param \
		| sed "s/\[.*\]//g" \
		| sed "s/;//g" \
		| sed "s/  *=.*//g" \
		| sed "s/localparam.* //g" \
		> ___module_raw_param

.PHONY: module_raw_port
module_raw_port:
	@cat ___module_port \
		| sed "s/\[.*\]//g" \
		| sed "s/;//g" \
		| sed "s/  *=.*//g" \
		| sed "s/^.* //g" \
		> ___module_raw_port

.PHONY: module_raw_inst
module_raw_inst:
	@echo "$(RTL) #(" > ___module_raw_inst
	@$(foreach word, $(shell cat ___module_raw_param), echo "  .$(word)($(word))," >> ___module_raw_inst;)
	@echo ") u_$(RTL) (" >> ___module_raw_inst
	@$(foreach word, $(shell cat ___module_raw_port), echo "  .$(word)($(word))," >> ___module_raw_inst;)
	@echo ");" >> ___module_raw_inst
	
.PHONY: module_inst
module_inst:
	@cat ___module_raw_inst \
		| sed -z "s/,\n)/\n)/g" > ___module_inst
		
.PHONY: copy_instance
copy_instance:
	@$(MAKE) clean
	@$(MAKE) module_header RTL=$(RTL)
	@$(MAKE) module_param
	@$(MAKE) module_port
	@$(MAKE) module_raw_param
	@$(MAKE) module_raw_port
	@$(MAKE) module_raw_inst
	@$(MAKE) module_inst
	@echo "" > ___TO_COPY
	@cat ___module_param >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___module_port >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___module_inst >> ___TO_COPY
	@echo "" >> ___TO_COPY
	@cat ___TO_COPY | $(CLIP)
	@$(MAKE) clean
	@echo -e "\033[2;35m$(RTL) instance copied to clipboard\033[0m"

####################################################################################################
# Create TB
####################################################################################################

.PHONY: tb
tb:
	@echo "$(TOP)" > ___TOP
	@test -e ./tb/$(TOP)/$(TOP).sv || \
		(	\
			mkdir -p ./tb/$(TOP) && cat tb_model.sv	\
			  | sed "s/^module tb_model;$$/module $(TOP);/g" \
			  | sed "s/.*Author :.*/Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./tb/$(TOP)/$(TOP).sv \
		)
	@code ./tb/$(TOP)/$(TOP).sv

####################################################################################################
# Create RTL
####################################################################################################

.PHONY: rtl
rtl:
	@echo "$(RTL)" > ___RTL
	@test -e ./rtl/$(RTL).sv || \
		(	\
			cat rtl_model.sv	\
			  | sed "s/^module rtl_model #($$/module $(RTL) #(/g" \
			  | sed "s/.*Author :.*/Author : $(GIT_UNAME) ($(GIT_UMAIL))/g" \
				> ./rtl/$(RTL).sv \
		)
	@code ./rtl/$(RTL).sv

####################################################################################################
# Update Doc List
####################################################################################################

.PHONY: update_doc_list
update_doc_list: create_all_docs
	@cat readme_base.md > readme.md
	@echo "" >> readme.md
	@echo "## RTL" >> readme.md
	@$(foreach file, $(shell find ./docs/rtl -name "*.md"), $(MAKE) get_rtl_doc_header FILE=$(file);)
	@echo "" >> readme.md
	@echo "## INCLUDE" >> readme.md
	@$(foreach file, $(shell find ./docs/inc -name "*.md"), $(MAKE) get_inc_doc_header FILE=$(file);)
	@echo "" >> readme.md

.PHONY: clear_all_docs
clear_all_docs:
	@mkdir -p docs/rtl
	@mkdir -p docs/inc
	@rm -rf docs/rtl/*.md
	@rm -rf docs/rtl/*_top.svg
	@git submodule update --init --depth 1 -- ./sub/documenter

.PHONY: create_all_docs
create_all_docs: clear_all_docs
	@$(foreach file, $(shell find $(realpath ./rtl/) -type f -wholename "*/rtl/*.sv"), \
		$(if $(shell echo $(file) | sed "s/.*__no_upload__.*//g"), $(MAKE) gen_doc FILE=$(file), echo "");)

.PHONY: get_rtl_doc_header
get_rtl_doc_header:
	@$(eval HEADER := $(shell cat $(FILE) | grep -E "# " | sed "s/^# //g" | sed "s/ .*//g"))
	@echo "[$(HEADER)]($(FILE))<br>" >> readme.md

.PHONY: get_inc_doc_header
get_inc_doc_header:
	@$(eval HEADER := $(shell echo $(FILE) | sed "s/\.\/docs\/inc\///g" | sed "s/\.md$$//g"))
	@echo "[$(HEADER)]($(FILE))<br>" >> readme.md

.PHONY: gen_doc
gen_doc:
	@echo "Creating document for $(FILE)"
	@$(PYTHON) ./sub/documenter/sv_documenter.py $(FILE) ./docs/rtl

####################################################################################################
# LINTING
####################################################################################################

.PHONY: lint
lint:
	@rm -rf ___LINT_ERROR
	@$(eval list := $(shell find -name "*.v" -o -name "*.sv"))
	@$(foreach file, $(list), verible-verilog-lint.exe $(file) >> ___LINT_ERROR 2>&1;)
	@cat ___LINT_ERROR

####################################################################################################
# REPOSITORY MAINTAINANCE
####################################################################################################

.gitmodules:
	@touch ./.gitmodules

ci_run:
	@echo ".PHONY: ci_vivado_run" > ci_run
	@echo "ci_vivado_run:" >> ci_run
	@echo "	@> ___CI_REPORT;" >> ci_run

rtl_model.sv:
	@cp ./sub/sv-genesis/rtl_model.sv ./

tb_model.sv:
	@cp ./sub/sv-genesis/tb_model.sv ./

LICENSE:
	@cp ./sub/sv-genesis/LICENSE ./

readme_base.md:
	@cp ./sub/sv-genesis/readme_base.md ./

.PHONY: submodule_add_update
submodule_add_update:
	@mkdir -p sub
	@cd sub; git submodule add --depth 1 $(URL) > /dev/null 2>&1 | : ;
	@$(eval REPO_NAME = $(shell echo $(URL) | sed "s/.*\///g" | sed "s/\..*//g"))
	@git submodule update --init -- ./sub/$(REPO_NAME) > /dev/null 2>&1
	@cd ./sub/$(REPO_NAME); git checkout main > /dev/null 2>&1; git pull > /dev/null 2>&1

.PHONY:base_repo_init
base_repo_init:
	@$(MAKE) submodule_add_update URL=https://github.com/squared-studio/sv-genesis.git
	@$(MAKE) submodule_add_update URL=https://github.com/squared-studio/documenter.git

.PHONY: add_ignore
add_ignore:
	@$(if $(filter $(EX),$(shell cat ./.gitignore)), : , echo "$(EX)" >> ./.gitignore)

.PHONY: repo_update 
repo_update: .gitmodules ci_run base_repo_init rtl_model.sv tb_model.sv LICENSE readme_base.md
	@cp ./sub/sv-genesis/Makefile ./Makefile
	@mkdir -p ./.github/workflows
	@cp -r ./sub/sv-genesis/*.yml ./.github/workflows/
	@mkdir -p ./tb/__no_upload__
	@mkdir -p ./rtl/__no_upload__
	@mkdir -p ./intf/__no_upload__
	@mkdir -p ./inc/__no_upload__
	@mkdir -p ./inc/vip/
	@cp ./sub/sv-genesis/tb_ess.sv ./inc/vip/
	@echo "# WARNING FILES THIS FOLDER IS NOT UPLOADED" > ./inc/__no_upload__/readme.md
	@echo "# WARNING FILES THIS FOLDER IS NOT UPLOADED" > ./intf/__no_upload__/readme.md
	@echo "# WARNING FILES THIS FOLDER IS NOT UPLOADED" > ./rtl/__no_upload__/readme.md
	@echo "# WARNING FILES THIS FOLDER IS NOT UPLOADED" > ./tb/__no_upload__/readme.md
	@$(MAKE) add_ignore EX=___*
	@$(MAKE) add_ignore EX=__no_upload__
	@$(MAKE) add_ignore EX=.Xil/
	@$(MAKE) add_ignore EX=*.jou
	@$(MAKE) add_ignore EX=*.log
	@$(MAKE) add_ignore EX=*.out
	@$(MAKE) add_ignore EX=*.pb
	@$(MAKE) add_ignore EX=*.swp
	@$(MAKE) add_ignore EX=*.vcd
	@$(MAKE) add_ignore EX=*.vvp
	@$(MAKE) add_ignore EX=*.wdb
	@$(MAKE) add_ignore EX=top.cache
	@$(MAKE) add_ignore EX=top.hw
	@$(MAKE) add_ignore EX=top.ip_user_files
	@$(MAKE) add_ignore EX=top.runs
	@$(MAKE) add_ignore EX=top.sim
	@$(MAKE) add_ignore EX=top.tcl
	@$(MAKE) add_ignore EX=top.xpr
	@$(MAKE) add_ignore EX=vivado_pid*.str
	@$(MAKE) add_ignore EX=xsim.dir
	@git add .
	@git add -f ./inc/__no_upload__/readme.md
	@git add -f ./intf/__no_upload__/readme.md
	@git add -f ./rtl/__no_upload__/readme.md
	@git add -f ./tb/__no_upload__/readme.md
