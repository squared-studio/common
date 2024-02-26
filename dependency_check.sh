#!/bin/bash
rm -rf ___temp

code -v && (echo -e "\033[1;32mVS Code\033[0m" >> ___temp) || (echo -e "\033[1;31mVS Code\033[0m" >> ___temp)

pip install teroshdl && (echo -e "\033[1;32mPIP Installs Packages\033[0m" >> ___temp) && (echo -e "\033[1;32mTerosHDL\033[0m" >> ___temp) || (echo -e "\033[1;31mPIP Installs Packages\033[0m" >> ___temp)

gtkwave -x && (echo -e "\033[1;32mGTKWave\033[0m" >> ___temp) || (echo -e "\033[1;31mGTKWave\033[0m" >> ___temp)

xsim --version && (echo -e "\033[1;32mXilinx Vivado\033[0m" >> ___temp) || (echo -e "\033[1;31mXilinx Vivado\033[0m" >> ___temp)

make -v && (echo -e "\033[1;32mGNU Make\033[0m" >> ___temp) || (echo -e "\033[1;31mGNU Make\033[0m" >> ___temp)

verible-verilog-format --version && (echo -e "\033[1;32mVerible Verilog Format\033[0m" >> ___temp) || (echo -e "\033[1;31mVerible Verilog Format\033[0m" >> ___temp)

verible-verilog-lint --version && (echo -e "\033[1;32mVerible Verilog Lint\033[0m" >> ___temp) || (echo -e "\033[1;31mVerible Verilog Lint\033[0m" >> ___temp)

clear
cat ___temp
rm -rf ___temp
