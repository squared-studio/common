# register_dual_flop (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./register_dual_flop_top.svg">

## Description


## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||32||
|RESET_VALUE|bit [ELEM_WIDTH-1:0]||'0||
|FIRST_FF_EDGE_POSEDGED|bit||1||
|LAST_FF_EDGE_POSEDGED|bit||0||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|en_i|input|logic|||
|d_i|input|logic [ELEM_WIDTH-1:0]|||
|q_o|output|logic [ELEM_WIDTH-1:0]|||
