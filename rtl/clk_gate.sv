/*
The `clk_gate` module is a clock gating module that enables or disables the input clock (`clk_i`)
based on the enable input (`en_i`). The gated clock is output on `clk_o`.
The module uses either a dual synchronizer or a latch to sample the enable signal (`en_i`). The
sampled enable signal is then used to gate the clock (`clk_i`). If `sampled_en_i` is high, the clock
is enabled and `clk_o` is equal to `clk_i`. If `sampled_en_i` is low, the clock is disabled and
`clk_o` is low.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module clk_gate #(
    // A parameter that determines whether to use a dual synchronizer or a latch for sampling the
    // enable signal. If `USE_DUAL_SYNC` is 1, a dual synchronizer is used
    parameter bit USE_DUAL_SYNC = 1
) (
    // Asynchronous active low reset input
    input logic arst_ni,
    // Enable input. When high, the clock is enabled. When low, the clock is disabled
    input logic en_i,

    // Clock input
    input logic clk_i,

    // Output clock. This is the gated clock based on `en_i`
    output logic clk_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // sampled enable signal. This is either the output of the dual synchronizer or the latch,
  // depending on the value of `USE_DUAL_SYNC`.
  logic sampled_en_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign clk_o = clk_i & sampled_en_i;

  if (USE_DUAL_SYNC) begin : g_dual_sync
    dual_flop_synchronizer #(
        .FIRST_FF_EDGE_POSEDGED(1),
        .LAST_FF_EDGE_POSEDGED (0)
    ) u_dual_flop_synchronizer (
        .clk_i  (clk_i),
        .arst_ni(arst_ni),
        .en_i   ('1),
        .d_i    (en_i),
        .q_o    (sampled_en_i)
    );
  end else begin : g_latch
    latch #(
        .DATA_WIDTH(1)
    ) _latch (
        .arst_ni(arst_ni),
        .en_i(~clk),
        .d_i(en_i),
        .q_o(sampled_en_i)
    );
  end

endmodule
