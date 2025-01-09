/*
The `priority_encoder` module is a simple priority encoder with a configurable number of output
wires and priority direction.
Author: Foez Ahmed (foez.official@gmail.com)
<br>This file is part of squared-studio:common
<br>Copyright (c) 2025 squared-studio
<br>Licensed under the MIT License
<br>See LICENSE file in the project root for full license information
*/

module priority_encoder #(
    parameter int NUM_WIRE            = 4,  // Number of output wires
    parameter bit HIGH_INDEX_PRIORITY = 0   // Prioritize Higher index
) (
    input logic [NUM_WIRE-1:0] d_i,  // Wire input

    output logic [$clog2(NUM_WIRE)-1:0] addr_o,       // Address output
    output logic                        addr_valid_o  // Address Valid output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_WIRE-1:0] select_already_found;  // Select already found. Current select won't work

  logic [NUM_WIRE-1:0] allowed_selects;  // Computed select based on select_already_found

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_WIRE; i++) begin : g_allowed_selects
    assign allowed_selects[i] = ~(~d_i[i] | select_already_found[i]);
  end

  if (HIGH_INDEX_PRIORITY) begin : g_msb_p
    for (genvar i = 0; i < (NUM_WIRE - 1); i++) begin : g_select_found
      assign select_already_found[i] = select_already_found[i+1] | d_i[i+1];
    end
    assign select_already_found[NUM_WIRE-1] = 0;
  end else begin : g_lsb_p
    assign select_already_found[0] = 0;
    for (genvar i = 1; i < NUM_WIRE; i++) begin : g_select_found
      assign select_already_found[i] = select_already_found[i-1] | d_i[i-1];
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (NUM_WIRE > 32) begin
      $display("\033[7;31m %m NUM_WIRE=%0d \033[0m", NUM_WIRE);
    end
  end
`endif  // SIMULATION

endmodule
