# SystemVerilog IP Design & Verification

## Repository Structure
The repository is structured into several directories, each with a distinct role:

- **docs**: Contains all the documentation files.

- **inc**: Houses include files, which are incorporated into other SystemVerilog files using the ``` `include``` directive. These files, which may or may not be part of the RTL, are further categorized into folders based on their protocol or use case. **Note that this does not include certain include files located in the Testbench directory.**

- **intf**: Stores SystemVerilog interfaces, which are recommended solely for verification purposes and not for RTL design. We favor structured IOs for requests and responses to facilitate connections, as opposed to using interfaces.

- **rtl**: This is where all the design source files are located.

- **sub**: Contains all submodules. **Please note that submodule files are not compiled automatically. They must be manually added in the compile order within the **`config/*/xvlog`** for each Testbench (TB). This file is auto-generated next to the TB top file.**

- **tb**: All the Testbenches (TBs) are stored here. Each TB should be in a separate directory that corresponds to the name of the Device Under Test (DUT) module, suffixed with `_tb`. The Testbenches are utilized to verify the design functionality under various scenarios.

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
[dual_flop_synchronizer ](./docs/rtl/dual_flop_synchronizer.md)<br>
[edge_detector ](./docs/rtl/edge_detector.md)<br>
[encoder ](./docs/rtl/encoder.md)<br>
[fifo ](./docs/rtl/fifo.md)<br>
[fixed_priority_arbiter ](./docs/rtl/fixed_priority_arbiter.md)<br>
[gray_to_bin ](./docs/rtl/gray_to_bin.md)<br>
[handshake_combiner ](./docs/rtl/handshake_combiner.md)<br>
[handshake_counter ](./docs/rtl/handshake_counter.md)<br>
[io_pad ](./docs/rtl/io_pad.md)<br>
[jk_ff ](./docs/rtl/jk_ff.md)<br>
[latch ](./docs/rtl/latch.md)<br>
[mem ](./docs/rtl/mem.md)<br>
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
[rv_float_converter ](./docs/rtl/rv_float_converter.md)<br>
[rv_float_reg_file ](./docs/rtl/rv_float_reg_file.md)<br>
[rv_id ](./docs/rtl/rv_id.md)<br>
[shift_register ](./docs/rtl/shift_register.md)<br>
[sr_latch_arstn ](./docs/rtl/sr_latch_arstn.md)<br>
[uart_parity_checker ](./docs/rtl/uart_parity_checker.md)<br>
[xbar ](./docs/rtl/xbar.md)<br>

## INCLUDE
[axi4l_typedef.svh](./docs/inc/axi4l_typedef.svh.md)<br>
[axi4_typedef.svh](./docs/inc/axi4_typedef.svh.md)<br>
[vip/axi4l_pkg.sv](./docs/inc/vip/axi4l_pkg.sv.md)<br>

