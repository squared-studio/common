/*
The `pipeline_branch` module is a parameterized SystemVerilog module that implements a pipeline
branch. The module uses a `pipeline_core` instance to process the input data and then branches the
output to two different paths.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module pipeline_branch #(
    parameter int ELEM_WIDTH = 8  // width of each pipeline element
) (
    // global clock signal
    input logic clk_i,
    // asynchronous active low reset signal
    input logic arst_ni,

    // input element
    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    // input element valid signal
    input  logic                  elem_in_valid_i,
    // input element ready signal
    output logic                  elem_in_ready_o,

    // main output element
    output logic [ELEM_WIDTH-1:0] elem_out_main_o,
    // main output element valid signal
    output logic                  elem_out_main_valid_o,
    // main output element ready signal
    input  logic                  elem_out_main_ready_i,

    // secondary output element
    output logic [ELEM_WIDTH-1:0] elem_out_scnd_o,
    // secondary output element valid signal
    output logic                  elem_out_scnd_valid_o,
    // secondary output element ready signal
    input  logic                  elem_out_scnd_ready_i
);

  logic [ELEM_WIDTH-1:0] elem_out_core;  // core output element
  logic                  elem_out_core_valid;  // core output element valid signal
  logic                  elem_out_core_ready;  // core output element ready signal

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

// TODO
