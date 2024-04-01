# io_pad (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./io_pad_top.svg">

## Description

The `io_pad` module is a SystemVerilog module that implements an I/O pad. The module uses a
pull-down buffer, a data drive buffer, and a read data buffer to control the I/O pad.

<img src="./io_pad_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|pull_i|input|wire||pull-down control signal|
|wdata_i|input|wire||write data signal|
|wen_i|input|wire||write enable signal|
|rdata_o|output|wire||read data signal|
|pin_io|inout|wire||I/O pad pin|
