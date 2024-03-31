/*
The `circular_xbar` module is a parameterized SystemVerilog module that implements a circular
crossbar switch. The module uses a multiplexer to select the appropriate output based on the
rotation base select.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module circular_xbar #(
    parameter int ELEM_WIDTH = 8,  // The width of each crossbar element
    parameter int NUM_ELEM   = 6   // The number of elements in the crossbar
) (
    // The rotation base select. It is a logic vector of size `[$clog2(NUM_ELEM)-1:0]`
    input logic [$clog2(NUM_ELEM)-1:0] s_i,

    // The array of input buses. It is a 2D logic array of size `[NUM_ELEM-1:0][ELEM_WIDTH-1:0]`
    input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,

    // The array of output buses. It is a 2D logic array of size `[NUM_ELEM-1:0][ELEM_WIDTH-1:0]`
    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // A 2D logic array of size `[NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0]` that holds the internal select
  // signals with offset handling.
  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] selects;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // A generator that assigns each element of `selects` based on the rotation base select and the
  // element index. It handles the overflow case when the sum of the rotation base select and the
  // element index is greater than or equal to `NUM_ELEM`.
  if ((2 ** ($clog2(NUM_ELEM))) == NUM_ELEM) begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = s_i + i;
    end
  end else begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = ((s_i + i) < NUM_ELEM) ? (s_i + i) : ((s_i + i) - NUM_ELEM);
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // An instance of the `mux` module that selects the output bus based on the select signal.
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
