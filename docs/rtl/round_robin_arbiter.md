# round_robin_arbiter (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./round_robin_arbiter_top.svg">

## Description


## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_REQ|int||4||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||Global clock|
|arst_ni|input|logic||Asynchronous resent|
|allow_req_i|input|logic||Allow requests|
|req_i|input|logic [NUM_REQ-1:0]||Allow requests|
|gnt_addr_o|output|logic [$clog2(NUM_REQ)-1:0]||Grant Address|
|gnt_addr_valid_o|output|logic||Grant Valid|
