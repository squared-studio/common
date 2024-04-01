# fifo (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./fifo_top.svg">

## Description

The `fifo` module is a First-In-First-Out (FIFO) memory buffer with configurable parameters.

The FIFO operates based on the handshake signals `elem_in_valid_i`, `elem_in_ready_o`,
`elem_out_valid_o` & `elem_out_ready_i`. When the FIFO is not full, it is ready to accept an input
element. When the FIFO is not empty, it is ready to output an element. The FIFO can operate in
either pipelined mode or pass-through mode, depending on the `PIPELINED` parameter.

The FIFO uses registers to store the write and read pointers. It also uses a memory block to store
the elements. The size of the memory block is determined by the `FIFO_SIZE` parameter.

<img src="./fifo_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|PIPELINED|bit||1| A bit that determines whether the FIFO is pipelined|
|ELEM_WIDTH|int||8| The width of each element in the FIFO|
|FIFO_SIZE|int||4| The number of elements that can be stored in the FIFO|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|| input clock signal|
|arst_ni|input|logic|| asynchronous active low reset signal|
|elem_in_i|input|logic [ELEM_WIDTH-1:0]|| input element|
|elem_in_valid_i|input|logic|| input valid signal. It indicates whether the input element is valid|
|elem_in_ready_o|output|logic|| input ready signal. It indicates whether the FIFO is ready to accept an input element|
|elem_out_o|output|logic [ELEM_WIDTH-1:0]|| output element|
|elem_out_valid_o|output|logic|| output valid signal. It indicates whether the output element is valid|
|elem_out_ready_i|input|logic|| output ready signal. It indicates whether the FIFO is ready to output an element|
