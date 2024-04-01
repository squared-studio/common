/*
The `latch` module is a parameterized SystemVerilog module that implements a latch. The module uses
a sequential block to control the state of the latch.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module latch #(
    parameter int DATA_WIDTH = 8  // The width of the data
) (
    input logic arst_ni,  // The asynchronous reset signal
    input logic en_i,     // The latch enable signal

    input logic [DATA_WIDTH-1:0] d_i,  // The latch data input

    output logic [DATA_WIDTH-1:0] q_o  // The latch data output
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
