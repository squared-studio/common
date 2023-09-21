# AXI4 Lite Verification IP

## Package Contents
[axi4l_seq_item](#axi4l_seq_item)<br>
[axi4l_resp_item](#axi4l_resp_item)<br>
[axi4l_mem](#axi4l_mem)<br>
[axi4l_driver](#axi4l_driver)<br>
[axi4l_monitor](#axi4l_monitor)<br>

## Dependencies
[`Type Definitions for AXI4 Lite`](../../../include/axi4l/typedef.svh)
<br>
[`AXI4 Lite Interface`](../../../intf/axi4l_if.sv)

## axi4l_seq_item
Sequence Item for the driver class
|Parameter |Description
|-         |-
|ADDR_WIDTH|Width of the AW/AR address bus
|DATA_WIDTH|Width of the W/R data bus

## axi4l_resp_item
Response Item for the scoreboard
|Parameter |Description
|-         |-
|ADDR_WIDTH|Width of the AW/AR address bus
|DATA_WIDTH|Width of the W/R data bus

## axi4l_mem
Linkable subordinate memory

## axi4l_driver
Driver class for AXI4
Response Item for the scoreboard
|Parameter |Description
|-         |-
|ADDR_WIDTH|Width of the AW/AR address bus
|DATA_WIDTH|Width of the W/R data bus
|ROLE      |Role of the driver

|Veriable    |Description
|-           |-
|failure_odds|Chances of intensional failure in 100 transaction
|aw_delay_min|Minimum delay in AW channel
|w_delay_min |Minimum delay in W channel
|b_delay_min |Minimum delay in B channel
|ar_delay_min|Minimum delay in AR channel
|r_delay_min |Minimum delay in R channel
|aw_delay_max|Maximum delay in AW channel
|w_delay_max |Maximum delay in W channel
|b_delay_max |Maximum delay in B channel
|ar_delay_max|Maximum delay in AR channel
|r_delay_max |Maximum delay in R channel

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
|Parameter |Description
|-         |-
|ADDR_WIDTH|Width of the AW/AR address bus
|DATA_WIDTH|Width of the W/R data bus

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
