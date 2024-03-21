// Edge Detector Module Sync
// ### Author : Foez Ahmed (foez.official@gmail.com)

module edge_detector #(
    parameter bit POSEDGE = 1,  // detect positive edge
    parameter bit NEGEDGE = 1,  // detect negative edge
    parameter bit ASYNC   = 0
) (
    input logic arst_ni,  // Asynchronous reset
    input logic clk_i,    // Global clock

    input logic d_i,  // Data in

    output logic posedge_o,  // posedge detected
    output logic negedge_o   // negedge detected
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic q_intermediate;
  logic q_final;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (POSEDGE) begin : g_posedge
    assign posedge_o = ~q_final & q_intermediate;
  end else begin : g_no_posedge
    assign posedge_o = '0;
  end

  if (NEGEDGE) begin : g_negedge
    assign negedge_o = q_final & ~q_intermediate;
  end else begin : g_no_negedge
    assign negedge_o = '0;
  end

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (ASYNC) begin : g_dual_sync
    dual_synchronizer #(
        .FIRST_FF_EDGE_POSEDGED(1),
        .LAST_FF_EDGE_POSEDGED (1)
    ) u_dual_synchronizer (
        .arst_ni(arst_ni),
        .clk_i(clk_i),
        .en_i(1),
        .d_i(d_i),
        .q_o(q_intermediate)
    );
  end else begin : g_dff
    dff #() u_single_synchronizer (
        .arst_ni(arst_ni),
        .clk_i(clk_i),
        .en_i(1),
        .d_i(d_i),
        .q_o(q_intermediate)
    );
  end

  dff #() u_dff (
      .arst_ni(arst_ni),
      .clk_i(clk_i),
      .en_i(1),
      .d_i(q_intermediate),
      .q_o(q_final)
  );

  //}}}

endmodule
