/*
The `jk_ff` module is a SystemVerilog module that implements a JK flip-flop. The module uses a
flip-flop to store the state of the JK flip-flop and a case statement to update the state based on
the inputs.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module jk_ff (
    input logic clk_i,   // global clock signal
    input logic arst_ni, // asynchronous active low reset signal

    input logic j_i,  // J input to the JK flip-flop
    input logic k_i,  // K input to the JK flip-flop

    output logic q_o,  // Q output of the JK flip-flop
    output logic q_no  // negated Q output of the JK flip-flop
);

  // inverse of `q_o`.
  assign q_no = ~q_o;

  // This block updates `q_o` at the positive edge of `clk_i` or the negative edge of `arst_ni`. If
  // `arst_ni` is `0`, `q_o` is reset to `0`. Otherwise, `q_o` is updated based on the values of
  // `j_i` and `k_i`.
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= 0;
    end else begin
      case ({
        j_i, k_i
      })
        2'b01:   q_o <= '0;
        2'b10:   q_o <= '1;
        2'b11:   q_o <= q_no;
        default: q_o <= q_o;
      endcase
    end
  end

endmodule
