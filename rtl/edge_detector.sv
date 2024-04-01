/*
The `edge_detector` module is a configurable edge detector that can detect positive and/or negative
edges.

The edge detector operates based on the `POSEDGE`, `NEGEDGE`, and `ASYNC` parameters. If `POSEDGE`
is set, the detector will output a signal when a positive edge is detected. If `NEGEDGE` is set, the
detector will output a signal when a negative edge is detected. The `ASYNC` parameter determines
whether to use a dual synchronizer or a single synchronizer for the edge detection process.

The edge detector uses a dual synchronizer when `ASYNC` is set, and a single synchronizer otherwise.
The synchronizer takes the data input and outputs an intermediate signal, which is then used to
detect the edges. The final signal after the edge detection process is stored in a flip-flop.

Author : Foez Ahmed (foez.official@gmail.com)
*/

module edge_detector #(
    parameter bit POSEDGE = 1,  // A bit that determines whether to detect positive edges
    parameter bit NEGEDGE = 1,  // A bit that determines whether to detect negative edges
    parameter bit ASYNC   = 0   // A bit that determines whether to use asynchronous mode
) (
    input logic arst_ni,  // asynchronous active low reset signal
    input logic clk_i,    // global clock signal

    input logic d_i,  // data input signal

    output logic posedge_o,  // positive edge detected signal
    output logic negedge_o   // negative edge detected signal
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic q_intermediate;
  logic q_final;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
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
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (ASYNC) begin : g_dual_sync
    dual_flop_synchronizer #(
        .FIRST_FF_EDGE_POSEDGED(1),
        .LAST_FF_EDGE_POSEDGED (1)
    ) u_dual_flop_synchronizer (
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
endmodule
