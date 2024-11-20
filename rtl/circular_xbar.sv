/*
The `circular_xbar` module is a parameterized SystemVerilog module that implements a circular
crossbar switch. The module uses a xbar to select the appropriate output based on the rotation base
select.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module circular_xbar #(
    parameter int ELEM_WIDTH = 8,  // width of each crossbar element
    parameter int NUM_ELEM   = 6   // number of elements in the crossbar
) (
    // rotation base select
    input logic [$clog2(NUM_ELEM)-1:0] s_i,

    // array of input buses
    input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,

    // array of output buses
    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // A 2D logic array that holds the internal select
  // signals with offset handling.
  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] selects;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
    assign selects[i] = s_i + i;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  xbar #(
      .ELEM_WIDTH(ELEM_WIDTH),
      .NUM_ELEM  (NUM_ELEM)
  ) u_xbar (
      .s_i(selects),
      .i_i(i_i),
      .o_o(o_o)
  );

endmodule
