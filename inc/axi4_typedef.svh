// TYPE DEFINIATION FOR AXI4 LITE CHANNELS AND REQUEST-RESPONSE STRUCTURE
// ### Author : Foez Ahmed (foez.official@gmail.com)

`ifndef AXI4_TYPEDEF_SVH
`define AXI4_TYPEDEF_SVH

`define AXI4_R_USER_T(__NM__, __UDTAW__, __URSPW__)                                                \
  typedef struct packed {                                                                          \
    logic [``__UDTAW__``-1:0] data ;                                                               \
    logic [``__URSPW__``-1:0] resp ;                                                               \
  } ``__NM__``;                                                                                    \

`define AXI4_AX_CHAN_T(__NM__, __IW__, __AW__, __UW__)                                             \
  typedef struct packed {                                                                          \
    logic [``__IW__``-1:0] id     ;                                                                \
    logic [``__AW__``-1:0] addr   ;                                                                \
    logic [7:0]            len    ;                                                                \
    logic [2:0]            size   ;                                                                \
    logic [1:0]            burst  ;                                                                \
    logic [0:0]            lock   ;                                                                \
    logic [3:0]            cache  ;                                                                \
    logic [2:0]            prot   ;                                                                \
    logic [3:0]            qos    ;                                                                \
    logic [3:0]            region ;                                                                \
    logic [``__UW__``-1:0] user   ;                                                                \
  } ``__NM__``;                                                                                    \

`define AXI4_W_CHAN_T(__NM__, __DW__, __UW__)                                                      \
  typedef struct packed {                                                                          \
    logic [``__DW__``/8-1:0][7:0] data ;                                                           \
    logic [``__DW__``/8-1:0]      strb ;                                                           \
    logic [0:0]                   last ;                                                           \
    logic [``__UW__``-1:0]        user ;                                                           \
  } ``__NM__``;                                                                                    \

`define AXI4_B_CHAN_T(__NM__, __IW__, __UW__)                                                      \
  typedef struct packed {                                                                          \
    logic [``__IW__``-1:0] id   ;                                                                  \
    logic [1:0]            resp ;                                                                  \
    logic [``__UW__``-1:0] user ;                                                                  \
  } ``__NM__``;                                                                                    \

`define AXI4_R_CHAN_T(__NM__, __IW__, __DW__, __USER_T__)                                          \
  typedef struct packed {                                                                          \
    logic [``__IW__``-1:0] id        ;                                                             \
    logic [``__DW__``-1:0][7:0] data ;                                                             \
    logic [1:0]                 resp ;                                                             \
    logic [0:0]                 last ;                                                             \
    ``__USER_T__``              user ;                                                             \
  } ``__NM__``;                                                                                    \

`define AXI4_REQ_T(__NM__, __AW_CHAN_T__, __W_CHAN_T__, __AR_CHAN_T__)                             \
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

`define AXI4_RESP_T(__NM__, __B_CHAN_T__, __R_CHAN_T__)                                            \
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
`define AXI4_T(__NM__, __AW__, __DW__, __IRW__, __IWW__, __UREQW__, __UDTAW__, __URSPW__)          \
  `AXI4_R_USER_T(``__NM__``_r_user_t,``__UDTAW__``, ``__URSPW__``)                                 \
  `AXI4_AX_CHAN_T(``__NM__``_aw_chan_t, ``__IWW__``, ``__AW__``, ``__UREQW__``)                    \
  `AXI4_W_CHAN_T(``__NM__``_w_chan_t, ``__DW__``, ``__UDTAW__``)                                   \
  `AXI4_B_CHAN_T(``__NM__``_b_chan_t, ``__IWW__``, ``__URSPW__``)                                  \
  `AXI4_AX_CHAN_T(``__NM__``_ar_chan_t, ``__IRW__``, ``__AW__``, ``__UREQW__``)                    \
  `AXI4_R_CHAN_T(``__NM__``_r_chan_t, ``__IRW__``, ``__DW__``, ``__NM__``_r_user_t)                \
  `AXI4_REQ_T(``__NM__``_req_t, ``__NM__``_aw_chan_t, ``__NM__``_w_chan_t, ``__NM__``_ar_chan_t)   \
  `AXI4_RESP_T(``__NM__``_resp_t, ``__NM__``_b_chan_t, ``__NM__``_r_chan_t)                        \


`endif
