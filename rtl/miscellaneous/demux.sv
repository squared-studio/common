// General purpose DEMUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

module demux #(
    parameter int ELEM_WIDTH = 8,  // Width of each crossbar element
    parameter int NUM_ELEM   = 6   // Number of elements in the crossbar
) (
    input  logic [$clog2(NUM_ELEM)-1:0]                 sel_i,     // Output enable
    input  logic [      ELEM_WIDTH-1:0]                 input_i,   // Array of input bus
    output logic [        NUM_ELEM-1:0][ELEM_WIDTH-1:0] outputs_o  // Output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_outputs
    assign outputs_o[i] = (sel_i == i) ? input_i : '0;
  end

endmodule
