// ### Author : Foez Ahmed (foez.official@gmail.com)

module pipeline_branch #(
    parameter int ELEM_WIDTH = 8
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    input  logic                  elem_in_valid_i,
    output logic                  elem_in_ready_o,

    output logic [ELEM_WIDTH-1:0] elem_out_main_o,
    output logic                  elem_out_main_valid_o,
    input  logic                  elem_out_main_ready_i,

    output logic [ELEM_WIDTH-1:0] elem_out_scnd_o,
    output logic                  elem_out_scnd_valid_o,
    input  logic                  elem_out_scnd_ready_i
);

  logic [ELEM_WIDTH-1:0] elem_out_core;
  logic                  elem_out_core_valid;
  logic                  elem_out_core_ready;

  assign elem_out_main_o = elem_out_core;
  assign elem_out_scnd_o = elem_out_core;

  assign elem_out_main_valid_o = elem_out_core_valid;
  assign elem_out_scnd_valid_o = elem_out_core_valid & ~elem_out_main_ready_i;
  assign elem_out_core_ready = elem_out_scnd_ready_i | elem_out_main_ready_i;

  pipeline_core #(
      .ELEM_WIDTH(ELEM_WIDTH)
  ) pipeline_core_dut (
      .clk_i           (clk_i),
      .arst_ni         (arst_ni),
      .elem_in_i       (elem_in_i),
      .elem_in_valid_i (elem_in_valid_i),
      .elem_in_ready_o (elem_in_ready_o),
      .elem_out_o      (elem_out),
      .elem_out_valid_o(elem_out_valid),
      .elem_out_ready_i(elem_out_ready)
  );

endmodule
