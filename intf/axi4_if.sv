// ### Author : Foez Ahmed (foez.official@gmail.com))

`include "axi4_typedef.svh"
`include "vip/bus_dvr_mon.svh"

interface axi4_if #(
    parameter int ADDR_WIDTH      = 64,
    parameter int DATA_WIDTH      = 1024,
    parameter int ID_R_WIDTH      = 3,
    parameter int ID_W_WIDTH      = 2,
    parameter int USER_REQ_WIDTH  = 8,
    parameter int USER_DATA_WIDTH = 4,
    parameter int USER_RESP_WIDTH = 2
) (
    input logic clk_i,
    input logic arst_ni
);

  `AXI4_T(axi, ADDR_WIDTH, DATA_WIDTH, ID_R_WIDTH, ID_W_WIDTH, USER_REQ_WIDTH, USER_DATA_WIDTH,
          USER_RESP_WIDTH)

  axi_req_t                                          req;
  axi_resp_t                                         resp;

  logic                                              ACLK;
  logic                                              ARESETn;

  logic      [                       ID_W_WIDTH-1:0] AWID;
  logic      [                       ADDR_WIDTH-1:0] AWADDR;
  logic      [                                  7:0] AWLEN;
  logic      [                                  2:0] AWSIZE;
  logic      [                                  1:0] AWBURST;
  logic      [                                  0:0] AWLOCK;
  logic      [                                  3:0] AWCACHE;
  logic      [                                  2:0] AWPROT;
  logic      [                                  3:0] AWQOS;
  logic      [                                  3:0] AWREGION;
  logic      [                   USER_REQ_WIDTH-1:0] AWUSER;
  logic      [                                  0:0] AWVALID;
  logic      [                                  0:0] AWREADY;

  logic      [                       DATA_WIDTH-1:0] WDATA;
  logic      [                     DATA_WIDTH/8-1:0] WSTRB;
  logic      [                                  0:0] WLAST;
  logic      [                  USER_DATA_WIDTH-1:0] WUSER;
  logic      [                                  0:0] WVALID;
  logic      [                                  0:0] WREADY;

  logic      [                       ID_W_WIDTH-1:0] BID;
  logic      [                                  1:0] BRESP;
  logic      [                  USER_RESP_WIDTH-1:0] BUSER;
  logic      [                                  0:0] BVALID;
  logic      [                                  0:0] BREADY;

  logic      [                       ID_R_WIDTH-1:0] ARID;
  logic      [                       ADDR_WIDTH-1:0] ARADDR;
  logic      [                                  7:0] ARLEN;
  logic      [                                  2:0] ARSIZE;
  logic      [                                  1:0] ARBURST;
  logic      [                                  0:0] ARLOCK;
  logic      [                                  3:0] ARCACHE;
  logic      [                                  2:0] ARPROT;
  logic      [                                  3:0] ARQOS;
  logic      [                                  3:0] ARREGION;
  logic      [                   USER_REQ_WIDTH-1:0] ARUSER;
  logic      [                                  0:0] ARVALID;
  logic      [                                  0:0] ARREADY;

  logic      [                       ID_R_WIDTH-1:0] RID;
  logic      [                       DATA_WIDTH-1:0] RDATA;
  logic      [                                  1:0] RRESP;
  logic      [                                  0:0] RLAST;
  logic      [(USER_DATA_WIDTH+USER_RESP_WIDTH)-1:0] RUSER;
  logic      [                                  0:0] RVALID;
  logic      [                                  0:0] RREADY;

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

  `define BUS_RESET_AXI4_IF(__SIGNAL__)                                                            \
    if (``__SIGNAL__`` !== '0) begin                                                               \
      $display(`"%m applying autoreset for ``__SIGNAL__``    `");                                  \
      ``__SIGNAL__`` <= '0;                                                                        \
    end                                                                                            \

  always @(negedge arst_ni) begin
    #1;
    `BUS_RESET_AXI4_IF(req.aw.id)
    `BUS_RESET_AXI4_IF(req.aw.addr)
    `BUS_RESET_AXI4_IF(req.aw.len)
    `BUS_RESET_AXI4_IF(req.aw.size)
    `BUS_RESET_AXI4_IF(req.aw.burst)
    `BUS_RESET_AXI4_IF(req.aw.lock)
    `BUS_RESET_AXI4_IF(req.aw.cache)
    `BUS_RESET_AXI4_IF(req.aw.prot)
    `BUS_RESET_AXI4_IF(req.aw.qos)
    `BUS_RESET_AXI4_IF(req.aw.region)
    `BUS_RESET_AXI4_IF(req.aw.user)
    `BUS_RESET_AXI4_IF(req.aw_valid)
    `BUS_RESET_AXI4_IF(resp.aw_ready)
    `BUS_RESET_AXI4_IF(req.w.data)
    `BUS_RESET_AXI4_IF(req.w.strb)
    `BUS_RESET_AXI4_IF(req.w.last)
    `BUS_RESET_AXI4_IF(req.w.user)
    `BUS_RESET_AXI4_IF(req.w_valid)
    `BUS_RESET_AXI4_IF(resp.w_ready)
    `BUS_RESET_AXI4_IF(resp.b.id)
    `BUS_RESET_AXI4_IF(resp.b.resp)
    `BUS_RESET_AXI4_IF(resp.b.user)
    `BUS_RESET_AXI4_IF(resp.b_valid)
    `BUS_RESET_AXI4_IF(req.b_ready)
    `BUS_RESET_AXI4_IF(req.ar.id)
    `BUS_RESET_AXI4_IF(req.ar.addr)
    `BUS_RESET_AXI4_IF(req.ar.len)
    `BUS_RESET_AXI4_IF(req.ar.size)
    `BUS_RESET_AXI4_IF(req.ar.burst)
    `BUS_RESET_AXI4_IF(req.ar.lock)
    `BUS_RESET_AXI4_IF(req.ar.cache)
    `BUS_RESET_AXI4_IF(req.ar.prot)
    `BUS_RESET_AXI4_IF(req.ar.qos)
    `BUS_RESET_AXI4_IF(req.ar.region)
    `BUS_RESET_AXI4_IF(req.ar.user)
    `BUS_RESET_AXI4_IF(req.ar_valid)
    `BUS_RESET_AXI4_IF(resp.ar_ready)
    `BUS_RESET_AXI4_IF(resp.r.id)
    `BUS_RESET_AXI4_IF(resp.r.data)
    `BUS_RESET_AXI4_IF(resp.r.resp)
    `BUS_RESET_AXI4_IF(resp.r.last)
    `BUS_RESET_AXI4_IF(resp.r.user)
    `BUS_RESET_AXI4_IF(resp.r_valid)
    `BUS_RESET_AXI4_IF(req.r_ready)
  end

  task automatic manager_reset();
    disable send_aw;
    disable send_w;
    disable recv_b;
    disable send_ar;
    disable recv_r;
    aw_send_id = '0;
    aw_send_queue.delete();
    w_send_id = '0;
    w_send_queue.delete();
    b_recv_id = '0;
    b_recv_queue.delete();
    ar_send_id = '0;
    ar_send_queue.delete();
    r_recv_id = '0;
    r_recv_queue.delete();
    req <= '0;
  endtask

  task automatic subordinate_reset();
    disable recv_aw;
    disable recv_w;
    disable send_b;
    disable recv_ar;
    disable send_r;
    aw_recv_id = '0;
    aw_recv_queue.delete();
    w_recv_id = '0;
    w_recv_queue.delete();
    b_send_id = '0;
    b_send_queue.delete();
    ar_recv_id = '0;
    ar_recv_queue.delete();
    r_send_id = '0;
    r_send_queue.delete();
    resp <= '0;
  endtask

  task automatic monitor_reset();
    disable look_aw;
    disable look_w;
    disable look_b;
    disable look_ar;
    disable look_r;
    aw_look_id = '0;
    aw_look_queue.delete();
    w_look_id = '0;
    w_look_queue.delete();
    b_look_id = '0;
    b_look_queue.delete();
    ar_look_id = '0;
    ar_look_queue.delete();
    r_look_id = '0;
    r_look_queue.delete();
  endtask

  task automatic clk_edge(bit invert = 0);
    if (invert) @(negedge clk_i);
    else @(posedge clk_i);
  endtask

endinterface
