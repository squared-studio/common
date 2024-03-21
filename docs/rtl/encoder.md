# encoder (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./encoder_top.svg">

## Description
 General purpose Encoder

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_WIRE|int||16|Number of output wires|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|d_i|input|logic [NUM_WIRE-1:0]||Wire input|
|addr_o|output|logic [$clog2(NUM_WIRE)-1:0]||Address output|
|addr_valid_o|output|logic||Address Valid output|
