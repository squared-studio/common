# reg_file (module)

### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

## TOP IO
<img src="./reg_file_top.svg">

## Description

The `reg_file` module is a register file with a configurable number of source registers, register
width, and an option to hardcode zero to the first register.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_RS|int||3|number of source register|
|ZERO_REG|bit||1|hardcoded zero(0) to first register|
|NUM_REG|int||32|number of registers|
|REG_WIDTH|int||32|width of each register|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||Global clock|
|arst_ni|input|logic||asynchronous active low reset|
|rd_addr_i|input|logic [$clog2(NUM_REG)-1:0]||destination register address|
|rd_data_i|input|logic [ REG_WIDTH-1:0]||read data|
|rd_en_i|input|logic||read enable|
|rs_addr_i|input|logic [NUM_RS-1:0][$clog2(NUM_REG)-1:0]||array of source register address|
|rs_data_o|output|logic [NUM_RS-1:0][REG_WIDTH-1:0]||array of source register data|
