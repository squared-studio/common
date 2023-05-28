// ### Author : Foez Ahmed (foez.official@gmail.com)

module round_robin_arbiter #(
    parameter int CLOG_2_NUM_REQ = 2
) (
    input  logic                             clk_i,
    input  logic                             arst_ni,
    input  logic                             allow_req_i,
    input  logic                             en_i,
    input  logic [(2 ** CLOG_2_NUM_REQ)-1:0] req_i,
    output logic [(2 ** CLOG_2_NUM_REQ)-1:0] gnt_o
);

  localparam int NumReq = (2 ** CLOG_2_NUM_REQ);

  logic [CLOG_2_NUM_REQ-1:0] xbar_sel;

  logic [NumReq-1:0][CLOG_2_NUM_REQ-1:0] req_in_sel;
  logic [NumReq-1:0][CLOG_2_NUM_REQ-1:0] gnt_in_sel;

  logic [NumReq-1:0] req_xbar;
  logic [NumReq-1:0] gnt_xbar;

  logic [CLOG_2_NUM_REQ-1:0] gnt_code;

  logic gnt_found;

  xbar #(
      .ELEM_WIDTH(1),
      .NUM_ELEM  (NumReq)
  ) xbar_req (
      .select_i (req_in_sel),
      .inputs_i (req_i),
      .outputs_o(req_xbar)
  );

  xbar #(
      .ELEM_WIDTH(1),
      .NUM_ELEM  (NumReq)
  ) xbar_gnt (
      .select_i (gnt_in_sel),
      .inputs_i (gnt_xbar),
      .outputs_o(gnt_o)
  );

  for (genvar i = 0; i < NumReq; i++) begin : g_req_in_sel
    assign req_in_sel[i] = i + xbar_sel;
  end

  for (genvar i = 0; i < NumReq; i++) begin : g_gnt_in_sel
    assign gnt_in_sel[i] = i + (NumReq - xbar_sel);
  end

  fixed_priority_arbiter #(
      .NUM_REQ(NumReq)
  ) fixed_priority_arbiter_dut (
      .arst_ni(arst_ni),
      .allow_req_i(allow_req_i),
      .en_i(en_i),
      .req_i(req_xbar),
      .gnt_o(gnt_xbar)
  );

  priority_encoder #(
      .NUM_INPUTS(NumReq)
  ) gnt_encode (
      .in_i  (gnt_o),
      .code_o(gnt_code)
  );

  assign gnt_found = |gnt_o;

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      xbar_sel <= '0;
    end else begin
      if (en_i & gnt_found) begin
        xbar_sel <= gnt_code + 1;
      end
    end
  end

endmodule
