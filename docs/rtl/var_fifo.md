# var_fifo (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./var_fifo_top.svg">

## Description


## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ELEM_WIDTH|int||8||
|NUM_ELEM|int||128||
|FIFO_DEPTH|int||2 * NUM_ELEM||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|data_in_num_lanes_i|input|logic [$clog2(NUM_ELEM+1)-1:0]|||
|data_in_start_lane_i|input|logic [ $clog2(NUM_ELEM)-1:0]|||
|data_in_req_valid_o|output|logic|||
|data_in_i|input|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]|||
|data_in_valid_i|input|logic|||
|data_in_ready_o|output|logic|||
|data_out_num_lanes_i|input|logic [$clog2(NUM_ELEM+1)-1:0]|||
|data_out_start_lane_i|input|logic [ $clog2(NUM_ELEM)-1:0]|||
|data_out_req_valid_o|output|logic|||
|data_out_o|output|logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]|||
|data_out_valid_o|output|logic|||
|data_out_ready_i|input|logic|||
|space_available_o|output|logic [$clog2(FIFO_DEPTH+1)-1:0]|||
|elem_available_o|output|logic [$clog2(FIFO_DEPTH+1)-1:0]|||
