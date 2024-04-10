# rv_float_reg_file (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./rv_float_reg_file_top.svg">

## Description

Write a markdown documentation for this systemverilog module:

| Precision              | Sign Bit | Exponent Bits | mantissa Bits | Bias  | Format |
|------------------------|----------|---------------|---------------|-------|--------|
| 16b (Half Precision)   | 1 (15)   | 5 [14:10]     | 10 [9:0]      | 15    | 10     |
| 32b (Single Precision) | 1 (31)   | 8 [30:23]     | 23 [22:0]     | 127   | 00     |
| 64b (Double Precision) | 1 (63)   | 11 [62:52]    | 52 [51:0]     | 1023  | 01     |
| 128b (Quad Precision)  | 1 (127)  | 15 [126:112]  | 112 [111:0]   | 16383 | 11     |

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DOUBLE|bit||0||
|QUAD|bit||1||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|rs1_addr_i|input|logic [AddrWidth-1:0]|||
|rs1_fmt_i|input|logic [ 1:0]|||
|rs1_data_o|output|logic [ RegWidth-1:0]|||
|rs2_addr_i|input|logic [AddrWidth-1:0]|||
|rs2_fmt_i|input|logic [ 1:0]|||
|rs2_data_o|output|logic [ RegWidth-1:0]|||
|rs3_addr_i|input|logic [AddrWidth-1:0]|||
|rs3_fmt_i|input|logic [ 1:0]|||
|rs3_data_o|output|logic [ RegWidth-1:0]|||
|rd_addr_i|input|logic [AddrWidth-1:0]|||
|rd_fmt_i|input|logic [ 1:0]|||
|rd_data_i|input|logic [ RegWidth-1:0]|||
|rd_en_i|input|logic|||
