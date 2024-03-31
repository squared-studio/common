# circular_xbar (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./circular_xbar_top.svg">

## Description

The `circular_xbar` module is a parameterized SystemVerilog module that implements a circular
crossbar switch. The module uses a multiplexer to select the appropriate output based on the
rotation base select.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8|The width of each crossbar element|
|NUM_ELEM|int||6|The number of elements in the crossbar|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|s_i|input|logic [$clog2(NUM_ELEM)-1:0]|| The rotation base select. It is a logic vector of size `[$clog2(NUM_ELEM)-1:0]`|
|i_i|input|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]|| The array of input buses. It is a 2D logic array of size `[NUM_ELEM-1:0][ELEM_WIDTH-1:0]`|
|o_o|output|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]|| The array of output buses. It is a 2D logic array of size `[NUM_ELEM-1:0][ELEM_WIDTH-1:0]`|
