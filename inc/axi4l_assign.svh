// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef AXI4L_ASSIGN_SVH
`define AXI4L_ASSIGN_SVH

// macro for setting or assigning axi4l req to req
`define AXI4L_REQ_TO_REQ(__MODE__, __DST__, __SRC__)                                               \
  ``__MODE__`` ``__DST__``.aw.addr  = ``__SRC__``.aw.addr  ;                                       \
  ``__MODE__`` ``__DST__``.aw.prot  = ``__SRC__``.aw.prot  ;                                       \
  ``__MODE__`` ``__DST__``.aw_valid = ``__SRC__``.aw_valid ;                                       \
  ``__MODE__`` ``__DST__``.w.data   = ``__SRC__``.w.data   ;                                       \
  ``__MODE__`` ``__DST__``.w.strb   = ``__SRC__``.w.strb   ;                                       \
  ``__MODE__`` ``__DST__``.w_valid  = ``__SRC__``.w_valid  ;                                       \
  ``__MODE__`` ``__DST__``.b_ready  = ``__SRC__``.b_ready  ;                                       \
  ``__MODE__`` ``__DST__``.ar.addr  = ``__SRC__``.ar.addr  ;                                       \
  ``__MODE__`` ``__DST__``.ar.prot  = ``__SRC__``.ar.prot  ;                                       \
  ``__MODE__`` ``__DST__``.ar_valid = ``__SRC__``.ar_valid ;                                       \
  ``__MODE__`` ``__DST__``.r_ready  = ``__SRC__``.r_ready  ;                                       \


// macro for setting or assigning axi4l req to req
`define AXI4L_RESP_TO_RESP(__MODE__, __DST__, __SRC__)                                             \
  ``__MODE__`` ``__DST__``.aw_ready = ``__SRC__``.aw_ready ;                                       \
  ``__MODE__`` ``__DST__``.w_ready  = ``__SRC__``.w_ready  ;                                       \
  ``__MODE__`` ``__DST__``.b.resp   = ``__SRC__``.b.resp   ;                                       \
  ``__MODE__`` ``__DST__``.b_valid  = ``__SRC__``.b_valid  ;                                       \
  ``__MODE__`` ``__DST__``.ar_ready = ``__SRC__``.ar_ready ;                                       \
  ``__MODE__`` ``__DST__``.r.data   = ``__SRC__``.r.data   ;                                       \
  ``__MODE__`` ``__DST__``.r.resp   = ``__SRC__``.r.resp   ;                                       \
  ``__MODE__`` ``__DST__``.r_valid  = ``__SRC__``.r_valid  ;                                       \


`endif
