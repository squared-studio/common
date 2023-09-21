# AXI4 Lite Verification IP

## Package Contents
[`axi4l_seq_item`](#axi4l_seq_item)<br>
[`axi4l_resp_item`](#axi4l_resp_item)<br>
[`axi4l_mem`](#axi4l_mem)<br>
[`axi4l_driver`](#axi4l_driver)<br>
[`axi4l_monitor`](#axi4l_monitor)<br>

## Dependencies
[`Type Definitions for AXI4 Lite`](../../../include/axi4l/typedef.svh)
<br>
[`AXI4 Lite Interface`](../../../intf/axi4l_if.sv)

## axi4l_seq_item
Sequence Item for the driver class
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus

|Signal |Type                  |Description
|-      |-                     |-
|`_type`|`bit [0:0]           `|Transaction Type
|`_addr`|`bit [ADDR_WIDTH-1:0]`|Transaction Address
|`_prot`|`bit [2:0]           `|Transaction Access Persmissions
|`_data`|`bit [$:127][7:0]    `|Transaction Data. Remains unused for read transaction
|`_strb`|`bit [$:127][0:0]    `|Transaction Strobes. Remains unused for read transaction

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

</table>

## axi4l_resp_item
Response Item for the scoreboard
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus

|Signal     |Type                  |Description
|-          |-                     |-
|`_type    `|`bit [0:0]           `|Transaction Type
|`_addr    `|`bit [ADDR_WIDTH-1:0]`|Transaction Address
|`_prot    `|`bit [2:0]           `|Transaction Access Persmissions
|`_data    `|`bit [$:127][7:0]    `|Transaction Data
|`_strb    `|`bit [$:127][0:0]    `|Transaction Strobes
|`_resp    `|`bit [1:0]           `|Transaction Response
|`_ax_clk  `|`realtime            `|Time of address handshake
|`_x_clk   `|`realtime            `|Time of data handshake
|`_resp_clk`|`realtime            `|Time of final respose handshake
|`_notes   `|`bit [1:0]           `|Transactions notes

## axi4l_mem
Linkable subordinate memory. This is an internally used class. The handle of this class form multiple drivers can point to exact same memory allowing multiple drivers use the exact same shared memory. For example:
```SV
axi4l_driver #(
  .ADDR_WIDTH(32),
  .ADDR_WIDTH(32),
  .ROLE(0)
) dvr_1 = new();

axi4l_driver #(
  .ADDR_WIDTH(64),
  .ADDR_WIDTH(64),
  .ROLE(0)
) dvr_2 = new();

initial begin
  // at some point, preferably at time 0
  dvr_1.mem_inst = dvr_2.mem_inst; // Two drivers share same memory even though different widths and address range
end
```

## axi4l_driver
Driver class for AXI4
Response Item for the scoreboard
|Parameter   |Description
|-           |-
|`ADDR_WIDTH`|Width of the AW/AR address bus
|`DATA_WIDTH`|Width of the W/R data bus
|`ROLE      `|Role of the driver

|Veriable      |Description
|-             |-
|`failure_odds`|Chances of intensional failure in 100 transaction
|`aw_delay_min`|Minimum delay in AW channel
|`w_delay_min `|Minimum delay in W channel
|`b_delay_min `|Minimum delay in B channel
|`ar_delay_min`|Minimum delay in AR channel
|`r_delay_min `|Minimum delay in R channel
|`aw_delay_max`|Maximum delay in AW channel
|`w_delay_max `|Maximum delay in W channel
|`b_delay_max `|Maximum delay in B channel
|`ar_delay_max`|Maximum delay in AR channel
|`r_delay_max `|Maximum delay in R channel

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
Monitor Class for AXI4
Response Item for the scoreboard
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
