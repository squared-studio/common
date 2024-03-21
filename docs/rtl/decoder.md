# decoder (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./decoder_top.svg">

## Description
 General purpose decoder module

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_WIRE|int||4|Number of output wires|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|a_i|input|logic [$clog2(NUM_WIRE)-1:0]||Address input|
|a_valid_i|input|logic||Address Valid input|
|d_o|output|logic [ NUM_WIRE-1:0]||data output|
