# Type Definitions for AXI4
Suppose we want to define an AXI4 typedef, calling it `my_axi`. Here:

|Field                                |Value |
|-                                    |-     |
|Name                                 |my_axi|
|Address Width                        |32    |
|Data Width                           |512   |
|Read Transaction ID width            |5     |
|Write Transaction ID width           |4     |
|User Defined Signl Width for Request |10    |
|User Defined Signl Width for Data    |11    |
|User Defined Signl Width for Response|12    |

Therefore, the macro for this would be
```SV
`AXI4_T(my_axi, 32, 512, 5, 4, 10, 11, 12)
```
And this macro expands to
```SV
typedef struct packed {
  logic [11-1:0] data  ;  // '11' is from 'User Defined Signl Width for Data'
  logic [12-1:0] resp  ;  // '12' is from 'User Defined Signl Width for Response'
} my_axi_r_user_t;  // 'my_axi_r_user_t' is derived from 'Name'

typedef struct packed {
  logic [4-1:0]  id      ;  // '4' is from 'Write Transaction ID width'
  logic [32-1:0] addr    ;  // '32' is from 'Address Width'
  logic [7:0]    len     ;
  logic [2:0]    size    ;
  logic [1:0]    burst   ;
  logic [0:0]    lock    ;
  logic [3:0]    cache   ;
  logic [2:0]    prot    ;
  logic [3:0]    qos     ;
  logic [3:0]    region  ;
  logic [10-1:0] user    ;  // '10' is from 'User Defined Signl Width for Request'
} my_axi_aw_chan_t;  // 'my_axi_aw_chan_t' is derived from 'Name'

typedef struct packed {
  logic [512-1:0]   data  ;  // '512' is from 'Data Width'
  logic [512/8-1:0] strb  ;  // '512' is from 'Data Width'
  logic [0:0]       last  ;
  logic [11-1:0]    user  ;  // '11' is from 'User Defined Signl Width for Data'
} my_axi_w_chan_t;  // 'my_axi_w_chan_t' is derived from 'Name'

typedef struct packed {
  logic [4-1:0]  id    ;  // '4' is from 'Write Transaction ID width'
  logic [1:0]    resp  ;
  logic [12-1:0] user  ;  // '12' is from 'User Defined Signl Width for Response'
} my_axi_b_chan_t;  // 'my_axi_b_chan_t' is derived from 'Name'

typedef struct packed {
  logic [5-1:0]  id      ;  // '5' is from 'Read Transaction ID width'
  logic [32-1:0] addr    ;  // '32' is from 'Address Width'
  logic [7:0]    len     ;
  logic [2:0]    size    ;
  logic [1:0]    burst   ;
  logic [0:0]    lock    ;
  logic [3:0]    cache   ;
  logic [2:0]    prot    ;
  logic [3:0]    qos     ;
  logic [3:0]    region  ;
  logic [10-1:0] user    ;  // '10' is from 'User Defined Signl Width for Request'
} my_axi_ar_chan_t;  // 'my_axi_ar_chan_t' is derived from 'Name'

typedef struct packed {
  logic [5-1:0]   id    ;  // '5' is from 'Read Transaction ID width'
  logic [512-1:0] data  ;  // '512' is from 'Data Width'
  logic [1:0]     resp  ;
  logic [0:0]     last  ;
  my_axi_r_user_t user  ;  // 'my_axi_r_user_t' is from previous typedef
} my_axi_r_chan_t;  // 'my_axi_r_chan_t' is derived from 'Name'

typedef struct packed {
  my_axi_aw_chan_t aw        ;  // 'my_axi_aw_chan_t' is from previous typedef
  logic            aw_valid  ;
  my_axi_w_chan_t  w         ;  // 'my_axi_w_chan_t' is from previous typedef
  logic            w_valid   ;
  logic            b_ready   ;
  my_axi_ar_chan_t ar        ;  // 'my_axi_ar_chan_t' is from previous typedef
  logic            ar_valid  ;
  logic            r_ready   ;
} my_axi_req_t;  // 'my_axi_req_t' is derived from 'Name'

typedef struct packed {
  logic            aw_ready  ;
  logic            w_ready   ;
  my_axi_b_chan_t  b         ;  // 'my_axi_b_chan_t' is from previous typedef
  logic            b_valid   ;
  logic            ar_ready  ;
  my_axi_r_chan_t  r         ;  // 'my_axi_r_chan_t' is from previous typedef
  logic            r_valid   ;
} my_axi_rsp_t;  // 'my_axi_rsp_t' is derived from 'Name'
```