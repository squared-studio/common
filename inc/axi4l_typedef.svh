// TYPE DEFINIATION FOR AXI4 LITE CHANNELS AND REQUEST-RESPONSE STRUCTURE
// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef AXI4L_TYPEDEF_SVH
`define AXI4L_TYPEDEF_SVH

`define AXI4L_AX_CHAN_T(__NM__, __AW__)                                                            \
  typedef struct packed {                                                                          \
    logic [``__AW__``-1:0] addr ;                                                                  \
    logic [2:0]            prot ;                                                                  \
  } ``__NM__``;                                                                                    \

`define AXI4L_W_CHAN_T(__NM__, __DW__)                                                             \
  typedef struct packed {                                                                          \
    logic [``__DW__``/8-1:0][7:0] data ;                                                           \
    logic [``__DW__``/8-1:0]      strb ;                                                           \
  } ``__NM__``;                                                                                    \

`define AXI4L_B_CHAN_T(__NM__)                                                                     \
  typedef struct packed {                                                                          \
    logic [1:0] resp ;                                                                             \
  } ``__NM__``;                                                                                    \

`define AXI4L_R_CHAN_T(__NM__, __DW__)                                                             \
  typedef struct packed {                                                                          \
    logic [``__DW__``/8-1:0][7:0] data ;                                                           \
    logic [1:0]                   resp ;                                                           \
  } ``__NM__``;                                                                                    \

`define AXI4L_REQ_T(__NM__, __AW_CHAN_T__, __W_CHAN_T__, __AR_CHAN_T__)                            \
  typedef struct packed {                                                                          \
    ``__AW_CHAN_T__`` aw       ;                                                                   \
    logic             aw_valid ;                                                                   \
    ``__W_CHAN_T__``  w        ;                                                                   \
    logic             w_valid  ;                                                                   \
    logic             b_ready  ;                                                                   \
    ``__AR_CHAN_T__`` ar       ;                                                                   \
    logic             ar_valid ;                                                                   \
    logic             r_ready  ;                                                                   \
  } ``__NM__``;                                                                                    \

`define AXI4L_RESP_T(__NM__, __B_CHAN_T__, __R_CHAN_T__)                                           \
  typedef struct packed {                                                                          \
    logic            aw_ready ;                                                                    \
    logic            w_ready  ;                                                                    \
    ``__B_CHAN_T__`` b        ;                                                                    \
    logic            b_valid  ;                                                                    \
    logic            ar_ready ;                                                                    \
    ``__R_CHAN_T__`` r        ;                                                                    \
    logic            r_valid  ;                                                                    \
  } ``__NM__``;                                                                                    \

// THIS MACROS EXPANDS TO DECLARING THE FOLLOWING TYPEDEF:
// *_aw_chan_t
// *_w_chan_t
// *_b_chan_t
// *_ar_chan_t
// *_r_chan_t
// *_req_t
// *_resp_t
// see doc for more details
`define AXI4L_T(__NM__, __AW__, __DW__)                                                            \
  `AXI4L_AX_CHAN_T(``__NM__``_aw_chan_t, ``__AW__``)                                               \
  `AXI4L_W_CHAN_T(``__NM__``_w_chan_t, ``__DW__``)                                                 \
  `AXI4L_B_CHAN_T(``__NM__``_b_chan_t)                                                             \
  `AXI4L_AX_CHAN_T(``__NM__``_ar_chan_t, ``__AW__``)                                               \
  `AXI4L_R_CHAN_T(``__NM__``_r_chan_t, ``__DW__``)                                                 \
  `AXI4L_REQ_T(``__NM__``_req_t, ``__NM__``_aw_chan_t, ``__NM__``_w_chan_t, ``__NM__``_ar_chan_t)  \
  `AXI4L_RESP_T(``__NM__``_resp_t, ``__NM__``_b_chan_t, ``__NM__``_r_chan_t)                       \


`endif
