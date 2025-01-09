/*
The `decoder` module is a parameterized SystemVerilog module that decodes an input address to an
output data line. The number of output lines is determined by the parameter `NUM_WIRE`.

The module operates by inverting the address input and storing it in `a_i_n`. It then performs a
bitwise AND operation on the inverted and non-inverted address inputs based on the current index.
The result is stored in `output_and_red`. If the address input is valid (`a_valid_i` is high), the
corresponding output line is enabled.

Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module decoder #(
    parameter int NUM_WIRE = 4  // This parameter determines the number of output wires
) (
    // This is the address input
    input logic [$clog2(NUM_WIRE)-1:0] a_i,       // Address input
    // This is a single bit input signal that indicates whether the address input is valid
    input logic                        a_valid_i, // Address Valid input

    // This is the data output
    output logic [NUM_WIRE-1:0] d_o  // data output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_WIRE)-1:0] a_i_n;  // This is the inverted address input

  // This is an array of logic vectors used for the output and reduction operations
  logic [$clog2(NUM_WIRE):0] output_and_red[NUM_WIRE];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb a_i_n = ~a_i;

  always_comb begin
    for (bit [$clog2(NUM_WIRE):0] i = 0; i < NUM_WIRE; i++) begin
      for (int j = 0; j < $clog2(NUM_WIRE); j++) begin
        output_and_red[i][j] = i[j] ? a_i[j] : a_i_n[j];
      end
      output_and_red[i][$clog2(NUM_WIRE)] = a_valid_i;
    end
  end

  for (genvar i = 0; i < NUM_WIRE; i++) begin : g_output_and_red
    always_comb d_o[i] = &output_and_red[i];
  end

endmodule
