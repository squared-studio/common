// ### Author : Foez Ahmed (foez.official@gmail.com)

`ifndef AXI4_ASSIGN_SVH
`define AXI4_ASSIGN_SVH

// macro for setting or assigning axi4l req to req
`define AXI4_REQ_TO_REQ(__MODE__, __DST__, __SRC__)                                                \
  ``__MODE__`` ``__DST__``.aw.id     = ``__SRC__``.aw.id     ;                                     \
  ``__MODE__`` ``__DST__``.aw.addr   = ``__SRC__``.aw.addr   ;                                     \
  ``__MODE__`` ``__DST__``.aw.len    = ``__SRC__``.aw.len    ;                                     \
  ``__MODE__`` ``__DST__``.aw.size   = ``__SRC__``.aw.size   ;                                     \
  ``__MODE__`` ``__DST__``.aw.burst  = ``__SRC__``.aw.burst  ;                                     \
  ``__MODE__`` ``__DST__``.aw.lock   = ``__SRC__``.aw.lock   ;                                     \
  ``__MODE__`` ``__DST__``.aw.cache  = ``__SRC__``.aw.cache  ;                                     \
  ``__MODE__`` ``__DST__``.aw.prot   = ``__SRC__``.aw.prot   ;                                     \
  ``__MODE__`` ``__DST__``.aw.qos    = ``__SRC__``.aw.qos    ;                                     \
  ``__MODE__`` ``__DST__``.aw.region = ``__SRC__``.aw.region ;                                     \
  ``__MODE__`` ``__DST__``.aw.user   = ``__SRC__``.aw.user   ;                                     \
  ``__MODE__`` ``__DST__``.aw_valid  = ``__SRC__``.aw_valid  ;                                     \
  ``__MODE__`` ``__DST__``.w.data    = ``__SRC__``.w.data    ;                                     \
  ``__MODE__`` ``__DST__``.w.strb    = ``__SRC__``.w.strb    ;                                     \
  ``__MODE__`` ``__DST__``.w.last    = ``__SRC__``.w.last    ;                                     \
  ``__MODE__`` ``__DST__``.w.user    = ``__SRC__``.w.user    ;                                     \
  ``__MODE__`` ``__DST__``.w_valid   = ``__SRC__``.w_valid   ;                                     \
  ``__MODE__`` ``__DST__``.b_ready   = ``__SRC__``.b_ready   ;                                     \
  ``__MODE__`` ``__DST__``.ar.id     = ``__SRC__``.ar.id     ;                                     \
  ``__MODE__`` ``__DST__``.ar.addr   = ``__SRC__``.ar.addr   ;                                     \
  ``__MODE__`` ``__DST__``.ar.len    = ``__SRC__``.ar.len    ;                                     \
  ``__MODE__`` ``__DST__``.ar.size   = ``__SRC__``.ar.size   ;                                     \
  ``__MODE__`` ``__DST__``.ar.burst  = ``__SRC__``.ar.burst  ;                                     \
  ``__MODE__`` ``__DST__``.ar.lock   = ``__SRC__``.ar.lock   ;                                     \
  ``__MODE__`` ``__DST__``.ar.cache  = ``__SRC__``.ar.cache  ;                                     \
  ``__MODE__`` ``__DST__``.ar.prot   = ``__SRC__``.ar.prot   ;                                     \
  ``__MODE__`` ``__DST__``.ar.qos    = ``__SRC__``.ar.qos    ;                                     \
  ``__MODE__`` ``__DST__``.ar.region = ``__SRC__``.ar.region ;                                     \
  ``__MODE__`` ``__DST__``.ar.user   = ``__SRC__``.ar.user   ;                                     \
  ``__MODE__`` ``__DST__``.ar_valid  = ``__SRC__``.ar_valid  ;                                     \
  ``__MODE__`` ``__DST__``.r_ready   = ``__SRC__``.r_ready   ;                                     \


// macro for setting or assigning axi4l req to req
`define AXI4_RESP_TO_RESP(__MODE__, __DST__, __SRC__)                                              \
  ``__MODE__`` ``__DST__``.aw_ready    = ``__SRC__``.aw_ready    ;                                 \
  ``__MODE__`` ``__DST__``.w_ready     = ``__SRC__``.w_ready     ;                                 \
  ``__MODE__`` ``__DST__``.b.id        = ``__SRC__``.b.id        ;                                 \
  ``__MODE__`` ``__DST__``.b.resp      = ``__SRC__``.b.resp      ;                                 \
  ``__MODE__`` ``__DST__``.b.user      = ``__SRC__``.b.user      ;                                 \
  ``__MODE__`` ``__DST__``.b_valid     = ``__SRC__``.b_valid     ;                                 \
  ``__MODE__`` ``__DST__``.ar_ready    = ``__SRC__``.ar_ready    ;                                 \
  ``__MODE__`` ``__DST__``.r.id        = ``__SRC__``.r.id        ;                                 \
  ``__MODE__`` ``__DST__``.r.data      = ``__SRC__``.r.data      ;                                 \
  ``__MODE__`` ``__DST__``.r.resp      = ``__SRC__``.r.resp      ;                                 \
  ``__MODE__`` ``__DST__``.r.last      = ``__SRC__``.r.last      ;                                 \
  ``__MODE__`` ``__DST__``.r.user.data = ``__SRC__``.r.user.data ;                                 \
  ``__MODE__`` ``__DST__``.r.user.resp = ``__SRC__``.r.user.resp ;                                 \
  ``__MODE__`` ``__DST__``.r_valid     = ``__SRC__``.r_valid     ;                                 \


`endif
