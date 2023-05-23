////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ### Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module priority_encoder #(
    parameter int NumInputs = 4
) (
    input  logic [        NumInputs-1:0] in_i,
    output logic [$clog2(NumInputs)-1:0] code_o
);

  logic [$clog2(NumInputs)-1:0] out_[NumInputs];

  assign code_o  = out_[NumInputs-1];

  assign out_[0] = 0;
  for (genvar i = 1; i < NumInputs; i++) begin : g_msb
    assign out_[i] = in_i[i] ? i : out_[i-1];
  end

endmodule
