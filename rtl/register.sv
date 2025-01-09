/*
The `register` module is a simple register with configurable element width and reset value.
Author: Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module register #(
    parameter int                  ELEM_WIDTH  = 32,  // width of each element
    parameter bit [ELEM_WIDTH-1:0] RESET_VALUE = '0   // reset value for each element
) (
    input logic clk_i,   // clock input
    input logic arst_ni, // asynchronous active low reset input

    input logic en_i,  // enable input
    input logic [ELEM_WIDTH-1:0] d_i,  // data input

    output logic [ELEM_WIDTH-1:0] q_o  // output
);

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= RESET_VALUE;
    end else if (en_i) begin
      q_o <= d_i;
    end
  end

endmodule
