// ### Author : Foez Ahmed (foez.official@gmail.com))

`include "axi4l/typedef.svh"
`include "vip/bus_dvr_mon.svh"

interface axi4l_if #(
    parameter type req_t  = logic,
    parameter type resp_t = logic
) (
    input logic clk_i,
    input logic arst_ni
);

  req_t  req;
  resp_t resp;

  `AXI4L_T(axi, $bits(req.ar.addr), $bits(resp.r.data))

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

  logic [$bits(resp.r.data)-1:0] RDATA;
  logic [                   1:0] RRESP;
  logic [                   0:0] RVALID;
  logic [                   0:0] RREADY;

  assign ACLK    = clk_i;
  assign ARESETn = arst_ni;

  assign AWADDR  = req.aw.addr ;
  assign AWPROT  = req.aw.prot ;
  assign AWVALID = req.aw_valid;
  assign AWREADY = resp.aw_ready;

  assign WDATA   = req.w.data  ;
  assign WSTRB   = req.w.strb  ;
  assign WVALID  = req.w_valid ;
  assign WREADY  = resp.w_ready ;

  assign BRESP   = resp.b.resp  ;
  assign BVALID  = resp.b_valid ;
  assign BREADY  = req.b_ready ;

  assign ARADDR  = req.ar.addr ;
  assign ARPROT  = req.ar.prot ;
  assign ARVALID = req.ar_valid;
  assign ARREADY = resp.ar_ready;

  assign RDATA   = resp.r.data  ;
  assign RRESP   = resp.r.resp  ;
  assign RVALID  = resp.r_valid ;
  assign RREADY  = req.r_ready ;

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
