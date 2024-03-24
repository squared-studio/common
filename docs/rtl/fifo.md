# fifo (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./fifo_top.svg">

## Description
 Simple FIFO

<img src="./fifo_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|PIPELINED|bit||1|Width of each element|
|ELEM_WIDTH|int||8|Width of each element|
|FIFO_SIZE|int||4|Number of elements that can be stored in the FIFO|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||Input clock|
|arst_ni|input|logic||Asynchronous reset|
|elem_in_i|input|logic [ELEM_WIDTH-1:0]||Input element|
|elem_in_valid_i|input|logic||Input valid|
|elem_in_ready_o|output|logic||Input ready|
|elem_out_o|output|logic [ELEM_WIDTH-1:0]||Output element|
|elem_out_valid_o|output|logic||Output valid|
|elem_out_ready_i|input|logic||Output ready|
