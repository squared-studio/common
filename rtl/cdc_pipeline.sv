// [CDC pipeline] (./diagrams/cdc_pipeline.drawio)
// ### Author : Foez Ahmed (foez.official@gmail.com)


module cdc_pipeline #(
    parameter int ELEM_WIDTH = 8  // Element width
) (
    input logic arst_ni,  // Asynchronous reset

    input  logic                  elem_in_clk_i,    // Input clock
    input  logic [ELEM_WIDTH-1:0] elem_in_i,        // Input element
    input  logic                  elem_in_valid_i,  // Input valid
    output logic                  elem_in_ready_o,  // Input ready

    input  logic                  elem_out_clk_i,    // Output clock
    output logic [ELEM_WIDTH-1:0] elem_out_o,        // Output element
    output logic                  elem_out_valid_o,  // Output valid
    input  logic                  elem_out_ready_i   // Output ready
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic                  w0;
  logic                  w1;
  logic                  w2;
  logic                  w3;
  logic                  w4;
  logic                  w5;
  logic [ELEM_WIDTH-1:0] w6;
  logic                  w7;
  logic                  w8;
  logic                  w9;
  logic                  w10;
  logic                  w11;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  nor g0 (w0, ~elem_in_valid_i, w1);
  nor g1 (elem_in_ready_o, w1, ~w2);
  nor g2 (w11, ~w10, elem_out_valid_o);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  pipeline_core #(
      .ELEM_WIDTH(ELEM_WIDTH)
  ) u0 (
      .clk_i           (elem_in_clk_i),
      .arst_ni         (arst_ni),
      .elem_in_i       (elem_in_i),
      .elem_in_valid_i (w0),
      .elem_in_ready_o (w2),
      .elem_out_o      (w6),
      .elem_out_valid_o(w1),
      .elem_out_ready_i(w3)
  );

  edge_detector #(
      .POSEDGE(1),
      .NEGEDGE(1)
  ) u1 (
      .arst_ni(arst_ni),
      .clk_i(elem_in_clk_i),
      .d_i(w1),
      .posedge_o(w5),
      .negedge_o(w4)
  );

  sr_latch_arstn u2 (
      .arst_ni(arst_ni),
      .s_i(w8),
      .r_i(w4),
      .q_o(w3),
      .q_no()
  );

  ff_back_to_back #(
      .NUM_STAGES(1)
  ) u3 (
      .clk_i(elem_in_clk_i),
      .arst_ni(arst_ni),
      .en_i(1),
      .d_i(w5),
      .q_o(w7)
  );

  sr_latch_arstn u4 (
      .arst_ni(arst_ni),
      .s_i(w7),
      .r_i(w9),
      .q_o(w10),
      .q_no()
  );

  edge_detector #(
      .POSEDGE(1),
      .NEGEDGE(1)
  ) u5 (
      .arst_ni(arst_ni),
      .clk_i(elem_out_clk_i),
      .d_i(elem_out_valid_o),
      .posedge_o(w9),
      .negedge_o(w8)
  );

  pipeline_core #(
      .ELEM_WIDTH(ELEM_WIDTH)
  ) u6 (
      .clk_i           (elem_out_clk_i),
      .arst_ni         (arst_ni),
      .elem_in_i       (w6),
      .elem_in_valid_i (w11),
      .elem_in_ready_o (),
      .elem_out_o      (elem_out_o),
      .elem_out_valid_o(elem_out_valid_o),
      .elem_out_ready_i(elem_out_ready_i)
  );

endmodule
