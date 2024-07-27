# pipeline (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./pipeline_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8|width of each pipeline element|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||asynchronous active low reset signal|
|clk_i|input|logic||global clock signal|
|rst_i|input|logic||synchronous reset signal|
|elem_in_i|input|logic [ELEM_WIDTH-1:0]||input element|
|elem_in_valid_i|input|logic||input element valid signal|
|elem_in_ready_o|output|logic||input element ready signal|
|elem_out_o|output|logic [ELEM_WIDTH-1:0]||output element|
|elem_out_valid_o|output|logic||output element valid signal|
|elem_out_ready_i|input|logic||output element ready signal|
