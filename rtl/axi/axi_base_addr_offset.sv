////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                                   ---------------------------
                                  ¦                           ¦
[ManAddrWidth] base_addr_offset_i →                           ¦
                                  ¦    axi_base_addr_offset   ¦
            [man_req_t] man_req_i →                           → [sub_req_t] sub_req_o
                                  ¦                           ¦
                                   ---------------------------
*/

module axi_base_addr_offset #(
    parameter type man_req_t = logic,
    parameter type sub_req_t = logic,
    parameter int ManAddrWidth = 64
) (
    input  logic     [ManAddrWidth-1:0] base_addr_offset_i,
    input  man_req_t                    man_req_i,
    output sub_req_t                    sub_req_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [ManAddrWidth-1:0] wr_addr;
  logic [ManAddrWidth-1:0] rd_addr;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign wr_addr             = man_req_i.aw.addr - base_addr_offset_i;
  assign rd_addr             = man_req_i.ar.addr - base_addr_offset_i;

  assign sub_req_i.aw.id     = man_req_i.aw.id;
  assign sub_req_i.aw.addr   = wr_addr;
  assign sub_req_i.aw.len    = man_req_i.aw.len;
  assign sub_req_i.aw.size   = man_req_i.aw.size;
  assign sub_req_i.aw.burst  = man_req_i.aw.burst;
  assign sub_req_i.aw.lock   = man_req_i.aw.lock;
  assign sub_req_i.aw.cache  = man_req_i.aw.cache;
  assign sub_req_i.aw.prot   = man_req_i.aw.prot;
  assign sub_req_i.aw.qos    = man_req_i.aw.qos;
  assign sub_req_i.aw.region = man_req_i.aw.region;
  assign sub_req_i.aw.user   = man_req_i.aw.user;

  assign sub_req_i.aw_valid  = man_req_i.aw_valid;

  assign sub_req_i.w         = man_req_i.w;

  assign sub_req_i.w_valid   = man_req_i.w_valid;

  assign sub_req_i.b_ready   = man_req_i.b_ready;

  assign sub_req_i.ar.id     = man_req_i.ar.id;
  assign sub_req_i.ar.addr   = rd_addr;
  assign sub_req_i.ar.len    = man_req_i.ar.len;
  assign sub_req_i.ar.size   = man_req_i.ar.size;
  assign sub_req_i.ar.burst  = man_req_i.ar.burst;
  assign sub_req_i.ar.lock   = man_req_i.ar.lock;
  assign sub_req_i.ar.cache  = man_req_i.ar.cache;
  assign sub_req_i.ar.prot   = man_req_i.ar.prot;
  assign sub_req_i.ar.qos    = man_req_i.ar.qos;
  assign sub_req_i.ar.region = man_req_i.ar.region;
  assign sub_req_i.ar.user   = man_req_i.ar.user;

  assign sub_req_i.ar_valid  = man_req_i.ar_valid;

  assign sub_req_i.r_ready   = man_req_i.r_ready;

endmodule
