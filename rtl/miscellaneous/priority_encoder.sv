// A simple priority encoder which prioritizes the LSB
// ### Author : Foez Ahmed (foez.official@gmail.com)

module priority_encoder #(
    parameter int NUM_INPUTS = 4 // Number of Inputs
) (
    input  logic [        NUM_INPUTS-1:0] in_i, // Wire input
    output logic [$clog2(NUM_INPUTS)-1:0] code_o // Code output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_INPUTS)-1:0] out_[NUM_INPUTS]; // finalizing output based on previous

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Final output
  assign code_o  = out_[NUM_INPUTS-1];

  // MSB calculations
  assign out_[0] = 0;
  for (genvar i = 1; i < NUM_INPUTS; i++) begin : g_msb
    assign out_[i] = in_i[i] ? i : out_[i-1];
  end

endmodule
