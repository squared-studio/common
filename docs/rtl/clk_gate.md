## Overview
Clock gate is designed to generate the Reference clock for our chip. In this design, we maintain TSMC standard cell specification. In here, we use an And gate and a mux.
## clk_gate Design Architecture
<img src=../diagrams/clk_gate.svg>

### Signal Description

| Signal  |  Direction  | Width  | Description |
| --- | ----------- |----------- |----------- |
|cp_i     | input        | 1     |Input clock pulse|
|e_i |input| 1 |enable signal
|te_i |input |1 |Test enable who control the MUX 
|q_o |output |1 |Output signal|

