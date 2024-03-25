# axi_fifo (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./axi_fifo_top.svg">

## Description

The `axi_fifo` module is a parameterized module that creates FIFOs (First-In-First-Out) for AXI
(Advanced eXtensible Interface) transactions. It is designed to handle different types of AXI
transactions, including AW (Address Write), W (Write), B (Write Response), AR (Address Read), and
R (Read) channels.

**AW FIFO (`u_fifo_aw`)**: This FIFO handles the AW (Address Write) channel. It takes in AW
requests from `req_i.aw` and sends them out to `req_o.aw`. The validity of the input and output
requests are controlled by `req_i.aw_valid` and `req_o.aw_valid`, respectively. The readiness of
the output and input requests are controlled by `resp_o.aw_ready` and `resp_i.aw_ready`,
respectively.

**W FIFO (`u_fifo_w`)**: This FIFO handles the W (Write) channel. It operates similarly to the AW
FIFO, but for the W requests.

**B FIFO (`u_fifo_b`)**: This FIFO handles the B (Write Response) channel. It takes in B responses
from `resp_i.b` and sends them out to `resp_o.b`. The validity of the input and output responses
are controlled by `resp_i.b_valid` and `resp_o.b_valid`, respectively. The readiness of the output
and input responses are controlled by `req_o.b_ready` and `req_i.b_ready`, respectively.

**AR FIFO (`u_fifo_ar`)**: This FIFO handles the AR (Address Read) channel. It operates similarly
to the AW FIFO, but for the AR requests.

**R FIFO (`u_fifo_r`)**: This FIFO handles the R (Read) channel. It operates similarly to the B
FIFO, but for the R responses.

Each FIFO is created using the `fifo` module, which is a generic FIFO module. The depth and element
width of each FIFO are parameterized. The depth of each FIFO is set by the parameters
`AW_FIFO_DEPTH`, `W_FIFO_DEPTH`, `B_FIFO_DEPTH`, `AR_FIFO_DEPTH`, and `R_FIFO_DEPTH`. The element
width of each FIFO is determined by the bit width of the corresponding request or response.

The `axi_fifo` module operates synchronously with the clock signal `clk_i` and can be reset by the
active low reset signal `arst_ni`.

<img src="./axi_fifo_des.svg">

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|axi_req_t|type||default_param_pkg::axi4l_req_t| type of the AXI request. The default type is `axi4l_req_t` from the `default_param_pkg`|
|axi_resp_t|type||default_param_pkg::axi4l_resp_t| type of the AXI response. The default type is `axi4l_resp_t` from the `default_param_pkg`|
|AW_FIFO_DEPTH|int||4| depth of the Address Write (AW) FIFO. The default value is 4|
|W_FIFO_DEPTH|int||4| depth of the Address Write (AW) FIFO. The default value is 4|
|B_FIFO_DEPTH|int||4| depth of the Write Response (B) FIFO. The default value is 4|
|AR_FIFO_DEPTH|int||4| depth of the Address Read (AR) FIFO. The default value is 4|
|R_FIFO_DEPTH|int||4| depth of the Address Read (AR) FIFO. The default value is 4|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|| clock input|
|arst_ni|input|logic|| asynchronous reset input|
|req_i|input|axi_req_t|| AXI request input|
|resp_o|output|axi_resp_t|| AXI response output|
|req_o|output|axi_req_t|| AXI request output|
|resp_i|input|axi_resp_t|| AXI response input|
