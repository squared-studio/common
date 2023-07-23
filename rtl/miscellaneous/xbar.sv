// A simple non-stallable xbar
// ### Author : Foez Ahmed (foez.official@gmail.com)

module xbar #(
    parameter int ELEM_WIDTH = 8,  // Width of each crossbar element
    parameter int NUM_ELEM   = 6   // Number of elements in the crossbar
) (
    input  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] select_i,  // Input bus select
    input  logic [NUM_ELEM-1:0][      ELEM_WIDTH-1:0] inputs_i,  // Array of input bus
    output logic [NUM_ELEM-1:0][      ELEM_WIDTH-1:0] outputs_o  // Array of output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] selects;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if ((2 ** ($clog2(NUM_ELEM))) == NUM_ELEM) begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = select_i[i];
    end
  end else begin : g_overflow
    for (genvar i = 0; i < NUM_ELEM; i++) begin : g_selects_assign
      assign selects[i] = (select_i[i] < NUM_ELEM) ? select_i[i] : (select_i[i] - NUM_ELEM);
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
        .sel_i(selects[i]),
        .inputs_i(inputs_i),
        .output_o(outputs_o[i])
    );
  end

endmodule
