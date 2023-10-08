// General purpose DEMUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

module demux #(
    parameter int NUM_ELEM   = 6,  // Number of elements in the demux
    parameter int ELEM_WIDTH = 8   // Width of each element
) (
    input  logic [$clog2(NUM_ELEM)-1:0]                 s_i,  // Output select
    input  logic [      ELEM_WIDTH-1:0]                 i_i,  // input
    output logic [        NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o   // Array of Output
);

  logic [NUM_ELEM-1:0] valid_out;

  for (genvar i = 0; i < NUM_ELEM; i++) begin : g_elem
    for (genvar j = 0; j < ELEM_WIDTH; j++) begin : g_bits
      assign o_o[i][j] = i_i[j] & valid_out[i];
    end
  end

  decoder #(
      .NUM_WIRE(NUM_ELEM)
  ) u_decoder (
      .a_i(s_i),
      .a_valid_i('1),
      .d_o(valid_out)
  );

endmodule
