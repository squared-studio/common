# axi4l_gpio (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./axi4l_gpio_top.svg">

## Description

The `axi4l_gpio` module is a General-Purpose Input/Output (GPIO) module that allows individual pins
to be programmed as either an input or an output. Each pin operates off of 4 different registers:

1. `rdata`: A read-only register for reading the actual value on the pin.
2. `wdata`: A read-write register for output or pull of the pin.
3. `wen`: Used to strongly drive the pin with `wdata`.
4. `pull`: Used to weakly drive the pin with `wdata`.

The `port_io` is a byte array, meaning each port is byte addressable. The number of bytes in the
port is defined by the parameter `PORT_SIZE`, so the port will have `2^PORT_SIZE` bytes.

The base address of each type of register is defined as follows:

```verilog
BlockSize = ((AXI_DATA_WIDTH/8) > (2**PORT_SIZE)) ?
                (AXI_DATA_WIDTH/8) :
                (2**PORT_SIZE) ;

RdataBase = BlockSize * 0;
WdataBase = BlockSize * 1;
WenBase   = BlockSize * 2;
PullBase  = BlockSize * 3;
```
The module uses an AXI FIFO to handle the AXI4L requests and responses. It also uses a demultiplexer
(`demux`) to handle the write strobe rows (`wr_strb_row`). For each row in the `RowPerType`, it uses
a register to handle the `wdata`, `wen`, and `pull` values. Finally, it uses an IO pad for each wire
in the byte in the `RowPerType` and a multiplexer (`mux`) to handle the response data.

<img src="./axi4l_gpio_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|axi4l_req_t|type||default_param_pkg::axi4l_req_t| type of AXI4L request|
|axi4l_resp_t|type||default_param_pkg::axi4l_resp_t| type of AXI4L response|
|PORT_SIZE|int||5| size of the port in bytes|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic||input clock signal|
|arst_ni|input|logic||asynchronous active low reset signal|
|req_i|input|axi4l_req_t||AXI4L request input|
|resp_o|output|axi4l_resp_t||AXI4L response output|
|port_io|inout|wire [PortBytes-1:0][7:0]||inout port array|
