#!/bin/bash
rm -rf ___temp

which code && (echo -e "\033[1;32mVS Code\033[0m" >> ___temp) || (echo -e "\033[1;31mVS Code\033[0m" >> ___temp)

which pip && (echo -e "\033[1;32mPIP Installs Packages\033[0m" >> ___temp) || (echo -e "\033[1;31mPIP Installs Packages\033[0m" >> ___temp)

which gtkwave && (echo -e "\033[1;32mGTKWave\033[0m" >> ___temp) || (echo -e "\033[1;31mGTKWave\033[0m" >> ___temp)

which xsim && (echo -e "\033[1;32mXilinx Vivado\033[0m" >> ___temp) || (echo -e "\033[1;31mXilinx Vivado\033[0m" >> ___temp)

which make && (echo -e "\033[1;32mGNU Make\033[0m" >> ___temp) || (echo -e "\033[1;31mGNU Make\033[0m" >> ___temp)

pip install teroshdl && (echo -e "\033[1;32mTerosHDL\033[0m" >> ___temp) || (echo -e "\033[1;31mTerosHDL\033[0m" >> ___temp)

which verible-verilog-format && (echo -e "\033[1;32mVerible Verilog Format\033[0m" >> ___temp) || (echo -e "\033[1;31mVerible Verilog Format\033[0m" >> ___temp)

which verible-verilog-lint && (echo -e "\033[1;32mVerible Verilog Lint\033[0m" >> ___temp) || (echo -e "\033[1;31mVerible Verilog Lint\033[0m" >> ___temp)

clear
cat ___temp
rm -rf ___temp
