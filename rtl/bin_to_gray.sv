/*
The `bin_to_gray` module is a binary to gray code converter. It takes a binary input (`data_in_i`)
and converts it to gray code (`data_out_o`).
The module uses a for loop to generate the gray code from the binary input. For each bit from the
least significant bit (LSB) to the second most significant bit (MSB-1), the gray code bit is the XOR
of the current binary bit and the next binary bit. The most significant bit (MSB) of the gray code
is the same as the MSB of the binary input.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module bin_to_gray #(
    // width of the data. This is the number of bits in the binary and gray code
    parameter int DATA_WIDTH = 4
) (
    // Binary code input. This is a `DATA_WIDTH`-bit binary number that is to be converted to gray code
    input logic [DATA_WIDTH-1:0] data_in_i,

    // Gray code output. This is the `DATA_WIDTH`-bit gray code equivalent of the binary input
    output logic [DATA_WIDTH-1:0] data_out_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < (DATA_WIDTH - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_in_i[1+i] ^ data_in_i[i];
  end
  assign data_out_o[DATA_WIDTH-1] = data_in_i[DATA_WIDTH-1];

endmodule
