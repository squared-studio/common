# jk_ff (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./jk_ff_top.svg">

## Description

The `jk_ff` module is a SystemVerilog module that implements a JK flip-flop. The module uses a
flip-flop to store the state of the JK flip-flop and a case statement to update the state based on
the inputs.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||The global clock signal|
|arst_ni|input|logic||The asynchronous reset signal|
|j_i|input|logic||The J input to the JK flip-flop|
|k_i|input|logic||The global clock signal|
|q_o|output|logic||The Q output of the JK flip-flop|
|q_no|output|logic||The negated Q output of the JK flip-flop|
