// A simple decoder module for translating a code into individual wire set as HIGH
// ### Author : Foez Ahmed (foez.official@gmail.com)

module decoder #(
    parameter int ADDR_WIDTH = 4  // Code with
) (
    input  logic [   ADDR_WIDTH-1:0] addr_i,        // Address input
    input  logic                     addr_valid_i,  // Address Valid input
    output logic [2**ADDR_WIDTH-1:0] select_o       // Wire output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  demux #(
      .ELEM_WIDTH(1),
      .NUM_ELEM  (2 ** ADDR_WIDTH)
  ) u_demux (
      .sel_i(addr_i),
      .input_i(addr_valid_i),
      .outputs_o(select_o)
  );

endmodule
