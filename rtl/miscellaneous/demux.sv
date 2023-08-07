// General purpose DEMUX
// ### Author : Foez Ahmed (foez.official@gmail.com)

module demux #(
    parameter int ELEM_WIDTH = 8,  // Width of each demux element
    parameter int NUM_ELEM   = 6   // Number of elements in the demux
) (
    input  logic [$clog2(NUM_ELEM)-1:0]                 s_i,  // Output select
    input  logic [      ELEM_WIDTH-1:0]                 i_i,  // input bus
    output logic [        NUM_ELEM-1:0][ELEM_WIDTH-1:0] o_o   // Array of Output bus
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin
    foreach (o_o[i]) o_o[i] = '0;
    o_o[s_i] = i_i;
  end

endmodule
