// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module axi_fifo #(
    parameter type axi_req_t    = default_param_pkg::axi4l_req_t,
    parameter type axi_resp_t   = default_param_pkg::axi4l_resp_t,
    parameter int AW_FIFO_DEPTH = 4,
    parameter int W_FIFO_DEPTH  = 4,
    parameter int B_FIFO_DEPTH  = 4,
    parameter int AR_FIFO_DEPTH = 4,
    parameter int R_FIFO_DEPTH  = 4
) (
    input logic clk_i,
    input logic arst_ni,

    input  axi_req_t  req_i,
    output axi_resp_t resp_o,

    output axi_req_t  req_o,
    input  axi_resp_t resp_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
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

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (DATA_WIDTH > 2) begin
      $display("\033[7;31m%m DATA_WIDTH\033[0m");
    end
  end
`endif  // SIMULATION

  //}}}

endmodule
