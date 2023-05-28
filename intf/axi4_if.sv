// ### Author : Foez Ahmed (foez.official@gmail.com))

interface axi4_if #(
    parameter int ADDR_WIDTH,
    parameter int DATA_WIDTH,
    parameter int ID_R_WIDTH,
    parameter int ID_W_WIDTH,
    parameter int USER_REQ_WIDTH,
    parameter int USER_DATA_WIDTH,
    parameter int USER_RESP_WIDTH
) (
    input logic ACLK,
    input logic ARESETn
);

  logic [ID_W_WIDTH-1:0]     AWID;
  logic [ADDR_WIDTH-1:0]     AWADDR;
  logic [7:0]                AWLEN;
  logic [2:0]                AWSIZE;
  logic [1:0]                AWBURST;
  logic [0:0]                AWLOCK;
  logic [3:0]                AWCACHE;
  logic [2:0]                AWPROT;
  logic [3:0]                AWQOS;
  logic [3:0]                AWREGION;
  logic [USER_REQ_WIDTH-1:0] AWUSER;
  logic [0:0]                AWVALID;
  logic [0:0]                AWREADY;

  logic [DATA_WIDTH-1:0]      WDATA;
  logic [DATA_WIDTH/8-1:0]    WSTRB;
  logic [0:0]                 WLAST;
  logic [USER_DATA_WIDTH-1:0] WUSER;
  logic [0:0]                 WVALID;
  logic [0:0]                 WREADY;

  logic [ID_W_WIDTH-1:0]      BID;
  logic [1:0]                 BRESP;
  logic [USER_RESP_WIDTH-1:0] BUSER;
  logic [0:0]                 BVALID;
  logic [0:0]                 BREADY;

  logic [ID_R_WIDTH-1:0]     ARID;
  logic [ADDR_WIDTH-1:0]     ARADDR;
  logic [7:0]                ARLEN;
  logic [2:0]                ARSIZE;
  logic [1:0]                ARBURST;
  logic [0:0]                ARLOCK;
  logic [3:0]                ARCACHE;
  logic [2:0]                ARPROT;
  logic [3:0]                ARQOS;
  logic [3:0]                ARREGION;
  logic [USER_REQ_WIDTH-1:0] ARUSER;
  logic [0:0]                ARVALID;
  logic [0:0]                ARREADY;

  logic [ID_R_WIDTH-1:0]                        RID;
  logic [DATA_WIDTH-1:0]                        RDATA;
  logic [1:0]                                   RRESP;
  logic [0:0]                                   RLAST;
  logic [(USER_DATA_WIDTH+USER_RESP_WIDTH)-1:0] RUSER;
  logic [0:0]                                   RVALID;
  logic [0:0]                                   RREADY;


  modport manager(
      input ACLK,
      input ARESETn,

      output AWID,
      output AWADDR,
      output AWLEN,
      output AWSIZE,
      output AWBURST,
      output AWLOCK,
      output AWCACHE,
      output AWPROT,
      output AWQOS,
      output AWREGION,
      output AWUSER,
      output AWVALID,
      input AWREADY,

      output WDATA,
      output WSTRB,
      output WLAST,
      output WUSER,
      output WVALID,
      input WREADY,

      input BID,
      input BRESP,
      input BUSER,
      input BVALID,
      output BREADY,

      output ARID,
      output ARADDR,
      output ARLEN,
      output ARSIZE,
      output ARBURST,
      output ARLOCK,
      output ARCACHE,
      output ARPROT,
      output ARQOS,
      output ARREGION,
      output ARUSER,
      output ARVALID,
      input ARREADY,

      input RID,
      input RDATA,
      input RRESP,
      input RLAST,
      input RUSER,
      input RVALID,
      output RREADY
  );

  modport subordinate(
      input ACLK,
      input ARESETn,

      input AWID,
      input AWADDR,
      input AWLEN,
      input AWSIZE,
      input AWBURST,
      input AWLOCK,
      input AWCACHE,
      input AWPROT,
      input AWQOS,
      input AWREGION,
      input AWUSER,
      input AWVALID,
      output AWREADY,

      input WDATA,
      input WSTRB,
      input WLAST,
      input WUSER,
      input WVALID,
      output WREADY,

      output BID,
      output BRESP,
      output BUSER,
      output BVALID,
      input BREADY,

      input ARID,
      input ARADDR,
      input ARLEN,
      input ARSIZE,
      input ARBURST,
      input ARLOCK,
      input ARCACHE,
      input ARPROT,
      input ARQOS,
      input ARREGION,
      input ARUSER,
      input ARVALID,
      output ARREADY,

      output RID,
      output RDATA,
      output RRESP,
      output RLAST,
      output RUSER,
      output RVALID,
      input RREADY
  );

  modport monitor(
      input ACLK,
      input ARESETn,

      input AWID,
      input AWADDR,
      input AWLEN,
      input AWSIZE,
      input AWBURST,
      input AWLOCK,
      input AWCACHE,
      input AWPROT,
      input AWQOS,
      input AWREGION,
      input AWUSER,
      input AWVALID,
      input AWREADY,

      input WDATA,
      input WSTRB,
      input WLAST,
      input WUSER,
      input WVALID,
      input WREADY,

      input BID,
      input BRESP,
      input BUSER,
      input BVALID,
      input BREADY,

      input ARID,
      input ARADDR,
      input ARLEN,
      input ARSIZE,
      input ARBURST,
      input ARLOCK,
      input ARCACHE,
      input ARPROT,
      input ARQOS,
      input ARREGION,
      input ARUSER,
      input ARVALID,
      input ARREADY,

      input RID,
      input RDATA,
      input RRESP,
      input RLAST,
      input RUSER,
      input RVALID,
      input RREADY
  );

endinterface
