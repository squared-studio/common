/*
The `fixed_priority_arbiter` module is a priority arbiter with a fixed priority scheme.

The arbiter operates based on the `allow_req_i` and The priority encoder's address valid signal
signals. When requests are allowed and the address is valid, the arbiter grants the request with
the highest priority.

The arbiter uses a priority encoder to determine which request to grant. The priority encoder has
a fixed priority scheme, with the request at index 0 having the highest priority. The priority
encoder takes the request signals as input and outputs the grant address and a valid signal.

Author : Foez Ahmed (foez.official@gmail.com)
*/

module fixed_priority_arbiter #(
    parameter int NUM_REQ = 4  // The number of requests that the arbiter can handle
) (
    // The signal that allows requests to be made
    input logic               allow_req_i,
    // The request signals
    input logic [NUM_REQ-1:0] req_i,

    // The grant address
    output logic [$clog2(NUM_REQ)-1:0] gnt_addr_o,
    // The grant valid signal. It indicates whether the grant address is valid
    output logic                       gnt_addr_valid_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic addr_valid_o;  // Priority encoder address valid

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign gnt_addr_valid_o = allow_req_i & addr_valid_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  priority_encoder #(
      .NUM_WIRE(NUM_REQ),
      .HIGH_INDEX_PRIORITY(0)
  ) priority_encoder_dut (
      .d_i(req_i),
      .addr_o(gnt_addr_o),
      .addr_valid_o(addr_valid_o)
  );

endmodule
