/*
The `demux` module is a demultiplexer with a configurable number of elements and element width.

It uses a for loop to generate the output array, where each element is the bitwise AND of the data
input and the corresponding valid output signal.

The demux uses a decoder to generate the valid output signals. The decoder takes the select input as
the address input, a constant '1' as the address valid input, and outputs the valid output signals.

Author : Foez Ahmed (foez.official@gmail.com)
*/

module demux #(
    parameter int NUM_ELEM   = 6,  //The number of elements
    parameter int ELEM_WIDTH = 8   //The width of each element
) (
    // The select input. It is a logic vector with a width of `log2(NUM_ELEM)`
    input logic [$clog2(NUM_ELEM)-1:0] s_i,
    // The data input. It is a logic vector with a width of `ELEM_WIDTH`
    input logic [ELEM_WIDTH-1:0] i_i,

    // The output array. It is a 2D logic array with a size of `NUM_ELEM` by `ELEM_WIDTH`
    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // The valid output signals. It is a logic vector with a width of `NUM_ELEM`
  logic [NUM_ELEM-1:0] valid_out;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_elem
    for (genvar j = 0; j < ELEM_WIDTH; j++) begin : g_bits
      assign o_o[i][j] = i_i[j] & valid_out[i];
    end
  end
  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  decoder #(
      .NUM_WIRE(NUM_ELEM)
  ) u_decoder (
      .a_i(s_i),
      .a_valid_i('1),
      .d_o(valid_out)
  );
endmodule
