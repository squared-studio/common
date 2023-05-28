// ### Author : Foez Ahmed (foez.official@gmail.com))

package axi4l_pkg;

  `include "axi4l/typedef.svh"

  class axi4_seq_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  );

    rand bit [                0:0] TYPE;
    rand bit [     ADDR_WIDTH-1:0] ADDR;
    rand bit [                2:0] PROT;
    bit      [                7:0] DATA      [$:127];
    bit      [                0:0] STRB      [$:127];

  endclass

  class axi4l_rsp_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  ) extends axi4_seq_item #(
      .ADDR_WIDTH     (ADDR_WIDTH),
      .DATA_WIDTH     (DATA_WIDTH)
  );

    bit    [               1:0] RESP;
    bit    [              63:0] AX_CLK;
    bit    [              63:0] X_CLK [$:(1-1)];
    bit    [              63:0] RESP_CLK;
    string                      NOTES;

  endclass

  class axi4_driver #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  );

    virtual axi4l_if #(
        .ADDR_WIDTH     (ADDR_WIDTH),
        .DATA_WIDTH     (DATA_WIDTH)
    ) intf;

    `AXI4L_T(this, ADDR_WIDTH, DATA_WIDTH)

  endclass

  class axi4_monitor #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  );

    virtual axi4l_if #(
        .ADDR_WIDTH     (ADDR_WIDTH),
        .DATA_WIDTH     (DATA_WIDTH)
    ) intf;

    `AXI4L_T(this, ADDR_WIDTH, DATA_WIDTH)

    this_req_t req;

  endclass

endpackage
