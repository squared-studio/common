# shift_register (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./shift_register_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||4||
|DEPTH|int||8||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|load_i|input|logic|||
|en_i|input|logic|||
|l_shift_i|input|logic|||
|s_i|input|logic [ELEM_WIDTH-1:0]|||
|s_o|output|logic [ELEM_WIDTH-1:0]|||
|p_i|input|logic [DEPTH-1:0][ELEM_WIDTH-1:0]|||
|p_o|output|logic [DEPTH-1:0][ELEM_WIDTH-1:0]|||
