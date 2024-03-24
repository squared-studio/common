# edge_detector (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./edge_detector_top.svg">

## Description
 Edge Detector Module Sync

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|POSEDGE|bit||1|detect positive edge|
|NEGEDGE|bit||1|detect negative edge|
|ASYNC|bit||0| detect positive edge detect negative edge|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||Asynchronous reset|
|clk_i|input|logic||Global clock|
|d_i|input|logic||Data in|
|posedge_o|output|logic||posedge detected|
|negedge_o|output|logic||negedge detected|
