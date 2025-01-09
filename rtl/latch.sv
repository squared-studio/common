/*
The `latch` module is a parameterized SystemVerilog module that implements a latch. The module uses
a sequential block to control the state of the latch.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module latch #(
    parameter int DATA_WIDTH = 8  // width of the data
) (
    input logic arst_ni,  // asynchronous active low reset signal
    input logic en_i,     // latch enable signal

    input logic [DATA_WIDTH-1:0] d_i,  // latch data input

    output logic [DATA_WIDTH-1:0] q_o  // latch data output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This block updates `q_o` when `en_i`, `d_i`, or `arst_ni` changes. If `arst_ni` is `0`, `q_o`
  // is reset to `0`. Otherwise, if `en_i` is `1`, `q_o` is updated with `d_i`.
  always @(en_i or d_i or arst_ni) begin
    if (~arst_ni) q_o = '0;
    else if (en_i) q_o = d_i;
  end

endmodule
