# AXI4 Lite Verification IP

## Package Contents
[`axi4l_seq_item`](#axi4l_seq_item)<br>
[`axi4l_resp_item`](#axi4l_resp_item)<br>
[`axi4l_driver`](#axi4l_driver)<br>
[`axi4l_monitor`](#axi4l_monitor)<br>

## Dependencies
[`Type Definitions for AXI4 Lite`](../../../include/axi4l_typedef.svh)
<br>
[`AXI4 Lite Interface`](../../../intf/axi4l_if.sv)

## axi4l_seq_item
Sequence Item for the driver class
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus

|Signal                      |Description
|-                           |-
|`bit [0:0]            _type`|Transaction Type. `0` mean Read & `1` means Write Transaction
|`bit [ADDR_WIDTH-1:0] _addr`|Transaction Address (`AXADDR`)
|`bit [2:0]            _prot`|Transaction Access Persmissions (`AXPROT`)
|`bit [$:127][7:0]     _data`|Transaction Data. Remains unused for read transaction
|`bit [$:127][0:0]     _strb`|Transaction Data Strobe. Remains unused for read transaction

<table>
<tr>
<th>Method</th>
<th>Description</th>
</tr>

<tr>
<td>

```SV
function new();
```
</td>
<td>

Class constructor
</td>
</tr>

<tr>
<td>

```SV
function bit randomize();
```
</td>
<td>

Randomizes the previously mentioned signals. Returns `1` for successful randomization, otherwise returns `0`
</td>
</tr>

<tr>
<td>

```SV
function string to_string();
```
</td>
<td>

Returns a string of the packet in user friendly manner
</td>
</tr>

</table>

## axi4l_resp_item
Response Item for the scoreboard
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus

|Signal                          |Description
|-                               |-
|`bit [0:0]            _type    `|Transaction Type. `0` mean Read & `1` means Write Transaction
|`bit [ADDR_WIDTH-1:0] _addr    `|Transaction Address (`AXADDR`)
|`bit [2:0]            _prot    `|Transaction Access Persmissions (`AXPROT`)
|`bit [7:0][$:127]     _data    `|Transaction Data
|`bit [0:0][$:127]     _strb    `|Transaction Data Strobe
|`bit [1:0]            _resp    `|Transaction Response
|`realtime             _ax_clk  `|Time of address handshake
|`realtime             _x_clk   `|Time of data handshake
|`realtime             _resp_clk`|Time of final respose handshake
|`bit [1:0]            _notes   `|Transactions notes. Optional string filed for scoreboarding

<table>
<tr>
<th>Method</th>
<th>Description</th>
</tr>

<tr>
<td>

```SV
function string to_string();
```
</td>
<td>

Returns a string of the packet in user friendly manner
</td>
</tr>

</table>

## axi4l_driver
Driver class for AXI4. In manager role, drives the provided AXI4 Lite interface according to the provided sequence item. In subordinate role, reacts to the priveded AXI4 Lite interface
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus
|`ROLE      `|Role of the driver. `0` means subordinate & `1` means manager

|Variable        |Type |Description
|-               |-    |-
|`failure_odds  `|int  |Chances of intensional failure in 100 transaction
|`aw_delay_min  `|int  |Minimum delay in AW channel
|`w_delay_min   `|int  |Minimum delay in W channel
|`b_delay_min   `|int  |Minimum delay in B channel
|`ar_delay_min  `|int  |Minimum delay in AR channel
|`r_delay_min   `|int  |Minimum delay in R channel
|`aw_delay_max  `|int  |Maximum delay in AW channel
|`w_delay_max   `|int  |Maximum delay in W channel
|`b_delay_max   `|int  |Maximum delay in B channel
|`ar_delay_max  `|int  |Maximum delay in AR channel
|`r_delay_max   `|int  |Maximum delay in R channel
|`secure_mem    `|class|[byte_memory](../../../include/vip/memory_pkg.sv) class for axi secured memory
|`non_secure_mem`|class|[byte_memory](../../../include/vip/memory_pkg.sv) class for axi non-secured memory

<table>
<tr>
<th>Method</th>
<th>Description</th>
</tr>

<tr>
<td>

```SV
function new(
    virtual axi4l_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) intf
);
```
</td>
<td>

Class constructor. Requires an AXI4 Lite interface
</td>
</tr>

<tr>
<td>

```SV
task automatic reset();
```
</td>
<td>

Cancel out all ongoing transactions. Returns the driver to the initial state
</td>
</tr>

<tr>
<td>

```SV
task automatic stop();
```
</td>
<td>

Applies reset and also stop the driver form operating further
</td>
</tr>

<tr>
<td>

```SV
task automatic start();
```
</td>
<td>

Initiates the driver for transactions
</td>
</tr>

</table>

## axi4l_monitor
Monitor Class for AXI4. Generates Response Item for the scoreboard by obeserving the provided AXI4 Lite interface
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus

<table>
<tr>
<th>Method</th>
<th>Description</th>
</tr>

<tr>
<td>

```SV
function new(
    virtual axi4l_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) intf
);
```
</td>
<td>

Class constructor. Requires an AXI4 Lite interface
</td>
</tr>

<tr>
<td>

```SV
task automatic wait_cooldown(input int n = 10);
```
</td>
<td>

Wait additional `n` clock cycles after all ongoing transactions seem to get over
</td>
</tr>

<tr>
<td>

```SV
task automatic reset();
```
</td>
<td>

Cancel out all ongoing transactions. Returns the monitor to the initial state
</td>
</tr>

<tr>
<td>

```SV
task automatic stop();
```
</td>
<td>

Applies reset and also stop the monitor form operating further
</td>
</tr>

<tr>
<td>

```SV
task automatic start();
```
</td>
<td>

Initiates the monitor for recording transactions
</td>
</tr>

</table>
