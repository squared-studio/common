// General purpose MUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

module mux #(
    parameter int ELEM_WIDTH = 8,  // Width of each mux input element
    parameter int NUM_ELEM   = 6   // Number of elements in the mux
) (
    input  logic [$clog2(NUM_ELEM)-1:0]                 s_i,  // select
    input  logic [        NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,  // Array of input bus
    output logic [      ELEM_WIDTH-1:0]                 o_o   // Output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign o_o = i_i[s_i];

endmodule
