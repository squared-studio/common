# axi4l_gpio (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./axi4l_gpio_top.svg">

## Description
 Description

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|axi4l_req_t|type||default_param_pkg::axi4l_req_t||
|axi4l_resp_t|type||default_param_pkg::axi4l_resp_t||
|PORT_SIZE|int||5||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|req_i|input|axi4l_req_t|||
|resp_o|output|axi4l_resp_t|||
|port_io|inout|wire [PortBytes-1:0][7:0]|||
