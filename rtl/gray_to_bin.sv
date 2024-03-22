/*
A Gray to Binary code converter is a logical circuit that is used to convert gray code
into its equivalent Binary code
[more info](https://www.geeksforgeeks.org/code-converters-binary-to-from-gray-code/)
Author : Foez Ahmed (foez.official@gmail.com)
*/

module gray_to_bin #(
    parameter int DATA_WIDTH = 4  // Data Width
) (
    input logic [DATA_WIDTH-1:0] data_in_i,  // gray code in

    output logic [DATA_WIDTH-1:0] data_out_o  // binary code out
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < (DATA_WIDTH - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_out_o[1+i] ^ data_in_i[i];
  end
  assign data_out_o[DATA_WIDTH-1] = data_in_i[DATA_WIDTH-1];

endmodule
