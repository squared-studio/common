# Type Definitions for AXI4
Suppose we want to define an AXI4 typedef, calling it `my_axi`. Here:

|Field          |Used Value |Desription
|-              |-          |-
|NAME           |my_axi     |Name for referring the AXI typedefs
|ADDR_WIDTH     |32         |Width of Address bus in AW & AR channels
|DATA_WIDTH     |512        |Width of Data bus in W & R channels
|ID_R_WIDTH     |5          |Width of ID bus in AR & R channels
|ID_W_WIDTH     |4          |Width of ID bus in AW & B channels
|USER_REQ_WIDTH |10         |Width of User Defined signals for Request
|USER_DATA_WIDTH|11         |Width of User Defined signals for Data
|USER_RESP_WIDTH|12         |Width of User Defined signals for Response

Therefore, the macro for this would be
```SV
// `define AXI4_T(NAME, ADDR_WIDTH, DATA_WIDTH, ID_R_WIDTH, ID_W_WIDTH, USER_REQ_WIDTH, USER_DATA_WIDTH, USER_RESP_WIDTH)
`AXI4_T(my_axi, 32, 512, 5, 4, 10, 11, 12)
```
And this macro expands to
```SV
typedef struct packed {
  logic [11-1:0] data  ;  // '11' is from 'USER_DATA_WIDTH'
  logic [12-1:0] resp  ;  // '12' is from 'USER_RESP_WIDTH'
} my_axi_r_user_t;  // 'my_axi_r_user_t' is derived from 'NAME'

typedef struct packed {
  logic [4-1:0]  id      ;  // '4' is from 'ID_W_WIDTH'
  logic [32-1:0] addr    ;  // '32' is from 'ADDR_WIDTH'
  logic [7:0]    len     ;
  logic [2:0]    size    ;
  logic [1:0]    burst   ;
  logic [0:0]    lock    ;
  logic [3:0]    cache   ;
  logic [2:0]    prot    ;
  logic [3:0]    qos     ;
  logic [3:0]    region  ;
  logic [10-1:0] user    ;  // '10' is from 'USER_REQ_WIDTH'
} my_axi_aw_chan_t;  // 'my_axi_aw_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [512/8-1:0][7:0] data  ;  // '512' is from 'DATA_WIDTH'
  logic [512/8-1:0]      strb  ;  // '512' is from 'DATA_WIDTH'
  logic [0:0]            last  ;
  logic [11-1:0]         user  ;  // '11' is from 'USER_DATA_WIDTH'
} my_axi_w_chan_t;  // 'my_axi_w_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [4-1:0]  id    ;  // '4' is from 'ID_W_WIDTH'
  logic [1:0]    resp  ;
  logic [12-1:0] user  ;  // '12' is from 'USER_RESP_WIDTH'
} my_axi_b_chan_t;  // 'my_axi_b_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [5-1:0]  id      ;  // '5' is from 'ID_R_WIDTH'
  logic [32-1:0] addr    ;  // '32' is from 'ADDR_WIDTH'
  logic [7:0]    len     ;
  logic [2:0]    size    ;
  logic [1:0]    burst   ;
  logic [0:0]    lock    ;
  logic [3:0]    cache   ;
  logic [2:0]    prot    ;
  logic [3:0]    qos     ;
  logic [3:0]    region  ;
  logic [10-1:0] user    ;  // '10' is from 'USER_REQ_WIDTH'
} my_axi_ar_chan_t;  // 'my_axi_ar_chan_t' is derived from 'NAME'

typedef struct packed {
  logic [5-1:0]          id    ;  // '5' is from 'ID_R_WIDTH'
  logic [512/8-1:0][7:0] data  ;  // '512' is from 'DATA_WIDTH'
  logic [1:0]            resp  ;
  logic [0:0]            last  ;
  my_axi_r_user_t        user  ;  // 'my_axi_r_user_t' is from previous typedef
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
