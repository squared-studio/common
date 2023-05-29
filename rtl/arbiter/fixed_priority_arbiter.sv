// ### Author : Foez Ahmed (foez.official@gmail.com)

module fixed_priority_arbiter #(
    parameter int NUM_REQ = 4
) (
    input  logic               arst_ni,
    input  logic               allow_req_i,
    input  logic               en_i,
    input  logic [NUM_REQ-1:0] req_i,
    output logic [NUM_REQ-1:0] gnt_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_REQ-1:0] gnt_already_found;
  logic [NUM_REQ-1:0] latch_out;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign gnt_already_found[0] = ~allow_req_i;
  for (genvar i = 1; i < NUM_REQ; i++) begin : g_gnt_found
    assign gnt_already_found[i] = gnt_already_found[i-1] | gnt_o[i-1];
  end

  for (genvar i = 0; i < NUM_REQ; i++) begin : g_gnt
    assign gnt_o[i] = gnt_already_found[i] ? '0 : latch_out[i];
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  latch #(
      .ELEM_WIDTH(NUM_REQ)
  ) u_latch_req_i (
      .arst_ni(arst_ni),
      .en_i(en_i),
      .d_i(req_i),
      .q_o(latch_out)
  );

endmodule
