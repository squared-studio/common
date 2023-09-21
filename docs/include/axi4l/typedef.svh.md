# Type Definitions for AXI4 Lite
Suppose we want to define an AXI4L typedef, calling it `my_axi`. Here:

|Field     |Used Value |Desription
|-         |-          |-
|NAME      |my_axi     |Name for referring the AXI typedefs
|ADDR_WIDTH|32         |Width of Address bus in AW & AR channels
|DATA_WIDTH|64         |Width of Data bus in W & R channels

Therefore, the macro for this would be
```SV
// `AXI4L_T AXI4_T(NAME, ADDR_WIDTH, DATA_WIDTH)
`AXI4L_T(my_axi, 32, 64)
```
And this macro expands to
```SV
typedef struct packed {
  logic [32-1:0] addr  ;  // '32' is from 'ADDR_WIDTH'
  logic [2:0]    prot  ;
} my_axi_aw_chan_t;  // 'my_axi_aw_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [64/8-1:0][7:0] data  ;  // '64' is from 'DATA_WIDTH'
  logic [64/8-1:0]      strb  ;  // '64' is from 'DATA_WIDTH'
} my_axi_w_chan_t;  // 'my_axi_w_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [1:0]    resp  ;
} my_axi_b_chan_t;  // 'my_axi_b_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [32-1:0] addr  ;  // '32' is from 'ADDR_WIDTH'
  logic [2:0]    prot  ;
} my_axi_ar_chan_t;  // 'my_axi_ar_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [64/8-1:0][7:0]  data  ;  // '64' is from 'DATA_WIDTH'
  logic [1:0]            resp  ;
} my_axi_r_chan_t;  // 'my_axi_r_chan_t' is derived from 'NAME'

typedef struct packed {
  my_axi_aw_chan_t aw        ;  // 'my_axi_aw_chan_t' is from previous typedef
  logic            aw_valid  ;
  my_axi_w_chan_t  w         ;  // 'my_axi_w_chan_t' is from previous typedef
  logic            w_valid   ;
  logic            b_ready   ;
  my_axi_ar_chan_t ar        ;  // 'my_axi_ar_chan_t' is from previous typedef
  logic            ar_valid  ;
  logic            r_ready   ;
} my_axi_req_t;  // 'my_axi_req_t' is derived from 'NAME'

typedef struct packed {
  logic            aw_ready  ;
  logic            w_ready   ;
  my_axi_b_chan_t  b         ;  // 'my_axi_b_chan_t' is from previous typedef
  logic            b_valid   ;
  logic            ar_ready  ;
  my_axi_r_chan_t  r         ;  // 'my_axi_r_chan_t' is from previous typedef
  logic            r_valid   ;
} my_axi_resp_t;  // 'my_axi_resp_t' is derived from 'NAME'
```