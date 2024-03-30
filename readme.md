# SystemVerilog IP Design & Verification
Absolutely, here's a more detailed explanation of your directory structure:

## Directory Structure
This repository is organized into several directories, each serving a specific purpose:

- **docs**: This directory houses all documentation files. These could include design specifications, user manuals, and other resources that provide more information about the project.

- **include**: This directory contains 'include' files. These are files that are included in other SystemVerilog files using the `include` directive. They may or may not be part of the Register-Transfer Level (RTL) design. These files are further organized into folders based on their protocol or use case. Note: This excludes certain include files located in the Testbench directory.

- **intf**: This directory stores SystemVerilog interfaces. These are essentially collections of signals, bundled together under a single name, complete with their own driving and monitoring tasks. These interfaces are recommended for verification purposes only, not for RTL design. We prefer structured IOs for requests and responses to expedite connections, rather than using interfaces.

- **rtl**: All design source files reside here. These could include modules, packages, and other SystemVerilog files that make up the design.

- **submodules**: This directory contains all submodules. Submodules are typically separate projects that are included in the main project as a Git submodule. Please note that submodule files are not automatically compiled. They must be manually added in compile order within the `config/*/xvlog` for each Testbench (TB). This file is auto-generated next to the TB top file.

- **tb**: This is where all the Testbenches (TBs) are stored. Each TB should be in a separate directory that matches the name of the Device Under Test (DUT) module, ending with `_tb`. The Testbenches are used to verify the functionality of the design under different scenarios.

## How-to
To know how to use different commands on this repo, type `make help` or just `make` at the repo root and further details with be printed on the terminal.

## RTL
[addr_decoder ](./docs/rtl/addr_decoder.md)<br>
[axi4l_gpio ](./docs/rtl/axi4l_gpio.md)<br>
[axi_fifo ](./docs/rtl/axi_fifo.md)<br>
[bin_to_gray ](./docs/rtl/bin_to_gray.md)<br>
[cdc_fifo ](./docs/rtl/cdc_fifo.md)<br>
[circular_xbar ](./docs/rtl/circular_xbar.md)<br>
[clk_div ](./docs/rtl/clk_div.md)<br>
[clk_gate ](./docs/rtl/clk_gate.md)<br>
[clk_mux ](./docs/rtl/clk_mux.md)<br>
[counter ](./docs/rtl/counter.md)<br>
[decoder ](./docs/rtl/decoder.md)<br>
[demux ](./docs/rtl/demux.md)<br>
[dff ](./docs/rtl/dff.md)<br>
[dual_synchronizer ](./docs/rtl/dual_synchronizer.md)<br>
[edge_detector ](./docs/rtl/edge_detector.md)<br>
[encoder ](./docs/rtl/encoder.md)<br>
[fifo ](./docs/rtl/fifo.md)<br>
[fixed_priority_arbiter ](./docs/rtl/fixed_priority_arbiter.md)<br>
[freq_div ](./docs/rtl/freq_div.md)<br>
[gray_to_bin ](./docs/rtl/gray_to_bin.md)<br>
[handshake_combiner ](./docs/rtl/handshake_combiner.md)<br>
[handshake_counter ](./docs/rtl/handshake_counter.md)<br>
[io_pad ](./docs/rtl/io_pad.md)<br>
[jk_ff ](./docs/rtl/jk_ff.md)<br>
[latch ](./docs/rtl/latch.md)<br>
[mem ](./docs/rtl/mem.md)<br>
[mem_bank ](./docs/rtl/mem_bank.md)<br>
[mem_core ](./docs/rtl/mem_core.md)<br>
[mux ](./docs/rtl/mux.md)<br>
[mux_primitive ](./docs/rtl/mux_primitive.md)<br>
[pipeline ](./docs/rtl/pipeline.md)<br>
[pipeline_branch ](./docs/rtl/pipeline_branch.md)<br>
[pipeline_core ](./docs/rtl/pipeline_core.md)<br>
[pll_model ](./docs/rtl/pll_model.md)<br>
[priority_encoder ](./docs/rtl/priority_encoder.md)<br>
[register ](./docs/rtl/register.md)<br>
[register_dual_flop ](./docs/rtl/register_dual_flop.md)<br>
[reg_file ](./docs/rtl/reg_file.md)<br>
[round_robin_arbiter ](./docs/rtl/round_robin_arbiter.md)<br>
[rv_float_reg_file ](./docs/rtl/rv_float_reg_file.md)<br>
[rv_int_reg_file ](./docs/rtl/rv_int_reg_file.md)<br>
[rv_vec_reg_file ](./docs/rtl/rv_vec_reg_file.md)<br>
[shift_register ](./docs/rtl/shift_register.md)<br>
[sr_latch_arstn ](./docs/rtl/sr_latch_arstn.md)<br>
[uart_parity_checker ](./docs/rtl/uart_parity_checker.md)<br>
[var_fifo ](./docs/rtl/var_fifo.md)<br>
[xbar ](./docs/rtl/xbar.md)<br>

## INCLUDE
[axi4l_typedef.svh](./docs/include/axi4l_typedef.svh.md)<br>
[axi4_typedef.svh](./docs/include/axi4_typedef.svh.md)<br>
[vip/axi4l_pkg.sv](./docs/include/vip/axi4l_pkg.sv.md)<br>

