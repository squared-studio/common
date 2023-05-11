interface axi4_if #(
    parameter type axi_req_t = logic,
    parameter type axi_rsp_t = logic
) (
    input logic clk_i,
    input logic arst_ni
);

  axi_req_t req;
  axi_rsp_t rsp;

  modport manager(input clk_i, input arst_ni, output req, input rsp);

  modport subordinate(input clk_i, input arst_ni, input req, output rsp);

  modport monitor(input clk_i, input arst_ni, input req, input rsp);

endinterface
