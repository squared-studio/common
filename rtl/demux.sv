/*
The `demux` module is a demultiplexer with a configurable number of elements and element width.

It uses a for loop to generate the output array, where each element is the bitwise AND of the data
input and the corresponding valid output signal.

The demux uses a decoder to generate the valid output signals. The decoder takes the select input as
the address input, a constant '1' as the address valid input, and outputs the valid output signals.

Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module demux #(
    parameter int NUM_ELEM   = 6,  //The number of elements
    parameter int ELEM_WIDTH = 8   //The width of each element
) (
    // select input
    input logic [$clog2(NUM_ELEM)-1:0] s_i,
    // data input
    input logic [ELEM_WIDTH-1:0] i_i,

    // output array
    output logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // valid output signals
  logic [NUM_ELEM-1:0] valid_out;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_elem
    for (genvar j = 0; j < ELEM_WIDTH; j++) begin : g_bits
      always_comb o_o[i][j] = i_i[j] & valid_out[i];
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
