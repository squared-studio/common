interface axi4l_if #(
    parameter type axi_req_t = logic,
    parameter type axi_rsp_t = logic
) (
    // verilog_linter: off
    input logic ACLK,
    input logic ARESETn
    // verilog_linter: on
);

  // modport manager(input clk_i, input arst_ni, output req, input rsp);

  // modport subordinate(input clk_i, input arst_ni, input req, output rsp);

  // modport monitor(input clk_i, input arst_ni, input req, input rsp);

endinterface
