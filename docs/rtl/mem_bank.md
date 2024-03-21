# mem_bank (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./mem_bank_top.svg">

## Description
 Memory bank with byte size storage. **All requests must be aligned**

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|ADDR_WIDTH|int||8|Memory bank address width|
|DATA_SIZE|int||2|log2(bytes_in_databus)|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||Global clock|
|cs_i|input|logic||Asynchronous reset|
|addr_i|input|logic [ ADDR_WIDTH-1:0]||Aligned byte address|
|wdata_i|input|logic [(8*(2**DATA_SIZE))-1:0]||Aligned write data|
|wstrb_i|input|logic [ (2**DATA_SIZE)-1:0]||Aligned write strobe|
|rdata_o|output|logic [(8*(2**DATA_SIZE))-1:0]||Aligned read data|
