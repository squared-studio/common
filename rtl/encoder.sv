// General purpose Encoder
// ### Author : Foez Ahmed (foez.official@gmail.com)

module encoder #(
    parameter int NUM_WIRE = 16  // Number of output wires
) (
    input logic [NUM_WIRE-1:0] d_i,  // Wire input

    output logic [$clog2(NUM_WIRE)-1:0] addr_o,       // Address output
    output logic                        addr_valid_o  // Address Valid output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_WIRE/2-1:0] addr_or_red[$clog2(NUM_WIRE)];  // addr or reduction array

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar j = 0; j < $clog2(NUM_WIRE); j++) begin : g_addr_or_red
    always_comb begin
      int k;
      addr_or_red[j] = '0;
      k = 0;
      for (int i = 0; i < NUM_WIRE; i++) begin
        if (!((i % (2 ** (j + 1))) < ((2 ** (j + 1)) / 2))) begin
          addr_or_red[j][k] = d_i[i];
          k++;
        end
      end
    end
  end

  for (genvar i = 0; i < $clog2(NUM_WIRE); i++) begin : g_addr_o
    assign addr_o[i] = |addr_or_red[i];
  end

  assign addr_valid_o = |d_i;

endmodule
