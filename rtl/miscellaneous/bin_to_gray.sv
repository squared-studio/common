////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : bin_to_gray
//    DESCRIPTION : converter module for binary to gray code conversion
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                       -------------------
                      ¦                   ¦
[DataWidth] data_in_i →    bin_to_gray    → [DataWidth] data_out_o
                      ¦                   ¦
                       -------------------
*/

module bin_to_gray #(
    parameter int DataWidth = 4
) (
    input  logic [DataWidth-1:0] data_in_i,
    output logic [DataWidth-1:0] data_out_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < (DataWidth - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_in_i[1+i] ^ data_in_i[i];
  end
  assign data_out_o[DataWidth-1] = data_in_i[DataWidth-1];

endmodule
