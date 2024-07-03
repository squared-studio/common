/*
The `mux` module is a parameterized SystemVerilog module that implements a multiplexer. The module
uses an assignment to select the appropriate output based on the select input.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module mux #(
    parameter int ELEM_WIDTH = 8,  // width of each multiplexer input element
    parameter int NUM_ELEM   = 6   // number of elements in the multiplexer
) (
    input logic [$clog2(NUM_ELEM)-1:0] s_i,  // select

    input logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] i_i,  // Array of input bus

    output logic [ELEM_WIDTH-1:0] o_o  // Output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb o_o = i_i[s_i];

endmodule
