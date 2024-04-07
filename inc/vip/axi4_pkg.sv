// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef AXI4_PKG_SV
`define AXI4_PKG_SV

package axi4_pkg;

  `include "axi4_typedef.svh"

  parameter bit [1:0] FIXED = 0;
  parameter bit [1:0] INCR = 1;
  parameter bit [1:0] WRAP = 2;

  class axi4_seq_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter int USER_REQ_WIDTH = 0,
      parameter int USER_DATA_WIDTH = 0,
      parameter int USER_RESP_WIDTH = 0
  );

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

    constraint size_c {((2 ** SIZE) * 8) <= DATA_WIDTH;}

    constraint burst_c {
      BURST inside {FIXED, INCR, WRAP};
      if (BURST == FIXED) {LEN < 16;}
      if (BURST == INCR) {
        ((2 ** SIZE) * (1 + LEN)) <= (2 ** 12);
        (((2 ** SIZE) * (1 + LEN)) - (ADDR % (2 ** SIZE))) < (2 ** 12);
      }
      if (BURST == WRAP) {
        (ADDR % (2 ** SIZE)) == 0;
        LEN inside {1, 3, 7, 15};
        ((2 ** SIZE) * (1 + LEN)) < (2 ** 12);
      }
    }

    constraint excl_access_c {
      if (LOCK == 1) {
        (ADDR % ((2 ** SIZE) * (LEN + 1))) == 0;
        LEN <= 15;
        ((2 ** SIZE) * (LEN + 1)) inside {1, 2, 4, 8, 16, 32, 64, 128};
        CACHE == 0;
      }
    }

    constraint cache_c {CACHE inside {0, 1, 2, 3, 6, 7, 10, 11, 14, 15};}

  endclass

  class axi4_resp_item #(
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

`endif
