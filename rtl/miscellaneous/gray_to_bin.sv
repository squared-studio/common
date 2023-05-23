// ### Author : Foez Ahmed (foez.official@gmail.com)

module gray_to_bin #(
    parameter int DataWidth = 4
) (
    input  logic [DataWidth-1:0] data_in_i,
    output logic [DataWidth-1:0] data_out_o
);

  for (genvar i = 0; i < (DataWidth - 1); i++) begin : g_lsb
    assign data_out_o[i] = data_out_o[1+i] ^ data_in_i[i];
  end
  assign data_out_o[DataWidth-1] = data_in_i[DataWidth-1];

endmodule
