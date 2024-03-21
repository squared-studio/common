// General purpose decoder module
// ### Author : Foez Ahmed (foez.official@gmail.com)

module decoder #(
    parameter int NUM_WIRE = 4  // Number of output wires
) (
    input logic [$clog2(NUM_WIRE)-1:0] a_i,       // Address input
    input logic                        a_valid_i, // Address Valid input

    output logic [NUM_WIRE-1:0] d_o  // data output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_WIRE)-1:0] a_i_n;  // Inverted Address input

  logic [$clog2(NUM_WIRE):0] output_and_red[NUM_WIRE];  // Output and reduction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign a_i_n = ~a_i;

  always_comb begin
    for (bit [$clog2(NUM_WIRE):0] i = 0; i < NUM_WIRE; i++) begin
      for (int j = 0; j < $clog2(NUM_WIRE); j++) begin
        output_and_red[i][j] = i[j] ? a_i[j] : a_i_n[j];
      end
      output_and_red[i][$clog2(NUM_WIRE)] = a_valid_i;
    end
  end

  for (genvar i = 0; i < NUM_WIRE; i++) begin : g_output_and_red
    assign d_o[i] = &output_and_red[i];
  end

endmodule
