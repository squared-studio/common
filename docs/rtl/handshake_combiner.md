# handshake_combiner (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./handshake_combiner_top.svg">

## Description
 Description

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|NUM_TX|int||2||
|NUM_RX|int||2||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|tx_valid|input|logic [NUM_TX-1:0]|||
|tx_ready|output|logic [NUM_TX-1:0]|||
|rx_valid|output|logic [NUM_RX-1:0]|||
|rx_ready|input|logic [NUM_RX-1:0]|||
