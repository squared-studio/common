/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/
module bin_to_gray #(
    parameter int DATA_WIDTH = 4  // Data Width
) (
    input logic [DATA_WIDTH-1:0] data_in_i,  // binary code in

    output logic [DATA_WIDTH-1:0] data_out_o  // gray code out
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < (DATA_WIDTH - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_in_i[1+i] ^ data_in_i[i];
  end
  assign data_out_o[DATA_WIDTH-1] = data_in_i[DATA_WIDTH-1];

endmodule
