# handshake_counter (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./handshake_counter_top.svg">

## Description

The `handshake_counter` module is a parameterized SystemVerilog module that implements a handshake
counter. The module uses a flip-flop to count the number of handshakes.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DEPTH|int||4|The depth of the counter|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||The global clock signal|
|arst_ni|input|logic||The asynchronous reset signal|
|in_valid_i|input|logic||The input valid signal|
|in_ready_o|output|logic||The input ready signal|
|out_valid_o|output|logic||The output valid signal|
|out_ready_i|input|logic||The output ready signal|
|cnt_o|output|logic [$clog2(DEPTH+1)-1:0]||The counter output|
