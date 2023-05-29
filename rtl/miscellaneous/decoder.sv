// A simple decoder module for translating a code into individual wire set as HIGH
// ### Author : Foez Ahmed (foez.official@gmail.com)

module decoder #(
    parameter int NUM_OUTPUTS = 4  // Code with
) (
    input  logic [$clog2(NUM_OUTPUTS)-1:0] code_i, // Code input
    output logic [        NUM_OUTPUTS-1:0] out_o   // Wire output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // Generate output based on code
  for (genvar i = 0; i < NUM_OUTPUTS; i++) begin : g_outputs
    assign out_o[i] = (code_i == i);
  end

endmodule
