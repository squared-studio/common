# demux (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./demux_top.svg">

## Description
 General purpose DEMUX

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_ELEM|int||6|Number of elements in the demux|
|ELEM_WIDTH|int||8|Width of each element|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|s_i|input|logic [$clog2(NUM_ELEM)-1:0]||Output select|
|i_i|input|logic [ ELEM_WIDTH-1:0]||input|
|o_o|output|logic [ NUM_ELEM-1:0][ELEM_WIDTH-1:0]||Array of Output|
