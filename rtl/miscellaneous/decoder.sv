////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ### Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module decoder #(
    parameter int CodeWidth = 4
) (
    input  logic [CodeWidth-1:0]    code_i,
    output logic [2**CodeWidth-1:0] out_o
);

  for (genvar i = 0; i < (2 ** CodeWidth); i++) begin : g_outputs
    assign out_o[i] = (code_i == i);
  end

endmodule
