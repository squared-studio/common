# latch (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./latch_top.svg">

## Description
 General Purpose Latch

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DATA_WIDTH|int||8|Data Width|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||Asynchronous reset|
|en_i|input|logic||Latch enable|
|d_i|input|logic [DATA_WIDTH-1:0]||Latch data in|
|q_o|output|logic [DATA_WIDTH-1:0]||Latch data out|
