// ### Author : Foez Ahmed (foez.official@gmail.com)

module priority_encoder #(
    parameter int NUM_INPUTS = 4
) (
    input  logic [        NUM_INPUTS-1:0] in_i,
    output logic [$clog2(NUM_INPUTS)-1:0] code_o
);

  logic [$clog2(NUM_INPUTS)-1:0] out_[NUM_INPUTS];

  assign code_o  = out_[NUM_INPUTS-1];

  assign out_[0] = 0;
  for (genvar i = 1; i < NUM_INPUTS; i++) begin : g_msb
    assign out_[i] = in_i[i] ? i : out_[i-1];
  end

endmodule
