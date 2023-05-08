////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : priority_encoder
//    DESCRIPTION : simple priority encoder
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                  ------------------------
                 ¦                        ¦
[NumInputs] in_i →    priority_encoder    → [$clog2(NumInputs)] code_o
                 ¦                        ¦
                  ------------------------
*/

module priority_encoder #(
    parameter int NumInputs = 4
) (
    input  logic [        NumInputs-1:0] in_i,
    output logic [$clog2(NumInputs)-1:0] code_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NumInputs)-1:0] out_[NumInputs];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign code_o  = out_[NumInputs-1];

  assign out_[0] = 0;
  for (genvar i = 1; i < NumInputs; i++) begin : g_msb
    assign out_[i] = in_i[i] ? i : out_[i-1];
  end

endmodule
