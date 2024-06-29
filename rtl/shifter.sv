/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module shifter #(
    parameter int DATA_WIDTH  = 4,
    parameter int SHIFT_WIDTH = 3
) (
    input logic [ DATA_WIDTH-1:0] data_i,
    input logic [SHIFT_WIDTH-1:0] shift_i,
    input logic [SHIFT_WIDTH-1:0] right_shift_i,

    output logic [DATA_WIDTH-1:0] data_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [DATA_WIDTH-1:0] stage[SHIFT_WIDTH];
  logic [DATA_WIDTH-1:0] lr_init;
  logic [DATA_WIDTH-1:0] lr_final;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < DATA_WIDTH; i++) begin : g_right_shift_invertions
    assign lr_init[i] = right_shift_i ? data_i[DATA_WIDTH-1-i] : data_i[i];
    assign lr_final[i] = right_shift_i ? stage[SHIFT_WIDTH-1][DATA_WIDTH-1-i]
                                       : stage[SHIFT_WIDTH-1][i];
  end

  assign stage[0] = shift_i[0] ? lr_init : '0;
  for (genvar i = 0; i < SHIFT_WIDTH; i++) begin : g_shift_mux
    assign stage[i] = shift_i[i] ? {stage[i-1],{i{1'b0}}} : stage[i-1];
  end

  assign data_o = stage[SHIFT_WIDTH-1];

endmodule
