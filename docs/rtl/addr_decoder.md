# addr_decoder (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./addr_decoder_top.svg">

## Description

The `addr_decoder` module is a parameterized SystemVerilog module that decodes an input address to
select a slave device. The module uses a priority encoder and a multiplexer to select the
appropriate slave based on the input address.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ADDR_WIDTH|int||default_param_pkg::ADDR_DECODER_ADDR_WIDTH| The width of the address input|
|NUM_SLV|int||default_param_pkg::ADDR_DECODER_NUM_SLV| The number of slave devices|
|NUM_RULES|int||default_param_pkg::ADDR_DECODER_NUM_RULES| The number of address map rules|
|addr_map_t|type||default_param_pkg::addr_decoder_addr_map_t| The type of the address map|
|ADDR_MAP|addr_map_t|[NUM_RULES]|default_param_pkg::ADDR_MAP| The address map array|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|addr_i|input|logic [ADDR_WIDTH-1:0]|| The input address. It is a logic vector of size `[ADDR_WIDTH-1:0]`|
|slave_index_o|output|logic [$clog2(NUM_SLV)-1:0]|| The output slave index. It is a logic vector of size `[$clog2(NUM_SLV)-1:0]`|
|addr_found_o|output|logic|| A logic output that indicates if the address was found in the address map|
