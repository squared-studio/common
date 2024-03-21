# pipeline (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./pipeline_top.svg">

## Description


## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8||
|NUM_STAGES|int||1||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|elem_in_i|input|logic [ELEM_WIDTH-1:0]|||
|elem_in_valid_i|input|logic|||
|elem_in_ready_o|output|logic|||
|elem_out_o|output|logic [ELEM_WIDTH-1:0]|||
|elem_out_valid_o|output|logic|||
|elem_out_ready_i|input|logic|||
