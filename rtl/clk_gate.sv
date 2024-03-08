// Clock gate
// ### Author : Foez Ahmed (foez.official@gmail.com)

module clk_gate #(
    parameter bit USE_DUAL_SYNC = 1
) (
    input  logic arst_ni,
    input  logic clk_i,
    input  logic en_i,
    output logic clk_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic sampled_en_i;
  assign clk_o = clk_i & sampled_en_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (USE_DUAL_SYNC) begin : g_dual_sync
    dual_synchronizer #(
        .FIRST_FF_EDGE_POSEDGED(1),
        .LAST_FF_EDGE_POSEDGED (0)
    ) u_dual_synchronizer (
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
