# gray_to_bin (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./gray_to_bin_top.svg">

## Description

A Gray to Binary code converter is a logical circuit that is used to convert gray code
into its equivalent Binary code
[more info](https://www.geeksforgeeks.org/code-converters-binary-to-from-gray-code/)

<img src="./gray_to_bin_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DATA_WIDTH|int||4|Data Width|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|data_in_i|input|logic [DATA_WIDTH-1:0]||gray code in|
|data_out_o|output|logic [DATA_WIDTH-1:0]||binary code out|
