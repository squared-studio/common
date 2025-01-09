/*
The `dff` module is a D flip-flop with asynchronous active low reset
digital circuit design, commonly used for data storage and transfer.

The flip-flop samples the `d_i` input and updates the `q_o` output at the rising edge of the clock
`clk_i` if `en_i` is high. If `arst_ni` is low, the flip-flop resets the `q_o` output to
`RESET_VALUE` regardless of the clock or enable inputs.

Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module dff #(
  //The value that the flip-flop resets to when `arst_ni` is low
  parameter bit RESET_VALUE = '0
) (
  // This is the asynchronous active low reset input. When this input is low, the flip-flop resets to
  // `RESET_VALUE`
  input logic arst_ni,
  // This is the clock input. The flip-flop samples the `d_i` input at the rising edge of this clock
  input logic clk_i,

  // This is the enable input. When this input is high, the flip-flop samples the `d_i` input at the
  // next clock rising edge
  input logic en_i,
  // This is the data input. The value of this input is transferred to the output `q_o` at the
  // rising edge of the clock `clk_i` if `en_i` is high
  input logic d_i,

  // This is the data output. It holds the last value sampled from `d_i` at the rising edge of the
  // clock `clk_i` when `en_i` was high, or the `RESET_VALUE` if `arst_ni` was low
  output logic q_o
);

always_ff @(posedge clk_i or negedge arst_ni) begin
  if (~arst_ni) begin
    q_o <= RESET_VALUE;
  end else if (en_i) begin
    q_o <= d_i;
  end
end

endmodule
