// ### Author : Foez Ahmed (foez.official@gmail.com))

package axi4_pkg;

  `include "axi4/typedef.svh"


  class axi4_seq_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter int USER_REQ_WIDTH = 0,
      parameter int USER_DATA_WIDTH = 0,
      parameter int USER_RESP_WIDTH = 0
  );

    localparam bit [1:0] FIXED = 0;
    localparam bit [1:0] INCR = 1;
    localparam bit [1:0] WRAP = 2;

    rand bit [                0:0] TYPE;
    rand bit [     ADDR_WIDTH-1:0] ADDR;
    rand bit [                7:0] LEN;
    rand bit [                2:0] SIZE;
    rand bit [                1:0] BURST;
    rand bit [                0:0] LOCK;
    rand bit [                3:0] CACHE;
    rand bit [                2:0] PROT;
    rand bit [                3:0] QOS;
    rand bit [                3:0] REGION;
    rand bit [ USER_REQ_WIDTH-1:0] USER_REQ;
    rand bit [USER_DATA_WIDTH-1:0] USER_DATA;
    bit      [                7:0] DATA      [$:4095];
    bit      [                0:0] STRB      [$:4095];

    constraint burst_c {BURST inside {FIXED, INCR, WRAP};}

    constraint wrap_c {
      if (BURST==WRAP) LEN inside {1, 3, 5, 7, 15};
    }

  endclass

  class axi4_rsp_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter int ID_R_WIDTH = 0,
      parameter int ID_W_WIDTH = 0,
      parameter int USER_REQ_WIDTH = 0,
      parameter int USER_DATA_WIDTH = 0,
      parameter int USER_RESP_WIDTH = 0
  ) extends axi4_seq_item #(
      .ADDR_WIDTH     (ADDR_WIDTH),
      .DATA_WIDTH     (DATA_WIDTH),
      .USER_REQ_WIDTH (USER_REQ_WIDTH),
      .USER_DATA_WIDTH(USER_DATA_WIDTH),
      .USER_RESP_WIDTH(USER_RESP_WIDTH)
  );

    localparam int MaxIDWidth = (ID_R_WIDTH > ID_W_WIDTH) ? ID_R_WIDTH : ID_W_WIDTH;

    bit    [    MaxIDWidth-1:0] ID;
    bit    [               1:0] RESP;
    bit    [USER_REQ_WIDTH-1:0] USER_RESP;
    bit    [              63:0] AX_CLK;
    bit    [              63:0] X_CLK     [$:255];
    bit    [              63:0] RESP_CLK;
    string                      NOTES;

  endclass

  class axi4_driver #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter int ID_R_WIDTH = 0,
      parameter int ID_W_WIDTH = 0,
      parameter int USER_REQ_WIDTH = 0,
      parameter int USER_DATA_WIDTH = 0,
      parameter int USER_RESP_WIDTH = 0
  );

    virtual axi4_if #(
        .ADDR_WIDTH     (ADDR_WIDTH),
        .DATA_WIDTH     (DATA_WIDTH),
        .ID_R_WIDTH     (ID_R_WIDTH),
        .ID_W_WIDTH     (ID_W_WIDTH),
        .USER_REQ_WIDTH (USER_REQ_WIDTH),
        .USER_DATA_WIDTH(USER_DATA_WIDTH),
        .USER_RESP_WIDTH(USER_RESP_WIDTH)
    ) intf;

    `AXI4_T(this, ADDR_WIDTH, DATA_WIDTH, ID_R_WIDTH, ID_W_WIDTH, USER_REQ_WIDTH, USER_DATA_WIDTH,
            USER_RESP_WIDTH)

  endclass

  class axi4_monitor #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter int ID_R_WIDTH = 0,
      parameter int ID_W_WIDTH = 0,
      parameter int USER_REQ_WIDTH = 0,
      parameter int USER_DATA_WIDTH = 0,
      parameter int USER_RESP_WIDTH = 0
  );

    virtual axi4_if #(
        .ADDR_WIDTH     (ADDR_WIDTH),
        .DATA_WIDTH     (DATA_WIDTH),
        .ID_R_WIDTH     (ID_R_WIDTH),
        .ID_W_WIDTH     (ID_W_WIDTH),
        .USER_REQ_WIDTH (USER_REQ_WIDTH),
        .USER_DATA_WIDTH(USER_DATA_WIDTH),
        .USER_RESP_WIDTH(USER_RESP_WIDTH)
    ) intf;

    `AXI4_T(this, ADDR_WIDTH, DATA_WIDTH, ID_R_WIDTH, ID_W_WIDTH, USER_REQ_WIDTH, USER_DATA_WIDTH,
            USER_RESP_WIDTH)

  endclass

endpackage
