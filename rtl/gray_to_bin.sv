/*
The `gray_to_bin` module is a parameterized SystemVerilog module that converts a Gray code input to
a binary code output. The module uses a loop and an XOR operation to perform the conversion.
Author : Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module gray_to_bin #(
    parameter int DATA_WIDTH = 4  // width of the data
) (
    // Gray code input
    input logic [DATA_WIDTH-1:0] data_in_i,

    // binary code output
    output logic [DATA_WIDTH-1:0] data_out_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // For each bit from `0` to `DATA_WIDTH - 2`, the corresponding bit in `data_out_o` is assigned
  // XOR of the next bit in `data_out_o` and the current bit in `data_in_i`.
  for (genvar i = 0; i < (DATA_WIDTH - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_out_o[1+i] ^ data_in_i[i];
  end

  // most significant bit in `data_out_o` is assigned the most significant bit in `data_in_i`
  assign data_out_o[DATA_WIDTH-1] = data_in_i[DATA_WIDTH-1];

endmodule
