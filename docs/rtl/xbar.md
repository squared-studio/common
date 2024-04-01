# xbar (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./xbar_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8|Width of each crossbar element|
|NUM_ELEM|int||6|Number of elements in the crossbar|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|s_i|input|logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0]||Input bus select|
|i_i|input|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]||Array of input bus|
|o_o|output|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]||Array of output bus|
