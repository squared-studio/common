/*
The `axi_fifo` module is a parameterized module that creates FIFOs (First-In-First-Out) for AXI
(Advanced eXtensible Interface) transactions. It is designed to handle different types of AXI
transactions, including AW (Address Write), W (Write), B (Write Response), AR (Address Read), and
R (Read) channels.

**AW FIFO (`u_fifo_aw`)**: This FIFO handles the AW (Address Write) channel. It takes in AW
requests from `req_i.aw` and sends them out to `req_o.aw`. The validity of the input and output
requests are controlled by `req_i.aw_valid` and `req_o.aw_valid`, respectively. The readiness of
the output and input requests are controlled by `resp_o.aw_ready` and `resp_i.aw_ready`,
respectively.

**W FIFO (`u_fifo_w`)**: This FIFO handles the W (Write) channel. It operates similarly to the AW
FIFO, but for the W requests.

**B FIFO (`u_fifo_b`)**: This FIFO handles the B (Write Response) channel. It takes in B responses
from `resp_i.b` and sends them out to `resp_o.b`. The validity of the input and output responses
are controlled by `resp_i.b_valid` and `resp_o.b_valid`, respectively. The readiness of the output
and input responses are controlled by `req_o.b_ready` and `req_i.b_ready`, respectively.

**AR FIFO (`u_fifo_ar`)**: This FIFO handles the AR (Address Read) channel. It operates similarly
to the AW FIFO, but for the AR requests.

**R FIFO (`u_fifo_r`)**: This FIFO handles the R (Read) channel. It operates similarly to the B
FIFO, but for the R responses.

Each FIFO is created using the `fifo` module, which is a generic FIFO module. The depth and element
width of each FIFO are parameterized. The depth of each FIFO is set by the parameters
`AW_FIFO_DEPTH`, `W_FIFO_DEPTH`, `B_FIFO_DEPTH`, `AR_FIFO_DEPTH`, and `R_FIFO_DEPTH`. The element
width of each FIFO is determined by the bit width of the corresponding request or response.

The `axi_fifo` module operates synchronously with the clock signal `clk_i` and can be reset by the
active low reset signal `arst_ni`.

Author : Foez Ahmed (foez.official@gmail.com)
*/
`include "default_param_pkg.sv"

module axi_fifo #(
    // type of the AXI request
    parameter type axi_req_t    = default_param_pkg::axi4l_req_t,
    // type of the AXI response
    parameter type axi_resp_t   = default_param_pkg::axi4l_resp_t,
    // depth of the Address Write (AW) FIFO
    parameter int AW_FIFO_DEPTH = 4,
    // depth of the Write (W) FIFO
    parameter int W_FIFO_DEPTH  = 4,
    // depth of the Write Response (B) FIFO
    parameter int B_FIFO_DEPTH  = 4,
    // depth of the Address Read (AR) FIFO
    parameter int AR_FIFO_DEPTH = 4,
    // depth of the Read (R) FIFO
    parameter int R_FIFO_DEPTH  = 4
) (
    // clock input
    input logic clk_i,
    // asynchronous active low reset input
    input logic arst_ni,

    // AXI request input
    input  axi_req_t  req_i,
    // AXI response output
    output axi_resp_t resp_o,

    // AXI request output
    output axi_req_t  req_o,
    // AXI response input
    input  axi_resp_t resp_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  fifo #(
      .ELEM_WIDTH($bits(req_i.aw)),
      .DEPTH(AW_FIFO_DEPTH)
  ) u_fifo_aw (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .elem_in_i(req_i.aw),
      .elem_in_valid_i(req_i.aw_valid),
      .elem_in_ready_o(resp_o.aw_ready),
      .elem_out_o(req_o.aw),
      .elem_out_valid_o(req_o.aw_valid),
      .elem_out_ready_i(resp_i.aw_ready),
      .el_cnt_o()
  );

  fifo #(
      .ELEM_WIDTH($bits(req_i.w)),
      .DEPTH(W_FIFO_DEPTH)
  ) u_fifo_w (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .elem_in_i(req_i.w),
      .elem_in_valid_i(req_i.w_valid),
      .elem_in_ready_o(resp_o.w_ready),
      .elem_out_o(req_o.w),  // TODO
      .elem_out_valid_o(req_o.w_valid),  // TODO
      .elem_out_ready_i(resp_i.w_ready),  // TODO
      .el_cnt_o()
  );

  fifo #(
      .ELEM_WIDTH($bits(resp_o.b)),
      .DEPTH(B_FIFO_DEPTH)
  ) u_fifo_b (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .elem_in_i(resp_i.b),
      .elem_in_valid_i(resp_i.b_valid),
      .elem_in_ready_o(req_o.b_ready),
      .elem_out_o(resp_o.b),
      .elem_out_valid_o(resp_o.b_valid),
      .elem_out_ready_i(req_i.b_ready),
      .el_cnt_o()
  );

  fifo #(
      .ELEM_WIDTH($bits(req_i.ar)),
      .DEPTH(AR_FIFO_DEPTH)
  ) u_fifo_ar (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .elem_in_i(req_i.ar),
      .elem_in_valid_i(req_i.ar_valid),
      .elem_in_ready_o(resp_o.ar_ready),
      .elem_out_o(req_o.ar),
      .elem_out_valid_o(req_o.ar_valid),
      .elem_out_ready_i(resp_i.ar_ready),
      .el_cnt_o()
  );

  fifo #(
      .ELEM_WIDTH($bits(resp_o.r)),
      .DEPTH(R_FIFO_DEPTH)
  ) u_fifo_r (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .elem_in_i(resp_i.r),
      .elem_in_valid_i(resp_i.r_valid),
      .elem_in_ready_o(req_o.r_ready),
      .elem_out_o(resp_o.r),
      .elem_out_valid_o(resp_o.r_valid),
      .elem_out_ready_i(req_i.r_ready),
      .el_cnt_o()
  );
endmodule
