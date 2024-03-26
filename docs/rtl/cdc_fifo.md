# cdc_fifo (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./cdc_fifo_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

<img src="./cdc_fifo_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8|Element width|
|FIFO_SIZE|int||2|Element width|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||Asynchronous reset|
|elem_in_clk_i|input|logic||Input clock|
|elem_in_i|input|logic [ELEM_WIDTH-1:0]||Input element|
|elem_in_valid_i|input|logic||Input valid|
|elem_in_ready_o|output|logic||Input ready|
|elem_out_clk_i|input|logic||Output clock|
|elem_out_o|output|logic [ELEM_WIDTH-1:0]||Output element|
|elem_out_valid_o|output|logic||Output valid|
|elem_out_ready_i|input|logic||Output ready|
