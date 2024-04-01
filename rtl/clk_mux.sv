/*
The `clk_mux` module is a glitch free clock multiplexer that selects between two input clocks
(`clk0_i` and `clk1_i`) based on the select input (`sel_i`). The selected clock is output on `clk_o`
The module uses dual flip-flop back-to-back synchronizers (`dual_flop_synchronizer`) for each input
clock. The synchronizers are used to mitigate metastability issues when switching between the
clocks. The select input (`sel_i`) determines which clock is selected. The selected clock is then
output on `clk_o`.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module clk_mux #(
) (
    input logic arst_ni,  // asynchronous active low reset input. Active low

    // Select input. When high, `clk1_i` is selected. When low, `clk0_i` is selected
    input logic sel_i,

    input logic clk0_i,  // Clock 0 input
    input logic clk1_i,  // Clock 1 input

    output logic clk_o  //Output clock. This is the selected clock based on `sel_i`
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic clk0_ffb2b_in;  // Inputs to the dual flip-flop back-to-back synchronizers for `clk0_i`
  logic clk1_ffb2b_in;  // Inputs to the dual flip-flop back-to-back synchronizers for `clk1_i`

  logic clk0_ffb2b_out;  // Outputs from the dual flip-flop back-to-back synchronizers for `clk0_i`
  logic clk1_ffb2b_out;  // Outputs from the dual flip-flop back-to-back synchronizers for `clk1_i`

  logic clk0_and;  // Intermediate signals used in the logic to generate `clk_o`
  logic clk1_and;  // Intermediate signals used in the logic to generate `clk_o`

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign clk0_ffb2b_in = ~(sel_i | clk1_ffb2b_out);
  assign clk1_ffb2b_in = ~(~sel_i | clk0_ffb2b_out);

  assign clk0_and = clk0_ffb2b_out & clk0_i;
  assign clk1_and = clk1_ffb2b_out & clk1_i;

  assign clk_o = clk0_and | clk1_and;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  dual_flop_synchronizer #(
      .FIRST_FF_EDGE_POSEDGED(1),
      .LAST_FF_EDGE_POSEDGED (0)
  ) clk0_ffb2b (
      .clk_i  (clk0_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (clk0_ffb2b_in),
      .q_o    (clk0_ffb2b_out)
  );

  dual_flop_synchronizer #(
      .FIRST_FF_EDGE_POSEDGED(1),
      .LAST_FF_EDGE_POSEDGED (0)
  ) clk1_ffb2b (
      .clk_i  (clk1_i),
      .arst_ni(arst_ni),
      .en_i   ('1),
      .d_i    (clk1_ffb2b_in),
      .q_o    (clk1_ffb2b_out)
  );
endmodule
