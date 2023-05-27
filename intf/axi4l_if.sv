interface axi4l_if #(
  parameter int ADDR_WIDTH,
  parameter int DATA_WIDTH
) (
  input logic ACLK,
  input logic ARESETn
);

  logic [ADDR_WIDTH-1:0] AWADDR;
  logic [2:0]            AWPROT;
  logic [0:0]            AWVALID;
  logic [0:0]            AWREADY;

  logic [DATA_WIDTH-1:0]   WDATA;
  logic [DATA_WIDTH/8-1:0] WSTRB;
  logic [0:0]              WVALID;
  logic [0:0]              WREADY;

  logic [1:0] BRESP;
  logic [0:0] BVALID;
  logic [0:0] BREADY;

  logic [ADDR_WIDTH-1:0] ARADDR;
  logic [2:0]            ARPROT;
  logic [0:0]            ARVALID;
  logic [0:0]            ARREADY;

  logic [DATA_WIDTH-1:0] RDATA;
  logic [1:0]            RRESP;
  logic [0:0]            RVALID;
  logic [0:0]            RREADY;


  modport manager(
      input ACLK,
      input ARESETn,
      output AWADDR,
      output AWPROT,
      output AWVALID,
      input AWREADY,
      output WDATA,
      output WSTRB,
      output WVALID,
      input WREADY,
      input BRESP,
      input BVALID,
      output BREADY,
      output ARADDR,
      output ARVALID,
      input ARREADY,
      input RDATA,
      input RRESP,
      input RVALID,
      output RREADY
  );

  modport subordinate(
    input AWADDR,
    input AWPROT,
    input AWVALID,
    output AWREADY,
    input WDATA,
    input WSTRB,
    input WVALID,
    output WREADY,
    output BRESP,
    output BVALID,
    input BREADY,
    input ARADDR,
    input ARVALID,
    output ARREADY,
    output RDATA,
    output RRESP,
    output RVALID,
    input RREADY
  );

  modport monitor(
    input ACLK,
    input ARESETn,
    input AWADDR,
    input AWPROT,
    input AWVALID,
    input AWREADY,
    input WDATA,
    input WSTRB,
    input WVALID,
    input WREADY,
    input BRESP,
    input BVALID,
    input BREADY,
    input ARADDR,
    input ARVALID,
    input ARREADY,
    input RDATA,
    input RRESP,
    input RVALID,
    input RREADY
  );

endinterface
