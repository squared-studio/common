// ### Author : Foez Ahmed (foez.official@gmail.com)

module round_robin_arbiter #(
    parameter int NUM_REQ = 4
) (
    input  logic                       clk_i,
    input  logic                       arst_ni,
    input  logic                       allow_req_i,
    input  logic [        NUM_REQ-1:0] req_i,
    output logic [$clog2(NUM_REQ)-1:0] gnt_addr_o,
    output logic                       gnt_addr_valid_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [$clog2(NUM_REQ)-1:0] last_gnt;
  logic [$clog2(NUM_REQ)-1:0] next_gnt;

  logic [NUM_REQ-1:0] fpa_in;

  logic [NUM_REQ-1:0] fpa_gnt_addr_valid;

  logic [$clog2(NUM_REQ)-1:0] rot_gnt_addr_o;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign gnt_addr_o = ((rot_gnt_addr_o + next_gnt ) < NUM_REQ) ? (rot_gnt_addr_o + next_gnt )
                      : ((rot_gnt_addr_o + next_gnt) - NUM_REQ);

  assign next_gnt = ((last_gnt + 1) < NUM_REQ) ? (last_gnt + 1) : ((last_gnt + 1) - NUM_REQ);

  assign gnt_addr_valid_o = fpa_gnt_addr_valid & arst_ni;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  circular_xbar #(
      .ELEM_WIDTH(1),
      .NUM_ELEM  (NUM_REQ)
  ) circular_xbar_dut (
      .s_i(next_gnt),
      .i_i(req_i),
      .o_o(fpa_in)
  );

  fixed_priority_arbiter #(
      .NUM_REQ(NUM_REQ)
  ) fixed_priority_arbiter_dut (
      .allow_req_i(allow_req_i),
      .req_i(fpa_in),
      .gnt_addr_o(rot_gnt_addr_o),
      .gnt_addr_valid_o(fpa_gnt_addr_valid)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      last_gnt <= NUM_REQ - 1;
    end else if (gnt_addr_valid_o) begin
      last_gnt <= gnt_addr_o;
    end
  end

endmodule

// TODO
