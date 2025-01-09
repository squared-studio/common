/*
The `register_dual_flop` module is a dual flip-flop register with configurable element width, reset
value, and clock edge polarity for both flip-flops.
Author: Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module register_dual_flop #(
    // width of each element
    parameter int                  ELEM_WIDTH             = 32,
    // reset value for each element
    parameter bit [ELEM_WIDTH-1:0] RESET_VALUE            = '0,
    // A bit to set the clock edge polarity of the first flip-flop
    parameter bit                  FIRST_FF_EDGE_POSEDGED = 1,
    // A bit to set the clock edge polarity of the last flip-flop
    parameter bit                  LAST_FF_EDGE_POSEDGED  = 0
) (
    input logic clk_i,   // clock input
    input logic arst_ni, // asynchronous active low reset input

    input logic en_i,  // enable input
    input logic [ELEM_WIDTH-1:0] d_i,  // data input

    output logic [ELEM_WIDTH-1:0] q_o  // data output
);

  logic [ELEM_WIDTH-1:0] q_intermediate;  // An intermediate logic array
  logic en_intermediate;  // An intermediate enable signal

  logic first_clk_in;  // clock input for the first flip-flop
  logic last_clk_in;  // clock input for the last flip-flop

  assign first_clk_in = FIRST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;
  assign last_clk_in  = LAST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;

  always_ff @(posedge first_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_intermediate  <= RESET_VALUE;
      en_intermediate <= '0;
    end else begin
      q_intermediate  <= d_i;
      en_intermediate <= en_i;
    end
  end

  always_ff @(posedge last_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= RESET_VALUE;
    end else begin
      if (en_intermediate) q_o <= q_intermediate;
    end
  end

endmodule
