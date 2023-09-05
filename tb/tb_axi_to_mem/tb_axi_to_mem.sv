module tb_axi_to_mem;

//-INCLUDE

`include "common_cells/registers.svh"
`include "axi_pkg.sv"
`include "include/assign.svh"
`include "include/typedef.svh"

//-IMPORTS

import axi_pkg::*;

//-LOCALPARAMS

/// AXI4+ATOP request type. See `include/axi/typedef.svh`.
localparam type         axi_req_t  = logic;
/// AXI4+ATOP response type. See `include/axi/typedef.svh`.
localparam type         axi_resp_t = logic;
/// Address width, has to be less or equal than the width off the AXI address field.
/// Determines the width of `mem_addr_o`. Has to be wide enough to emit the memory region
/// which should be accessible.
localparam int unsigned AddrWidth  = 0;
/// AXI4+ATOP data width.
localparam int unsigned DataWidth  = 0;
/// AXI4+ATOP ID width.
localparam int unsigned IdWidth    = 0;
/// Number of banks at output, must evenly divide `DataWidth`.
localparam int unsigned NumBanks   = 0;
/// Depth of memory response buffer. This should be equal to the memory response latency.
localparam int unsigned BufDepth   = 1;
/// Hide write requests if the strb == '0
localparam bit          HideStrb   = 1'b0;
/// Depth of output fifo/fall_through_register. Increase for asymmetric backpressure (contention) on banks.
localparam int unsigned OutFifoDepth = 1;

//-SIGNALS

/// Clock input.
logic                           clk_i;
/// Asynchronous reset, active low.
logic                           rst_ni;
/// The unit is busy handling an AXI4+ATOP request.
logic                           busy_o;
/// AXI4+ATOP slave port, request input.
axi_req_t                       axi_req_i;
/// AXI4+ATOP slave port, response output.
axi_resp_t                      axi_resp_o;
/// Memory stream master, request is valid for this bank.
logic           [NumBanks-1:0]  mem_req_o;
/// Memory stream master, request can be granted by this bank.
logic           [NumBanks-1:0]  mem_gnt_i;
/// Memory stream master, byte address of the request.
addr_t          [NumBanks-1:0]  mem_addr_o;
/// Memory stream master, write data for this bank. Valid when `mem_req_o`.
mem_data_t      [NumBanks-1:0]  mem_wdata_o;
/// Memory stream master, byte-wise strobe (byte enable).
mem_strb_t      [NumBanks-1:0]  mem_strb_o;
/// Memory stream master, `axi_pkg::atop_t` signal associated with this request.
axi_pkg::atop_t [NumBanks-1:0]  mem_atop_o;
/// Memory stream master, write enable. Then asserted store of `mem_w_data` is requested.
logic           [NumBanks-1:0]  mem_we_o;
/// Memory stream master, response is valid. This module expects always a response valid for a
/// request regardless if the request was a write or a read.
logic           [NumBanks-1:0]  mem_rvalid_i;
/// Memory stream master, read response data.
mem_data_t      [NumBanks-1:0]  mem_rdata_i;

//-RTL

axi_to_mem #(
  .AddrWidth(AddrWidth),
  .DataWidth(DataWidth),
  .IdWidth(IdWidth),
  .NumBanks(NumBanks),
  .BufDepth(BufDepth),
  .HideStrb(HideStrb),
  .OutFifoDepth(OutFifoDepth)
) u_axi_to_mem (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .busy_o(busy_o),
  .axi_req_i(axi_req_i),
  .axi_resp_o(axi_resp_o),
  .mem_req_o(mem_req_o),
  .mem_gnt_i(mem_gnt_i),
  .mem_addr_o(mem_addr_o),
  .mem_wdata_o(mem_wdata_o),
  .mem_strb_o(mem_strb_o),
  .mem_atop_o(mem_atop_o),
  .mem_we_o(mem_we_o),
  .mem_rvalid_i(mem_rvalid_i),
  .mem_rdata_i(mem_rdata_i)
);

endmodule
