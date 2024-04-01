# mem_core (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./mem_core_top.svg">

## Description

The `mem_core` module is a parameterized SystemVerilog module that implements a memory core. The
module uses a flip-flop to write data into the memory at the positive edge of the clock signal
the write enable signal is high.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8|The width of each memory data element|
|ADDR_WIDTH|int||8|The width of the address bus|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||The global clock signal|
|we_i|input|logic||The write enable signal|
|addr_i|input|logic [ADDR_WIDTH-1:0]||The address bus input|
|wdata_i|input|logic [ELEM_WIDTH-1:0]||The write data|
|rdata_o|output|logic [ELEM_WIDTH-1:0]||The read data|
