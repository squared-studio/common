/*
The `dual_flop_synchronizer` module is a parameterized SystemVerilog module that implements a dual
flip-flop synchronizer. The module uses two flip-flops to synchronize the input data signal to the
output.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module dual_flop_synchronizer #(
    // A bit that determines whether the first flip-flop runs on positive edges
    parameter bit FIRST_FF_EDGE_POSEDGED = 0,
    // A bit that determines whether the last flip-flop runs on positive edges
    parameter bit LAST_FF_EDGE_POSEDGED  = 0
) (
    input logic arst_ni,  // asynchronous active low reset signal
    input logic clk_i,    // global clock signal

    input logic en_i,  // enable signal

    input logic d_i,  // data input signal

    output logic q_o  // output signal
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic dff0_clk_in;  // clock input for the first flip-flop
  logic dff1_clk_in;  // clock input for the second flip-flop
  logic en_intermediate;  // intermediate enable signal
  logic q_intermediate;  // intermediate output signal

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign dff0_clk_in = FIRST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;
  assign dff1_clk_in = LAST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // first sequential block updates `en_intermediate` and `q_intermediate` at the positive edge
  // of `dff0_clk_in` or the negative edge of `arst_ni`.
  always @(posedge dff0_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      en_intermediate <= '0;
      q_intermediate  <= '0;
    end else begin
      en_intermediate <= en_i;
      q_intermediate  <= d_i;
    end
  end

  // second sequential block updates `q_o` at the positive edge of `dff1_clk_in` or the negative
  // edge of `arst_ni`.
  always @(posedge dff1_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= '0;
    end else begin
      if (en_intermediate) q_o <= q_intermediate;
    end
  end

endmodule
