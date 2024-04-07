// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef AXI4L_PKG_MACROS_SVH
`define AXI4L_PKG_MACROS_SVH

`include "axi4l_assign.svh"

`define IMPORT_AXI4L_PKG_CLASSES                                                                   \
  import axi4l_pkg::axi4l_seq_item;                                                                \
  import axi4l_pkg::axi4l_resp_item;                                                               \
  import axi4l_pkg::axi4l_driver;                                                                  \
  import axi4l_pkg::axi4l_monitor;                                                                 \

`define AXI4L_VIP(__NAME__, __ROLE__, __CLK__, __ARSTN__, __REQ__, __RESP__)                       \
  /*---------------------------------------------------------------------------------------------*/\
  typedef axi4l_seq_item#(                                                                         \
      .ADDR_WIDTH($bits(``__REQ__``.aw.addr)),                                                     \
      .DATA_WIDTH($bits(``__RESP__``.r.data))                                                      \
  ) ``__NAME__``_seq_item_t;                                                                       \
  /*---------------------------------------------------------------------------------------------*/\
  typedef axi4l_resp_item#(                                                                        \
      .ADDR_WIDTH($bits(``__REQ__``.aw.addr)),                                                     \
      .DATA_WIDTH($bits(``__RESP__``.r.data))                                                      \
  ) ``__NAME__``_resp_item_t;                                                                      \
  /*---------------------------------------------------------------------------------------------*/\
  axi4l_if #(                                                                                      \
      .ADDR_WIDTH($bits(``__REQ__``.aw.addr)),                                                     \
      .DATA_WIDTH($bits(``__RESP__``.r.data))                                                      \
  ) ``__NAME__``_axi4l_if (                                                                        \
      .clk_i  (``__CLK__``),                                                                       \
      .arst_ni(``__ARSTN__``)                                                                      \
  );                                                                                               \
  /*---------------------------------------------------------------------------------------------*/\
  if (``__ROLE__``) begin : g_manager_``__NAME__``_connections                                     \
    `AXI4L_REQ_TO_REQ(assign, ``__REQ__``, ``__NAME__``_axi4l_if.req)                              \
    `AXI4L_RESP_TO_RESP(assign, ``__NAME__``_axi4l_if.resp, ``__RESP__``)                          \
  end else begin : g_subordinate_``__NAME__``_connections                                          \
    `AXI4L_REQ_TO_REQ(assign, ``__NAME__``_axi4l_if.req, ``__REQ__``)                              \
    `AXI4L_RESP_TO_RESP(assign, ``__RESP__``, ``__NAME__``_axi4l_if.resp)                          \
  end                                                                                              \
  /*---------------------------------------------------------------------------------------------*/\
  mailbox #(``__NAME__``_seq_item_t)  ``__NAME__``_dvr_mbx = new();                                \
  mailbox #(``__NAME__``_resp_item_t) ``__NAME__``_mon_mbx = new();                                \
  /*---------------------------------------------------------------------------------------------*/\
  axi4l_driver #(                                                                                  \
    .ADDR_WIDTH($bits(``__REQ__``.aw.addr)),                                                       \
    .DATA_WIDTH($bits(``__RESP__``.r.data)),                                                       \
    .ROLE(``__ROLE__``)                                                                            \
  ) ``__NAME__``_dvr = new(``__NAME__``_axi4l_if);                                                 \
  /*---------------------------------------------------------------------------------------------*/\
  axi4l_monitor #(                                                                                 \
    .ADDR_WIDTH($bits(``__REQ__``.aw.addr)),                                                       \
    .DATA_WIDTH($bits(``__RESP__``.r.data))                                                        \
  ) ``__NAME__``_mon = new(``__NAME__``_axi4l_if);                                                 \
  /*---------------------------------------------------------------------------------------------*/\
  initial begin                                                                                    \
    ``__NAME__``_dvr.mbx = ``__NAME__``_dvr_mbx;                                                   \
    ``__NAME__``_mon.mbx = ``__NAME__``_mon_mbx;                                                   \
  end                                                                                              \
  /*---------------------------------------------------------------------------------------------*/\


`endif
