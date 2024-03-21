# freq_div (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./freq_div_top.svg">

## Description
 Frequency Divider

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DIVISOR_SIZE|int||9|divisor register size|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||Asynchronous Global Reset|
|divisor_i|input|logic [DIVISOR_SIZE-1:0]||clock divisor|
|clk_i|input|logic||clock in|
|clk_o|output|logic||clock out|
