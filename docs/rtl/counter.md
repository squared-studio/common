# counter (module)

### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

## TOP IO
<img src="./counter_top.svg">

## Description
 A simple up down counter that counts up to MAX_COUNT

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|MAX_COUNT|int||25||
|RESET_VALUE|bit [$clog2(MAX_COUNT+1)-1:0]||'0||
|UP_COUNT|bit||1||
|DOWN_COUNT|bit||1||

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|clk_i|input|logic|||
|arst_ni|input|logic|||
|up_i|input|logic|||
|down_i|input|logic|||
|count_o|output|logic [$clog2(MAX_COUNT+1)-1:0]|||
