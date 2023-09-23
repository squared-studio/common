// ### Author : Foez Ahmed (foez.official@gmail.com))

`include "axi4l_typedef.svh"
`include "vip/bus_dvr_mon.svh"

interface axi4l_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (
    input logic clk_i,
    input logic arst_ni
);

  `AXI4L_T(axi, ADDR_WIDTH, DATA_WIDTH)

  axi_req_t                     req;
  axi_resp_t                    resp;


  logic                         ACLK;
  logic                         ARESETn;

  logic      [  ADDR_WIDTH-1:0] AWADDR;
  logic      [             2:0] AWPROT;
  logic      [             0:0] AWVALID;
  logic      [             0:0] AWREADY;

  logic      [  DATA_WIDTH-1:0] WDATA;
  logic      [DATA_WIDTH/8-1:0] WSTRB;
  logic      [             0:0] WVALID;
  logic      [             0:0] WREADY;

  logic      [             1:0] BRESP;
  logic      [             0:0] BVALID;
  logic      [             0:0] BREADY;

  logic      [  ADDR_WIDTH-1:0] ARADDR;
  logic      [             2:0] ARPROT;
  logic      [             0:0] ARVALID;
  logic      [             0:0] ARREADY;

  logic      [  DATA_WIDTH-1:0] RDATA;
  logic      [             1:0] RRESP;
  logic      [             0:0] RVALID;
  logic      [             0:0] RREADY;

  assign ACLK    = clk_i;
  assign ARESETn = arst_ni;

  assign AWADDR  = req.aw.addr;
  assign AWPROT  = req.aw.prot;
  assign AWVALID = req.aw_valid;
  assign AWREADY = resp.aw_ready;

  assign WDATA   = req.w.data;
  assign WSTRB   = req.w.strb;
  assign WVALID  = req.w_valid;
  assign WREADY  = resp.w_ready;

  assign BRESP   = resp.b.resp;
  assign BVALID  = resp.b_valid;
  assign BREADY  = req.b_ready;

  assign ARADDR  = req.ar.addr;
  assign ARPROT  = req.ar.prot;
  assign ARVALID = req.ar_valid;
  assign ARREADY = resp.ar_ready;

  assign RDATA   = resp.r.data;
  assign RRESP   = resp.r.resp;
  assign RVALID  = resp.r_valid;
  assign RREADY  = req.r_ready;

  `HANDSHAKE_SEND_RECV_LOOK(aw, axi_aw_chan_t, clk_i, req.aw, req.aw_valid, resp.aw_ready)
  `HANDSHAKE_SEND_RECV_LOOK(w, axi_w_chan_t, clk_i, req.w, req.w_valid, resp.w_ready)
  `HANDSHAKE_SEND_RECV_LOOK(b, axi_b_chan_t, clk_i, resp.b, resp.b_valid, req.b_ready)
  `HANDSHAKE_SEND_RECV_LOOK(ar, axi_ar_chan_t, clk_i, req.ar, req.ar_valid, resp.ar_ready)
  `HANDSHAKE_SEND_RECV_LOOK(r, axi_r_chan_t, clk_i, resp.r, resp.r_valid, req.r_ready)

  `define BUS_RESET_AXI4L_IF(__SIGNAL__)                                                           \
    if (``__SIGNAL__`` !== '0) begin                                                               \
      $display(`"%m applying autoreset for ``__SIGNAL__``    `");                                  \
      ``__SIGNAL__`` <= '0;                                                                        \
    end                                                                                            \

  always @(negedge arst_ni) begin
    #1;
    `BUS_RESET_AXI4L_IF(req.aw.addr)
    `BUS_RESET_AXI4L_IF(req.aw.prot)
    `BUS_RESET_AXI4L_IF(req.aw_valid)
    `BUS_RESET_AXI4L_IF(resp.aw_ready)
    `BUS_RESET_AXI4L_IF(req.w.data)
    `BUS_RESET_AXI4L_IF(req.w.strb)
    `BUS_RESET_AXI4L_IF(req.w_valid)
    `BUS_RESET_AXI4L_IF(resp.w_ready)
    `BUS_RESET_AXI4L_IF(resp.b.resp)
    `BUS_RESET_AXI4L_IF(resp.b_valid)
    `BUS_RESET_AXI4L_IF(req.b_ready)
    `BUS_RESET_AXI4L_IF(req.ar.addr)
    `BUS_RESET_AXI4L_IF(req.ar.prot)
    `BUS_RESET_AXI4L_IF(req.ar_valid)
    `BUS_RESET_AXI4L_IF(resp.ar_ready)
    `BUS_RESET_AXI4L_IF(resp.r.data)
    `BUS_RESET_AXI4L_IF(resp.r.resp)
    `BUS_RESET_AXI4L_IF(resp.r_valid)
    `BUS_RESET_AXI4L_IF(req.r_ready)
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
