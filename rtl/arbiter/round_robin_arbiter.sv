////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                  clk_i             arst_ni
                ---↓-------------------↓---
               ¦                           ¦
[NumReq] req_i →    round_robin_arbiter    → [NumReq] gnt_o
               ¦                           ¦
                ---------------------------
*/

module round_robin_arbiter #(
    parameter int Clog2NumReq = 2,
    localparam int NumReq = (2 ** Clog2NumReq)
) (
    input  logic              clk_i,
    input  logic              arst_ni,
    input  logic              allow_req_i,
    input  logic              en_i,
    input  logic [NumReq-1:0] req_i,
    output logic [NumReq-1:0] gnt_o
);

  logic [Clog2NumReq-1:0] xbar_sel;

  logic [NumReq-1:0][Clog2NumReq-1:0] req_in_sel;
  logic [NumReq-1:0][Clog2NumReq-1:0] gnt_in_sel;

  logic [NumReq-1:0] req_xbar;
  logic [NumReq-1:0] gnt_xbar;

  logic [Clog2NumReq-1:0] gnt_code;

  logic gnt_found;

  xbar #(
      .ElemWidth(1),
      .NumElem  (NumReq)
  ) xbar_req (
      .input_select_i(req_in_sel),
      .inputs_i      (req_i),
      .outputs_o     (req_xbar)
  );

  xbar #(
      .ElemWidth(1),
      .NumElem  (NumReq)
  ) xbar_gnt (
      .input_select_i(gnt_in_sel),
      .inputs_i      (gnt_xbar),
      .outputs_o     (gnt_o)
  );

  for (genvar i = 0; i < NumReq; i++) begin : g_req_in_sel
    assign req_in_sel[i] = i + xbar_sel;
  end

  for (genvar i = 0; i < NumReq; i++) begin : g_gnt_in_sel
    assign gnt_in_sel[i] = i + (NumReq - xbar_sel);
  end

  fixed_priority_arbiter #(
      .NumReq(NumReq)
  ) fixed_priority_arbiter_dut (
      .arst_ni(arst_ni),
      .allow_req_i(allow_req_i),
      .en_i(en_i),
      .req_i(req_i),
      .gnt_o(gnt_o)
  );

  priority_encoder #(
      .NumInputs(NumReq)
  ) gnt_encode (
      .in_i  (gnt_o),
      .code_o(gnt_code)
  );

  assign gnt_found = |gnt_o;

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      xbar_sel <= '0;
    end else begin
      if (gnt_found) begin
        xbar_sel <= gnt_code + 1;
      end
    end
  end

endmodule
