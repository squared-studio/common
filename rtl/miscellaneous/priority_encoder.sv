// A simple priority encoder which prioritizes the LSB
// ### Author : Foez Ahmed (foez.official@gmail.com)

module priority_encoder #(
    parameter int NUM_INPUTS = 4  // Number of Inputs
) (
    input  logic [        NUM_INPUTS-1:0] in_i,         // Wire input
    output logic [$clog2(NUM_INPUTS)-1:0] code_o,       // Code output
    output logic                          code_valid_o  // Code output is valid
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_INPUTS)-1:0] out_[NUM_INPUTS];  // finalizing output based on previous

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign code_o = out_[0];

  assign code_valid_o = | in_i;

  for (genvar i = 0; i < (NUM_INPUTS - 1); i++) begin : g_msb
    assign out_[i] = in_i[i] ? i : out_[i+1];
  end
  assign out_[NUM_INPUTS - 1] = in_i[NUM_INPUTS - 1] ? (NUM_INPUTS - 1) : 0;

endmodule
