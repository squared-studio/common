// ### Author : Foez Ahmed (foez.official@gmail.com))

`include "axi4/typedef.svh"
`include "vip/bus_dvr_mon.svh"

interface axi4_if #(
    parameter type req_t  = logic,
    parameter type resp_t = logic
) (
    input logic clk_i,
    input logic arst_ni
);

  req_t  req;
  resp_t resp;

  `AXI4_T(axi, $bits(req.ar.addr), $bits(resp.r.data), $bits(req.ar.id), $bits(req.aw.id),
          $bits(req.aw.user), $bits(req.w.user), $bits(resp.b.user))

  logic                          ACLK;
  logic                          ARESETn;

  logic [  $bits(req.aw.id)-1:0] AWID;
  logic [$bits(req.aw.addr)-1:0] AWADDR;
  logic [                   7:0] AWLEN;
  logic [                   2:0] AWSIZE;
  logic [                   1:0] AWBURST;
  logic [                   0:0] AWLOCK;
  logic [                   3:0] AWCACHE;
  logic [                   2:0] AWPROT;
  logic [                   3:0] AWQOS;
  logic [                   3:0] AWREGION;
  logic [$bits(req.aw.user)-1:0] AWUSER;
  logic [                   0:0] AWVALID;
  logic [                   0:0] AWREADY;

  logic [ $bits(req.w.data)-1:0] WDATA;
  logic [ $bits(req.w.strb)-1:0] WSTRB;
  logic [                   0:0] WLAST;
  logic [ $bits(req.w.user)-1:0] WUSER;
  logic [                   0:0] WVALID;
  logic [                   0:0] WREADY;

  logic [  $bits(resp.b.id)-1:0] BID;
  logic [                   1:0] BRESP;
  logic [$bits(resp.b.user)-1:0] BUSER;
  logic [                   0:0] BVALID;
  logic [                   0:0] BREADY;

  logic [  $bits(req.ar.id)-1:0] ARID;
  logic [$bits(req.ar.addr)-1:0] ARADDR;
  logic [                   7:0] ARLEN;
  logic [                   2:0] ARSIZE;
  logic [                   1:0] ARBURST;
  logic [                   0:0] ARLOCK;
  logic [                   3:0] ARCACHE;
  logic [                   2:0] ARPROT;
  logic [                   3:0] ARQOS;
  logic [                   3:0] ARREGION;
  logic [$bits(req.ar.user)-1:0] ARUSER;
  logic [                   0:0] ARVALID;
  logic [                   0:0] ARREADY;

  logic [  $bits(resp.r.id)-1:0] RID;
  logic [$bits(resp.r.data)-1:0] RDATA;
  logic [                   1:0] RRESP;
  logic [                   0:0] RLAST;
  logic [$bits(resp.r.user)-1:0] RUSER;
  logic [                   0:0] RVALID;
  logic [                   0:0] RREADY;

  assign ACLK     = clk_i;
  assign ARESETn  = arst_ni;

  assign AWID     = req.aw.id;
  assign AWADDR   = req.aw.addr;
  assign AWLEN    = req.aw.len;
  assign AWSIZE   = req.aw.size;
  assign AWBURST  = req.aw.burst;
  assign AWLOCK   = req.aw.lock;
  assign AWCACHE  = req.aw.cache;
  assign AWPROT   = req.aw.prot;
  assign AWQOS    = req.aw.qos;
  assign AWREGION = req.aw.region;
  assign AWUSER   = req.aw.user;
  assign AWVALID  = req.aw_valid;
  assign AWREADY  = resp.aw_ready;

  assign WDATA    = req.w.data;
  assign WSTRB    = req.w.strb;
  assign WLAST    = req.w.last;
  assign WUSER    = req.w.user;
  assign WVALID   = req.w_valid;
  assign WREADY   = resp.w_ready;

  assign BID      = resp.b.id;
  assign BRESP    = resp.b.resp;
  assign BUSER    = resp.b.user;
  assign BVALID   = resp.b_valid;
  assign BREADY   = req.b_ready;

  assign ARID     = req.ar.id;
  assign ARADDR   = req.ar.addr;
  assign ARLEN    = req.ar.len;
  assign ARSIZE   = req.ar.size;
  assign ARBURST  = req.ar.burst;
  assign ARLOCK   = req.ar.lock;
  assign ARCACHE  = req.ar.cache;
  assign ARPROT   = req.ar.prot;
  assign ARQOS    = req.ar.qos;
  assign ARREGION = req.ar.region;
  assign ARUSER   = req.ar.user;
  assign ARVALID  = req.ar_valid;
  assign ARREADY  = resp.ar_ready;

  assign RID      = resp.r.id;
  assign RDATA    = resp.r.data;
  assign RRESP    = resp.r.resp;
  assign RLAST    = resp.r.last;
  assign RUSER    = resp.r.user;
  assign RVALID   = resp.r_valid;
  assign RREADY   = req.r_ready;

  `HANDSHAKE_SEND_RECV_LOOK(aw, axi_aw_chan_t, clk_i, req.aw, req.aw_valid, resp.aw_ready)
  `HANDSHAKE_SEND_RECV_LOOK(w, axi_w_chan_t, clk_i, req.w, req.w_valid, resp.w_ready)
  `HANDSHAKE_SEND_RECV_LOOK(b, axi_b_chan_t, clk_i, resp.b, resp.b_valid, req.b_ready)
  `HANDSHAKE_SEND_RECV_LOOK(ar, axi_ar_chan_t, clk_i, req.ar, req.ar_valid, resp.ar_ready)
  `HANDSHAKE_SEND_RECV_LOOK(r, axi_r_chan_t, clk_i, resp.r, resp.r_valid, req.r_ready)

  task automatic manager_reset();
    disable send_aw;
    disable send_w;
    disable recv_b;
    disable send_ar;
    disable recv_r;
    req <= '0;
  endtask

  task automatic subordinate_reset();
    disable recv_aw;
    disable recv_w;
    disable send_b;
    disable recv_ar;
    disable send_r;
    resp <= '0;
  endtask

  task automatic monitor_reset();
    disable look_aw;
    disable look_w;
    disable look_b;
    disable look_ar;
    disable look_r;
  endtask

  task automatic clk_delay();
    @(posedge clk_i);
  endtask

endinterface
