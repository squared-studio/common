# handshake_counter (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./handshake_counter_top.svg">

## Description
                  handshakes

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DEPTH|int||4||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|in_valid_i|input|logic|||
|in_ready_o|output|logic|||
|out_valid_o|output|logic|||
|out_ready_i|input|logic|||
|cnt_o|output|logic [$clog2(DEPTH+1)-1:0]|||
