/*
The `xbar` module is a configurable crossbar switch implemented in SystemVerilog. A crossbar switch
is a device that connects multiple inputs to multiple outputs in a matrix manner. It's a crucial
component in many digital systems, including multiprocessor interconnection networks and telephone
exchanges.

This module is highly configurable with two parameters: `ELEM_WIDTH` and `NUM_ELEM`. `ELEM_WIDTH`
specifies the width of each crossbar element, and `NUM_ELEM` determines the number of elements in
the crossbar.

The module has three main parts: input bus select (`s_i`), array of input bus (`i_i`), and array of
output bus (`o_o`). The `s_i` is a logic input that selects which input bus to connect to the output
bus. The `i_i` is an array of logic inputs that represent the different input buses. The `o_o` is an
array of logic outputs that represent the different output buses.

Internally, the module uses a logic array `selects` for handling offset in the input bus select. The
module also contains a conditional assignment block that assigns the select lines based on the
overflow condition.

Finally, the module uses a `mux` (multiplexer) module to connect the selected input bus to the
output bus. The `mux` module is instantiated in a generate loop, creating a separate multiplexer for
each output bus.

Author: Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module xbar #(
    parameter int ELEM_WIDTH = 8,  // Width of each crossbar element
    parameter int NUM_ELEM   = 6   // Number of elements in the crossbar
) (
    input logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] s_i,  // Input bus select

    input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,  // Array of input bus

    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o  // Array of output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] selects;  // Internal select with offset handling

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if ((2 ** ($clog2(NUM_ELEM))) == NUM_ELEM) begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = s_i[i];
    end
  end else begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = (s_i[i] < NUM_ELEM) ? s_i[i] : (s_i[i] - NUM_ELEM);
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_mux
    mux #(
        .ELEM_WIDTH(ELEM_WIDTH),
        .NUM_ELEM  (NUM_ELEM)
    ) mux_dut (
        .s_i(selects[i]),
        .i_i(i_i),
        .o_o(o_o[i])
    );
  end

endmodule
