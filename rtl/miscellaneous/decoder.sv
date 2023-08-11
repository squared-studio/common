// General purpose decoder module
// ### Author : Foez Ahmed (foez.official@gmail.com)

module decoder #(
    parameter int NUM_WIRE = 4  // Number of output wires
) (
    input  logic [$clog2(NUM_WIRE)-1:0] a_i,        // Address input
    input  logic                        a_valid_i,  // Address Valid input
    output logic [        NUM_WIRE-1:0] d_o         // data    output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  demux #(
      .NUM_ELEM  (NUM_WIRE)
  ) u_demux (
      .sel_i(a_i),
      .input_i(a_valid_i),
      .outputs_o(d_o)
  );

endmodule
