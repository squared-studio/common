// A simple priority encoder which prioritizes the LSB
// ### Author : Foez Ahmed (foez.official@gmail.com)

module priority_encoder #(
    parameter int NUM_WIRE            = 4,  // Number of output wires
    parameter bit HIGH_INDEX_PRIORITY = 0   // Prioritize Higher index
) (
    input  logic [        NUM_WIRE-1:0] d_i,          // Wire input
    output logic [$clog2(NUM_WIRE)-1:0] addr_o,       // Address output
    output logic                        addr_valid_o  // Address Valid output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_WIRE-1:0] select_found;
  logic [NUM_WIRE-1:0] allowed_selects;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_WIRE; i++) begin : g_allowed_selects
    assign allowed_selects[i] = d_i[i] & ~select_found[i];
  end

  if (HIGH_INDEX_PRIORITY) begin : g_msb_p
    for (genvar i = 0; i < (NUM_WIRE-1); i++) begin : g_select_found
      assign select_found[i] = select_found[i+1] | d_i[i+1];
    end
    assign select_found[NUM_WIRE-1] = 0;
  end else begin : g_lsb_p
    assign select_found[0] = 0;
    for (genvar i = 1; i < NUM_WIRE; i++) begin : g_select_found
      assign select_found[i] = select_found[i-1] | d_i[i-1];
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  encoder #(
      .NUM_WIRE(NUM_WIRE)
  ) u_encoder (
      .d_i(allowed_selects),
      .addr_o(addr_o),
      .addr_valid_o(addr_valid_o)
  );

endmodule
