// ### Author : Foez Ahmed (foez.official@gmail.com))

`include "axi4l/typedef.svh"
`include "vip/bus_dvr_mon.svh"

interface axi4l_if #(
    parameter type req_t = logic,
    parameter type rsp_t = logic
) (
    input logic clk_i,
    input logic arst_ni
);

  req_t req;
  rsp_t rsp;

  `AXI4L_T(axi, $bits(req.ar.addr), $bits(req.r.data))

  logic                          ACLK;
  logic                          ARESETn;

  logic [$bits(req.aw.addr)-1:0] AWADDR;
  logic [                   2:0] AWPROT;
  logic [                   0:0] AWVALID;
  logic [                   0:0] AWREADY;

  logic [ $bits(req.w.data)-1:0] WDATA;
  logic [ $bits(req.w.strb)-1:0] WSTRB;
  logic [                   0:0] WVALID;
  logic [                   0:0] WREADY;

  logic [                   1:0] BRESP;
  logic [                   0:0] BVALID;
  logic [                   0:0] BREADY;

  logic [$bits(req.ar.addr)-1:0] ARADDR;
  logic [                   2:0] ARPROT;
  logic [                   0:0] ARVALID;
  logic [                   0:0] ARREADY;

  logic [ $bits(rsp.r.data)-1:0] RDATA;
  logic [                   1:0] RRESP;
  logic [                   0:0] RVALID;
  logic [                   0:0] RREADY;

  assign ACLK    = clk_i;
  assign ARESETn = arst_ni;

  assign AWADDR  = req.aw.addr ;
  assign AWPROT  = req.aw.prot ;
  assign AWVALID = req.aw_valid;
  assign AWREADY = rsp.aw_ready;

  assign WDATA   = req.w.data  ;
  assign WSTRB   = req.w.strb  ;
  assign WVALID  = req.w_valid ;
  assign WREADY  = rsp.w_ready ;

  assign BRESP   = rsp.b.resp  ;
  assign BVALID  = rsp.b_valid ;
  assign BREADY  = req.b_ready ;

  assign ARADDR  = req.ar.addr ;
  assign ARPROT  = req.ar.prot ;
  assign ARVALID = req.ar_valid;
  assign ARREADY = rsp.ar_ready;

  assign RDATA   = rsp.r.data  ;
  assign RRESP   = rsp.r.resp  ;
  assign RVALID  = rsp.r_valid ;
  assign RREADY  = req.r_ready ;

  `HANDSHAKE_SEND_RECV_LOOK(aw, axi_aw_chan_t, clk_i, req.aw, req.aw_valid, rsp.aw_ready)
  `HANDSHAKE_SEND_RECV_LOOK(w, axi_w_chan_t, clk_i, req.w, req.w_valid, rsp.w_ready)
  `HANDSHAKE_SEND_RECV_LOOK(b, axi_b_chan_t, clk_i, rsp.b, rsp.b_valid, req.b_ready)
  `HANDSHAKE_SEND_RECV_LOOK(ar, axi_ar_chan_t, clk_i, req.ar, req.ar_valid, rsp.ar_ready)
  `HANDSHAKE_SEND_RECV_LOOK(r, axi_r_chan_t, clk_i, rsp.r, rsp.r_valid, req.r_ready)

endinterface
