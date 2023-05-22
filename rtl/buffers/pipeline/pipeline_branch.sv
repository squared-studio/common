////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                        clk_i                    arst_ni
                       ---↓-------------------------↓---
                      ¦                                 ¦
                      ¦                                 → [DataWidth] data_out_main_o
                      ¦                                 → data_out_main_valid_o
[DataWidth] data_in_i →                                 ← data_out_main_ready_i
      data_in_valid_i →         pipeline_branch         ¦
      data_in_ready_o ←                                 → [DataWidth] data_out_scnd_o
                      ¦                                 → data_out_scnd_valid_o
                      ¦                                 ← data_out_scnd_ready_i
                      ¦                                 ¦
                       ---------------------------------
*/

module pipeline_branch #(
    parameter int DataWidth = 8
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [DataWidth-1:0] data_in_i,
    input  logic                 data_in_valid_i,
    output logic                 data_in_ready_o,

    output logic [DataWidth-1:0] data_out_main_o,
    output logic                 data_out_main_valid_o,
    input  logic                 data_out_main_ready_i,

    output logic [DataWidth-1:0] data_out_scnd_o,
    output logic                 data_out_scnd_valid_o,
    input  logic                 data_out_scnd_ready_i
);

  logic [DataWidth-1:0] data_out_core;
  logic                 data_out_core_valid;
  logic                 data_out_core_ready;

  assign data_out_main_o = data_out_core;
  assign data_out_scnd_o = data_out_core;

  assign data_out_main_valid_o = data_out_core_valid;
  assign data_out_scnd_valid_o = data_out_core_valid & ~data_out_main_ready_i;
  assign data_out_core_ready = data_out_scnd_ready_i | data_out_main_ready_i;

  pipeline_core #(
      .DataWidth(DataWidth)
  ) pipeline_core_dut (
      .clk_i          (clk_i),
      .arst_ni        (arst_ni),
      .data_in_i      (data_in_i),
      .data_in_valid_i(data_in_valid_i),
      .data_in_ready_o(data_in_ready_o),
      .data_out       (data_out_core),
      .data_out_valid (data_out_core_valid),
      .data_out_ready (data_out_core_ready)
  );

endmodule
