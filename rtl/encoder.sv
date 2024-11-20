/*
The `encoder` module is a priority encoder with a configurable number of output wires.

The encoder operates based on the `d_i` and `addr_or_red` signals. It uses a for loop to generate
the `addr_or_red` array, which is used to calculate the address output. The address output is the
bitwise OR of the `addr_or_red` array. The address valid output is the bitwise OR of the wire input.

The encoder uses assignments to calculate the `addr_or_red` array, the address output, and the
address valid output. The `addr_or_red` array is calculated in a for loop, where each element is the
bitwise OR of a subset of the wire input. The address output is the bitwise OR of the `addr_or_red`
array. The address valid output is the bitwise OR of the wire input.

Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2024 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module encoder #(
    parameter int NUM_WIRE = 16  // number of output wires
) (
    // wire input
    input logic [NUM_WIRE-1:0] d_i,

    // address output
    output logic [$clog2(NUM_WIRE)-1:0] addr_o,
    // address valid output. It indicates whether the address output is valid
    output logic                        addr_valid_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_WIRE/2-1:0] addr_or_red[$clog2(NUM_WIRE)];  // addr or reduction array

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar j = 0; j < $clog2(NUM_WIRE); j++) begin : g_addr_or_red
    always_comb begin
      int k;
      addr_or_red[j] = '0;
      k = 0;
      for (int i = 0; i < NUM_WIRE; i++) begin
        if (!((i % (2 ** (j + 1))) < ((2 ** (j + 1)) / 2))) begin
          addr_or_red[j][k] = d_i[i];
          k++;
        end
      end
    end
  end

  for (genvar i = 0; i < $clog2(NUM_WIRE); i++) begin : g_addr_o
    assign addr_o[i] = |addr_or_red[i];
  end

  assign addr_valid_o = |d_i;

endmodule
